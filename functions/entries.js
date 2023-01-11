const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.onEntryAdded = functions.firestore.document('entries/{entryId}').onCreate( async (snap, context) => {
    const entryData = snap.data();

    const entryId = context.params.entryId;

    functions.logger.log('Entry added', 'entryID:', entryId, 'userID:', entryData.userID);

    await addRecentEntry(entryId);
    await tryAddToTrendEntry(entryData);

    return Promise.resolve();
});

exports.onEntryRemoved = functions.firestore.document('entries/{entryId}').onDelete( async (snap, context) => {
    const entryData = snap.data();
    const entryID = context.params.entryId;

    functions.logger.log('Entry removed', 'entryID:', entryID, 'userID:', entryData.userID);

    // Remove the entry from trending if it is in.
    var trendDoc = admin.firestore().collection('feeds').doc('trendings');
    var trendColRef = trendDoc.collection('list');
    var entryDocInTrendings = await trendColRef.doc(entryID).get();
    if (entryDocInTrendings.exists) {
        await trendColRef.doc(entryID).delete();
        await trendDoc.update({ totalTrendEntries: admin.firestore.FieldValue.increment(-1) });
    }

    // Remove the entry from recents if it is in.
    var recentDoc = admin.firestore().collection('feeds').doc('recents');
    var recentDocSnapshot = await recentDoc.get();
    var recentDocData = recentDocSnapshot.data();
    var recentEntriesIDList = recentDocData.recentEntriesIDList;

    if (recentEntriesIDList != undefined) {
        if (recentEntriesIDList.includes(entryID)) {
            functions.logger.log("Entry is being removed from recents:", entryID);
            await recentDoc.update({recentEntriesIDList: admin.firestore.FieldValue.arrayRemove(entryID)});
        }
    }
});

// TODO: func tryAddToTrendEntry should be called when entry is created or updated with answer or up/down votes
async function tryAddToTrendEntry(entryData) {
    var trendDoc = admin.firestore().collection('feeds').doc('trendings');
    var trendDocSnapshot = await trendDoc.get();
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
        var entryDocWithLowestScore = await trendColRef.orderBy("score", "asc").limit(1).get();
        var entryDataWithLowestScore = entryDocWithLowestScore.docs[0].data();
        functions.logger.log("addedEntryScore:", entryScore, "lowestEntryScore:", entryDataWithLowestScore.score);
        if (entryScore >= entryDataWithLowestScore.score) {
            await trendColRef.doc(entryDataWithLowestScore.entryID).delete();
            totalTrendEntries--;
        }
        else
            addEntry = false;
    }

    if (addEntry) {
        functions.logger.log("Entry is being added to trending:", entryData.entryID);
        await trendColRef.doc(entryData.entryID).set(entryMap);
        functions.logger.log("current totalTrendEntries:", totalTrendEntries, "new totalTrendEntries:", totalTrendEntries + 1);
        await trendDoc.update({ totalTrendEntries: totalTrendEntries + 1 });
    }
}

async function addRecentEntry(entryID) {
    var recentDocSnapshot = await admin.firestore().collection('feeds').doc('recents').get();
    var recentDocData = recentDocSnapshot.data();
    var recentEntriesIDList = recentDocData.recentEntriesIDList;

    if (recentEntriesIDList != undefined && recentEntriesIDList.length >= process.env.MAX_RECENT_ENTRIES) {
        await recentDocSnapshot.ref.update({recentEntriesIDList: admin.firestore.FieldValue.arrayRemove(recentEntriesIDList[0])});
    }

    return await recentDocSnapshot.ref.update({recentEntriesIDList: admin.firestore.FieldValue.arrayUnion(entryID)});
}