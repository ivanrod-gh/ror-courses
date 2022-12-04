class Carriage
  @@carriages = []

  attr_reader :type

  def self.carriages
    @@carriages
  end

  def initialize(type = '')
    @type = type
    self.class.carriages << self
  end
end