require_relative 'station'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'route'

def select_train
  puts "Выберите поезд:"
  Train.show_trains_with_indexes
  Train.trains[gets.to_i - 1]
end

def select_route
  puts "Выберите маршрут:"
  Route.show_routes_with_indexes
  Route.routes[gets.to_i - 1]
end

puts "Управление железной дорогой"
loop do
  puts "="*10
  puts "Выберите пунт меню:"
  puts "1  Вывести список станций"
  puts "2  Вывести список поездов на станции"
  puts "3  Создать станцию"
  puts "4  Создать поезд"
  puts "5  Создать маршрут"
  puts "6  Управлять маршрутом"
  puts "7  Назначить маршрут поезду"
  puts "8  Добавить вагон к поезду"
  puts "9  Отцепить вагон от поезда"
  puts "10  Перегнать поезд на следующую станцию"
  puts "11  Перегнать поезд на предыдущую станцию"
  puts "0  Выйти"
  user_main_menu_select = gets.chomp
  puts "="*10
  case user_main_menu_select
  when "1"
    puts "Список станций:"
    Station.show_stations
  when "2"
    puts "Выберите станцию:"
    Station.show_stations_with_indexes
    user_station_select = gets.to_i - 1
    Station.stations[user_station_select].show_trains
  when "3"
    puts "Введите название станции:"
    user_station_name_select = gets.chomp
    Station.new(user_station_name_select)
  when "4"
    puts "Введите тип поезда:"
    puts "1  Пассажирский"
    puts "2  Грузовой"
    user_train_type_select = gets.to_i
    puts "Введите порядковый номер поезда:"
    user_train_number = gets.to_i
    case user_train_type_select
    when 1
      PassengerTrain.new(user_train_number)
    when 2
      CargoTrain.new(user_train_number)
    end
  when "5"
    puts "Введите название маршрута:"
    user_route_name = gets.chomp
    puts "Выберите начальную остановку:"
    Station.show_stations_with_indexes
    user_first_station_select = Station.stations[gets.to_i - 1]
    puts "Выберите конечную остановку:"
    Station.show_stations_with_indexes
    user_last_station_select = Station.stations[gets.to_i - 1]
    Route.new(user_route_name, user_first_station_select, user_last_station_select)
  when "6"
    user_route_select = select_route
    puts "Выберите действие:"
    puts "1  Добавить станцию в маршрут"
    puts "2  Удалить станцию из маршрута"
    user_action_select = gets.to_i
    puts "Выберите станцию:"
    case user_action_select
    when 1
      Station.show_stations_with_indexes
      user_station_select = Station.stations[gets.to_i - 1]
      user_route_select.add_station(user_station_select)
      user_route_select.show_stations
    when 2
      user_route_select.show_stations_with_indexes
      user_station_select = user_route_select.stations[gets.to_i - 1]
      user_route_select.remove_station(user_station_select)
      user_route_select.show_stations
    end
  when "7"
    user_train_select = select_train
    user_route_select = select_route
    user_train_select.route = user_route_select
  when "8"
    user_train_select = select_train
    user_train_select.carriage_add
  when "9"
    user_train_select = select_train
    user_train_select.carriage_remove
  when "10"
    user_train_select = select_train
    user_train_select.forward
  when "11"
    user_train_select = select_train
    user_train_select.backward
  when "0"
    break
  end
end


