module Ki
  module Middleware #:nodoc:
    class Realtime
      include BaseMiddleware

      def ws_send(ws, hash)
        ws.send(hash.to_json.to_s)
      end

      def call(env)
        req = BaseRequest.new env
        if req.path.to_s == '/realtime/info'
          hash = {
            sockets: ::Ki::ChannelManager.sockets,
          }
          resp = Rack::Response.new(hash.to_json, 200)
          resp['Content-Type'] = 'application/json'
          resp.finish
        elsif req.path.to_s == '/realtime' && Faye::WebSocket.websocket?(env)
          ws = Faye::WebSocket.new(env)

          socket = ::Ki::ChannelManager.connect
          ws_send(ws, socket)

          ws.on :message do |event|
            begin
              json = JSON.parse(event.data)
              json['socket_id'] = socket['id']
              if json['type'] == 'subscribe'
                output = ::Ki::ChannelManager.subscribe json
                if json['channel_name']
                  ws_send(ws, output)
                else
                  ws_send(ws, { message: 'Please specify a channel_name' })
                end
              elsif json['type'] == 'unsubscribe'
                output = ::Ki::ChannelManager.unsubscribe json
                ws_send(ws, output)
              elsif json['type'] == 'publish'
                if json['channel_name']
                  output = ::Ki::ChannelManager.publish json
                  ws_send(ws, output)
                else
                  ws_send(ws, { message: 'Please specify a channel_name' })
                end
              else
                ws_send(ws, { message: 'Please specify a valid type' })
              end
            rescue JSON::ParserError
              ws_send(ws, { message: 'Please send a valid json string' })
            end
          end

          timer = EventMachine::PeriodicTimer.new(1) do
            msgs = ::Ki::ChannelManager.tick(socket_id: socket['id'])
            ws_send(ws, { messages: msgs }) if msgs.count > 0
          end

          ws.on :close do |event|
            timer.cancel
            # p [:close, event.code, event.reason]
            ::Ki::ChannelManager.disconnect socket
            ws = nil
          end

          ws.rack_response
        else
          @app.call env
        end
      end
    end
  end
end
