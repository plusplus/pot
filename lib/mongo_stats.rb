require 'mongo'
require 'mongo_stats/config'
require 'mongo_stats/collection'
require 'mongo_stats/database'
require 'mongo_stats/data_point'
require 'mongo_stats/report'
require 'mongo_stats/update_query'

module MongoStats
  extend self

  def configure
    yield MongoStats::Config
    @@database ||= MongoStats::Database.new(
      mongo_db: MongoStats::Config.database,
    )
  end

  def database
    @@database
  end

  def []( collection_name )
    database[collection_name]
  end

end