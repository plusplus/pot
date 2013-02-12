require 'spec_helper'
require 'pot/update_converter'
describe Pot::UpdateConverter do

  subject {Pot::UpdateConverter}

  describe "#flatten_for_update" do
    it "converts symbols to strings" do
      subject.flatten_for_update( a: 10 ).should eql("a" => 10)
    end

    it "handles multiple keys" do
      subject.flatten_for_update( b: 1, a: 10 ).should eql("b" => 1, "a" => 10)
    end

    it "uses '.' in key names to describe nested hashes" do
      subject.flatten_for_update( a: {b: 10} ).should eql("a.b" => 10)
    end

    it "handles a mixture of nested hashes and regular keys" do
      subject.flatten_for_update( b: 1, a: {b:10}, c: {d: {e:10, f:5}} ).should eql("b" => 1, "a.b" => 10, "c.d.e" => 10, "c.d.f" => 5)
    end
  end
end
