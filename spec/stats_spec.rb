require 'spec_helper'

describe MongoStats::Collection do

  before :each do
    @conn = Mongo::Connection.new
    @db   = @conn['stats_test']
    @db.drop_collection('evt')
    @db.drop_collection('rpt')
  end

  subject do
    MongoStats::Collection.new( MongoStats::Config.timeslot_formats, @db, 'rpt', 'evt')
  end

  describe "#stat" do
    it "Put things into the right buckets" do
      base = Time.new( 2011, 12, 23, 12, 43 )
      same_hour = Time.new( 2011, 12, 23, 12, 44 )
      prev_hour = Time.new( 2011, 12, 23, 11, 23 )
      prev_day = Time.new( 2011, 12, 22, 8, 0 )
      prev_month = Time.new( 2011, 11, 1, 0, 0 )
      prev_year = Time.new( 2010, 1, 1 )


      subject.stat( base, 'scope1', 'event1', {}, 10 )
      subject.stat( same_hour, 'scope1', 'event1', {}, 10 )
      subject.stat( prev_hour, 'scope1', 'event1', {}, 10 )
      subject.stat( prev_day, 'scope1', 'event1', {}, 10 )
      subject.stat( prev_month, 'scope1', 'event1', {}, 10 )
      subject.stat( prev_year, 'scope1', 'event1', {}, 10 )
      
      {"hour" => 2, "day" => 3, "month" => 4, "year" => 5}.each do |slot_name, expected|
        report = subject.report_for( "scope1", slot_name, base )
        report.count('event1').should eq(expected)        
        report.value('event1').should eq(expected * 10)        
      end
    end

    it "keeps events separate" do
      base = Time.new( 2011, 12, 23, 12, 43 )

      subject.stat( base, 'scope1', 'event1', {}, 10 )
      subject.stat( base, 'scope1', 'event2', {}, 19 )
      
      report = subject.report_for( "scope1", "hour", base )
      report.count('event1').should eq(1)
      report.value('event1').should eq(10)
      report.count('event2').should eq(1)
      report.value('event2').should eq(19)
    end

    it "keeps scopes separate" do
      base = Time.new( 2011, 12, 23, 12, 43 )

      subject.stat( base, 'scope1', 'event1', {}, 10 )
      subject.stat( base, 'scope2', 'event1', {}, 19 )
      
      report = subject.report_for( "scope1", "hour", base )
      report.count('event1').should eq(1)
      report.value('event1').should eq(10)
    end
  end
end
