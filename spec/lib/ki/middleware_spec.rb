# frozen_string_literal: true

require 'spec_helper'

describe Ki::Middleware do
  context Ki::Middleware::ApiHandler do
    it 'should only handle urls maped from objects that extend Ki::Model' do
      get '/asd.json'
      json
      expect(last_response.status).to eq 404
    end
  end
end
