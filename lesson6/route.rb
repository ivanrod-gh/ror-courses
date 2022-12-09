require_relative 'instance_counter'

class Route
  include InstanceCounter

  @@all = []

  attr_reader :name

  def self.all
    @@all
  end

  def initialize(name, first_station, last_station)
    @name = name
    @stations = [first_station, last_station]
    validate!
    @@all << self
  end

  def validate?
    validate!
  end

  def stations
    @stations
  end

  def add_station(station)
    add_station!(station)
  end

  def remove_station(station)
    remove_station!(station)
  end

  private

  def validate!
    raise "Название маршрута должно состоять минимум из 4 символов!" if @name.length < 4
    raise "Неверный формат названия маршрута!" if @name !~ /^[а-яёa-z|\d|\s]{4,}$/i
    raise "Не выбрана начальная и конечная остановки!" if stations[0] == nil && stations[1] == nil
    raise "Не выбрана начальная или конечная остановка!" if stations[0] == nil || stations[1] == nil
    raise "Начальная и конечная остановки должны отличаться!" if stations[0] == stations[1]
    true
  end

  def add_station!(station)
    @stations.insert(-2, station)
  end

  def remove_station!(station)
    @stations.delete(station)
  end
end

