# frozen_string_literal: true

require 'spec_helper'

describe Ki::Middleware::InitMiddleware do
  let(:app) { {} }
  let(:init) { Ki::Middleware::InitMiddleware.new app }
  let(:req) { Ki::BaseRequest }

  it 'redirects to /index if public/index.html does not exist' do
    env = Rack::MockRequest.env_for('/', { 'REQUEST_METHOD' => 'GET' })
    resp = init.call env
    expect(resp[0]).to eq 302 # redirect
  end

  it 'renders index.html if it exists' do
    env = Rack::MockRequest.env_for('/', { 'REQUEST_METHOD' => 'GET' })

    expect_any_instance_of(Ki::Middleware::InitMiddleware).to receive(:public_file_exists?).and_return(true)
    resp = init.call env
    expect(resp[0]).to eq 404 # not found because index.html doesn't exist
  end
end
