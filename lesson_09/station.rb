#!/usr/bin/ruby -w

# класс Станций
class Station
  include Validate
  include InstanceCounter

  class << self
    attr_accessor :stations

    def all
      @stations
    end
  end

  attr_reader :name

  def initialize(name)
    @name = name.to_s
    validate!
    @cargo_trains = {}
    @passenger_trains = {}
    self.class.stations ||= {}
    # https://github.com/Rick-ROR/Lessons_ruby/commit/9e9bf254bb0999cfa541b82341a3e934ea60b12a#r32230331
    self.class.stations[name] = self
    register_instance
  end

  # поезд прибывает на станцию
  def arrival_train(train)
    if train.is_a?(CargoTrain)
      @cargo_trains[train.number] = train
    else
      @passenger_trains[train.number] = train
    end
  end

  # поезд отбывает со станции
  def departure_trains(train)
    if train.is_a?(CargoTrain)
      @cargo_trains.delete(train.number)
    else
      @passenger_trains.delete(train.number)
    end
  end

  # показывает сколько поездов по типам и список для каждого
  def show_trains_by_types
    puts 'Всего поездов на станции:'
    puts "#{@cargo_trains.keys.size} "\
            "Грузовых: #{@cargo_trains.keys.join(', ')}"
    puts "#{@passenger_trains.keys.size} "\
            "Пассажирских: #{@passenger_trains.keys.join(', ')}"
  end

  # список поездов без разделения по типу
  def show_trains_all
    trains = @cargo_trains.merge(@passenger_trains)
    puts "Всего поездов на станции: #{trains.keys.size}"
    puts trains.keys.join(', ')
  end

  def each_train
    all_trains = @passenger_trains.merge(@cargo_trains)
    all_trains.values.each { |train| yield(train) }
  end
end
