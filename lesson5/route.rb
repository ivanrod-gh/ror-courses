require_relative 'instance_counter'

class Route
  include InstanceCounter

  @@all = []

  attr_reader :name

  def self.all
    all!
  end

  def self.show_all_with_indexes
    show_all_with_indexes!
  end

  def initialize(name, first_station, last_station)
    @name = name
    @stations = [first_station, last_station]
    self.class.all << self
  end

  def stations
    stations!
  end

  def add_station(station)
    add_station!(station)
  end

  def remove_station(station)
    remove_station!(station)
  end

  def show_stations
    show_stations!
  end

  def show_stations_with_indexes
    show_stations_with_indexes!
  end

  # private, т.к. внутренние методы должны быть защищены от прямого внешнего использования и нет классов-наследников
  private

  def self.all!
    @@all
  end

  def self.show_all_with_indexes!
    all!.each_with_index {|route, index| puts "#{index+1}  #{route.name}"}
  end

  def stations!
    @stations
  end

  def add_station!(station)
    @stations.insert(-2, station)
  end

  def remove_station!(station)
    @stations.delete(station)
  end

  def show_stations!
    @stations.each { |station| puts station.name}
  end

  def show_stations_with_indexes!
    @stations.each_with_index {|station, index| puts "#{index+1}  #{station.name}"}
  end
end

