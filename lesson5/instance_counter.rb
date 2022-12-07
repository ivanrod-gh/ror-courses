module InstanceCounter
  def self.included(caller)
    caller.extend ClassMethods
    caller.include InstanceMethods
  end

  module ClassMethods
    def instances
      instances!
    end

    protected

    def instances!
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