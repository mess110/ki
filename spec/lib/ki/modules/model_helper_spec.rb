require 'spec_helper'

describe Ki::Model::ModelHelper do
  include Ki::Model::ModelHelper

  it 'has skipped params' do
    expect(skipped_params).to eq []
  end

  # TODO: find out if this is a good idea
  it 'tests the request' do
    class TmpClassModelHelper
      def get?
        true
      end

      def post?
        true
      end

      def put?
        true
      end

      def delete?
        true
      end
    end

    @req = TmpClassModelHelper.new
    expect(post?).to be true
    expect(put?).to be true
    expect(delete?).to be true
  end
end
