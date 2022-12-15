# frozen_string_literal: true

require_relative 'instance_counter'

class Station
  include InstanceCounter

  @all = []

  class << self
    attr_reader :all

    private

    attr_writer :all
  end

  attr_reader :name, :trains

  def self.process_trains(station, &block)
    station.trains.each(&block)
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    self.class.all << self
  end

  def validate?
    validate!
  end

  def receive_train(train)
    receive_train!(train)
  end

  def send_train(train)
    send_train!(train)
  end

  private

  def validate!
    raise "Название станции должно состоять минимум из 4 символов!" if @name.length < 4
    raise "Неверный формат названия станции!" if @name !~ /^[а-яёa-z|\d|\s]{4,}$/i

    true
  end

  def receive_train!(train)
    @trains << train
  end

  def send_train!(train)
    @trains.delete(train)
  end
end
