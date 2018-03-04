require 'spec_helper'

describe Ki::Model do
  before :all do
    class Foo < Ki::Model; end
    class Bar < Ki::Model; end
  end

  it 'knows about descendants' do
    desc = Ki::Model.descendants
    expect(desc).to include(Foo)
    expect(desc).to include(Bar)
  end

  context Ki::Model::QueryInterface do
    it 'should have the query interface' do
      expect(Foo.class_name).to eq 'Foo'
      expect do
        id = Foo.create({ hello: 'world' })['id']
        expect(Foo.find(id).first['hello']).to eq 'world'
        Foo.update('id' => id, 'hello' => 'universe')
        expect(Foo.find(id).first['hello']).to eq 'universe'
        Foo.delete(id)
      end.to change { Foo.count }.by 0
    end

    it 'should find or create' do
      expect {
        h = { time: Time.now.to_i.to_s, random: SecureRandom.uuid }
        Foo.find_or_create(h)
        Foo.find_or_create(h)
      }.to change { Foo.count }.by 1
    end
  end

  it 'should have restrictions configured' do
    expect(Bar.unique_attributes).to eq []
    expect(Bar.required_attributes).to eq []
    expect(Bar.forbidden_actions).to eq []

    class Bar < Ki::Model
      unique :foo
      requires :foo
      forbid :delete
    end

    expect(Bar.unique_attributes).to eq [:foo]
    expect(Bar.required_attributes).to eq [:foo]
    expect(Bar.forbidden_actions).to eq [:delete]
  end

  context 'default properties' do
    class DefaultProperties < Ki::Model
    end

    it 'should create object' do
      mock_req = {}
      expect(mock_req).to receive(:to_action).and_return(:create)
      # mock_req.stub(:to_action).and_return(:create)
      # mock_req.stub(:params).and_return({})
      expect(mock_req).to receive(:params).and_return({})

      expect {
        DefaultProperties.new(mock_req)
      }.to change { DefaultProperties.count }.by 1
    end
  end

  context 'required, unique, forbid' do
    class SpecialProperties < Ki::Model
      unique :foo
      requires :foo
      forbid :delete
    end

    it 'should create object' do
      t = Time.now.to_i
      # keep in mind that delete does not call unique/requires/forbid filters
      # make sure there are no duplicates
      SpecialProperties.delete({ 'foo' => t })

      mock_req = {}
      expect(mock_req).to receive(:to_action).and_return(:create)
      expect(mock_req).to receive(:params).and_return('name' => 'zim', 'foo' => t)

      expect {
        SpecialProperties.new(mock_req)
      }.to change { SpecialProperties.count }.by 1
    end

    it 'should check for required attributes' do
      mock_req = {}
      expect(mock_req).to receive(:to_action).and_return(:create)
      expect(mock_req).to receive(:params).and_return({})

      expect {
        SpecialProperties.new(mock_req)
      }.to raise_error Ki::RequiredAttributeMissing
    end

    it 'should check for unique attributes' do
      t = Time.now.to_i
      mock_req = {}
      expect(mock_req).to receive(:to_action).and_return(:create)
      expect(mock_req).to receive(:params).and_return({ 'name' => 'zim', 'foo' => t })

      expect {
        SpecialProperties.new(mock_req)
        SpecialProperties.new(mock_req)
      }.to raise_error Ki::AttributeNotUnique
    end

    it 'should not allow forbidden actions' do
      mock_req = {}
      expect(mock_req).to receive(:to_action).and_return(:delete)
      expect(mock_req).to receive(:params).and_return({})

      expect {
        SpecialProperties.new(mock_req)
      }.to raise_error Ki::ForbiddenAction
    end
  end
end
