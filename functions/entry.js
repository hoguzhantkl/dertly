const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.onAnswerAdded = functions.firestore.document('answers/{answerId}').onCreate( async (snap, context) => {
    const answerData = snap.data();
    const answerId = context.params.answerId;

    functions.logger.log('Answer added', 'answerID:', answerId, 'userID:', answerData.userID, 'entryID:', answerData.entryID);

    await updateTotalAnswer(answerData.entryID, answerData.answerType, +1);

    return Promise.resolve();
});

exports.onAnswerDeleted = functions.firestore.document('answers/{answerId}').onDelete( async (snap, context) => {
    const answerData = snap.data();
    const answerId = context.params.answerId;

    functions.logger.log('Answer deleted', 'answerID:', answerId, 'userID:', answerData.userID, 'entryID:', answerData.entryID);

    await updateTotalAnswer(answerData.entryID, answerData.answerType, -1);

    return Promise.resolve();
});

async function updateTotalAnswer(entryID, answerType, offset) {
    const db = admin.firestore();
    functions.logger.log("totalAnswers will be updated", "entryID:", entryID, "offset:", offset);
    return db.runTransaction(async (transaction) => {
        var entryDoc = db.collection('entries').doc(entryID);
        var entryDocSnapshot = await transaction.get(entryDoc);
        var entryDocData = entryDocSnapshot.data();
        var answerCount = Math.max(entryDocData.totalAnswers[answerType] + offset, 0);
        await transaction.update(entryDoc, { ['totalAnswers.' + answerType]: answerCount });
    })
    .then(() => {
        functions.logger.log("updateTotalAnswer transaction success!");
    })
    .catch((error) => {
        functions.logger.log("updateTotalAnswer transaction failed:", error);
    });
}