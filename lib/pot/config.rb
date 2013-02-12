module Pot
  module Config
    extend self

    def database=( db )
      @database = db
    end

    def database
      @database
    end

  end

end