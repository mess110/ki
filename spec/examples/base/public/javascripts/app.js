// var client = new Faye.Client('/faye');
// client.disable('autodisconnect');
// client.publish('/message', {text: 'Hi there'});
// var subscription = client.subscribe('/message', function(message) {
  // console.log(message);
// }).then(function () {
  // console.log('active');
// });

var socket = new WebSocket("ws://localhost:1337/faye");
socket.onmessage = function(m) {console.log(m);}
socket.onclose   = function()  {console.log('socket closed');}
