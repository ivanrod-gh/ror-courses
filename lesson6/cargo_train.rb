require_relative 'train'

class CargoTrain < Train
  def initialize(number)
    super('cargo', number)
  end
end