require_relative 'carriage'

class PassengerСarriage < Carriage
  SEAT_COUNT_MIN = 20
  SEAT_COUNT_MAX = 150

  def initialize(seat_count)
    @seat_count = seat_count
    @seat_occupied_count = 0
    super('passenger')
  end

  def occupy_seat
    occupy_seat!
  end

  def seat_occupied_count
    @seat_occupied_count
  end

  def seat_realesed_count
    @seat_count - @seat_occupied_count
  end

  protected

  def validate!
    raise "Неверное количество мест в вагоне!" if @seat_count < SEAT_COUNT_MIN || @seat_count > SEAT_COUNT_MAX
    true
  end

  def occupy_seat!
    @seat_occupied_count += 1
  end
end