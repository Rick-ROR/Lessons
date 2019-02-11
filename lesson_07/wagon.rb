#!/usr/bin/ruby -w
# coding: utf-8

class Wagon
  include NameCompany
  attr_reader :type

  def initialize(type)
    # устаналиваем тип вагона
    if type.include?('cargo')
      @type = :cargo
    else
      @type = :passenger
    end
  end
end

class CargoWagon < Wagon
  def initialize
    super('cargo')
  end
end

class PassengerWagon < Wagon
  def initialize
    super('passenger')
  end
end
