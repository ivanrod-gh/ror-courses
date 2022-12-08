require_relative 'instance_counter'

class Station
  include InstanceCounter

  @@all = []

  attr_reader :name

  def self.all
    all!
  end

  def initialize(name)
    @name = name
    @trains = []
    self.class.all! << self
    validate!
  end

  def validate?
    validate!
  end

  def receive_train(train)
    receive_train!(train)
  end

  def send_train(train)
    send_train!(train)
  end

  # def show_trains
  #   show_trains!
  # end

  def trains
    trains!
  end

  private

  def self.all!
    @@all
  end

  def validate!
    raise "Название станции должно состоять минимум из 4 символов!" if @name.length < 4
    raise "Неверный формат названия станции!" if @name !~ /^[а-яёa-z|\d|\s]{4,}$/i
    true
  end

  def receive_train!(train)
    @trains << train
  end

  def send_train!(train)
    @trains.delete(train)
  end
  
  def trains!
    @trains
  end
end