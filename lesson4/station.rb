class Station
  @@stations = []

  attr_reader :name

  def self.stations
    stations!
  end

  def self.show_stations
    show_stations!
  end

  def self.show_stations_with_indexes
    show_stations_with_indexes!
  end

  def initialize(name)
    @name = name
    @trains = []
    self.class.stations! << self
  end

  def receive_train(train)
    receive_train!(train)
  end

  def send_train(train)
    send_train!(train)
  end

  def show_trains
    show_trains!
  end

  # private, т.к. внутренние методы должны быть защищены от прямого внешнего использования и нет классов-наследников
  private

  def self.stations!
    @@stations
  end

  def self.show_stations!
    stations!.each {|station| puts station.name}
  end

  def self.show_stations_with_indexes!
    stations!.each_with_index {|station, index| puts "#{index+1}  #{station.name}"}
  end

  def receive_train!(train)
    @trains << train
  end

  def send_train!(train)
    @trains.delete(train)
  end

  def show_trains!
    puts "Станция [#{@name}], поезда:"
    if @trains.size > 0
      @trains.each do |train|
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
end