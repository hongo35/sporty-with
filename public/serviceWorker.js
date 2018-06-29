self.addEventListener('install', function(event) {
  console.log('Service Worker installing.');
});

self.addEventListener('activate', function(event) {
  console.log('Service Worker activating.');  
});


self.addEventListener('fetch', function(event) {

});

self.addEventListener("push", function(event) {
  event.waitUntil(
    self.registration.showNotification("Push通知タイトル", {
      body: "Push通知本文"
    })
  )
});
