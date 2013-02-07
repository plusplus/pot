module MongoStats
  
  # Converts the hash of data for a stats update into
  # 
  class UpdateConverter

    def self.flatten_for_update( value )
      _flatten_for_update( {}, [], value )
    end

    def self._flatten_for_update( clause, path, value )
      case value
      when Hash
        value.each do |k,v|
          _flatten_for_update( clause, path + [k], v)
        end
      else
        clause[path.join(".")] = value
      end
      clause
    end

  end
end