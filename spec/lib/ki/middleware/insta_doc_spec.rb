# frozen_string_literal: true

require 'spec_helper'

describe Ki::Middleware::InstaDoc do
  it 'works' do
    get '/instadoc'
    expect(last_response.body).to include('Ki InstaDoc')
  end
end
