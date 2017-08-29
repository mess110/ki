require 'spec_helper'

describe Ki::ApiError do
  it 'knows about descendants' do
    expect(Ki::ApiError.descendants).to include(Ki::InvalidUrlError)
  end
end
