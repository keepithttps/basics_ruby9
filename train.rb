require_relative "modules"
# require_relative "route"

class Train
  include Manufacturer 
  extend  Counter::ClassMethods
  attr_reader :count, :route, :type, :wagons
  attr_accessor :number

  # формат по типу "мск-12345"
  NUMBER_FORMAT = /^[а-яА-Я]{3}-[0-9]{5}$/i   
  FULL_NUMBER_TRAIN = 10
  
  def self.find(number)
    @@train[number]
  end

  def initialize(number)
    @number = number
    @wagons = []
    @@train = {}
    @@train[@number] = self 
    register_instance
    validate!
  end

  def valid?
    validate!
    true 
  rescue
    false
  end

  def total_wagons
    @wagons.size
  end

  def each_wagon_train(wagons)
    wagons.each do |wagon|
      yield(wagon)
    end
  end

  def add_wagon(wagon)
    if wagon.type == type
      wagons << wagon
    elsif wagon.type == type
      wagons << wagon
    else
      puts "Нельзя добавить вагон #{wagon.type}"
    end 
  end 

  def delete_wagon(wagon)
    wagons.delete(wagon)      
  end

  def add_route(route)
    @route = route
    @current_station_index = 0
    current_station
  end

  # Обьект станция из массива @station класса Route
  def current_station
    @route.stations[@current_station_index]
  end

  def add_train_on_station
    current_station.add_train_on_station(self)
  end

  def go_next_station
    current_station.delete_train(self)
    current_station = @route.stations[@current_station_index += 1]
    current_station.add_train_on_station(self)
    current_station
  end

  def go_previous_station
    current_station.delete_station(self)
    current_station = @route.stations[current_station_index -= 1]
    current_station.add_station(self)
    current_station.add_train_on_station
    current_station
  end

  # protected 
  def validate!
    raise "Number can't be nil" if number.nil?
    raise "Number should be at least #{FULL_NUMBER_TRAIN} symbols = #{((number.split('').length) + 1)} " if ((number.split('').length) + 1) != FULL_NUMBER_TRAIN
    raise "Number has invalid format" if number !~ NUMBER_FORMAT
  end

  private
  include Counter::InstanceMethods
end
