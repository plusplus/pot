module Pot
  class Report
    def initialize( raw_report )
      @raw = raw_report
    end

    def count( event )
      (@raw[event] && @raw[event]['count']) || 0
    end

    def value( event )
      (@raw[event] && @raw[event]['value']) || 0
    end

    def events
      @raw.keys
    end
  end
end