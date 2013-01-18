module MongoStats
  module Config
    extend self

    def timeslot_formats
      {:year => "%Y", :month => "%Y-%m", :day => "%Y-%m-%d", :hour => "%Y-%m-%d-%H"}
    end

    def events_collection_name
      "stats_events"
    end

    def reports_collection_name
      "stats_reports"
    end

    def database=( db )
      @database = db
    end

    def database
      @database
    end

  end

end