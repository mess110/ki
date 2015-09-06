require 'spec_helper'

describe Ki::Orm do
  before :all do
    @db = Ki::Orm::Db.instance.establish_connection
  end

  it 'should know db name in test env' do
    @db.config['name'].should == 'np_test'
  end

  it 'has a connection string' do
    expect(@db.connection_string.class).to be String
  end

  it 'should create a db object' do
    expect {
      oid = @db.insert 'foo', { hello: 'world' }
      oid.class.should == Hash
    }.to change { @db.count('foo') }.by(1)
  end

  context 'count' do
    it 'should count' do
      expect {
        @db.insert 'foo', { hello: 'world' }
      }.to change { @db.count('foo') }.by(1)
    end

    it 'should count by hash' do
      t = Time.now.to_i.to_s
      expect {
        @db.insert 'foo', { hello: t }
      }.to change { @db.count('foo', { hello: t }) }.by(1)
    end
  end

  context 'find' do
    it 'should find all' do
      @db.insert 'foo', { hello: 'world' }
      @db.insert 'foo', { hello: 'world' }
      @db.find('foo').to_a.size.should >= 2
    end

    it 'should find by string id' do
      obj_id = @db.insert('foo', { hello: 'world' })['id']
      @db.find('foo', obj_id).first['id'].should eq obj_id
    end

    it 'should find by hash["id"]' do
      obj_id = @db.insert 'foo', { 'hello' => 'world' }
      @db.find('foo', { 'id' => obj_id['id'] }).first.should eq obj_id
    end

    it 'should find by hash["_id"]' do
      obj_id = @db.insert('foo', { hello: 'world' })['id']
      @db.find('foo', { '_id' => obj_id }).first['id'].should eq obj_id
    end

    it 'should find by BSON::ObjectId(id)' do
      obj_id = @db.insert('foo', { 'hello' => 'world' })['id']
      @db.find('foo', { 'id' => BSON::ObjectId(obj_id) }).first['id'].should eq obj_id
      @db.find('foo', { '_id' => BSON::ObjectId(obj_id) }).first['id'].should eq obj_id
    end

    it 'should return empty array when nothing found' do
      r = @db.find('foo', { 'it does not exist' => 'sure hope so' + Time.now.to_i.to_s })
      expect(r.class).to eq Array
      expect(r).to be_empty
    end
  end

  it 'should update' do
    obj_id = @db.insert('foo', { 'hello' => 'world' })['id']
    @db.find('foo', obj_id).first['hello'].should eq 'world'
    up = @db.update('foo', { 'id' => obj_id, 'hello' => 'universe' })['id']
    up.should eq obj_id
    @db.find('foo', obj_id).first['hello'].should eq 'universe'
  end

  it 'should delete by id' do
    obj_id = @db.insert 'foo', { 'hello' => 'world' }
    expect {
      @db.delete('foo', obj_id).should == { deleted_item_count: 1 }
    }.to change { @db.count 'foo' }.by(-1)
  end
end
