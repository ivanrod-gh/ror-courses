# frozen_string_literal: true

require_relative 'station'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'route'

puts "Программа управления железной дорогой"
def user_interface
  loop do
    main_menu_show
    main_menu_user_item_select = gets.to_i
    break if main_menu_process_user_choise(main_menu_user_item_select) == "exit"
  end
end

def main_menu_show
  puts "=" * 10
  MAIN_MENU.each { |key, item| puts format_message(key, item[:description]) }
end

def format_message(integer, string)
  format("%2<integer>d  %<string>s", { integer: integer, string: string })
end

def main_menu_process_user_choise(menu_item)
  case menu_item
  when 1..13
    main_menu_execute(menu_item)
  when 99
    puts "Программа завершает работу"
    "exit"
  end
end

def main_menu_execute(key)
  MAIN_MENU[key][:reference].call
end

def show_stations
  check_class_has_no_instances(Station)
  puts "Список станций:"
  show_all_with_indexes(Station)
rescue RuntimeError => e
  return unless exeption_error_show_message(e)
end

def check_class_has_no_instances(*args)
  args.each do |class_name|
    method("check_#{class_name.to_s.downcase}_instances_existance".to_sym).call(class_name)
  end
end

def check_station_instances_existance(class_name)
  raise "Нет объявленных станций!" unless class_name.all.size.positive?
end

def check_train_instances_existance(class_name)
  raise "Нет объявленных поездов!" unless class_name.all.size.positive?
end

def check_route_instances_existance(class_name)
  raise "Нет объявленных маршрутов!" unless class_name.all.size.positive?
end

def check_carriage_instances_existance(class_name)
  raise "Нет объявленных вагонов!" unless class_name.all.size.positive?
end

def show_station_trains
  check_class_has_no_instances(Station, Train)
  puts "Выберите станцию:"
  show_all_with_indexes(Station)
  user_station_select = safe_user_select_from_array(Station.all)
  show_trains(user_station_select)
rescue RuntimeError => e
  return unless exeption_error_show_message(e)
end

def show_trains(station)
  puts "Станция #{station.name}, поезда:"
  if station_has_trains?(station)
    show_trains_on_station(station)
  else
    puts "--на станции сейчас нет поездов--"
  end
end

def station_has_trains?(station)
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

def show_all_with_indexes(class_name)
  method("show_all_#{class_name.to_s.downcase}s_with_indexes".to_sym).call(class_name)
end

def show_all_stations_with_indexes(class_name)
  class_name.all.each_with_index { |instance, index| puts format_message(index + 1, instance.name) }
end

def show_all_trains_with_indexes(class_name)
  class_name.all.each_with_index { |instance, index| puts format_message(index + 1, instance.number) }
end

alias show_all_routes_with_indexes show_all_stations_with_indexes

def create_station
  print "Введите название станции (формат названия: минимум 4 "
  print "буквы/цифры/пробела в любом порядке, например: лесная 5):\n"
  user_station_name_select = gets.chomp
  station = Station.new(user_station_name_select)
  puts "Создание станции #{station.name} прошло успешно" if station.valid?
rescue RuntimeError => e
  return unless exeption_error_show_message(e)
end

def create_train
  train = create_train_instance(select_train_type, input_train_number)
  puts "Создание поезда номер #{train.number} прошло успешно" if train.valid?
rescue RuntimeError => e
  return unless exeption_error_show_message(e)
end

def select_train_type
  puts "Выберите тип поезда:"
  puts " 1  Пассажирский"
  puts " 2  Грузовой"
  safe_user_select_item_number_from_all_items(2)
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
  else
    raise "Введены пустые данные!"
  end
end

def exeption_error_show_message(exeption)
  puts "~" * 10
  case exeption.class.to_s
  when RuntimeError.to_s
    puts "Ошибка: #{exeption}"
  when NoMethodError.to_s
    puts "Ошибка: Введены пустые данные"
  end
  puts "~" * 10
end

def create_route
  check_minimum_instance_count(Station, 2)
  route = Route.new(input_route_name, select_first_station, select_last_station)
  puts "Создание маршрута #{route.name} прошло успешно" if route.valid?
rescue RuntimeError => e
  return unless exeption_error_show_message(e)
end

def check_minimum_instance_count(class_name, count)
  raise "Для создания маршрута нужно минимум 2 станции!" unless class_name.all.size >= count
end

def input_route_name
  print "Введите название маршрута (формат названия: минимум 4 "
  print "буквы/цифры/пробела в любом порядке, например: пригородный 12):\n"
  name = gets.chomp
  name !~ Route::NAME_FORMAT ? raise("Неверный формат имени!") : name
end

def select_first_station
  puts "Выберите начальную остановку:"
  show_all_with_indexes(Station)
  safe_user_select_from_array(Station.all)
end

def select_last_station
  puts "Выберите конечную остановку:"
  show_all_with_indexes(Station)
  safe_user_select_from_array(Station.all)
end

def manage_route
  check_class_has_no_instances(Route)
  user_route_select = select_route
  user_action_select = select_action_on_route
  select_station_and_assign_action_to_route(user_route_select, user_action_select)
rescue RuntimeError => e
  return unless exeption_error_show_message(e)
end

def select_route
  puts "Выберите маршрут:"
  show_all_routes_with_indexes(Route)
  safe_user_select_from_array(Route.all)
end

def safe_user_select_from_array(array)
  user_choise = gets.to_i
  raise "Выбран некорректный пункт!" if user_choise <= 0 || user_choise > array.size

  array[user_choise - 1]
end

def select_action_on_route
  puts "Выберите действие:"
  puts "1  Добавить станцию в маршрут"
  puts "2  Удалить станцию из маршрута"
  safe_user_select_item_number_from_all_items(2)
end

def select_station_and_assign_action_to_route(route, choise)
  puts "Выберите станцию:"
  case choise
  when 1
    add_station_to_route(route)
  when 2
    remove_station_from_route(route)
  end
end

def safe_user_select_item_number_from_all_items(items_size)
  user_choise = gets.to_i
  raise "Выбран некорректный пункт!" if user_choise <= 0 || user_choise > items_size

  user_choise
end

def add_station_to_route(route)
  show_all_with_indexes(Station)
  user_station_select = safe_user_select_from_array(Station.all)
  route.add_station(user_station_select)
end

def remove_station_from_route(route)
  show_route_stations_with_indexes(route)
  user_station_select = safe_user_select_from_array(route.stations)
  route.remove_station(user_station_select)
end

def show_route_stations(route)
  route.stations.each { |station| puts station.name }
end

def show_route_stations_with_indexes(route)
  route.stations.each_with_index { |station, index| puts format_message(index + 1, station.name) }
end

def set_train_route
  check_class_has_no_instances(Train, Route)
  user_train_select = select_train
  user_route_select = select_route
  puts "Поезду #{user_train_select.number} успешно задан маршрут!"
  user_train_select.route = user_route_select
rescue RuntimeError, NoMethodError => e
  return unless exeption_error_show_message(e)
end

def select_train
  puts "Выберите поезд:"
  show_all_trains_with_indexes(Train)
  safe_user_select_from_array(Train.all)
end

def add_train_carriage
  check_class_has_no_instances(Train)
  add_carriage_to_selected_train(select_train)
rescue RuntimeError => e
  return unless exeption_error_show_message(e)
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
  print "Введите количество мест в вагоне (от #{Carriage::VOLUME_LIMIT_MIN} "
  print "до #{Carriage::VOLUME_LIMIT_MAX} штук):\n"
  train.carriage_add(gets.to_i)
end

def add_carriage_to_cargo_train(train)
  print "Введите общий объем вагона (от #{Carriage::VOLUME_LIMIT_MIN} "
  print "до #{Carriage::VOLUME_LIMIT_MAX} куб. метров):\n"
  train.carriage_add(gets.to_f)
end

def remove_train_carriage
  check_class_has_no_instances(Train)
  select_train.carriage_remove
rescue RuntimeError => e
  return unless exeption_error_show_message(e)
end

def show_train_carriages
  check_class_has_no_instances(Train, Carriage)
  user_train_select = select_train
  show_current_train_carriages(user_train_select)
rescue RuntimeError => e
  return unless exeption_error_show_message(e)
end

def show_current_train_carriages(user_train_select)
  puts "Поезд #{user_train_select.number}, вагоны:"
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
  check_class_has_no_instances(Train, Carriage)
  user_train_select = show_train_carriages
  raise "Введены пустые данные!" if user_train_select.nil?

  puts "Выберите вагон поезда:"
  user_carriage_select = safe_user_select_from_array(user_train_select.carriages)
  occipy_selected_carriage(user_carriage_select)
rescue RuntimeError, NoMethodError => e
  return unless exeption_error_show_message(e)
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
  check_class_has_no_instances(Train)
  user_train_select = select_train
  raise "Это конечная станция!" if user_train_select.nearest_stations[:next].nil?

  user_train_select.forward
  print "Поезд #{user_train_select.number} двигается вперед "
  print "к станции: #{user_train_select.nearest_stations[:current].name}\n"
rescue RuntimeError, NoMethodError => e
  return unless exeption_error_show_message(e)
end

def move_train_backward
  check_class_has_no_instances(Train)
  user_train_select = select_train
  raise "Это начальная станция!" if user_train_select.nearest_stations[:previous].nil?

  user_train_select.backward
  print "Поезд #{user_train_select.number} двигается назад "
  print "к станции: #{user_train_select.nearest_stations[:current].name}\n"
rescue RuntimeError, NoMethodError => e
  return unless exeption_error_show_message(e)
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
