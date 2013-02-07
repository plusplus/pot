require 'spec_helper'

require 'mongo_stats/periods'

describe MongoStats::Collection do

  let(:periods) {MongoStats::Periods.new}
  let(:name)    {"subject"}
  let(:connection) {Mongo::Connection.new}
  let(:database) {connection['stats_test']}

  subject do
    MongoStats::Collection.new(
      periods: periods,
      mongo_collection_prefix: 'st',
      mongo_database: database,
      name: name
    )
  end

  let(:collection_2) {
    MongoStats::Collection.new(
      periods: periods,
      mongo_collection_prefix: 'st',
      mongo_database: database,
      name: 'collection_2')
  }

  let(:base) {Time.new( 2011, 12, 23, 12, 43 )}
  let(:base_1m) {Time.new( 2012, 1, 23, 12, 43 )}
  let(:base_2m) {Time.new( 2012, 2, 23, 12, 43 )}

  before :each do
    periods.all_period_keys.each do |period|
      ['subject', 'collection_2'].each do |collection_name|
        collection_name = "st-#{period}-#{collection_name}"
        database.drop_collection(collection_name)
      end
    end
  end

  describe "#series" do
    it "works" do
      [base, base_1m, base_2m].each_with_index do |time, i|
        subject.record( time: time, data: {a: (i + 1)} )
      end
      series = subject.series( 'month', base, base_2m )
      series.size.should be(3)
      series[0].time_key.should eql("2011-12")
      series[0]["a"].should eql(1)

      series = subject.series( 'hour', base, base_2m )
      series.size.should be(3)

    end
  end

  describe "#pick" do
    it "works for plain keys" do
      [base, base_1m, base_2m].each_with_index do |time, i|
        subject.record( time: time, data: {a: (i + 1)} )
      end
      series = subject.pick( 'month', base, base_2m, "a" )
      series.size.should eq(3)
      series[0][1].should eq(1)
      series[1][1].should eq(2)
      series[2][1].should eq(3)
    end

    it "works for structured records" do
      [base, base_1m, base_2m].each_with_index do |time, i|
        subject.record( time: time, data: {a: {b: (i + 1)}} )
      end
      series = subject.pick( 'month', base, base_2m, "a.b" )
      series.size.should eq(3)
      series[0][1].should eq(1)
      series[1][1].should eq(2)
      series[2][1].should eq(3)
    end

    it "can extract structured records" do
      [base, base_1m, base_2m].each_with_index do |time, i|
        subject.record( time: time, data: {a: {b: (i + 1)}} )
      end
      series = subject.pick( 'month', base, base_2m, "a" )
      series.size.should eq(3)
      series[0][1].should eq("b" => 1)
      series[1][1].should eq("b" => 2)
      series[2][1].should eq("b" => 3)
    end

  end

  describe "#record" do
    it "Put things into the right buckets" do
      base = Time.new( 2011, 12, 23, 12, 43 )
      same_hour = Time.new( 2011, 12, 23, 12, 44 )
      prev_hour = Time.new( 2011, 12, 23, 11, 23 )
      prev_day = Time.new( 2011, 12, 22, 8, 0 )
      prev_month = Time.new( 2011, 11, 1, 0, 0 )
      prev_year = Time.new( 2010, 1, 1 )

      subject.record( time: base, data: {a: 10} )
      subject.record( time: same_hour, data: {a: 10} )
      subject.record( time: prev_hour, data: {a: 10} )
      subject.record( time: prev_day, data: {a: 10} )
      subject.record( time: prev_month, data: {a: 10} )
      subject.record( time: prev_year, data: {a: 10} )
      
      {"hour" => 2, "day" => 3, "month" => 4, "year" => 5}.each do |period_name, expected|
        report = subject.report_at( period_name, time: base )
        report["a"].should eq(expected * 10)
      end
    end

    it "handles multiple keys" do
      base = Time.new( 2011, 12, 23, 12, 43 )

      subject.record(  time: base, data: {a: 10} )
      subject.record(  time: base, data: {b: 5} )
      
      report = subject.report_at( :hour, time: base )
      report["a"].should eq(10)
      report["b"].should eq(5)

      subject.record(  time: base, data: {a: 2, b: 8} )
      report = subject.report_at( :hour, time: base )
      report["a"].should eq(12)
      report["b"].should eq(13)
    end

    it "handles structured data" do
      subject.record(  time: base, data: {a: {b: 10, c: 20}} )
      subject.record(  time: base, data: {a: {b: 2, d: 3}} )
      
      report = subject.report_at( :hour, time: base )
      report["a"]["b"].should eq(12)
      report["a"]["c"].should eq(20)
      report["a"]["d"].should eq(3)
    end

    it "keeps stats collections separate" do
      collection_2.record( time: base, data: {a: 10})
      subject.record( time: base, data: {a: 5})
      report = subject.report_at( :hour, time: base )
      report["a"].should eq(5)
    end

  end
end
