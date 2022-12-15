# frozen_string_literal: true

require_relative 'instance_counter'

class Route
  include InstanceCounter

  @all = []

  class << self
    attr_reader :all

    private

    attr_writer :all
  end

  attr_reader :name, :stations

  def initialize(name, first_station, last_station)
    @name = name
    @stations = [first_station, last_station]
    validate!
    self.class.all << self
  end

  def validate?
    validate!
  end

  def add_station(station)
    add_station!(station)
  end

  def remove_station(station)
    remove_station!(station)
  end

  private

  def validate!
    validate_name
    validate_stops
    true
  end

  def validate_name
    raise "Название маршрута должно состоять минимум из 4 символов!" if @name.length < 4
    raise "Неверный формат названия маршрута!" if @name !~ /^[а-яёa-z|\d|\s]{4,}$/i
  end

  def validate_stops
    raise "Не выбрана начальная остановка!" if stations[0].nil?
    raise "Не выбрана конечная остановка!" if stations[1].nil?
    raise "Начальная и конечная остановки должны отличаться!" if stations[0] == stations[1]
  end

  def add_station!(station)
    @stations.insert(-2, station)
  end

  def remove_station!(station)
    @stations.delete(station)
  end
end
