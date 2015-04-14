require 'spec_helper'

describe Ki::Model do
  before :all do
    class Foo < Ki::Model; end
    class Bar < Ki::Model; end
  end

  it "should know about all descendants" do
    desc = Ki::Model.descendants
    desc.include?(Foo).should be_true
    desc.include?(Bar).should be_true
  end

  context Ki::Model::QueryInterface do
    it 'should have the query interface' do
      Foo.class_name.should == 'Foo'
      expect {
        id = Foo.create({hello: 'world'})['id']
        Foo.find(id).first['hello'].should == 'world'
        Foo.update('id' => id, 'hello' => 'universe')
        Foo.find(id).first['hello'].should == 'universe'
        Foo.delete(id)
      }.to change { Foo.count }.by 0
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
    Bar.unique_attributes.should == []
    Bar.required_attributes.should == []
    Bar.forbidden_actions.should == []

    class Bar < Ki::Model
      unique :foo
      requires :foo
      forbid :delete
    end

    Bar.unique_attributes.should == [:foo]
    Bar.required_attributes.should == [:foo]
    Bar.forbidden_actions.should == [:delete]
  end

  context 'default properties' do
    class DefaultProperties < Ki::Model
    end

    it 'should create object' do
      expect {
        DefaultProperties.new(:create, { 'name' => 'zim' })
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
      SpecialProperties.delete({'foo' => t})
      expect {
        SpecialProperties.new(:create, { 'name' => 'zim', 'foo' => t })
      }.to change { SpecialProperties.count }.by 1
    end

    it 'should check for required attributes' do
      expect {
        SpecialProperties.new(:create, { 'name' => 'zim' })
      }.to raise_error Ki::RequiredAttributeMissing
    end

    it 'should check for unique attributes' do
      expect {
        t = Time.now.to_i
        SpecialProperties.new(:create, { 'name' => 'zim', 'foo' => t })
        SpecialProperties.new(:create, { 'name' => 'zim', 'foo' => t })
      }.to raise_error Ki::AttributeNotUnique
    end

    it 'should not allow forbidden actions' do
      expect {
        SpecialProperties.new(:delete, {})
      }.to raise_error Ki::ForbiddenAction
    end
  end
end
