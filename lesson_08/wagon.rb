#!/usr/bin/ruby -w
# coding: utf-8

class Wagon
  include NameCompany
  attr_reader :allowable_capacity, :current_capacity

  def initialize(allowable_capacity)
    @allowable_capacity = allowable_capacity
    @current_capacity = 0
  end

  def free_capacity
    @allowable_capacity - @current_capacity
  end
end

class CargoWagon < Wagon
  def loading(capacity)
    if @allowable_capacity <= @current_capacity + capacity
      puts "Этот вагон уже полон!"
    else
      @current_capacity += capacity
      puts "Загрузка произошла успешно."
    end
  end
end

class PassengerWagon < Wagon
  def loading
    if @allowable_capacity <= @current_capacity
      puts "Этот вагон уже полон!"
    else
      @current_capacity += 1
      puts "Пассажир занял место в вагоне."
    end
  end
end
