# frozen_string_literal: true

require_relative 'accessors'
require_relative 'validation'
require_relative 'instance_counter'

class Route
  extend Accessors
  include Validation
  include InstanceCounter

  NAME_FORMAT = /^[а-яёa-z|\d|\s]{4,}$/i.freeze

  @all = []

  class << self
    attr_reader :all

    private

    attr_writer :all
  end

  attr_reader :name, :stations

  validate :name, :format, NAME_FORMAT
  validate :stations, :presence
  validate :stations, :presence, 0
  validate :stations, :presence, 1
  validate :stations, :all_elements_unique
  validate :stations, :array_size, 2

  def initialize(name, first_station, last_station)
    @name = name
    @stations = [first_station, last_station]
    validate!
    self.class.all << self
  end

  def add_station(station)
    add_station!(station)
  end

  def remove_station(station)
    remove_station!(station)
  end

  private

  def add_station!(station)
    check_repeating_elements(station, @stations, 0)
    @stations.insert(-2, station)
  end

  def remove_station!(station)
    check_minimum_array_size(@stations, 3)
    @stations.delete(station)
  end
end
