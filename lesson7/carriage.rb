require_relative 'manufacturer'

class Carriage
  include Manufacturer

  @@all = []

  attr_reader :type

  def self.all
    @@all
  end

  def initialize(type = '')
    @type = type
    validate!
    @@all << self
  end

  protected

  def validate!
  end
end