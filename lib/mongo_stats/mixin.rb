module MongoStats
  module Mixin
    def record_stat( event, data = nil, value = nil)
      MongoStats.collection.stat( Time.now, statistic_scope, event, data, value )
    end

    def statistic_scope
      self.id
    end
  end
end