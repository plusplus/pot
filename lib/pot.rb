require 'mongo'
require 'pot/config'
require 'pot/collection'
require 'pot/database'
require 'pot/data_point'
require 'pot/report'
require 'pot/update_query'

module Pot
  extend self

  def configure
    yield Pot::Config
    @@database ||= Pot::Database.new(
      mongo_db: Pot::Config.database,
    )
  end

  def database
    @@database
  end

  def []( collection_name )
    database[collection_name]
  end

end