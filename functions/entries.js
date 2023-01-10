const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.onEntryAdded = functions.firestore.document('entries/{entryId}').onCreate((snap, context) => {
    // Grab the current value of what was written to Cloud Firestore.
    const entryData = snap.data();

    const entryId = context.params.entryId;

    functions.logger.log('Entry added', 'entryID:', entryId, 'userID:', entryData.userID);

    // Add this entry to recent entry
    addRecentEntry(entryId);

    // Setting original field
   //return snap.ref.set({original: uppercase}, {merge: true});
   return Promise.resolve();
});

async function addRecentEntry(entryID) {
    var recentDoc = await admin.firestore().collection('feeds').doc('recents').get();
    var snapshot = recentDoc.data();
    var recentEntriesIDList = snapshot.recentEntriesIDList;

    functions.logger.log("entryID from recents document:", snapshot.recentEntriesIDList);

    if (recentEntriesIDList != undefined && recentEntriesIDList.length >= process.env.MAX_RECENT_ENTRIES) {
        await recentDoc.ref.update({recentEntriesIDList: admin.firestore.FieldValue.arrayRemove(recentEntriesIDList[0])});
    }

    return await recentDoc.ref.update({recentEntriesIDList: admin.firestore.FieldValue.arrayUnion(entryID)});
}