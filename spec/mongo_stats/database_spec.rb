require 'spec_helper'
require 'mongo_stats/update_converter'
describe MongoStats::Database do


  let(:mongo_database) {double(:mongo_db)}
  let(:periods) {double(:periods)}
  let(:prefix) {"prefix"}
  subject {MongoStats::Database.new( mongo_db: mongo_database, periods: periods, mongo_collection_prefix: prefix )}


  describe "#collection" do
    let( :collection ) {subject.collection("foo")}
    
    it "passes everything to the collection" do
      collection.mongo_database.should be(mongo_database)
      collection.periods.should be(periods)
      collection.name.should eq("foo")
      collection.mongo_collection_prefix.should eq(prefix)
    end
  end
end
