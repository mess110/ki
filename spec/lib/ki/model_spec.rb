require 'spec_helper'

describe Ki::Model do
  before :all do
    class Foo < Ki::Model; end
    class Bar < Ki::Model; end
  end

  it 'should know about all descendants' do
    desc = Ki::Model.descendants
    desc.include?(Foo).should be_true
    desc.include?(Bar).should be_true
  end

  context Ki::Model::QueryInterface do
    it 'should have the query interface' do
      Foo.class_name.should eq 'Foo'
      expect do
        id = Foo.create({ hello: 'world' })['id']
        Foo.find(id).first['hello'].should eq 'world'
        Foo.update('id' => id, 'hello' => 'universe')
        Foo.find(id).first['hello'].should eq 'universe'
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
    Bar.unique_attributes.should eq []
    Bar.required_attributes.should eq []
    Bar.forbidden_actions.should eq []

    class Bar < Ki::Model
      unique :foo
      requires :foo
      forbid :delete
    end

    Bar.unique_attributes.should eq [:foo]
    Bar.required_attributes.should eq [:foo]
    Bar.forbidden_actions.should eq [:delete]
  end

  context 'default properties' do
    class DefaultProperties < Ki::Model
    end

    it 'should create object' do
      mock_req = {}
      mock_req.stub(:to_action).and_return(:create)
      mock_req.stub(:params).and_return({})

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
      mock_req.stub(:to_action).and_return(:create)
      mock_req.stub(:params).and_return('name' => 'zim', 'foo' => t)

      expect {
        SpecialProperties.new(mock_req)
      }.to change { SpecialProperties.count }.by 1
    end

    it 'should check for required attributes' do
      mock_req = {}
      mock_req.stub(:to_action).and_return(:create)
      mock_req.stub(:params).and_return({})

      expect {
        SpecialProperties.new(mock_req)
      }.to raise_error Ki::RequiredAttributeMissing
    end

    it 'should check for unique attributes' do
      t = Time.now.to_i
      mock_req = {}
      mock_req.stub(:to_action).and_return(:create)
      mock_req.stub(:params).and_return({ 'name' => 'zim', 'foo' => t })

      expect {
        SpecialProperties.new(mock_req)
        SpecialProperties.new(mock_req)
      }.to raise_error Ki::AttributeNotUnique
    end

    it 'should not allow forbidden actions' do
      mock_req = {}
      mock_req.stub(:to_action).and_return(:delete)
      mock_req.stub(:params).and_return({})

      expect {
        SpecialProperties.new(mock_req)
      }.to raise_error Ki::ForbiddenAction
    end
  end
end
