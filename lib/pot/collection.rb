require 'pot/update_query'
require 'pot/periods'
require 'pot/data_point'

module Pot

  class Collection

    attr_accessor :mongo_database, :periods, :collection_names, :name

    # collection_finder can just be a mongo db object,
    # or a hash of collections
    def initialize( attrs = {} )
      self.name                    = attrs.fetch(:name)
      self.mongo_database          = attrs.fetch(:mongo_database)
      self.periods                 = attrs[:periods]           || Periods.new
      self.collection_names        = attrs[:collection_names]  || MongoCollectionNames.new(prefix: 'pot')
    end

    def record( attrs = {} )
      data = attrs.fetch( :data )
      time = attrs[:time] || Time.now
      mongo_operations( time, data ).each( &:run )
    end

    def report_at( period_name, attrs = {} )
      time = attrs[:time] || Time.now
      id = periods.id_for( time, period_name )
      opts = {}
      opts[:fields] = {d: attrs[:fields]} if attrs[:field]
      opts[:fields] ||= {d: true}
      record = mongo_collection( period_name ).find_one( {"_id" => id}, opts )
      record["d"] if record
    end

    def all_reports_for( time )
      {}.tap do |reports|
        @timeslot_formats.keys.each do |slot_name|
          reports[slot_name] = report_for( name, slot_name, time )
        end
      end
    end

    def series( period_name, from, to, key = nil )
      mongo_collection(period_name).find(select_for_date_range(period_name, from, to), :sort => "_id").map do |raw_record|
        DataPoint.new( period_name: period_name, raw_record: raw_record )
      end
    end

    def pick( period_name, from, to, field, options = {} )
      sparse = options[:sparse]
      path = ["d"] + field.split(".")

      cursor = mongo_collection(period_name).find(select_for_date_range(period_name, from, to), fields: ["d.#{field}"], sort: "_id")
      if sparse
        cursor.map do |mongo_record|
          [mongo_record["_id"], pick_from_data( mongo_record, path)]
        end.select {|key,d| !d.nil?}
      else
        all_keys = periods.all_keys_for( period_name, from, to )
        ks = all_keys.each_with_object({}) {|k, hash| hash[k] = 0}

        cursor.each do |mongo_record|
          ks[mongo_record["_id"]] = pick_from_data( mongo_record, path) || 0
        end

        ks.map {|k,v| [k,v]}
      end
    end

    def select_for_date_range( period_name, from, to )
      from_id = periods.id_for(from, period_name )
      to_id   = periods.id_for(to, period_name )
      {"_id" => {"$gte" => from_id, "$lte" => to_id}}
    end

    def pick_from_data( hash, path )
      head, *rest = path
      return nil if head.nil? || hash.nil?

      if rest.empty?
        hash[head]
      else
        pick_from_data( hash[head], rest)
      end
    end

    protected

    def mongo_operations( time, data )
      periods.all_periods_for(time).map {|period_name, timeslot|
        UpdateQuery.new(
          collection: mongo_collection( period_name ),
          id: timeslot,
          data: data)
      }
    end

    def mongo_collection( period_name )
      mongo_database[collection_names.period( name, period_name )]
    end

    def point_in_time( period_name, at )
      collection = mongo_collection( period_name )
      id = timeslot( at )
      collection.find({"_id" => id})
    end



    def id_for( timeslot )
      timeslot
    end

    def report_timeslots( time )
      @timeslot_formats.map {|slot_name, format| [slot_name, timeslot( slot_name, time )]}
    end

    def timeslot( slot_name, time )
      format = @timeslot_formats[slot_name.to_sym]
      raise "No known report timeslot for #{slot_name}" if format.nil?
      time.strftime( format )
    end



  end
end