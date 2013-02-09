module MongoStats
  class MongoCollectionNames
    
    # Prefix for all the stats collections (e.g. "st")
    attr_accessor :prefix

    def initialize( attrs={} )
      self.prefix = attrs.fetch(:prefix)
    end

    def base_name(name)
      [prefix, name].compact.join("-")
    end

    def period( collection_name, period )
      [base_name(collection_name), period].join("-")
    end

    def is_for_collection?( collection_name, mongo_collection_name )
      name, _ = parse_name(mongo_collection_name)
      name == collection_name
    end

    def stats_collection?( mongo_collection_name )
      name, _ = parse_name(mongo_collection_name)
      !name.nil?
    end

    def parse_name( mongo_name )
      prefix, name, period = mongo_name.split("-")
      if prefix == self.prefix && !name.nil? && !period.nil? && [prefix,name,period].join("-") == mongo_name
        [name, period]
      else
        [nil,nil]
      end        
    end

  end
end