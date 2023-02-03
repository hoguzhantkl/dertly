const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

require('dotenv').config()

exports.feeds = require("./feeds.js");
exports.entry = require("./entry.js");
exports.vote = require("./vote.js");

exports.writeMessage2 = functions.region("europe-west1").https.onCall(async (data, context) => {
  // Grab the text parameter.
  const original = data.text;
  //Returns the text received
  return `Successfully received: ${original}`;
});