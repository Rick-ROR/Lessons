#!/usr/bin/ruby -w
# coding: utf-8

module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :count_insts

    def instances
      self.count_insts ||= 0
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.count_insts ||= 0
      self.class.count_insts += 1
    end
  end
end
