# frozen_string_literal: true

require 'spec_helper'

describe Ki::Orm do
  before :all do
    @db = Ki::Orm::Db.instance.establish_connection
  end

  it 'should know db name in test env' do
    expect(@db.config['name']).to eq 'np_test'
  end

  it 'has a connection string' do
    expect(@db.connection_string.class).to be String
  end

  it 'should create a db object' do
    expect {
      oid = @db.insert 'foo', { hello: 'world' }
      expect(oid).to be_a(Hash)
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
      expect(@db.find('foo').to_a.size).to be >= 2
    end

    it 'should find by string id' do
      obj_id = @db.insert('foo', { hello: 'world' })['id']
      expect(@db.find('foo', obj_id).first['id']).to eq obj_id
    end

    it 'should find by hash["id"]' do
      obj_id = @db.insert('foo', { 'hello' => 'world' })['id']
      find_query = @db.find('foo', { 'id' => obj_id })
      expect(find_query.first['id']).to eq obj_id
    end

    it 'should find by hash["_id"]' do
      obj_id = @db.insert('foo', { hello: 'world' })['id']
      expect(@db.find('foo', { '_id' => obj_id }).first['id']).to eq obj_id
    end

    it 'should find by BSON::ObjectId(id)' do
      obj_id = @db.insert('foo', { 'hello' => 'world' })['id']
      expect(@db.find('foo', { 'id' => BSON::ObjectId(obj_id) }).first['id']).to eq obj_id
      expect(@db.find('foo', { '_id' => BSON::ObjectId(obj_id) }).first['id']).to eq obj_id
    end

    it 'should return empty array when nothing found' do
      r = @db.find('foo', { 'it does not exist' => 'sure hope so' + Time.now.to_i.to_s })
      expect(r.class).to eq Array
      expect(r).to be_empty
    end

    it 'applies sorting according to __sort key' do
      @db.delete('sort_tests', {})

      @db.insert('sort_tests', { 'value' => 1 })
      @db.insert('sort_tests', { 'value' => 2 })

      r = @db.find('sort_tests', { '__sort' => { 'value' => -1 } })
      expect(r.size).to eq 2
      expect(r[0]['value']).to eq 2
      expect(r[1]['value']).to eq 1

      r = @db.find('sort_tests', { '__sort' => { 'value' => 1 } })
      expect(r.size).to eq 2
      expect(r[0]['value']).to eq 1
      expect(r[1]['value']).to eq 2
    end

    it 'applies limiting according to __limit key' do
      3.times do
        @db.insert('limit_tests', { 'created_at' => Time.now.to_i })
      end

      r = @db.find('limit_tests', { '__limit' => 2 })
      expect(r.size).to eq 2
    end

    it 'queries by regex' do
      @db.delete('regex_tests', {})
      @db.insert('regex_tests', { 'name' => 'hello', 'created_at' => Time.now.to_i })
      @db.insert('regex_tests', { 'name' => 'hello world', 'created_at' => Time.now.to_i })

      r = @db.find('regex_tests', { 'name' => /world/ })
      expect(r.size).to eq 1

      r = @db.find('regex_tests', { 'name' => 'world', '__regex' => 'name' })
      expect(r.size).to eq 1

      r = @db.find('regex_tests', { 'name' => 'world', '__regex' => ['name'] })
      expect(r.size).to eq 1
    end
  end

  it 'should update' do
    obj_id = @db.insert('foo', { 'hello' => 'world' })['id']
    expect(@db.find('foo', obj_id).first['hello']).to eq 'world'
    up = @db.update('foo', { 'id' => obj_id, 'hello' => 'universe' })['id']
    expect(up).to eq obj_id
    expect(@db.find('foo', obj_id).first['hello']).to eq 'universe'
  end

  it 'should delete by id' do
    obj_id = @db.insert 'foo', { 'hello' => 'world' }
    expect {
      expect(@db.delete('foo', obj_id)).to eq({ deleted_item_count: 1 })
    }.to change { @db.count 'foo' }.by(-1)
  end
end
