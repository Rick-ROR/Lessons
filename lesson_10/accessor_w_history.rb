#!/usr/bin/ruby -w

module MyAttrAccessor
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_name_history = "@#{name}_history".to_sym

      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}_history" ) do
        instance_variable_get(var_name_history)
      end
      define_method("#{name}=".to_sym) do |value|
        # можно ли более лаконично назначать дефолтное значение instance_variable?
        # instance_variable_set(var_name_history, []) if instance_variable_get(var_name_history).nil?

        instance_variable_set(var_name, value)
        instance_variable_get(var_name_history).push(value)

      rescue NoMethodError
        instance_variable_set(var_name_history, [])
      end
    end
  end

  def strong_attr_accessor(name, class_value)
    var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=".to_sym) do |value|
        raise TypeError, 'Не совпадает тип значения!'  unless value.is_a?(class_value)
        instance_variable_set(var_name, value)
    end
  end
end

class Misha
  extend MyAttrAccessor

  attr_accessor_with_history :namexx
  strong_attr_accessor(:gg, Integer)
end
