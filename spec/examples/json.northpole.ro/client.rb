require 'httparty'

class NPClient
  include HTTParty
  base_uri 'localhost:9292'
  format :json

  def options
    {
      body: {
      secret: 'foo'
    }
    }
  end

  def find o
    self.class.get("/storage.json", body: o)
  end

  def create o
    self.class.post("/storage.json", body: o)
  end
end

p NPClient.new.find({"api_key" => "guest", "secret" => "secret"})
