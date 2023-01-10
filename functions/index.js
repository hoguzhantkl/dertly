const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

require('dotenv').config()

exports.entries = require("./entries.js");