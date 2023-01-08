const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp();

exports.addEntry = functions.https.onRequest(async (req, res) => {
    const original = req.query.text;

    const writeResult = await admin.firestore().collection('entries').add({original: original});
    res.json({result: `Entry with ID: ${writeResult.id} added.`});
});

exports.onEntryAdded = functions.firestore.document('entries/{entryId}').onCreate((snap, context) => {
    // Grab the current value of what was written to Cloud Firestore.
    const original = snap.data().original;

    const entryId = context.params.entryId;

    functions.logger.log('Entry added', entryId, original);

    const uppercase = original.toUpperCase();

    // You must return a Promise when performing asynchronous tasks inside a Functions such as
    // writing to Cloud Firestore.
    // Setting an 'uppercase' field in Cloud Firestore document returns a Promise.

    // Setting original field
   return snap.ref.set({original: uppercase}, {merge: true});
});