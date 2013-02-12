require 'spec_helper'

require 'pot/periods'

describe Pot::Collection do

  let(:connection) {Mongo::Connection.new}
  let(:mongo_db)   {connection['stats_test']}
  let(:database)   {Pot::Database.new( mongo_db: mongo_db )}


  let(:c1) {database.collection('c1')}
  let(:c2) {database.collection('c2')}

  let(:base) {Time.new( 2011, 12, 23, 12, 43 )}
  let(:base_1m) {Time.new( 2012, 1, 23, 12, 43 )}
  let(:base_2m) {Time.new( 2012, 2, 23, 12, 43 )}

  before :each do
    mongo_db.collection_names.each do |name|
      mongo_db.drop_collection(name) if name.start_with?("pot-")
    end
  end

  describe "#collection_names" do

    it "works" do
      c1.record( time: base, data: {a: 1})
      c2.record( time: base, data: {a: 1})

      expect(database.collection_names).to eq(["c1", "c2"])

      database.drop("c1")
      expect(database.collection_names).to eq(["c2"])
    end
  end
end
