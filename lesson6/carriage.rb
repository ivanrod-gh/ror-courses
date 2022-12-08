require_relative 'manufacturer'

class Carriage
  include Manufacturer

  @@instances = []

  attr_reader :type

  def self.all
    all!
  end

  def initialize(type = '')
    @type = type
    self.class.all << self
  end

  protected

  def self.all!
    @@instances
  end
end