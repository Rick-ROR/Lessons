#!/usr/bin/ruby -w
# coding: utf-8
require_relative 'name_company'
require_relative 'validate'
require_relative 'counter'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'wagon'
require_relative 'main'

puts "Создаём поезда .."
w455 = CargoTrain.new('455-22')
w459 = PassengerTrain.new('459-55')

puts "Создаём станции .."
moscow = Station.new('Москва')
spb = Station.new('Питер')
tver = Station.new('Тверь')

puts "Создаём маршруты .."
msk_spb = Route.new(moscow, spb)
msk_spb.add_station(tver, 1)

puts "#" * 70
w455.set_route(msk_spb)
w459.set_route(msk_spb)
puts "#" * 70
w459.next

puts "#" * 70
w455.add_wagon(CargoWagon.new(23))
w455.add_wagon(CargoWagon.new(27))

w459.add_wagon(PassengerWagon.new(32))
w459.add_wagon(PassengerWagon.new(16))


msk_spb.route_hsh.values.each do |station|
  puts "#" * 70
  puts "Станция #{station.name}."
  station.show_trains_by_types

  station.each_train do |train|
    if train.is_a?(PassengerTrain)
      puts "Пассажирский поезд #{train.number} содержит #{train.wagons.size} вагона."
    else
      puts "Грузовой поезд #{train.number} содержит #{train.wagons.size} вагона."
    end

    unless train.wagons.size.zero?
      i = 1
      train.each_wagon do |wagon|
        if wagon.is_a?(PassengerWagon)
          puts "Пассажирский вагон №#{i}, занято мест #{wagon.current_capacity} из #{wagon.allowable_capacity}."
        else
          puts "Грузовой вагон №#{i}, занято куб. м #{wagon.current_capacity} из #{wagon.allowable_capacity}."
        end
        i += 1
      end
    else
      puts 'Поезд не содержит вагонов.'
    end

  end

end
