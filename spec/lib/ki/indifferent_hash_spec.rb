# frozen_string_literal: true

require 'spec_helper'

describe IndifferentHash do
  let(:hash) { IndifferentHash.new }

  it 'works' do
    hash['asd'] = 1
    expect(hash[:asd]).to eq hash['asd']
  end
end
