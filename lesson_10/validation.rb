#!/usr/bin/ruby -w

module Validate
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validations

    def validate(name, type, arg = nil)
      @validations ||= []
      @validations << {name: name, type: type, arg: arg}
      # puts "#{@validations}"
    end
  end

  module InstanceMethods
    REGEX = /^[a-zа-я0-9]+$/i.freeze

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
      raise "Значение имеет неверный формат! Допустимый формат: #{regex.to_s}"  if value !~ regex
    end

    def valid_type(value, type)
      raise 'Значение имеет неверный тип!' unless value.is_a?(type)
    end

    def validate!
      # print "#{self.class.validations} \n"
      self.class.validations.each do |validation|
        method = "valid_#{validation[:type]}".to_sym
        value = instance_variable_get("@#{validation[:name]}".to_sym)
        send(method, value, validation[:arg])
      end
    end
  end
end
