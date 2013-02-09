require 'spec_helper'
require 'mongo_stats/mongo_collection_names'

describe MongoStats::MongoCollectionNames do

  subject {MongoStats::Periods.new}


  subject {MongoStats::MongoCollectionNames.new( prefix: "p")}
  describe "#base_name" do
    it "adds the prefix" do
      expect(subject.base_name('x')).to eq("p-x")
    end
  end

  describe "#period" do
    it "adds the prefix" do
      expect(subject.period('x', 'day')).to eq("p-x-day")
    end
  end

  describe "#is_for_collection?" do
    it "expects the prefix and collection name at the beginning" do
      expect(subject.is_for_collection?('x', 'p-x-foo')).to be_true
      expect(subject.is_for_collection?('x', 'p-x')).to be_false
      expect(subject.is_for_collection?('x', 'p-x-')).to be_false
      expect(subject.is_for_collection?('x', 'p-')).to be_false
      expect(subject.is_for_collection?('x', 'x-foo')).to be_false
    end
  end
end
