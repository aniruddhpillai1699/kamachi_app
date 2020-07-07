const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.pushNotification = functions.database.ref('/reports/{id}')
 .onWrite(( change,context) => {
    console.log("Push Notification event triggered");
    var request = change.after.val();
    const payload = {
        notification:{
                    title : 'Request Reviewed',
                    body : 'Your request has been reviewed please click to see the changes',
                    badge : '1',
                    sound : 'default'

                }

    };
    return admin.database().ref('reports').once('value').then(allToken => {
            if(allToken.val()){
                console.log('token available');
                const token = Object.keys(allToken.val());
                return admin.messaging().sendToDevice(request.token,payload);
            }else{
                console.log('No token available');
            }
            return null;
        });
 })