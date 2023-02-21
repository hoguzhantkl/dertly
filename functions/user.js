const functions = require("firebase-functions");
const admin = require("firebase-admin");

async function updateUserGeneralInfos(key, userID, offset){
    const db = admin.firestore();
    return db.runTransaction(async (transaction) => {
        var userDoc = db.collection('users').doc(userID);
        var userDocSnapshot = await transaction.get(userDoc);
        var userDocData = userDocSnapshot.data();
        var entryCount = Math.max(userDocData[key] + offset, 0);
        await transaction.update(userDoc, { [key]: entryCount });
    });
}

async function updateTotalEntriesCount(userID, offset){
    functions.logger.log("totalEntries for userID:", userID, "will be updated", "offset:", offset);
    return await updateUserGeneralInfos("totalEntries", userID, offset);
}

async function updateTotalAnswersCount(userID, offset){
    functions.logger.log("totalAnswers for userID:", userID, "will be updated", "offset:", offset);
    return await updateUserGeneralInfos("totalAnswers", userID, offset);
}

async function updateTotalFollowersCount(userID, offset){
    functions.logger.log("totalFollowers for userID:", userID, "will be updated", "offset:", offset);
    return await updateUserGeneralInfos("totalFollowers", userID, offset);
}

async function updateTotalFollowingCount(userID, offset){
    functions.logger.log("totalFollowing for userID:", userID, "will be updated", "offset:", offset);
    return await updateUserGeneralInfos("totalFollowing", userID, offset);
}

exports.updateTotalEntriesCount = updateTotalEntriesCount;
exports.updateTotalAnswersCount = updateTotalAnswersCount;
exports.updateTotalFollowersCount = updateTotalFollowersCount;
exports.updateTotalFollowingCount = updateTotalFollowingCount;