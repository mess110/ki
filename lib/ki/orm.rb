# frozen_string_literal: true

require 'singleton'

module Ki
  module Orm #:nodoc:
    # This singleton class establishes the database connection and CRUD
    # operations.
    #
    # == Connecting
    #
    #   Db.instance.establish_connection
    #
    # == Queries
    #
    #   db = Db.instance
    #   db.find 'users', {}
    #   db.find 'users', { name: 'Homer' }
    #
    class Db
      include Singleton

      attr_reader :config, :connection, :db

      # Creates the mongo connection.
      #
      # It first checks if the env variable "MONGODB_URI" is set. The required
      # format: http://docs.mongodb.org/manual/reference/connection-string/
      #
      # If the env variable is not set, it will use the information stored in
      # config.yml.
      #
      def establish_connection
        Mongo::Logger.logger.level = Logger::FATAL
        # Mongo::Logger.logger       = Logger.new('mongo.log')
        # Mongo::Logger.logger.level = Logger::INFO

        @config = KiConfig.instance.database
        @db = if ENV['MONGODB_URI']
                Mongo::Client.new
              else
                Mongo::Client.new('mongodb://' + connection_string)
              end
        self
      end

      def connection_string
        db = KiConfig.instance.database
        if ENV['MONGODB_URI']
          ENV['MONGODB_URI']
        else
          "#{db['host']}:#{db['port']}/#{db['name']}"
        end
      end

      # ==== Returns
      #
      # An array of all the collection names in the database.
      #
      def collection_names
        @db.collection_names.delete_if { |name| name =~ /^system/ }
      end

      # Insert a hash in the database.
      #
      # ==== Attributes
      #
      # * +name+ - the mongo collection name
      # * +hash+ - the hash which will be inserted
      #
      # ==== Returns
      #
      # The inserted hash.
      #
      # * +:conditions+ - An SQL fragment like "administrator = 1"
      #
      # ==== Examples
      #
      #   db = Db.instance
      #   db.insert 'users', { name: 'Homer' }
      #
      def insert(name, hash)
        item = @db[name].insert_one(hash)
        hash['id'] = item.inserted_id.to_s
        hash
      end

      # Find a hash in the database
      #
      # ==== Attributes
      #
      # * +name+ - the mongo collection name
      #
      # ==== Options
      #
      # * +:hash+ - Filter by specific hash attributes
      #
      # ==== Returns
      #
      # An array of hashes which match the query criteria
      #
      # ==== Examples
      #
      #   db = Db.instance
      #   db.find 'users'
      #   db.find 'users', { id: 'id' }
      #   db.find 'users', { name: 'Homer' }
      #
      def find(name, hash = {})
        hash = nourish_hash_id hash
        a = nourish_regex hash
        hash = a[0]

        a = nourish_hash_limit hash
        hash = a[0]
        limit = a[1]
        a = nourish_hash_sort hash
        hash = a[0]
        sort = a[1]

        @db[name].find(hash, limit).sort(sort).to_a.stringify_ids
      end

      # Update a hash from the database
      #
      # The method will update the hash obj with the id specified in the hash
      # attribute.
      #
      # ==== Attributes
      #
      # * +name+ - the mongo collection name
      # * +hash+ - requires at least the id of the hash which needs to be
      #            updated
      #
      # ==== Returns
      #
      # The updated hash
      #
      # ==== Examples
      #
      #  db = Db.instance
      #  db.update('users', { id: 'id', name: 'Sir Homer' })
      #
      def update(name, hash)
        hash = nourish_hash_id hash
        id = hash['_id'].to_s
        hash.delete('_id')
        @db[name].update_one({ '_id' => BSON::ObjectId(id) }, hash)
        hash['id'] = id
        hash
      end

      # Deletes a hash from the database
      #
      # ==== Attributes
      #
      # * +name+ - the mongo collection name
      # * +:hash+ - Filter by specific hash attributes. id required
      #
      # ==== Returns
      #
      # Empty hash
      #
      # ==== Examples
      #
      #   db = Db.instance
      #   db.delete 'users', { id: 'id' }
      #   db.delete 'users', {}
      #
      def delete(name, hash)
        hash = nourish_hash_id hash
        r = @db[name].delete_many hash
        {
          deleted_item_count: r.documents[0]['n']
        }
      end

      # Count the number of hashes found in a specified collection, filtered
      # by a hash attribute
      #
      # ==== Attributes
      #
      # * +name+ - the mongo collection name
      #
      # ==== Options
      #
      # * +hash+ - used for filtering
      #
      # ==== Returns
      #
      # The number of objects found.
      #
      # ==== Examples
      #
      #   db = Db.instance
      #   db.count 'users'
      #   db.count 'users', { name: 'Homer' }
      #
      def count(name, hash = {})
        @db[name].count hash
      end

      private

      def nourish_hash_id(hash)
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

      # TODO: write tests
      def nourish_hash_limit(hash)
        tmp = {}
        if hash['__limit']
          # really need to work on hash_with_indifferent access
          # if you change how you access the symbol you will have a bad time
          tmp[:limit] = hash['__limit']
          hash.delete('__limit')
        end
        [hash, tmp]
      end

      def nourish_regex(hash)
        tmp = {}
        %w(__regex __regexi).each do |key|
          if hash[key]
            hash[key] = [hash[key]] if !hash[key].is_a?(Array)
            hash[key].each do |target|
              hash[target] = Regexp.new hash[target], key == '__regexi' ? Regexp::IGNORECASE : nil
            end
            hash.delete(key)
          end
        end
        [hash, tmp]
      end

      # TODO: write tests
      def nourish_hash_sort(hash)
        tmp = {}
        if hash['__sort']
          if hash['__sort'].class != Hash
            tmp = {}
          else
            # TODO: validate for size and number of elements
            # TODO: validate value
            # TODO: handle sorting by id
            hash['__sort'].to_a.each do |e|
              tmp[e[0].to_sym] = e[1]
            end
          end
          hash.delete('__sort')
        end
        [hash, tmp]
      end
    end
  end
end
