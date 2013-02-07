require 'spec_helper'
require 'mongo_stats/update_converter'
describe MongoStats::Database do

  describe "#new" do

    let(:mongo_database) {double(:mongo_db)}
    let(:periods) {double(:periods)}
    let(:prefix) {"prefix"}

    it "accepts right attributes" do
      MongoStats::Database.new( mongo_db: mongo_database, periods: periods, mongo_collection_prefix: prefix )
    end

    it "can have collection called on it" do
      collection = MongoStats::Database.new( mongo_db: mongo_database, periods: periods, mongo_collection_prefix: prefix ).collection("foo")

      collection.mongo_database.should be(mongo_database)
      collection.periods.should be(periods)
      collection.name.should eq("foo")
      collection.mongo_collection_prefix.should eq(prefix)
    end
  end
end
