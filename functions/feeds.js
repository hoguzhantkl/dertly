const functions = require("firebase-functions");
const admin = require("firebase-admin");

const user = require("./user.js");

exports.onEntryAdded = functions.firestore.document('entries/{entryId}').onCreate( async (snap, context) => {
    const entryData = snap.data();

    const entryId = context.params.entryId;

    functions.logger.log('Entry added', 'entryID:', entryId, 'userID:', entryData.userID);

    await addRecentEntry(entryId);
    await tryAddToTrendEntry(entryData);
    await user.updateTotalEntriesCount(entryData.userID, +1);

    return Promise.resolve();
});

exports.onEntryRemoved = functions.firestore.document('entries/{entryId}').onDelete( async (snap, context) => {
    const entryData = snap.data();
    const entryID = context.params.entryId;

    functions.logger.log('Entry removed', 'entryID:', entryID, 'userID:', entryData.userID);

    // TODO: use transaction for removing entry from trendings and recents
    const db = admin.firestore();
    return db.runTransaction(async (transaction) => {
        // Remove the entry from trending if it is in.
        var trendDoc = admin.firestore().collection('feeds').doc('trendings');
        if (trendDoc != undefined){
            var trendColRef = trendDoc.collection('list');
            var entryDocInTrendingsDoc = trendColRef.doc(entryID)
            var entryDocInTrendings = await entryDocInTrendingsDoc.get();
            if (entryDocInTrendings.exists) {
                await transaction.delete(entryDocInTrendingsDoc);
                await transaction.update(trendDoc, { totalTrendEntries: admin.firestore.FieldValue.increment(-1) });
            }
        }

        // Remove the entry from recents if it is in.
        var recentDoc = admin.firestore().collection('feeds').doc('recents');
        var recentDocSnapshot = await recentDoc.get();
        var recentDocData = recentDocSnapshot.data();
        var recentEntriesIDList = recentDocData.recentEntriesIDList;

        if (recentEntriesIDList != undefined) {
            if (recentEntriesIDList.includes(entryID)) {
                functions.logger.log("Entry is being removed from recents:", entryID);
                await transaction.update(recentDoc, {recentEntriesIDList: admin.firestore.FieldValue.arrayRemove(entryID)});
            }
        }

        await user.updateTotalEntriesCount(entryData.userID, -1);

        await deleteAllEntryAnswers(entryID);
    })
    .then(() => {
        functions.logger.log("onEntryRemoved transaction success!");
    })
    .catch((error) => {
        functions.logger.log("onEntryRemoved transaction failed:", error);
    });
});

// TODO: func tryAddToTrendEntry should be called when entry is created or updated with answer or up/down votes
async function tryAddToTrendEntry(entryData) {
    const db = admin.firestore();
    return db.runTransaction(async (transaction) => {
        var trendDoc = db.collection('feeds').doc('trendings');
        var trendDocSnapshot = await transaction.get(trendDoc);
        var trendDocData = trendDocSnapshot.data();
        var totalTrendEntries = (trendDocData.totalTrendEntries != undefined) ? trendDocData.totalTrendEntries : 0;

        var trendColRef = await trendDoc.collection("list");

        // TODO: calculate the score of the entry with a func
        const entryScore = entryData.upVote + entryData.downVote + entryData.totalAnswers;

        // TODO: make a condition for entry to be added to Trending List

        const entryMap = {
            'entryID': entryData.entryID,
            'score': entryScore,
            'date': entryData.date
        }

        var addEntry = true;
        if (totalTrendEntries >= process.env.MAX_TREND_ENTRIES) {
            var entryDocSnapShotWithLowestScore = await transaction.get(trendColRef.orderBy("score", "asc").limit(1));
            var entryDataWithLowestScore = entryDocSnapShotWithLowestScore.docs[0].data();
            functions.logger.log("addedEntryScore:", entryScore, "lowestEntryScore:", entryDataWithLowestScore.score);
            if (entryScore >= entryDataWithLowestScore.score) {
                functions.logger.log("Entry lowestEntryScore is being deleted from trending:", entryDataWithLowestScore.entryID);
                await transaction.delete(trendColRef.doc(entryDataWithLowestScore.entryID));
                totalTrendEntries--;
            }
            else
                addEntry = false;
        }

        if (addEntry) {
            functions.logger.log("Entry is being added to trending:", entryData.entryID);
            totalTrendEntries++;
            await transaction.set(trendColRef.doc(entryData.entryID), entryMap); //await trendColRef.doc(entryData.entryID).set(entryMap);
            await transaction.update(trendDoc, { totalTrendEntries: totalTrendEntries }); //await trendDoc.update({ totalTrendEntries: totalTrendEntries + 1 });
        }
        else{
            functions.logger.log("Entry", entryData.entryID, " has not enough score to be added to trending");
        }

        return totalTrendEntries;
    })
    .then((totalTrendEntries) => {
        functions.logger.log("AddTrendEntry transaction success!");
        functions.logger.log("Total Trend Entries:", totalTrendEntries);
    })
    .catch((error) => {
        functions.logger.log("AddTrendEntry transaction failed: ", error);
    });
}

async function addRecentEntry(entryID) {
    const db = admin.firestore();
    functions.logger.log("Entry is being added to recents:", entryID);
    return db.runTransaction(async (transaction) => {

        var recentDocSnapshot = await transaction.get(db.collection('feeds').doc('recents'));
        var recentDocData = recentDocSnapshot.data();
        var recentEntriesIDList = recentDocData.recentEntriesIDList;

        if (recentEntriesIDList == undefined){
            recentEntriesIDList = [];
        }

        if (recentEntriesIDList.length >= process.env.MAX_RECENT_ENTRIES) {
            recentEntriesIDList.pop();
        }

        recentEntriesIDList.unshift(entryID);

        return await transaction.update(recentDocSnapshot.ref, { recentEntriesIDList: recentEntriesIDList });
    })
    .then(() => {
        functions.logger.log("AddRecentEntry transaction success!");
    })
    .catch((error) => {
        functions.logger.log("AddRecentEntry transaction failed: ", error);
    });
}

async function deleteAllEntryAnswers(entryID){
    const db = admin.firestore();
    functions.logger.log("All answers of entry", entryID, "are being deleted");

    var currentBatch = db.batch();
    var currentBatchCount = 0;
    var batches = [currentBatch];
    var answerColRef = db.collection('answers');
    var query = answerColRef.where('entryID', '==', entryID);
    var querySnapshot = await query.get();
    querySnapshot.forEach(async (doc) => {
        currentBatch.delete(doc.ref);
        currentBatchCount++;
        if (currentBatchCount >= 500){
            currentBatchCount = 0;
            currentBatch = db.batch();
            batches.push(currentBatch);
        }
    });

    return await Promise.all(batches.map(batch => batch.commit()));
}