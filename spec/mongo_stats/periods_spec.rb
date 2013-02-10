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


  describe "#years" do
    it "works for a single year" do
      r = subject.years( Time.new(2013,1,11), Time.new(2013,2,11) )
      expect(r).to eq(["2013"])
    end

    it "works for a range of years" do
      r = subject.years( Time.new(2011,1,11), Time.new(2013,2,11) )
      expect(r).to eq(%w(2011 2012 2013))
    end
  end

  describe "#months" do
    it "works for a single month" do
      r = subject.months( Time.new(2013,1,11), Time.new(2013,1,12) )
      expect(r).to eq(["2013-01"])
    end

    it "works for a range of months across years" do
      r = subject.months( Time.new(2011,12,11), Time.new(2012,2,11) )
      expect(r).to eq(["2011-12","2012-01","2012-02"])
    end
  end

  describe "#weeks" do
    it "works for a single week" do
      r = subject.weeks( Time.new(2013,1,11), Time.new(2013,1,12) )
      expect(r).to eq(["2013-01-07"])
    end

    it "works for a range of weeks" do
      r = subject.weeks( Time.new(2013,1,11), Time.new(2013,1,23) )
      expect(r).to eq(["2013-01-07","2013-01-14","2013-01-21"])
    end
  end



end
