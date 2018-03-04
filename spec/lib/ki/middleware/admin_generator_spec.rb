# frozen_string_literal: true

require 'spec_helper'

describe Ki::Middleware::AdminInterfaceGenerator do
  it 'works' do
    get '/instadmin'
    expect(last_response.body).to include('Ki InstAdmin')
  end
end
