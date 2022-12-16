# frozen_string_literal: true

require_relative 'train'

class CargoTrain < Train
  @all = []

  def initialize(number)
    super(number, 'cargo')
    self.class.superclass.all << self
  end

  def carriage_add(volume)
    carriage_add!(volume)
  end

  protected

  def carriage_add!(volume)
    @carriages << CargoCarriage.new(volume) if train_stopped?
  end
end
