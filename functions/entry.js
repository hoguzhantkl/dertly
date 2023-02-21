const functions = require("firebase-functions");
const admin = require("firebase-admin");

const user = require("./user.js");

exports.onAnswerAdded = functions.firestore.document('answers/{answerId}').onCreate( async (snap, context) => {
    const answerData = snap.data();
    const answerId = context.params.answerId;

    functions.logger.log('Answer added', 'answerID:', answerId, 'userID:', answerData.userID, 'entryID:', answerData.entryID);

    await updateTotalAnswersCount(answerData.entryID, answerData.answerType, +1);

    if (isSubAnswer(answerData)) {
        await updateTotalSubAnswersCount(answerData.mentionedAnswerID, +1);
    }

    await user.updateTotalAnswersCount(answerData.userID, +1);

    return Promise.resolve();
});

exports.onAnswerDeleted = functions.firestore.document('answers/{answerId}').onDelete( async (snap, context) => {
    const answerData = snap.data();
    const answerId = context.params.answerId;

    functions.logger.log('Answer deleted', 'answerID:', answerId, 'userID:', answerData.userID, 'entryID:', answerData.entryID);

    await updateTotalAnswersCount(answerData.entryID, answerData.answerType, -1);

    if (isSubAnswer(answerData)) {
        await updateTotalSubAnswersCount(answerData.mentionedAnswerID, -1);
    }

    await user.updateTotalAnswersCount(answerData.userID, -1);

    return Promise.resolve();
});

async function updateTotalAnswersCount(entryID, answerType, offset) {
    const db = admin.firestore();
    functions.logger.log("totalAnswers will be updated", "entryID:", entryID, "offset:", offset);
    return db.runTransaction(async (transaction) => {
        var entryDoc = db.collection('entries').doc(entryID);
        var entryDocSnapshot = await transaction.get(entryDoc);

        if (!entryDocSnapshot.exists) {
            functions.logger.log("Entry is not found:", entryID, "totalAnswers of the Entry will not be updated");
            return;
        }

        var entryDocData = entryDocSnapshot.data();
        var answerCount = Math.max(entryDocData.totalAnswers[answerType] + offset, 0);
        await transaction.update(entryDoc, { ['totalAnswers.' + answerType]: answerCount });
    })
    .then(() => {
        functions.logger.log("updateTotalAnswersCount transaction success!");
    })
    .catch((error) => {
        functions.logger.log("updateTotalAnswersCount transaction failed:", error);
    });
}

function isSubAnswer(answerData) {
    return answerData.mentionedAnswerID != "";
}

async function updateTotalSubAnswersCount(mentionedAnswerID, offset) {
    const db = admin.firestore();
    functions.logger.log("totalSubAnswers will be updated", "mentionedAnswerID:", mentionedAnswerID, "offset:", offset);

    return db.runTransaction(async (transaction) => {
        var answerDoc = db.collection('answers').doc(mentionedAnswerID);
        var answerDocSnapshot = await transaction.get(answerDoc);

        if (!answerDocSnapshot.exists) {
            functions.logger.log("Answer is not found:", entryID, "totalSubAnswers of the Answer will not be updated");
            return;
        }

        var answerDocData = answerDocSnapshot.data();
        var subAnswerCount = Math.max(answerDocData.totalSubAnswers + offset, 0);
        await transaction.update(answerDoc, { totalSubAnswers: subAnswerCount });
    })
    .then(() => {
        functions.logger.log("updateTotalSubAnswersCount transaction success!");
    })
    .catch((error) => {
        functions.logger.log("updateTotalSubAnswersCount transaction failed:", error);
    });
}