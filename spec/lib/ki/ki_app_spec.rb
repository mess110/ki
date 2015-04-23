require 'spec_helper'

describe Ki::KiApp do
  it 'html returns 404 if not found' do
    get '/invalid_url'
    expect(last_response.status).to eq 404
  end

  it 'json returns 404 if not found' do
    get '/invalid_url.json'
    expect(last_response.status).to eq 404
  end
end
