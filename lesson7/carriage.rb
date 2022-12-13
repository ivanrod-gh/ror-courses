require_relative 'manufacturer'

class Carriage
  include Manufacturer

  VOLUME_MIN = 20
  VOLUME_MAX = 150

  @@all = []

  attr_reader :type, :volume_occupied

  def self.all
    @@all
  end

  def initialize(volume = '', type = '')
    @volume = volume
    @volume_occupied = 0
    @type = type
    validate!
    @@all << self
  end

  def occupy_volume(volume)
    occupy_volume!(volume)
  end

  def volume_realesed
    @volume - @volume_occupied
  end

  protected

  def validate!
  end

  def occupy_volume!(volume)
    @volume_occupied += volume
  end
end