require 'mongo_stats/periods'
require 'mongo_stats/mongo_collection_names'

module MongoStats

  class Database

    attr_accessor :mongo_db, :periods, :mongo_collection_names

    def initialize( attrs = {} )
      self.mongo_db = attrs.fetch( :mongo_db )
      self.periods           = attrs[:periods]           || Periods.new
      self.mongo_collection_names = MongoCollectionNames.new( prefix: attrs[:mongo_collection_prefix] || 'st')
    end

    def collection( name )
      Collection.new(
        periods: periods,
        name: name,
        collection_names: mongo_collection_names,
        mongo_database: mongo_db )
    end

    def [](name)
      collection( name )
    end

    def drop( name )
      mongo_collections_for_collection(name).each do |mongo_name|
        mongo_db.drop_collection( mongo_name )
      end
    end

    def collection_names
      mongo_db.collection_names.map {|mongo_name|
        mongo_collection_names.parse_name(mongo_name)[0]
      }.compact.uniq.sort
    end

    protected

    def mongo_collections_for_collection( name )
      mongo_db.collection_names.select {|mongo_name|
        mongo_collection_names.is_for_collection?(name, mongo_name)
      }
    end

  end

end