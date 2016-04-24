# Realtime

The following webservers are supported:

* Goliath
* Phusion Passenger >= 4.0 with nginx >= 1.4
* Puma >= 2.0
* Rainbows
* Thin

## Requrirements

* Load the adapter for your webserver in config.ru after 'require' (example: Faye::WebSocket.load_adapter('thin'))
* You need to run in production mode (example: rackup -p 1337 -E production)
* add the Realtime middlware in config.yml (example: add_middleware: 'Realtime')

## Documentation

Ki realtime offers channels to which a user subscribes to. Once a user is subscribed
to a channel he/she will recive messages from that channel. Anybody can publish
messages in a channel.

Upon connecting, the user will receive a unique id.

Using WebSockets, connect to the /realtime endpoint:

```javascript
// connect
var socket = new WebSocket("ws://localhost:1337/realtime");
socket.onclose = function() { console.log('socket closed'); }
socket.onmessage = function(m) {
  json = JSON.parse(m)
  console.log(json);
}

send = function (hash) {
  socket.send(JSON.stringify(hash))
}

// Subscribe to channel events
send({type: 'subscribe', channel_name: 'my-channel'})

// Unsubscribe from channel events
send({type: 'unsubscribe', channel_name: 'my-channel'})

// Send a message to a channel
send({type: 'publish', channel_name: 'my-channel', text: 'asd', custom_attribute: [1, 'text']})

```
