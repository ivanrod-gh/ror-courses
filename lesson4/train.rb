require_relative 'passenger_carriage'
require_relative 'cargo_carriage'

class Train
  @@trains = []

  attr_reader :number, :type

  def self.trains
    trains!
  end

  def self.show_trains_with_indexes
    show_trains_with_indexes!
  end

  def initialize(type = '', number)
    @number = number
    @type = type
    @carriages = []
    @speed = 0
    self.class.trains! << self
  end

  def speed_up
    speed_up!
  end

  def stop
    stop!
  end

  def carriage_add
    carriage_add!
  end

  def carriage_remove
    carriage_remove!
  end

  def route=(route)
    route!(route)
  end

  def forward
    forward!
  end

  def backward
    backward!
  end

  # protected, т.к. внутренние методы должны быть защищены от прямого внешнего использования и ими пользуются классы-наследники
  protected

  def self.trains!
    @@trains
    # p @@trains
  end

  def self.show_trains_with_indexes!
    trains!.each_with_index {|train, index| puts "#{index+1}  #{train.number}"}
  end

  def speed_up!
    @speed += 10
    # puts "У поезда #{self} #{@number} увеличена скорость до #{@speed}"
  end

  def stop!
    @speed = 0
    # puts "Поезд #{self} #{@number} остановлен (скорость = #{@speed})"
  end

  def carriage_add!
    if train_stopped?
      if @type == 'passenger'
        @carriages << PassengerСarriage.new
      else
        @carriages << СargoСarriage.new
      end
    end
  end

  def carriage_remove!
    if train_stopped?
     @carriages.pop
    end
  end

  def train_stopped?
    @speed.zero?
  end

  def route!(route)
    @route = route
    if @station
      @station.send_train(self)
    end
    @station = route.stations[0]
    @station.receive_train(self)
  end

  def forward!
    @station.send_train(self)
    @station = nearest_stations![2]
    @station.receive_train(self)
  end

  def backward!
    @station.send_train(self)
    @station = nearest_stations![0]
    @station.receive_train(self)
  end

  def nearest_stations!
    station_index = @route.stations.find_index(@station)
    nearest_stations = [@route.stations[station_index - 1], @route.stations[station_index], @route.stations[station_index + 1]]
  end
end