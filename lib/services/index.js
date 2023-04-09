const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.setNewUserClaim = functions.auth.user().onCreate(async (user) => {
  await admin.auth().setCustomUserClaims(user.uid, { newUser: true });
});
