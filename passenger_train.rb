require_relative "train"

class PassengerTrain < Train
  def initialize(number)
    @type = :passenger
    super 
  end

  def list_wagons_train
    self.wagons.each_with_index do |w, i|
      puts " #{i}: Порядковый номер вагон; Номер вагона: #{w.number}; тип вагона: #{w.type}."
    end
      puts "Kол-во вагонов: #{self.total_wagons}"
  end
end


# : свободные места: #{w.availabel_seats}; занятые места: #{w.seat_sold} 
