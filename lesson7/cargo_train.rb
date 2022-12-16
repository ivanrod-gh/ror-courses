require_relative 'train'

class CargoTrain < Train
  def initialize(number)
    super(number, 'cargo')
  end

  def carriage_add(volume_size)
    carriage_add!(volume_size)
  end

  protected

  def carriage_add!(volume_size)
    if train_stopped?
      @carriages << СargoСarriage.new(volume_size)
    end
  end
end