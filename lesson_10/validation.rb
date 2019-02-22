#!/usr/bin/ruby -w

module Validate
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    @@validations = []


    def validations
      @@validations
    end

    def validations=(value)
      @@validations.push(value)
    end

    def validate(class_name, name, type, arg = nil)
      self.validations = { class_name: class_name, name: name, type: type, arg: arg }
    end
  end

  module InstanceMethods
    REGEX = /^[a-zа-я0-9-]+$/i.freeze

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    protected

    def valid_presence(value, drop)
      raise 'Значение не может быть пустым!' if value.nil? || value == ''
    end

    def valid_format(value, regex)
      regex = REGEX if regex.nil?
      raise "Значение #{value} имеет неверный формат! Допустимый формат: #{regex.to_s}"  if value !~ regex
    end

    def valid_type(value, type)
      raise 'Значение имеет неверный тип!' unless value.is_a?(type)
    end

    def validate!
      self.class.validations.each do |validation|
        next if self.class.superclass.name != validation[:class_name]
        method = "valid_#{validation[:type]}".to_sym
        value = instance_variable_get("@#{validation[:name]}".to_sym)
        send(method, value, validation[:arg])
      end
    end
  end
end
