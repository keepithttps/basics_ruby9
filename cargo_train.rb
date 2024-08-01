require_relative "train"

class CargoTrain < Train
  def initialize(number)
    @type = :cargo
    super
  end

  def list_wagons_train
    self.wagons.each do |w|
      puts "Номер: #{w.number}; тип вагона: #{w.type}."
    end
    puts "Kол-во вагонов: #{self.total_wagons}"
  end
end
