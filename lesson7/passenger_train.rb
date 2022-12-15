# frozen_string_literal: true

require_relative 'train'

class PassengerTrain < Train
  @all = []

  def initialize(number)
    super(number, 'passenger')
    self.class.superclass.all << self
  end

  def carriage_add(volume)
    carriage_add!(volume)
  end

  protected

  def carriage_add!(volume)
    @carriages << PassengerCarriage.new(volume) if train_stopped?
  end
end
