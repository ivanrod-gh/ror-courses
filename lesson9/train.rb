# frozen_string_literal: true

require_relative 'passenger_carriage'
require_relative 'cargo_carriage'
require_relative 'accessors'
require_relative 'validation'
require_relative 'manufacturer'
require_relative 'instance_counter'

class Train
  extend Accessors
  include Validation
  include Manufacturer
  include InstanceCounter

  NUMBER_FORMAT = /^[а-яёa-z|\d]{3}(-)*[а-яёa-z|\d]{2}$/i.freeze

  @all = []

  class << self
    attr_reader :all

    protected

    attr_writer :all
  end

  attr_accessor_with_history :number
  strong_attr_accessor :type, String
  attr_reader :carriages

  validate :number, :format, NUMBER_FORMAT

  def self.find(number)
    @all.each { |train| return train if number == train.number }
    nil
  end

  def self.process_carriages(train, &block)
    train.carriages.each(&block)
  end

  def initialize(number = '', type = '')
    @number = number
    @type = type
    @carriages = []
    @speed = 0
    validate!
    self.class.all << self
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

  def nearest_stations
    station_index = @route.stations.find_index(@station)
    first_station = station_index.zero? ? nil : @route.stations[station_index - 1]
    { previous: first_station, current: @route.stations[station_index], next: @route.stations[station_index + 1] }
  end

  protected

  def speed_up!
    @speed += 10
  end

  def stop!
    @speed = 0
  end

  def carriage_add!
    @carriages << Carriage.new if train_stopped?
  end

  def carriage_remove!
    raise "Отцепить вагон можно только у вагона, который не двигается!" unless train_stopped?

    check_minimum_array_size(@carriages, 1)
    carriage = @carriages[-1]
    @carriages.delete(carriage)
    Carriage.all.delete(carriage)
  end

  def train_stopped?
    @speed.zero?
  end

  def route!(route)
    route.valid?
    @route = route
    @station&.send_train(self)
    @station = route.stations[0]
    @station.receive_train(self)
  end

  def forward!
    nearest_stations[:next].valid?
    @station.send_train(self)
    @station = nearest_stations[:next]
    @station.receive_train(self)
  end

  def backward!
    nearest_stations[:previous].valid?
    @station.send_train(self)
    @station = nearest_stations[:previous]
    @station.receive_train(self)
  end
end
