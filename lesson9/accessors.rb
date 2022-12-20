# frozen_string_literal: true

module Accessors
  SETTER_WITH_HISTORY = proc do |object, name, value|
    object.instance_variable_set("@#{name}".to_sym, value)
    variable = object.instance_variable_get("@#{name}_history".to_sym) || []
    variable << value
    object.instance_variable_set("@#{name}_history".to_sym, variable)
  end

  def attr_accessor_with_history(*args)
    args.each do |name|
      define_method(name) { instance_variable_get("@#{name}".to_sym) }
      define_method("#{name}_history".to_sym) { instance_variable_get("@#{name}_history".to_sym) }
      define_method("#{name}=".to_sym) do |value|
        SETTER_WITH_HISTORY.call(self, name, value)
      end
    end
  end

  def strong_attr_accessor(name, argument_class)
    define_method(name) { instance_variable_get("@#{name}".to_sym) }
    define_method("#{name}=".to_sym) do |value|
      raise "Неверный тип переменной!" if value.class != argument_class

      instance_variable_set("@#{name}".to_sym, value)
    end
  end
end
