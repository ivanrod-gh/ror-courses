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

    def register_instance!
      if @instances == nil
        @instances = 0
      end
      @instances += 1
      p @instances
    end

    def instances!
      @instances
    end
  end

  module InstanceMethods
    protected

    def register_instance!
      # self.class.register_instance!   # нет доступа?
      self.class.send :register_instance!
    end
  end
end




