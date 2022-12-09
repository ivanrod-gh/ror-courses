module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def instances
      @instances
    end
  end

  module InstanceMethods
    protected

    def register_instance!
      self.class.instance_variable_set(:@instances, 0) if !self.class.instance_variable_defined?(:@instances)
      self.class.instance_variable_set(:@instances, self.class.instance_variable_get(:@instances) + 1)
    end
  end
end