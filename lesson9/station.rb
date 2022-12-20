# frozen_string_literal: true

require_relative 'accessors'
require_relative 'validation'
require_relative 'instance_counter'

class Station
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

  attr_reader :name, :trains

  validate :name, :format, NAME_FORMAT

  def self.process_trains(station, &block)
    station.trains.each(&block)
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    self.class.all << self
  end

  def receive_train(train)
    receive_train!(train)
  end

  def send_train(train)
    send_train!(train)
  end

  private

  def receive_train!(train)
    @trains << train
  end

  def send_train!(train)
    @trains.delete(train)
  end
end
