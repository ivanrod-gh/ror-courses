# frozen_string_literal: true

require_relative 'passenger_carriage'
require_relative 'cargo_carriage'
require_relative 'manufacturer'
require_relative 'instance_counter'

class Train
  include Manufacturer
  include InstanceCounter

  @all = []

  class << self
    attr_reader :all

    protected

    attr_writer :all
  end

  attr_reader :number, :type, :carriages

  def self.find(number)
    @all.each do |train|
      return train if number == train.number
    end
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

  def validate?
    validate!
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

  protected

  def validate!
    raise "Неверный формат номера поезда!" if @number !~ /^[а-яёa-z|\d]{3}(-)*[а-яёa-z|\d]{2}$/i

    true
  end

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
    return unless train_stopped?

    carriage = @carriages[-1]
    @carriages.delete(carriage)
    Carriage.all.delete(carriage)
  end

  def train_stopped?
    @speed.zero?
  end

  def route!(route)
    @route = route
    @station&.send_train(self)
    @station = route.stations[0]
    @station.receive_train(self)
  end

  def forward!
    @station.send_train(self)
    @station = nearest_stations[2]
    @station.receive_train(self)
  end

  def backward!
    @station.send_train(self)
    @station = nearest_stations[0]
    @station.receive_train(self)
  end

  def nearest_stations
    station_index = @route.stations.find_index(@station)
    [@route.stations[station_index - 1], @route.stations[station_index], @route.stations[station_index + 1]]
  end
end
