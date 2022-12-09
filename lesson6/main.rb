require_relative 'station'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'route'

def show_stations
  puts "Список станций:"
  show_all(Station)
end

def show_all(class_name)
  class_name.all.each {|station| puts station.name}
end

def show_trains_on_station
  puts "Выберите станцию:"
  show_all_with_indexes(Station)
  user_station_select = gets.to_i - 1
  station = Station.all[user_station_select]
  puts "Станция [#{station.name}], поезда:"
  if station.trains.size > 0
    station.trains.each do |train|
      if train.type == "passenger"
        puts "Поезд номер #{train.number}, пассажирский"
      else
        puts "Поезд номер #{train.number}, грузовой"
      end
    end
  else
    puts "--на станции сейчас нет поездов--"
  end
end

def show_all_with_indexes(class_name)
  case class_name.to_s
  when Station.to_s
    class_name.all.each_with_index {|station, index| puts "#{index + 1}  #{station.name}"}
  when Train.to_s
    class_name.all.each_with_index {|train, index| puts "#{index + 1}  #{train.number}"}
  when Route.to_s
    class_name.all.each_with_index {|route, index| puts "#{index + 1}  #{route.name}"}
  end
end

def create_station
  puts "Введите название станции (формат названия: минимум 4 буквы/цифры/пробела в любом порядке, например: лесная 5):"
  user_station_name_select = gets.chomp
  Station.new(user_station_name_select)
end

def create_train
  user_train_type_select = ""
  begin
    loop do
      puts "Выберите тип поезда:"
      puts "1  Пассажирский"
      puts "2  Грузовой"
      user_train_type_select = gets.to_i
      puts user_train_type_select
      break if user_train_type_select == 1 || user_train_type_select == 2
    end
    puts user_train_type_select
    puts "Введите номер поезда (формат номера: 3 цифры/буквы, необязательный дефис и еще 2 цифры/буквы, например: АБВ-01):"
    user_train_number = gets.chomp
    case user_train_type_select
    when 1
      train = PassengerTrain.new(user_train_number)
    when 2
      train = CargoTrain.new(user_train_number)
    end
    puts "Создание поезда с номером #{user_train_number} прошло успешно" if train.validate?
  rescue RuntimeError
    puts "="*10 + "\nОшибка: были введены некорректные данные! Попробуйте еще раз\n" + "="*10
    retry
  end
end

def create_route
  puts "Введите название маршрута (формат названия: минимум 4 буквы/цифры/пробела в любом порядке, например: пригородный 12):"
  user_route_name = gets.chomp
  puts "Выберите начальную остановку:"
  show_all_with_indexes(Station)
  user_first_station_select = Station.all[gets.to_i - 1]
  puts "Выберите конечную остановку:"
  show_all_with_indexes(Station)
  user_last_station_select = Station.all[gets.to_i - 1]
  Route.new(user_route_name, user_first_station_select, user_last_station_select)
end

def manage_route
  user_route_select = select_route
  puts "Выберите действие:"
  puts "1  Добавить станцию в маршрут"
  puts "2  Удалить станцию из маршрута"
  user_action_select = gets.to_i
  puts "Выберите станцию:"
  case user_action_select
  when 1
    show_all_with_indexes(Station)
    user_station_select = Station.all[gets.to_i - 1]
    user_route_select.add_station(user_station_select)
    show_route_stations(user_route_select)
  when 2
    show_route_stations_with_indexes(user_route_select)
    user_station_select = user_route_select.stations[gets.to_i - 1]
    user_route_select.remove_station(user_station_select)
    show_route_stations(user_route_select)
  end
end

def select_route
  puts "Выберите маршрут:"
  show_all_with_indexes(Route)
  Route.all[gets.to_i - 1]
end

def show_route_stations(route)
  route.stations.each { |station| puts station.name}
end

def show_route_stations_with_indexes(route)
  route.stations.each_with_index {|station, index| puts "#{index + 1}  #{station.name}"}
end

def set_train_route
  user_train_select = select_train
  user_route_select = select_route
  user_train_select.route = user_route_select
end

def select_train
  puts "Выберите поезд:"
  show_all_with_indexes(Train)
  Train.all[gets.to_i - 1]
end

def add_train_carriage
  user_train_select = select_train
  user_train_select.carriage_add
end

def remove_train_carrige
  user_train_select = select_train
  user_train_select.carriage_remove
end

def move_train_forward
  user_train_select = select_train
  user_train_select.forward
end

def move_train_backward
  user_train_select = select_train
  user_train_select.backward
end

puts "Программа управления железной дорогой"
loop do
  puts "="*10
  puts "Выберите пунт меню:"
  puts "1   Вывести список станций"
  puts "2   Вывести список поездов на станции"
  puts "3   Создать станцию"
  puts "4   Создать поезд"
  puts "5   Создать маршрут"
  puts "6   Управлять маршрутом"
  puts "7   Назначить маршрут поезду"
  puts "8   Добавить вагон к поезду"
  puts "9   Отцепить вагон от поезда"
  puts "10  Перегнать поезд на следующую станцию"
  puts "11  Перегнать поезд на предыдущую станцию"
  puts "0   Выйти"
  user_main_menu_select = gets.chomp
  puts "="*10
  case user_main_menu_select
  when "1"
    show_stations
  when "2"
    show_trains_on_station
  when "3"
    create_station
  when "4"
    create_train
  when "5"
    create_route
  when "6"
    manage_route
  when "7"
    set_train_route
  when "8"
    add_train_carriage
  when "9"
    remove_train_carrige
  when "10"
    move_train_forward
  when "11"
    move_train_backward
  when "0"
    break
  end
end