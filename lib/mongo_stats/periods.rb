module MongoStats
  class Periods

    attr_accessor :first_day_of_week, :keys

    def initialize( attrs = {} )
      self.first_day_of_week = attrs[:first_day_of_week] || 1
      default_keys = [:year, :month, :week, :day, :hour]
      self.keys = attrs[:keys] || default_keys
    end

    def all_periods_for( time )
      keys.map {|k| [k, send(k.to_sym, time)]}
    end

    def id_for( time, period )
      if respond_to?( period.to_sym )
        send( period.to_sym, time )
      else
        raise "Unknown period #{period}"
      end
    end

    def year(time)
      time.strftime("%Y")
    end

    def month(time)
      time.strftime("%Y-%m")
    end

    def day(time)
      time.strftime("%Y-%m-%d")
    end

    def hour(time)
      time.strftime("%Y-%m-%d-%H")
    end

    def week(time)
      # move to closest start of week
      wday = time.wday
      time = time - ((wday - first_day_of_week) % 7) * 24 * 60 * 60
      time.strftime("%Y-%m-%d")
    end

    # def finyear(time)
    #   (time - 6.months).year.to_s
    # end

    # def finyear_start_month
    #   7
    # end

    # def au_quarter(time)
    #   finyear(time) + ((time-6.months).month / 4).to_i.to_s
    # end

  end
end