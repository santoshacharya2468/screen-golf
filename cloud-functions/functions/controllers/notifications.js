const { firestore } = require('firebase-admin');
const admin=require('firebase-admin');
const functions=require('firebase-functions');
const bookingAlert='예약알림!';
const hasbookedYourShop='당신의 가게를 예약했습니다';
const accepted='수락';
const scheduled='예정된';
const rejected='거부';
const hi='안녕';
const yourbookingOrderIs='귀하의 예약 주문은';
const welcomeTo='스크린 골프에 오신 것을 환영합니다';
const thanksForUsing='우리의 응용 프로그램을 사용해 주셔서 감사합니다';
const pointEarn='포인트 적립';
const pointLose='점수를 잃다';
const isNearYou='당신 근처에 있습니다';
const checkMyShop='내 가게를 확인하십시오';
const nearYou='가까운';
const bookingRejectedMessage='고객님이 원하시는 예약시간에는 예약이 불가능 합니다 죄송합니다';
const  bookingAcceptedMessage='입니다.  감사합니다 예약이 확정 되었습니다.';
const notification_options = {
    priority: "high",
    timeToLive: 60 * 60 * 24
  };
const db=admin.firestore();
exports.onBooking = functions.firestore.document('Bookings/{docId}').onCreate(async(snapshot,context)=>{
    let shop=await db.collection('shops').doc(snapshot.data().massage_shop_id).get();
  let user=await db.collection('users').doc(shop.data().userId).get();
  if(user){
   return admin.messaging().sendToDevice(user.data().fcmId,{
        data:{
            click_action: "FLUTTER_NOTIFICATION_CLICK"},
            notification:{
            title:bookingAlert,
            sound:"default",
            body:`${snapshot.data().user.email} ${hasbookedYourShop}`,
            badge:"1",
            tag:snapshot.id,
        }
    },notification_options);
  }
    
});
exports.onBookingStatusChanged = functions.firestore.document('Bookings/{docId}').onUpdate(async(snapshot,context)=>{
  if(snapshot.after.data().status==snapshot.before.data().status){
      return;
  }
  let user=await db.collection('users').doc(snapshot.after.data().user.userId).get();
  if(user){
       let status=snapshot.after.data().status;
       if(status==2){
         return;
       }
    let message=status==1?bookingAcceptedMessage:status==2?scheduled:bookingRejectedMessage;
  
   return admin.messaging().sendToDevice(user.data().fcmId,{
        data:{
            click_action: "FLUTTER_NOTIFICATION_CLICK"},
            notification:{
            title:bookingAlert,
            sound:"default",
            body:`${hi}, ${snapshot.after.data().user.name}, ${message}`,
            badge:"1",
            tag:snapshot.after.id,
        }
    },notification_options);
  } 
})
exports.onNotifications = functions.firestore.document('notifications/{docId}').onCreate(async(snapshot,context)=>{
  let user=await db.collection('users').doc(snapshot.data().userId).get();
  let shopId=snapshot.data().shopId;
  let shop= ( await db.collection('shops').doc(shopId).get()).data();
  if(shop.maximumNotifications>0 && shop.allowPush && shop.isActive){
   await db.collection('shops').doc(shopId).update({
      'maximumNotifications':shop.maximumNotifications-1
    });
    if(user){
      return admin.messaging().sendToDevice(user.data().fcmId,{
           data:{
               click_action: "FLUTTER_NOTIFICATION_CLICK",
               'shopId':shopId??'',
              },
               notification:{
               title:snapshot.data().title,
               sound:"default",
               body:snapshot.data().body,
               badge:"1",
               tag:snapshot.id,
               
           }
       },notification_options);
     }
  }
  
 
    
})
exports.onNewUserCreated = functions.firestore.document('users/{docId}').onCreate(async(snapshot,context)=>{
  let user=snapshot.data();
  let fcmId=user.fcmId;
   return admin.messaging().sendToDevice(fcmId,{
        data:{
            click_action: "FLUTTER_NOTIFICATION_CLICK"},
            notification:{
            title:welcomeTo,
            sound:"default",
            body:`${hi},${user.name?? user.email} ${thanksForUsing}.`,
            badge:"1",
            tag:snapshot.id,
        }
    },notification_options);
    
});

exports.onUserDeleted = functions.firestore.document('users/{docId}').onDelete(async(snapshot,context)=>{
  let user=snapshot.data();
  await  admin.auth().deleteUser(user.userId);
    
});

exports.onMessage = functions.firestore.document('messages/{docId}').onCreate(async(snapshot,context)=>{
  let message=snapshot.data();
  let messageReceiver=(await db.collection('users').doc(message.receiverId).get()).data();
  let messageSender=(await db.collection('users').doc(message.senderId).get()).data();
  let fcmId=messageReceiver.fcmId;
   return admin.messaging().sendToDevice(fcmId,{
        data:{
            click_action: "FLUTTER_NOTIFICATION_CLICK"},
            notification:{
            title:`${messageSender.name??messageSender.email}`,
            sound:"default",
            body:`${message.body}`,
            badge:"1",
            tag:snapshot.id,
        }
    },notification_options);
    
});
exports.onRating = functions.firestore.document('reviews/{docId}').onCreate(async(snapshot,context)=>{
  let review=snapshot.data();
  let shop=await db.collection('shops').doc(review.shopId).get();
  let allReviews=await db.collection('reviews').where('shopId','==',review.shopId).get();
  var allReviewCount=0.0;

  allReviews.docs.forEach((e)=>{
      allReviewCount+=e.data().rating;
  });
  await db.collection('shops').doc(review.shopId).update({'rating':allReviewCount/allReviews.docs.length,
  'totalReviews':allReviews.docs.length,
}); 
});


exports.onPointEarn = functions.firestore.document('points/{points}').onCreate(async(snapshot,context)=>{
  let point=snapshot.data();
  let user=(await db.collection('users').doc(point.userId).get()).data();
   await db.collection('users').doc(point.userId).update({
     'points':(user.points||0)+point.point
   });
   await db.collection('notifications').add({
    'userId':point.userId,
    'body':point.title,
    'title':point.point>0?pointEarn:pointLose
  });
});

exports.onShopVisited = functions.firestore.document('shops/{shopId}/views/{docId}').onCreate(async(snapshot,context)=>{
  let shopId=context.params.shopId;
  let shop=await db.collection('shops').doc(shopId).update({
    'totalvisits':firestore.FieldValue.increment(1)
  })

});


exports.onAppOpened = functions.firestore.document('AppOpen/{docId}').onCreate(async(snapshot,context)=>{
  let data=snapshot.data(); 
  let userId=data.userId;
  let lat=data.lat;
  let lon=data.lon;
  let allShops=await db.collection('shops').
  where('isActive','==',true)
  .where('allowPush','==',true)
  .where('maximumNotifications','>',0)
  .get();

  allShops.forEach(async(e)=>{
    try{
     let shop=e.data();
     let shopLat=shop.location[0];
     let shopLon=shop.location[1];
    let distanceInKm=calcDistance(shopLat,shopLon,lat,lon);
    let range=shop.notificationKmRange??5;
    if(distanceInKm<=range && shop.userId!=userId){
      await db.collection('notifications').add({
        'shopId':e.id,
        'userId':userId,
        'body':`${checkMyShop} ${distanceInKm.toFixed(2)} km ${nearYou}.`,
        'title':`${shop.name} ${isNearYou}`
      });
    }
    }catch(e){}

  });
});

///distance calculation
function calcDistance(lat1, lon1, lat2, lon2) 
    {
      var R = 6371; // km
      var dLat = toRad(lat2-lat1);
      var dLon = toRad(lon2-lon1);
      var lat1 = toRad(lat1);
      var lat2 = toRad(lat2);

      var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
      var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
      var d = R * c;
      return d;
    }

    // Converts numeric degrees to radians
    function toRad(Value) 
    {
        return Value * Math.PI / 180;
    }
