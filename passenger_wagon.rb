# require_relative 'wagon'
class PassengerWagon < Wagon

  def initialize(number, seats)
    @type = :passenger
    @SEATS_WAGON = seats.to_i
    @occupied_seat_wagon = 0
    super(number)
  end

# метод, который "занимает места" в вагоне (по одному за раз)

  def buy_seats
    @occupied_seat_wagon += 1
  end

# метод, который возвращает кол-во занятых мест в вагоне

  def seat_sold
    @occupied_seat_wagon
  end

# метод, возвращающий кол-во свободных мест в вагоне.

  def available_seats
    @SEATS_WAGON - @occupied_seat_wagon
  end
end
