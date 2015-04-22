require 'spec_helper'

describe Ki::Ki do
  class CorsResource < Ki::Model
  end

  it 'has CORS enabled' do
    get '/cors_resource.json'
    expect(last_response.headers.key?("Vary")).to be true
  end
end
