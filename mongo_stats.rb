require 'mongo_stats/config'
require 'mongo_stats/collection'

module MongoStats
  extend self

  def configure
    yield MongoStats::Config
  end

  def collection
    @@collection ||= MongoStats::Collection.new(
      MongoStats::Config.timeslot_formats,
      MongoStats::Config.database,
      MongoStats::Config.reports_collection_name,
      MongoStats::Config.events_collection_name
    )
  end

end