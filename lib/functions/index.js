const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.updateAppointments = functions.pubsub.schedule('every 15 minutes').onRun(async (context) => {
  const now = Date.now();
  const appointmentsRef = admin.firestore().collection("appointments");

  const snapshot = await appointmentsRef
    .where("status", "==", "Booked")
    .get();

  if (snapshot.empty) {
    console.log("No appointments found with status = Booked");
    return;
  }

  snapshot.forEach(async (doc) => {
    const data = doc.data();
    const now = new Date();


    const timeString = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });


    const dateString = now.toLocaleDateString([], { day: '2-digit', month: 'long', year: 'numeric' });


    time = timeString.split(" ")[0]; 
    date = dateString.split(" ")[0]+","+dateString.split(" ")[1]+dateString.split(" ")[2] ;

    console.log(time) ; 
    console.log(date) ;
    if(data.hasOwnProperty("status")) {
    // const allottedTime = new Date(data.date + " " + data.slotChosen['hour']).getTime();
      var currentMinutes = parseInt(time.split(":")[0])*60 + parseInt(time.split(":")[1]);
      var chosenMinutes = data.slotChosen['hour']*60 + data.slotChosen['minute'] ;
      var sessionTimeMinutes = parseint(data.sessionTime);
      if (currentMinutes > chosenMinutes + sessionTimeMinutes ) {
        await appointmentsRef.doc(doc.id).update({ status: "unattended" });
        // console.log(`Updated appointment with ID: ${doc.id}`);
        console.log("CHANGED TO UNATTENDED") ;
      }
  }
  });
});