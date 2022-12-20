# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(variable_name, method_name, additional_data = nil)
      @validations ||= {}
      @validations.store(variable_name, []) unless @validations.key?(variable_name)
      @validations[variable_name].push({ method_name: method_name, additional_data: additional_data })
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    end

    protected

    def validate!
      self.class.instance_variable_get(:@validations).each do |variable, method_and_data|
        method_and_data.each do |validate|
          if validate[:additional_data].nil?
            method("validate_#{validate[:method_name]}".to_sym).call(variable)
          else
            method("validate_#{validate[:method_name]}".to_sym).call(variable, validate[:additional_data])
          end
        end
      end
    end

    def validate_presence(variable, variable_index_in_array = nil)
      case variable_index_in_array
      when nil
        raise "Введены пустые данные!" if instance_variable_get("@#{variable}").nil?
      when true
        raise "Введены пустые данные!" if instance_variable_get("@#{variable}")[variable_index_in_array].nil?
      end
    end

    def validate_all_elements_unique(stations)
      stations = instance_variable_get("@#{stations}")
      stations.each { |station| check_repeating_elements(station, stations, 1) }
    end

    def check_repeating_elements(element, array, maximum_count = 0)
      raise "Остановки на маршруте не должны повторяться! (#{element.name})" if array.count(element) > maximum_count
    end

    def validate_array_size(stations, minimum_size)
      stations = instance_variable_get("@#{stations}")
      check_minimum_array_size(stations, minimum_size)
    end

    def check_minimum_array_size(array, minimum_size = 0)
      raise "Для выполнения операции должно быть объектов: #{minimum_size}" if array.size < minimum_size
    end

    def validate_format(name, format)
      raise "Неверный формат имени!" if instance_variable_get("@#{name}") !~ format
    end

    def validate_variable_min_max(volume_occupied, limits)
      volume_occupied = instance_variable_get("@#{volume_occupied}")
      check_variable_min(volume_occupied, limits[:min])
      check_variable_max(volume_occupied, limits[:max])
    end

    def check_variable_min(variable, minimum)
      raise "Минимум: #{minimum}" if variable < minimum
    end

    def check_variable_max(variable, maximum)
      raise "Максимум: #{maximum}" if variable > maximum
    end
  end
end
