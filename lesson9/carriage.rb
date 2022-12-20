# frozen_string_literal: true

require_relative 'manufacturer'
require_relative 'accessors'
require_relative 'validation'

class Carriage
  include Manufacturer
  extend Accessors
  include Validation

  VOLUME_LIMIT_MIN = 20
  VOLUME_LIMIT_MAX = 150

  @all = []

  class << self
    attr_reader :all

    protected

    attr_writer :all
  end

  attr_reader :type, :volume_occupied

  validate :volume, :variable_min_max, { min: VOLUME_LIMIT_MIN, max: VOLUME_LIMIT_MAX }

  def initialize(volume = '', type = '')
    @volume = volume
    @volume_occupied = 0
    @type = type
    validate!
    self.class.all << self
  end

  def occupy_volume(volume)
    occupy_volume!(volume)
  end

  def volume_realesed
    @volume - @volume_occupied
  end

  protected

  def occupy_volume!(volume)
    check_variable_max(@volume_occupied + volume, @volume)
    @volume_occupied += volume
  end
end
