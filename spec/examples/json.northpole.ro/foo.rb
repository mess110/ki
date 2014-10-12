require 'uri'
require 'net/http'
require 'json'

uri = URI.parse("http://localhost:9292")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new("/storage.json")
request.body = {'api_key' => 'guest', 'secret' => 'guest'}.to_json
response = http.request(request)
p response.body
