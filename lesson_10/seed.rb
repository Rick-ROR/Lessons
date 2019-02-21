#!/usr/bin/ruby -w

require_relative 'name_company'
require_relative 'validation'
require_relative 'accessor'
require_relative 'counter'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'wagon'
require_relative 'main'

puts 'Создаём поезда ..'
w455 = CargoTrain.new('455-22')
w459 = PassengerTrain.new('459-55')

puts 'Создаём станции ..'
moscow = Station.new('Москва')
spb = Station.new('Питер')
tver = Station.new('Тверь')

puts 'Создаём маршруты ..'
msk_spb = Route.new(moscow, spb)
msk_spb.add_station(tver, 1)

puts '#' * 70
w455.route_set(msk_spb)
w459.route_set(msk_spb)
puts '#' * 70
w459.next

puts '#' * 70
puts 'Добавляем вагоны ..'
w455.add_wagon(CargoWagon.new(23))
w455.add_wagon(CargoWagon.new(27))

w459.add_wagon(PassengerWagon.new(32))
w459.add_wagon(PassengerWagon.new(16))

puts '#' * 70
puts 'Изменяем скорость поезда и  провеяем accessor speed_history'
puts "#{w459.public_methods}"
puts "#{w459.instance_variables}"
puts "speed_history = #{w459.speed_history}"
w459.speed_up
w459.speed_up
w459.speed_up
puts "#{w459.instance_variables}"
puts "speed_history = #{w459.speed_history}"

msk_spb.route_hsh.values.each do |station|
  puts "#{'#' * 70}\nСтанция #{station.name}."

  station.show_trains_by_types
  station.each_train do |train|
    if train.is_a?(PassengerTrain)
      puts "Пассажирский поезд #{train.number} "\
              "содержит #{train.wagons.size} вагона."
    else
      puts "Грузовой поезд #{train.number} "\
              "содержит #{train.wagons.size} вагона."
    end

    if train.wagons.size.zero?
      puts 'Поезд не содержит вагонов.'
    else
      train.each_wagon do |wagon, index|
        if wagon.is_a?(PassengerWagon)
          puts "Пассажирский вагон №#{index}, занято мест "\
                  "#{wagon.current_capacity} из #{wagon.allowable_capacity}."
        else
          puts "Грузовой вагон №#{index}, занято куб. м "\
                  "#{wagon.current_capacity} из #{wagon.allowable_capacity}."
        end
      end
    end
  end
end
