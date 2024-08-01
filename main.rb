require_relative "passenger_train"
require_relative "cargo_train"
require_relative "station"
require_relative "train"
require_relative "route"
require_relative "wagon"
require_relative "passenger_wagon"
require_relative "cargo_wagon"
require_relative "modules"


@trains   = {}
@stations = {}
@routes   = {}

# Вывод предварительной информаций перед вводом данных
def print_contents_hash(array_hash)
  if array_hash == {}
    puts "Нет запрашивоемой информаций в базе"
    abort
  else
    puts "Выберети из вариантов #{array_hash.keys}"
  end

end

def prompt(msg)
  puts msg 
  print "=> "
  gets.chomp 
end

def create_train
  item = 0
  begin
    number = prompt("Введите номер поезда по типу (айя-12345)")
    type = prompt("Укажите цифру типа поезда (1 - пассажирский, 2 - грузовой)")

    train = case type
    when "1" then PassengerTrain.new(number)
    when "2" then CargoTrain.new(number)
    end

    @trains[number] = train
    puts "Поезд создан! #{train}"
  rescue StandardError => e
    puts e.message
    item += 1
    retry if item < 3
    abort "Превышено количество попыток ввода "
  end
end

# 2. Зарегистрировать станцию
def create_station
  print_contents_hash(@stations)
  name = prompt("Введите название станции по типу (ыыы)")
  station = Station.new(name)
  @stations[name] = station
end

# 3. Создать маршрут
def create_route
  name = prompt("Введите название маршрута формат по типу (от ффф-ййй)")
  route = Route.new(name)
  @routes[name] = route
end

# 4. Добавить станцию в маршрут
def add_station
  print_contents_hash(@routes)
  route_name = prompt("Введите название маршрута формат по типу (от ффф-ййй)")
  print_contents_hash(@stations)
  station_name = prompt("Введите название станции по типу (ыыы)")
  route   = @routes[route_name]
  station = @stations[station_name]
  route.add_station(station)
end

# 5. Убрать станцию из маршрута
def delete_station
  print_contents_hash(@routes)
  route_name = prompt("Введите название маршрута формат по типу (от ффф-ййй)")
  print_contents_hash(@stations)
  station_name = prompt("Введите название станции по типу (ыыы)")
  route   = @routes[route_name]
  station = @stations[station_name]
  route.delete_station(station)
end

# 6. Прицепить вагон
 # Номер вагона можно назначать автоматически
@n = 0
def number_block
  number = proc { @n += 1 }
  num = number.call.to_s
  return '%08d' % num
end

def add_wagon
  begin
    train_name   = prompt("Введите название поезда")
    # train_name = "ыыы-12345"
    train = @trains[train_name]
    # number_wagon = prompt("Введите номер вагона")
    type_wagon = train.type
    number_wagon = number_block
    # type_wagon   = prompt("Введите тип вагон - (1 - pessenger, 2 - cargo)")
  
    wagon = if type_wagon == :passenger
      seats_wagon = prompt("Введите колличество мест пустого вагона")
      print "#{number_wagon}: #{seats_wagon}: #{train}"
      PassengerWagon.new(number_wagon, seats_wagon)
    elsif type_wagon == :cargo
      volume_wagon = prompt("Введите Обьём пустого вагона")
      CargoWagon.new(number_wagon, volume_wagon)
    end
    puts "wagon = #{wagon}"
    train.add_wagon(wagon)
  rescue StandardError => e
    puts "Exception: #{e.message}"
    puts "Нет такого поезда #{train_name}"
  end
end

# 7. Отцепить вагон
def delete_wagon
  train_name   = prompt("Введите номер поезда по типу (айя-12345)")
  number_wagon = prompt("Введите номер вагона")
  train = @trains[train_name]
  train.delete_wagon(number_wagon)
end

def assign_route
  route_name = prompt("Введите название маршрута формат по типу (от ффф-ййй)")
  train_name = prompt("Введите номер поезда по типу (айя-12345)")
  train   = @trains[train_name]
  route   = @routes[route_name]
  train.add_route(route)
  p train.route.stations
end

def go_forward
  train_name   = prompt("Введите номер поезда по типу (айя-12345)")
  train   = @trains[train_name]
  train.go_next_station
end

def go_back
  train_name   = prompt("Введите номер поезда по типу (айя-12345)")
  train   = @trains[train_name]
  train.go_previous_station
end

def list_station
  puts @stations.keys
end

# 12. Посмотреть список поездов на станции
def show_trains
  station_name = prompt("Введите название станции по типу (мск-ыыы)")
  station = @stations[station_name]
  station.list_train_station
end

# 13. Выводить список вагонов у поезда
def list_wagons
  @trains.each { |k, v| puts " #{k}: #{v.type}"}
  name = prompt("Введите номер поезда по типу (айя-12345)")
  train = @trains[name]

  train.list_wagons_train
  # puts "№: #{train.number}. тип: #{train.type}. кол-во вагонов: #{train.wagons.size}"
end

# 14. Занять место в пассажирском вагоне
def buy_ticket_seats
   @trains.each { |k, v| puts " #{k}: #{v.type}"}
  name = prompt("Введите название поссажирского поезда по типу (айя-12345)")

  if @trains[name].type == :passenger  # не :cargo
    train = @trains[name] 
    train.list_wagons_train
    # puts "#{train.wagons[1].type}"
    item = prompt("Введите порядковый номер вагона в составе. ")
    item = item.to_i
    train.wagons[item].buy_seats
    puts "Вы купили Один билет на поезд #{train}"
    puts "Ваш вагон № #{train.wagons[item]}"
  else
    abort 'Введён не правельный тип вагона'
  end
end

# 15 Загрузить грузовой вагон 
def load_freight_car
  @trains.each { |k, v| puts " #{k}: #{v.type}"}
  name = prompt("Введите название грузового поезда по типу (айя-12345)")

  if @trains[name].type == :cargo   # не :passenger
    train = @trains[name] 
    train.list_wagons_train
    item = prompt("Введите порядковый номер вагона в составе.")
    item = item.to_i
    load_wagon = train.wagons[item]
    volue = prompt("Укажите обьем груза")
    load_wagon.body_volume(volue)
    puts "Вы загрузили груз обьёмом #{volue} на поезд #{train}"
    puts "Ваш груз в вагон № #{load_wagon}"
  else
    abort 'Введён не правельный тип вагона'
  end
end

# 90. Инженерный вход(создать данные)
def create_data
  # Зарегистрировать поезд
  array_number = ["мск-00777", "спб-00147", "клд-00139"]

  for number in array_number 
    type = rand(1..2)
    train = case type
    when 1 then PassengerTrain.new(number)
    when 2 then CargoTrain.new(number)
    end

    @trains[number] = train
  end
  puts "Поезда созданы!"
  @trains.each{ |k, v| puts "number train: #{k}: #{v.type}" }

  # Зарегистрировать станцию по типу (ыыы)
  array_station = ["омск", "уфа", "москва", "томск"]
  for name in array_station
    station = Station.new(name)
    @stations[name] = station
  end
  @stations.each{ |k, v| puts "station name: #{k}; trains: - #{v.trains} "}
  
  # Создать маршрут формат по типу от 3 до 25 букв между пробел или дефис
  array_route = ["москва-омск", "уфа-москва", "омск-томск", "уфа-томск"]
  for name in array_route
    route = Route.new(name)
    @routes[name] = route
  end
  @routes.each{ |r| puts "route name: #{r[0]}"}

  # Добавить станцию в маршрут
  @routes.each do  |key, value|
    route = value
    @stations.each do |key, value|
      station = value
      route.add_station(station)
    end
  end

end 
  
def data_name
  @trains.each_key{ |k| puts "Номера поезда: #{k}" }
  @stations.each_key{ |k| puts "Названия станций: #{k}"}
  @routes.each_key{ |k| puts "Названия  маршрута: #{k}"}
end

loop do
  input = prompt(
    "---\n" \
    "1.  Зарегистрировать поезд\n" \
    "2.  Зарегистрировать станцию\n" \
    "3.  Создать маршрут\n" \
    "---\n" \
    "4.  Добавить станцию в маршрут\n" \
    "5.  Убрать станцию из маршрута\n" \
    "---\n" \
    "6.  Прицепить вагон\n" \
    "7.  Отцепить вагон\n" \
    "---\n" \
    "8.  Назначить маршрут поезду\n" \
    "9.  Отправить поезд вперёд по маршруту\n" \
    "10. Отправить поезд назад по маршруту\n" \
    "---\n" \
    "11. Посмотреть список станций\n" \
    "12. Посмотреть список поездов на станции\n" \
    "---\n" \
    "13. Вывести список вагонов у поезда\n"\
    "14. Занять место в пассажирском вагоне\n"\
    "15. За грузить грузовой вагон\n"\
    "---\n" \
    "17. Закрыть программу\n" \
    "99. Информация ввода данных \n" \
    "90. Инженерный вход(создать данные)" 
  )
  case input
  when "90"
    create_data
  when "99"
    data_name
  when "1"
    create_train
  when "2"
    create_station
    puts @stations
  when "3"
    create_route
    puts @routes
  when "4"
    add_station
  when "5"
    delete_station
  when "6"
    add_wagon
  when "7"
    delete_wagon
  when  "8"
    assign_route
  when "9"
    go_forward
  when "10"
    go_back
  when "11"
    list_station
  when "12"
    show_trains
  when "13"
    list_wagons
  when "14"
    buy_ticket_seats
  when "15"
    load_freight_car
  when "17"
    break "Програvма закрата!"
  else
    puts "Пока в разработке"
  end
end
