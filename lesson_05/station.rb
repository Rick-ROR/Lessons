#!/usr/bin/ruby -w
# coding: utf-8

class Station
  attr_reader :name

  def initialize(name)
    @name = name
    @freight_trains = {}
    @passenger_trains = {}
  end

# поезд прибывает на станцию
  def arrival_train(train)
    if train.type == :freight
      @freight_trains[train.number] = train
    else
      @passenger_trains[train.number] = train
    end
  end

# поезд отбывает со станции
  def departure_trains(train)
    if train.type == :freight
      @freight_trains.delete(train.number)
    else
      @passenger_trains.delete(train.number)
    end
  end

# показывает сколько поездов по типам и список для каждого
  def show_trains_by_types
    puts "Всего поездов на станции:"
    puts "#{@freight_trains.keys.size} Грузовых: #{@freight_trains.keys.join(", ")}"
    puts "#{@passenger_trains.keys.size} Пассажирских: #{@passenger_trains.keys.join(", ")}"
  end

# список поездов без разделения по типу
  def show_trains_all
    trains = @freight_trains.merge(@passenger_trains)
    puts "Всего поездов на станции: #{trains.keys.size}"
    puts "#{trains.keys.join(", ")}"
  end
end
