# frozen_string_literal: true

require_relative 'station'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'route'

puts "Программа управления железной дорогой"
def user_interface
  loop do
    main_menu_show
    main_menu_user_select = gets.to_i
    case main_menu_user_select
    when 1..13
      main_menu_execute(main_menu_user_select)
    when 99
      break
    end
  end
end

def main_menu_show
  puts "=" * 10
  MAIN_MENU.each { |key, item| puts format_message(key, item[:description]) }
end

def format_message(integer, string)
  format("%<integer>d  %<string>s", { integer: integer, string: string })
end

def main_menu_execute(key)
  MAIN_MENU[key][:reference].call
end

def show_stations
  puts "Список станций:"
  station_class_show_all_with_indexes
end

def show_station_trains
  puts "Выберите станцию:"
  station_class_show_all_with_indexes
  user_station_select = select_station(gets.to_i - 1)
  show_trains(user_station_select) unless user_station_select.nil?
end

def select_station(user_choise)
  Station.all[user_choise] if Station.all.size.positive? && user_choise < Station.all.size
end

def show_trains(station)
  puts "Станция #{station.name}, поезда:"
  if station_has_trains(station)
    show_trains_on_station(station)
  else
    puts "--на станции сейчас нет поездов--"
  end
end

def station_has_trains(station)
  station.trains.size.positive?
end

def show_trains_on_station(station)
  Station.process_trains(station) do |train|
    if train.type == "passenger"
      puts "Поезд номер #{train.number}, пассажирский, вагонов: #{train.carriages.size}"
    else
      puts "Поезд номер #{train.number}, грузовой, вагонов: #{train.carriages.size}"
    end
  end
end

def station_class_show_all_with_indexes
  class_show_all_names_with_indexes(Station)
end

def class_show_all_names_with_indexes(class_name)
  class_name.all.each_with_index { |instance, index| puts format_message(index + 1, instance.name) }
end

def train_class_show_all_with_indexes
  Train.all.each_with_index { |train, index| puts format_message(index + 1, train.number) }
end

def route_class_show_all_with_indexes
  class_show_all_names_with_indexes(Route)
end

def create_station
  print "Введите название станции (формат названия: минимум 4 "
  print "буквы/цифры/пробела в любом порядке, например: лесная 5):\n"
  user_station_name_select = gets.chomp
  station = Station.new(user_station_name_select)
  puts "Создание станции #{station.name} прошло успешно" if station.validate?
rescue RuntimeError => e
  retry unless exeption_error_show_message(e)
end

def create_train
  train = create_train_instance(select_train_type, input_train_number)
  puts "Создание поезда номер #{train.number} прошло успешно" if train.validate?
rescue RuntimeError => e
  retry unless exeption_error_show_message(e)
end

def select_train_type
  puts "Выберите тип поезда:"
  puts " 1  Пассажирский"
  puts " 2  Грузовой"
  gets.to_i
end

def input_train_number
  print "Введите номер поезда (формат номера: 3 цифры/буквы, "
  print "необязательный дефис и еще 2 цифры/буквы, например: АБВ-01):\n"
  gets.chomp
end

def create_train_instance(type, number)
  case type
  when 1
    PassengerTrain.new(number)
  when 2
    CargoTrain.new(number)
  end
end

def exeption_error_show_message(exeption)
  puts "Ошибка: #{exeption}"
  puts "=" * 10
  puts "Ошибка: Были введены некорректные данные! Попробуйте еще раз"
  puts "=" * 10
end

def create_route
  route = Route.new(input_route_name, select_first_station, select_last_station)
  puts "Создание маршрута #{route.name} прошло успешно" if route.validate?
rescue RuntimeError => e
  retry unless exeption_error_show_message(e)
end

def input_route_name
  print "Введите название маршрута (формат названия: минимум 4 "
  print "буквы/цифры/пробела в любом порядке, например: пригородный 12):\n"
  gets.chomp
end

def select_first_station
  puts "Выберите начальную остановку:"
  station_class_show_all_with_indexes
  Station.all[gets.to_i - 1]
end

def select_last_station
  puts "Выберите конечную остановку:"
  station_class_show_all_with_indexes
  Station.all[gets.to_i - 1]
end

def manage_route
  user_route_select = select_route
  user_action_select = select_action_on_route
  puts "Выберите станцию:"
  case user_action_select
  when 1
    add_station_to_route(user_route_select)
  when 2
    remove_station_from_route(user_route_select)
  end
end

def select_route
  puts "Выберите маршрут:"
  route_class_show_all_with_indexes
  Route.all[gets.to_i - 1]
end

def select_action_on_route
  puts "Выберите действие:"
  puts "1  Добавить станцию в маршрут"
  puts "2  Удалить станцию из маршрута"
  gets.to_i
end

def add_station_to_route(route)
  station_class_show_all_with_indexes
  route.add_station(Station.all[gets.to_i - 1])
end

def remove_station_from_route(route)
  show_route_stations_with_indexes(route)
  route.remove_station(route.stations[gets.to_i - 1])
end

def show_route_stations(route)
  route.stations.each { |station| puts station.name }
end

def show_route_stations_with_indexes(route)
  route.stations.each_with_index { |station, index| puts format_message(index + 1, station.name) }
end

def set_train_route
  user_train_select = select_train
  user_route_select = select_route
  user_train_select.route = user_route_select
end

def select_train
  puts "Выберите поезд:"
  train_class_show_all_with_indexes
  Train.all[gets.to_i - 1]
end

def add_train_carriage
  add_carriage_to_selected_train(select_train)
rescue RuntimeError => e
  retry unless exeption_error_show_message(e)
end

def add_carriage_to_selected_train(train)
  case train.type
  when 'passenger'
    add_carriage_to_passenger_train(train)
  when 'cargo'
    add_carriage_to_cargo_train(train)
  end
end

def add_carriage_to_passenger_train(train)
  puts "Введите количество мест в вагоне (от #{Carriage::VOLUME_MIN} до #{Carriage::VOLUME_MAX} штук):"
  train.carriage_add(gets.to_i)
end

def add_carriage_to_cargo_train(train)
  puts "Введите общий объем вагона (от #{Carriage::VOLUME_MIN} до #{Carriage::VOLUME_MAX} куб. метров):"
  train.carriage_add(gets.to_f)
end

def remove_train_carriage
  select_train.carriage_remove
end

def show_train_carriages
  user_train_select = select_train
  puts "Поезд [#{user_train_select.number}], вагоны:"
  if user_train_select.carriages.size.positive?
    show_carriages(user_train_select)
  else
    puts "--у поезда сейчас нет прицепленных вагонов--"
  end
  user_train_select
end

def show_carriages(train)
  index = 0
  Train.process_carriages(train) do |carriage|
    index += 1
    if carriage.type == "passenger"
      show_passenger_carriage_info(carriage, index)
    else
      show_cargo_carriage_info(carriage, index)
    end
  end
end

def show_passenger_carriage_info(carriage, index)
  print "Вагон номер #{index}, пассажирский, число занятых/свободных "
  print "мест: #{carriage.volume_occupied}/#{carriage.volume_realesed}\n"
end

def show_cargo_carriage_info(carriage, index)
  print "Вагон номер #{index}, грузовой, занятый/свободный объём: "
  print "#{carriage.volume_occupied}/#{carriage.volume_realesed}\n"
end

def occupy_carriage
  user_train_select = show_train_carriages
  puts "Выберите вагон поезда:"
  user_carriage_select = user_train_select.carriages[gets.to_i - 1]
  occipy_selected_carriage(user_carriage_select)
end

def occipy_selected_carriage(carriage)
  if carriage.type == "passenger"
    carriage.occupy_volume(1)
  else
    puts "Введите объем, который необходимо занять:"
    volume = gets.to_f
    carriage.occupy_volume(volume)
  end
end

def move_train_forward
  user_train_select = select_train
  user_train_select.forward
end

def move_train_backward
  user_train_select = select_train
  user_train_select.backward
end

MAIN_MENU = {
  1 => {
    description: 'Вывести список станций',
    reference: method(:show_stations)
  },
  2 => {
    description: 'Вывести список поездов на станции',
    reference: method(:show_station_trains)
  },
  3 => {
    description: 'Создать станцию',
    reference: method(:create_station)
  },
  4 => {
    description: 'Создать поезд',
    reference: method(:create_train)
  },
  5 => {
    description: 'Создать маршрут',
    reference: method(:create_route)
  },
  6 => {
    description: 'Управлять маршрутом',
    reference: method(:manage_route)
  },
  7 => {
    description: 'Назначить маршрут поезду',
    reference: method(:set_train_route)
  },
  8 => {
    description: 'Добавить вагон к поезду',
    reference: method(:add_train_carriage)
  },
  9 => {
    description: 'Отцепить вагон от поезда',
    reference: method(:remove_train_carriage)
  },
  10 => {
    description: 'Вывести список вагонов поезда',
    reference: method(:show_train_carriages)
  },
  11 => {
    description: 'Занять место или объем в вагоне',
    reference: method(:occupy_carriage)
  },
  12 => {
    description: 'Перегнать поезд на следующую станцию',
    reference: method(:move_train_forward)
  },
  13 => {
    description: 'Перегнать поезд на предыдущую станцию',
    reference: method(:move_train_backward)
  },
  99 => { description: 'Выйти' }
}.freeze

user_interface
