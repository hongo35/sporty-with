// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require moment
//= require push.min
//= require_tree .

/*
$(function(){
  if(!canUsePushNotificatioin('permission_request')){
    Push.Permission.request();
  }
});

function canUsePushNotificatioin(ua) {
  var version = ua != 'permission_request' ? ua.toLowerCase() : window.navigator.appVersion.toLowerCase();
  return (version.indexOf("msie 6.") != -1 || version.indexOf("msie 7.") != -1 || version.indexOf("msie 8.") != -1 || version.indexOf("msie 9.") != -1 || version.indexOf("msie 10.") != -1 || version.indexOf("rv:11.") != -1);
}
*/
