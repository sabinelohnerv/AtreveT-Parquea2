const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendOfferNotification = functions.firestore
    .document('offers/{offerId}')
    .onCreate(async (snap, context) => {
        const offerData = snap.data();
        const providerId = offerData.provider.id;

        try {
            const providerDoc = await admin.firestore().collection('providers').doc(providerId).get();
            const providerData = providerDoc.data();
            
            if (providerData && providerData.fcmToken) {
                const message = {
                    notification: {
                        title: '¡Nueva Oferta Recibida!',
                        body: `Ha recibido una nueva oferta para ${offerData.garageSpace.garageName} a las ${offerData.time.startTime} por un precio de ${offerData.payOffer} BOB.`
                    },
                    token: providerData.fcmToken
                };

                await admin.messaging().send(message);
                console.log('Notification sent to provider:', providerId);
            } else {
                console.log('No FCM token found for provider:', providerId);
            }
        } catch (error) {
            console.error('Error sending notification:', error);
        }
    });

    exports.sendCounterOfferNotification = functions.firestore
    .document('offers/{offerId}')
    .onUpdate(async (change, context) => {
        const beforeData = change.before.data();
        const afterData = change.after.data();

        // Check if lastOfferBy has changed
        if (beforeData.lastOfferBy !== afterData.lastOfferBy) {
            let targetId = afterData.lastOfferBy === afterData.provider.id ? afterData.client.id : afterData.provider.id;
            let targetCollection = afterData.lastOfferBy === afterData.provider.id ? 'clients' : 'providers';

            try {
                const targetDoc = await admin.firestore().collection(targetCollection).doc(targetId).get();
                const targetData = targetDoc.data();
                
                if (targetData && targetData.fcmToken) {
                    const message = {
                        notification: {
                            title: '¡ContraOferta!',
                            body: `Ha recibido una contraoferta para ${afterData.garageSpace.garageName}. Nuevo precio ${afterData.payOffer} BOB`
                        },
                        token: targetData.fcmToken
                    };

                    await admin.messaging().send(message);
                    console.log('Notification sent to:', targetId);
                } else {
                    console.log('No FCM token found for user:', targetId);
                }
            } catch (error) {
                console.error('Error sending notification:', error);
            }
        }
    });
