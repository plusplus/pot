module MongoStats
  class UpdateQuery

    attr_accessor :id, :data, :collection, :converter

    def initialize( attrs = {} )
      self.collection = attrs.fetch(:collection)
      self.id         = attrs.fetch(:id)
      self.data       = attrs.fetch(:data)
      self.converter  = attrs[:converter] || UpdateConverter
    end

    def run
      collection.update( query_clause, update_clause, upsert: true )
    end
      
    def update_clause
      {"$inc" => converter.flatten_for_update( d: data )}
    end

    def query_clause
      {"_id" => id}
    end

  end
end