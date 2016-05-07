require './app'
unless `hostname`.include?('glassic-jenkins')
  Faye::WebSocket.load_adapter('thin')
end
use Rack::Reloader, 0
run Ki::Ki.new
