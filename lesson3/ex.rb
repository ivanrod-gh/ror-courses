#Железнодорожная станция

# т.к. задача похожа на заготовку чего-то, то могу ошибаться с направлением решения.
# не совсем понятно, как будет осуществляться работа пользователя - по идентификатору,
# по человеческим наваниям или же будет дополнительный пользовательский интерейс с
# выбором, то делать - добавить станцию, перегнать поезд с одной станции на другую,
# посмотреть список всех поездов и станций и т.д.
# в зависимости от конечного ТЗ реализовать это можно разными путями.
# в данной реализации функционал формально соответствует ТЗ.
# внешний ввод информации отсутствует

class Stantion
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def receive_train(train)
    puts "На станцию #{self} (#{@name}) прибыл поезд #{train} (номер #{train.number})"
    @trains << train
  end

  def send_train(train)
    puts "Со станции #{self} (#{@name}) отправлен поезд #{train} (номер #{train.number})"
    @trains.delete(train)
  end

  def show
    puts "Станциия #{self} (#{@name}), поезда:"
    if @trains.size > 0
      @trains.each do |train|
        if train.type == "passenger"
          puts "Пассажирский #{train} (номер #{train.number})"
        else
          puts "Грузовой #{train} (номер #{train.number})"
        end
      end
    else
      puts "-"*5
    end
  end
end

class Route
  attr_reader :stantions

  def initialize(first_st, last_st)
    if first_st.class != Stantion
      puts "Ошибка - первой из указанных станций не существует!"
    elsif last_st.class != Stantion
      puts "Ошибка - второй из указанных станций не существует!"
    else
      @stantions = [first_st, last_st]
    end
  end

  # добавить станцию в маршрут по идентификатору
  def add(stantion, position)
    if stantion.class != Stantion
      puts "Ошибка - указанной станции не существует!"
    elsif position.to_i > @stantions.size || position.to_i < 1
      puts "Ошибка - позиция добавляемой станции в списке станций не болжен быть меньше 1 или больше количества станций!"
    elsif @stantions.include?(stantion) == true
      puts "Ошибка - такая станция уже есть в маршруте!"
    else
      puts "В маршрут #{self} добавлена станция #{stantion} (#{stantion.name})"
      @stantions.insert(position - 1, stantion)
    end
  end

  # удалить станцию из маршрута по идентификатору
  def delete(stantion)
    if stantion.class != Stantion
      puts "Ошибка - указанной станции не существует!"
    elsif @stantions.first == stantion || @stantions.last == stantion
      puts "Ошибка - нельзя удалить начальную или конечную станции"
    elsif @stantions.include?(stantion) == false
      puts "Ошибка - такой станции нет в списке!"
    else
      puts "Из маршрута #{self} удалена станция #{stantion} (#{stantion.name})"
      @stantions.delete(stantion)
    end
  end

  # вывести все станции маршрута
  def show
    puts "Все остановки маршрута #{self}:"
    @stantions.each { |st| puts st}
  end
end

class Train
  attr_accessor :speed, :stantion
  attr_reader :route, :number, :type

  def initialize(number, type, carriage_count)
    @number = number
    @type = type
    @carriage_count = carriage_count.to_i
    @speed = 0
  end

  # прибавить скорость
  def speed_up
    @speed += 10
    puts "У поезда #{self} #{@number} увеличена скорость до #{@speed}"
  end

  # остановиться
  def stop
    @speed = 0
    puts "Поезд #{self} #{@number} остановлен (скорость = #{@speed})"
  end

  # вернуть количество вагонов
  def carriage
    puts "У поезда #{self} (номер #{@number}) #{@carriage_count} вагонов"
    @carriage_count
  end

  # изменить количество вагонов
  def carriage_change_count(count)
    if @speed != 0
      puts "Ошибка - прицеплять/отцеплять вагоны можно только тогда, когда поезд стоит на месте!"
    else
     @carriage_count += count.to_i
    end
    puts "У поезда #{self} (номер #{@number}) изменилось количество вагонов на #{count.to_i} и теперь их #{@carriage_count}"
  end

  # ввести маршрут
  def route=(route)
    @route = route
    if @stantion
      @stantion.send_train(self)
    end
    @stantion = route.stantions[0]
    @stantion.receive_train(self)
    @stantion_index = route.stantions.index(@stantion)
    puts "Поезду #{self} (номер #{@number}) добавлен маршрут #{route}"
  end

  # двигаться вперед по маршруту
  def forward
    if @stantion == nil
      puts "Ошибка - маршрут следования не определен"
    elsif @stantion_index >= @route.stantions.size - 1
      puts "Ошибка - это конечная остановка!"
    else
      @stantion.send_train(self)
      @stantion = @route.stantions[@stantion_index + 1]
      puts "Поезд #{self} (номер #{@number}) движется вперед по маршуту к #{@stantion} (#{@stantion.name})"
      @stantion.receive_train(self)
      @stantion_index += 1
    end
  end

  # двигаться назад по маршруту
  def backward
    if @stantion == nil
      puts "Ошибка - маршрут следования не определен"
    elsif @stantion_index == 0
      puts "Ошибка - это конечная остановка!"
    else
      @stantion.send_train(self)
      @stantion = @route.stantions[@stantion_index - 1]
      puts "Поезд #{self} (номер #{@number}) движется назад по маршуту к #{@stantion} (#{@stantion.name})"
      @stantion.receive_train(self)
      @stantion_index -= 1
    end
  end

  # вернуть данные о местоположении поезда
  # принято за основу, что "вперед" - это от первой к последней станции
  def location
    nearest_stantions = []
    if @stantion_index - 1 < 0
      nearest_stantions[0] = nil
    else
      nearest_stantions[0] = @route.stantions[@stantion_index - 1]
    end
    nearest_stantions[1] = @route.stantions[@stantion_index]
    if @stantion_index > @route.stantions.size
      nearest_stantions[2] = nil
    else
      nearest_stantions[2] = @route.stantions[@stantion_index + 1]
    end
    puts "Ближайшие остановки поезда #{self} (номер #{@number}):"
    puts nearest_stantions
    nearest_stantions
  end
end

# тесты
# tr1 = Train.new("123", "passenger", "8")
# p tr1
# tr1.speed_up
# tr1.speed_up
# tr1.speed_up
# p tr1
# puts tr1.speed
# puts "="*10
# tr1.stop
# p tr1
# puts tr1.speed
# puts "="*10
# puts tr1.carriage
# puts "="*10
# tr1.speed_up
# tr1.carriage_change_count(5)
# tr1.stop
# puts "="*10
# tr1.carriage_change_count(-3)
# puts tr1.carriage
# tr1.carriage_change_count(20)
# puts tr1.carriage
# puts "="*10
# st1 = Stantion.new("stantion 1")
# st2 = Stantion.new("stantion 2")
# p st1, st2
# puts "="*10
# st3 = Stantion.new("stantion 3")
# st4 = Stantion.new("stantion 4")
# st5 = Stantion.new("stantion 5")
# rou1 = Route.new(st1,st5)
# p rou1
# puts "="*10
# rou1.show
# rou1.add(st4,0)
# rou1.add(tr1,0)
# rou1.add(st4,2)
# rou1.add(st2,2)
# puts "-"*10
# rou1.show
# puts "="*10
# rou2 = Route.new(tr1,st1)
# rou2 = Route.new(st1,tr1)
# puts "="*10
# rou1.delete(st1)
# rou1.delete(st1)
# rou1.delete(st1)
# rou1.delete(st2)
# rou1.delete(st4)
# rou1.delete(st5)
# rou1.show
# puts "="*10
# rou1.delete(st1)
# rou1.delete(st2)
# rou1.delete(st3)
# rou1.delete(st4)
# rou1.delete(st5)
# rou1.add(st4,2)
# rou1.add(st3,2)
# rou1.add(st2,2)
# rou1.show
# puts "="*10
# rou2 = Route.new(st2,st5)
# rou2.add(st3,2)
# rou2.add(st3,2)
# rou2.add(st4,3)
# rou2.show
# tr2 = Train.new("234", "freight", "50")
# p tr2
# tr2.forward
# tr2.backward
# puts "="*10
# tr2.route = rou2
# tr2.route.show
# puts "="*10
# tr2.location
# tr2.forward
# tr2.forward
# tr2.forward
# tr2.forward
# tr2.forward
# tr2.location
# puts "="*10
# tr2.backward
# tr2.backward
# tr2.backward
# tr2.backward
# tr2.location
# puts "="*10
# tr1.route = rou1
# tr3 = Train.new("345", "freight", "60")
# tr3.route = rou1
# tr4 = Train.new("456", "passenger", "12")
# tr4.route = rou1
# tr5 = Train.new("567", "freight", "45")
# tr5.route = rou1
# tr6 = Train.new("678", "freight", "62")
# tr6.route = rou2
# puts "="*10
# st1.show
# st2.show
# st3.show
# st4.show
# st5.show
# puts "="*10
# rou1.show
# puts "="*10
# rou2.show
# puts "="*10
# tr1.forward
# tr1.forward
# tr1.forward
# tr1.forward
# tr1.route = rou1
# tr2.forward
# tr2.forward
# tr3.forward
# tr4.forward
# tr4.forward
# tr4.forward
# tr5.forward
# tr5.forward
# tr5.forward
# tr6.forward
# tr6.forward
# tr6.forward
# tr6.forward #tr2 - 4 станции
# tr6.backward
# tr5.forward
# puts "="*10
# st1.show
# st2.show
# st3.show
# st4.show
# st5.show