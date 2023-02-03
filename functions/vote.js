const functions = require("firebase-functions");
const admin = require("firebase-admin");


exports.giveVote8 = functions.region('europe-west1').https.onCall( async (data, context) => {
    const db = admin.firestore();

    if (!await canGiveVote(data)){
        return;
    }

    const voteDoc = db.collection('votes').doc();
    data.voteID = voteDoc.id;
    data.date = Date();

    data.date =
    await voteDoc.set(data);
});

async function canGiveVote(voteData){
    const db = admin.firestore();
    const voteQuery = await db.collection('votes')
        .where('userID', '==', voteData.userID)
        .where('referenceID', '==', voteData.referenceID).get();

    if (voteQuery.size > 0) {
        const voteDoc = voteQuery.docs[0];
        const voteDocData = voteDoc.data();
        if (voteDocData.voteType == voteData.voteType) {
            functions.logger.log("User has already voted on this entry with the same voteType. Can't vote again.");
            return false;
        }

        await deletePreviousContraryVote(voteDoc.ref);
    }

    return true;
}

async function deletePreviousContraryVote(voteDocRef){
    functions.logger.log("User has already voted on this entry, but with a different voteType. Deleting old vote and adding new vote.");
    await voteDocRef.delete();
}

exports.onVoteAdded = functions.firestore.document('votes/{voteId}').onCreate( async (snap, context) => {
    const voteData = snap.data();
    const voteId = context.params.voteId;

    functions.logger.log('Vote added', 'voteID:', voteId, 'voteType:', voteData.voteType, 'userID:', voteData.userID, 'referenceID:', voteData.referenceID);

    await updateTotalVote(voteData.referenceID, voteData.referenceType, voteData.voteType, +1);

    return Promise.resolve();
});

exports.onVoteDeleted = functions.firestore.document('votes/{voteId}').onDelete( async (snap, context) => {
    const voteData = snap.data();
    const voteId = context.params.voteId;

    functions.logger.log('Vote deleted', 'voteID:', voteId, 'userID:', voteData.userID, 'referenceID:', voteData.referenceID, 'voteType:', voteData.voteType);

    await updateTotalVote(voteData.referenceID, voteData.referenceType, voteData.voteType, -1);

    return Promise.resolve();
});

async function updateTotalVote(referenceID, referenceType, voteType, offset){
    const db = admin.firestore();
    return db.runTransaction(async (transaction) => {
        var entryDoc = db.collection(referenceType).doc(referenceID);
        var entryDocSnapshot = await transaction.get(entryDoc);
        if (!entryDocSnapshot.exists) {
            throw new Error("Entry does not exist! referenceID: " + referenceID);
        }

        var entryDocData = entryDocSnapshot.data();
        var voteCount = Math.max(entryDocData.totalVotes[voteType] + offset, 0)
        await transaction.update(entryDoc, { ['totalVotes.' + voteType]: voteCount});
    })
    .then(() => {
        functions.logger.log("updateTotalVote transaction success!");
    })
    .catch((error) => {
        functions.logger.log("updateTotalVote transaction failed:", error);
    });
}