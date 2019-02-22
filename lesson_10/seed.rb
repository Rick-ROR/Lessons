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
puts 'Создаём поезд с неверным номером ..'
w460 = PassengerTrain.new('**')


puts 'Создаём станции ..'
puts 'Создаём станцию .. Москва'
moscow = Station.new('Москва')
puts 'Создаём станцию .. Питер'
spb = Station.new('Питер')
puts 'Создаём станцию .. Тверь'
tver = Station.new('Тверь')
puts "Проверим станцию на валидность .."
puts "tver.valid? #{tver.valid?}"

puts "Создаём станцию с неверным типом nil для имени, проверяем strong_attr_accessor .."
none = Station.new(nil)

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
puts 'Изменяем скорость поезда и  проверяем accessor speed_history'

puts "instance_variables = #{w459.instance_variables}"
puts "speed_history = #{w459.speed_history}"
w459.speed_up
w459.speed_up
w459.speed_up
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
