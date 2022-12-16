require_relative 'train'

class PassengerTrain < Train
  def initialize(number)
    super(number, 'passenger')
  end

  def carriage_add(seat_count)
    carriage_add!(seat_count)
  end

  protected

  def carriage_add!(seat_count)
    if train_stopped?
      @carriages << PassengerСarriage.new(seat_count)
    end
  end
end