require 'spec_helper'

describe Pot do

  describe "you can configure it" do
    Pot.configure do |config|
      config.database = Mongo::Connection.new['mongo_stats_test']
    end
  end

end
