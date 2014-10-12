require 'spec_helper'

describe Ki::Orm do
  before :all do
    @db = Ki::Orm::Db.instance.establish_connection
  end

  it 'should know db name in test env' do
    @db.config['name'].should == 'np_test'
  end

  it 'should create a db object' do
    expect {
      oid = @db.insert 'foo', {hello: 'world'}
      oid.class.should == Hash
    }.to change{@db.count('foo')}.by(1)
  end

  context 'count' do
    it 'should count' do
      expect {
        @db.insert 'foo', {hello: 'world'}
      }.to change{@db.count('foo')}.by(1)
    end

    it 'should count by hash' do
      t = Time.now.to_i.to_s
      expect {
        @db.insert 'foo', {hello: t}
      }.to change{@db.count('foo', {hello: t})}.by(1)
    end
  end

  context 'find' do
    it 'should find all' do
      @db.insert 'foo', {hello: 'world'}
      @db.insert 'foo', {hello: 'world'}
      @db.find('foo').to_a.count.should >= 2
    end

    it 'should find by string id' do
      obj_id = @db.insert('foo', {hello: 'world'})['id']
      @db.find('foo', obj_id).first['id'].should == obj_id
    end

    it 'should find by hash["id"]' do
      obj_id = @db.insert 'foo', {'hello' => 'world'}
      @db.find('foo', {'id' => obj_id['id']}).first.should == obj_id
    end

    it 'should find by hash["_id"]' do
      obj_id = @db.insert('foo', {hello: 'world'})['id']
      @db.find('foo', {'_id' => obj_id}).first['id'].should == obj_id
    end

    it 'should find by BSON::ObjectId(id)' do
      obj_id = @db.insert('foo', {'hello' => 'world'})['id']
      @db.find('foo', {'id' => BSON::ObjectId(obj_id)}).first['id'].should == obj_id
      @db.find('foo', {'_id' => BSON::ObjectId(obj_id)}).first['id'].should == obj_id
    end

    it 'should return empty array when nothing found' do
      r = @db.find('foo', {'it does not exist' => 'sure hope so' + Time.now.to_i.to_s })
      r.class.should == Array
      r.should be_empty
    end
  end

  it 'should update' do
    obj_id = @db.insert('foo', { 'hello' => 'world' })['id']
    @db.find('foo', obj_id).first['hello'].should == 'world'
    up = @db.update('foo', { 'id' => obj_id, 'hello' => 'universe' })['id']
    up.should == obj_id
    @db.find('foo', obj_id).first['hello'].should == 'universe'
  end

  it 'should delete by id' do
    obj_id = @db.insert 'foo', { 'hello' => 'world' }
    expect {
      @db.delete('foo', obj_id).should == {}
    }.to change { @db.count 'foo' }.by -1
  end
end
