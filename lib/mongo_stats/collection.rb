module MongoStats

  class Collection

    # collection_finder can just be a mongo db object,
    # or a hash of collections
    def initialize( timeslot_formats, collection_finder, report_collection_name, events_collection_name )
      @timeslot_formats = timeslot_formats
      @collection_finder = collection_finder
      @reports_collection_name = report_collection_name
      @events_collection_name = events_collection_name
    end

    def stat( time, scope, event, data = nil, accumulator = nil )
      record_event( time, scope, event, accumulator || 0, data || {} )
      update_reports( time, scope, event, accumulator || 0, data || {} )
    end

    def record_event( time, scope, event, accumulator, data )
      event_collection.insert(
        :happened_at => time,
        :scope => scope,
        :event => event,
        :value => accumulator || 0,
        :data => data
      )
    end

    def update_reports( time, scope, event, accumulator, data)
      report_updates( time, scope, event, accumulator || 0 ).each do |query, update|
        report_collection.update( query, update, :upsert => true)
      end
    end

    def report_updates( time, scope, event, accumulator )
      report_timeslots( time ).map {|timeslot|
        report_update( scope, timeslot, event, accumulator )
      }
    end

    def report_update( scope, timeslot, event, accumulator )
      [
        {"_id" => id_for( scope, timeslot )},
        {"$inc" => {
          "stats.#{event}.count" => 1,
          "stats.#{event}.value" => accumulator
          }
        }
      ]
    end

    def id_for( scope, timeslot )
      "#{scope || "GLOBAL"}:#{timeslot}"
    end

    def report_timeslots( time )
      @timeslot_formats.keys.map {|slot_name| timeslot( slot_name, time )}
    end

    def timeslot( slot_name, time )
      format = @timeslot_formats[slot_name.to_sym]
      raise "No known report timeslot for #{slot_name}" if format.nil?
      time.strftime( format )
    end

    # reporting methods

    def report_for( scope, slot_name, time )
      report = report_collection.find_one( "_id"=> id_for( scope, timeslot( slot_name, time ) ) )
      Report.new( (report && report['stats']) || {} )
    end

    def all_reports_for( scope, time )
      {}.tap do |reports|
        @timeslot_formats.keys.each do |slot_name|
          reports[slot_name] = report_for( scope, slot_name, time )
        end
      end
    end

    protected

    def event_collection
      @collection_finder[@events_collection_name]
    end

    def report_collection
      @collection_finder[@reports_collection_name]
    end

  end
end