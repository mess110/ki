require 'spec_helper'

describe Ki::Middleware do
  context Ki::Middleware::ApiHandler do
    it 'should only handle urls maped from objects that extend Ki::Model' do
      get '/asd.json'
      JSON.parse(last_response.body)
      last_response.status.should == 404
    end
  end
end
