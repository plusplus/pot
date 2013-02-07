module MongoStats
  class Periods

    def all_period_keys
      ['year', 'month', 'day', 'hour']
    end

    def all_periods_for( time )
      all_period_keys.map {|k| [k, send(k.to_sym, time)]}
    end

    def adjust_for_zone( time )
      time
    end

    def id_for( time, period )
      if respond_to?( period.to_sym )
        send( period.to_sym, time )
      else
        raise "Unknown period #{period}"
      end
    end

    def year(time)
      adjust_for_zone(time).strftime("%Y")
    end

    def month(time)
      adjust_for_zone(time).strftime("%Y-%m")
    end

    def day(time)
      adjust_for_zone(time).strftime("%Y-%m-%d")
    end

    def hour(time)
      adjust_for_zone(time).strftime("%Y-%m-%d-%H")
    end

    # def finyear(time)
    #   (time - 6.months).year.to_s
    # end

    # def au_quarter(time)
    #   finyear(time) + ((time-6.months).month / 4).to_i.to_s
    # end

  end
end