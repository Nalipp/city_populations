require "sequel"

class SequelPersistence
  DB = Sequel.connect("postgres://localhost/cbsa")

  DB.disconnect

  def initialize(logger)
    DB.logger = logger
  end

  def all_populatations
    DB[:metro_area].all
  end

  def less_than_250k
    DB[:metro_area].where(:pop_2010 => 1..250000).all
  end

  def between_250k_500k
    DB[:metro_area].where(:pop_2010 => 250001..500000).all
  end

  def between_500k_1mil
    DB[:metro_area].where(:pop_2010 => 500001..1000000).all
  end

  def more_than_1mil
    DB[:metro_area].where(:pop_2010 => 1000001..100000000).all
  end

  def custom_range(range)
    DB[:metro_area].where(:pop_2010 => "#{range[0]}".to_i.."#{range[1]}".to_i).all
  end

  def custom_population_query(params)
    population_ranges = []

    if params.keys.include?("less_than_250k")
      population_ranges << less_than_250k
    elsif params.keys.include?("between_250k_500k")
      population_ranges << between_250k_500k
    elsif params.keys.include?("between_500k_1mil")
      population_ranges << between_500k_1mil
    elsif params.keys.include?("more_than_1mil")
      population_ranges << more_than_1mil
    end
    return population_ranges.flatten
  end
end
