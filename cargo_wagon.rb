class CargoWagon < Wagon
  TOTAL_VOLUME = 80     # стандартное пустое значение вагона
 
  def initialize(number, volume)
    @type = :cargo 
    @all_volume = volume
    super(number)
  end

  # метод, которые "занимает объем" в вагоне
  def body_volume(volume)
    @volume = @all_volume - volume
  end

  # метод, который возвращает занятый объем
  def ccupied_volume
    @all_volume - @volume
  end

  # метод, который возвращает оставшийся (доступный) объем
  def available_volume
    @volume
  end
end
