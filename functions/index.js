const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

require('dotenv').config()

exports.feeds = require("./feeds.js");
exports.entry = require("./entry.js");