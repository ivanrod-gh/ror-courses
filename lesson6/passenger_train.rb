require_relative 'train'

class PassengerTrain < Train
  def initialize(number)
    super('passenger', number)
  end
end