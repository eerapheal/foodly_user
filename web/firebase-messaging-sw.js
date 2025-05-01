importScripts('https://www.gstatic.com/firebasejs/9.1.3/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/9.1.3/firebase-messaging.js');

firebase.initializeApp({
            apiKey: "AIzaSyBy0My66SO_S8p1BXajWuUQPiI_XRwQO7Y",
            authDomain: "flutter-foodly-final-7d6ce.firebaseapp.com",
            databaseURL: "https://flutter-foodly-final-7d6ce-default-rtdb.asia-southeast1.firebasedatabase.app",
            projectId: "flutter-foodly-final-7d6ce",
            storageBucket: "flutter-foodly-final-7d6ce.appspot.com",
            messagingSenderId: "478084903744",
            appId: "1:478084903744:web:0ef129fa03529bd7c100a5"
});

  const messaging = firebase.messaging();

  /*messaging.onMessage((payload) => {
  console.log('Message received. ', payload);*/
  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });
