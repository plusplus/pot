require 'spec_helper'

describe MongoStats do


  describe "you can configure it" do
    MongoStats.configure do |config|
      config.database = Mongo::Connection.new['mongo_stats_test']
    end
  end
  
end
