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

    def all_keys_for( period_name, from, to )
      self.send( "#{period_name}s".to_sym, from, to)
    end

    def id_for( time, period )
      if respond_to?( period.to_sym )
        send( period.to_sym, time )
      else
        raise "Unknown period #{period}"
      end
    end

    def years(from, to)
      y1 = from.year
      y2 = to.year
      (y1..y2).map {|y| y.to_s}
    end

    def months(from, to)
      y1 = from.year
      m1 = from.month
      y2 = to.year
      m2 = to.month

      all = (y1..y2).map {|y| (1..12).map {|m| [y,m]}}.flatten(1)

      all.reject! {|y,m| y==y1 && m < m1}
      all.reject! {|y,m| y==y2 && m > m2}

      all.map {|y,m| "#{y}-#{"%02d" % m}"}
    end

    HOUR = 60 * 60
    DAY = HOUR * 24

    def weeks(from, to)
      all_days = []
      current = closest_week_start(from)
      while current < to
        all_days << current
        current = current + 7 * DAY
      end
      all_days.map {|d| week(d)}
    end

    def days(from, to)
      all_days = []
      current = from
      while current < to
        all_days << current
        current = current + DAY
      end
      all_days.map {|d| day(d)}
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
      closest_week_start(time).strftime("%Y-%m-%d")
    end

    def closest_week_start(time)
      wday = time.wday
      time - ((wday - first_day_of_week) % 7) * 24 * 60 * 60
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