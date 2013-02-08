require 'spec_helper'
require 'mongo_stats/periods'

describe MongoStats::Database do


  subject {MongoStats::Periods.new}


  describe "#week" do
    let( :monday )  {Time.new(2013,2,11) }
    let( :tuesday ) {Time.new(2013,2,12) }
    let( :sunday )  {Time.new(2013,2,17) }
    let( :prev_monday ) {"2013-02-11"}

    it "does not change monday" do
      expect(subject.week( monday )).to eq(prev_monday)
    end

    it "converts sunday to the previous monday" do
      expect(subject.week( sunday )).to eq(prev_monday)
    end

  end
end
