require 'singleton'

module Ki
  module Orm
    class Db
      include Singleton

      attr_reader :config, :connection, :db

      def establish_connection
        @config = KiConfig.instance.database
        @connection = Mongo::Connection.new(@config['host'], @config['port'])
        @db = @connection.db(@config['name'])
        self
      end

      def collection_names
        @db.collection_names.delete_if{|name| name =~ /^system/}
      end

      def insert name, hash
        @db[name].insert(hash)
        [hash].stringify_ids.first
      end

      def find name, hash={}
        hash = nourish_hash_id hash
        @db[name].find(hash).to_a.stringify_ids
      end

      def update name, hash
        hash = nourish_hash_id hash
        id = hash['_id'].to_s
        hash.delete('_id')
        @db[name].update({'_id' => BSON::ObjectId(id)}, hash)
        hash['id'] = id
        hash
      end

      def delete name, hash
        hash = nourish_hash_id hash
        @db[name].remove hash
        {}
      end

      def count name, hash={}
        @db[name].count hash
      end

      private

      def nourish_hash_id hash
        hash = { '_id' => BSON::ObjectId(hash) } if hash.class == String
        if hash['id']
          hash['_id'] = hash['id']
          hash.delete('id')
        end
        if hash['_id'].class == String
          hash['_id'] = BSON::ObjectId(hash['_id'].to_s)
        end
        hash
      end
    end
  end
end
