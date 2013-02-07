module MongoStats

  class Database

    attr_accessor :mongo_db, :periods, :mongo_collection_prefix
    
    def initialize( attrs = {} )
      self.mongo_db = attrs.fetch( :mongo_db )
      self.collection_prefix = attrs[:mongo_collection_prefix] || 'st'
      self.periods           = attrs[:periods]           || Periods.new
    end

    def collection( name )
      Collection.new( periods: periods, name: name, mongo_collection_prefix: mongo_collection_prefix, mongo_database: mongo_db )
    end

    def [](name)
      collection( name )
    end

  end

end