module MongoStats
  class DataPoint
    attr_accessor :raw_record, :period_name

    def initialize( attrs = {} )
      self.period_name = attrs.fetch( :period_name )
      self.raw_record = attrs.fetch( :raw_record )
    end

    # start of the period
    def time

    end

    def time_key
      raw_record["_id"]
    end

    def data
      raw_record["d"]
    end

    def [](key)
      data[key.to_s]
    end
  end

end
