#!/usr/bin/ruby -w
# coding: utf-8
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'wagon'

trap 'SIGINT' do
  puts 'Ctrl+C => Exiting'
  exit 130
end

class Railway

  def initialize
    @stations = {}
    @routes = {}
    @trains = {}
  end


  def greeting
    puts "Давайте прокатимся с ветерком!\n\n"
  end

  def main_menu
    text = ['Главное меню:',
    '1 - управление станциями',
    '2 - управление маршрутами',
    '3 - управление поездами',
    '0 - выход']

    while true do
      text.each { |msg| puts msg }
      print "Ваш выбор:\t"
      user = gets.chomp
      next unless number?(user)
      case user.to_i
      when 1 then menu_stations
      when 2 then menu_routes
      when 3 then menu_trains
      when 0 then break
      else puts 'Такого элемента нет в меню!'
      end
    end
  end

  private
  # оставил комментарий https://github.com/Rick-ROR/Lessons_ruby/commit/81a31650d87bfc7b18472a20f9721b49c203fad0#r32172759
  def number?(number)
    if number =~ /^\d+$/
      true
    else
      puts 'Похоже вы ввели не цифру!'
      false
    end
  end

  def menu_stations
    text = ['Меню управления станциями:',
            '1 - создать станцию',
            '2 - список станций',
            '3 - список поездов на станции',
            '0 - назад в главное меню']

    while true do
      text.each { |msg| puts msg }
      print "Ваш выбор:\t"
      user = gets.chomp
      next unless number?(user)
      case user.to_i
      when 1 then menu_station_new
      when 2 then menu_station_list
      when 3 then menu_station_trains_list
      when 0 then break
      else puts 'Такого элемента нет в меню!'
      end
    end
  end

  def menu_routes
    text = ['Меню управления маршрутами:',
            '1 - создать маршрут',
            '2 - добавить станцию в маршрут',
            '3 - удалить станцию в маршрут',
            '4 - просмотреть список станций на маршруте',
            '0 - назад в главное меню']

    while true do
      text.each { |msg| puts msg }
      print "Ваш выбор:\t"
      user = gets.chomp
      next unless number?(user)
      case user.to_i
      when 1 then menu_route_new
      when 2 then menu_route_add_station
      when 3 then menu_route_del_station
      when 4 then menu_route_show_stations
      when 0 then break
      else puts 'Такого элемента нет в меню!'
      end
    end
  end

  def menu_trains
    text = ['Меню управления поездами:',
            '1 - создать поезд',
            '2 - присоединить вагон',
            '3 - отцепить вагон',
            '4 - назначить маршрут',
            '5 - следующая станция',
            '6 - прошлая станция',
            '0 - назад в главное меню']

    while true do
      text.each { |msg| puts msg }
      print "Ваш выбор:\t"
      user = gets.chomp
      next unless number?(user)
      case user.to_i
      when 1 then menu_train_new
      when 2 then menu_train_add_wagon
      when 3 then menu_train_del_wagon
      when 4 then menu_train_set_route
      when 5 then menu_train_set_next
      when 6 then menu_train_set_prev
      when 0 then break
      else puts 'Такого элемента нет в меню!'
      end
    end
  end

  def hash_select(hash)
    keys = hash.keys
    if keys.size.zero?
      puts "Похоже этот список пуст!\t"
      return
    end
    keys.each_with_index {|key, index| print "= #{index}# #{key} = "}
    print "\nВыберите нужный элемент из списка:\t"
    user_choice = gets.to_i

    if (0..keys.size-1).include?(user_choice)
      hash[keys[user_choice]]
    else
      puts 'Данный элемент отсустувет в списке!'
    end
  end

# ================================= методы-меню для станций =========================
  def menu_station_new
    print "Ввведите название станции:\t"
    name = gets.chomp
    if @stations[name]
      puts "Станция #{name} уже существует!"
      return
    end
    @stations[name] = Station.new(name)
    puts  "Станция #{name} создана."
  end

  def menu_station_list
    if @stations.nil?
      puts "Список пуст."
    else
      @stations.keys.each_with_index {|key, index| print "= #{index}# #{key} = "}
      puts
    end
  end

  def menu_station_trains_list
    puts 'Выберите станцию:'
    station = hash_select(@stations)
    return unless station
    station.show_trains_by_types
  end

# ================================= методы-меню для маршрутов =========================
  def menu_route_new
    print "Ввведите название маршрута:\t"
    name = gets.chomp
    if @routes[name]
      puts "Маршрут #{name} уже существует!"
      return
    end
    puts 'Выберите первую станцию:'
    first = hash_select(@stations)
    return if first.nil?
    puts 'Выберите последнюю станцию:'
    last = hash_select(@stations)
    return if last.nil?

    if first.name == last.name
      puts "Конечные станции на маршрует не могут совпадать!"
      return
    end

    @routes[name] = Route.new(first, last)
    puts "Маршрут #{name} создан."
  end

  def menu_route_add_station
    puts 'Выберите маршрут для изменния:'
    route = hash_select(@routes)
    return if route.nil?
    puts 'Выберите станцию для добавления в маршрут:'
    station = hash_select(@stations)
    return if station.nil?

    route.print_stations
    puts "Конечные станции на маршруте нельзя изменять!"
    print "Ввведите номер для новой станции на маршруте:\t"
    number = gets.to_i
    route.add_station(station, number)
  end

  def menu_route_del_station
    route = hash_select(@routes)
    return if route.nil?

    route.print_stations
    print "Ввведите номер станции для удаления:\t"
    number = gets.to_i
    name = route.route_hsh.keys[number]
    station = route.route_hsh[name]
    route.del_station(station)
  end

  def menu_route_show_stations
    route = hash_select(@routes)
    return if route.nil?

    route.print_stations
  end

# ================================= методы-меню для поездов =========================
  def menu_train_new
    print "Ввведите номер поезда:\t"
    number = gets.chomp
    if @trains[number]
      puts "Поезд #{number} уже существует!"
      return
    end
    print "Ввведите тип поезда грузовой или пассажирский - 0 или 1:\t"
    type = gets.to_i
    if type.zero?
      @trains[number] = CargoTrain.new(number)
      puts "Грузовой поезд с номером #{number} создан."
    else
      @trains[number] = PassengerTrain.new(number)
      puts "Пассажирский поезд с номером #{number} создан."
    end
  end

  def menu_train_add_wagon
    train = hash_select(@trains)
    return if train.nil?
    if train.type == :passenger
      train.add_wagon(PassengerWagon.new)
    else
      train.add_wagon(CargoWagon.new)
    end
  end

  def menu_train_del_wagon
    train = hash_select(@trains)
    return if train.nil?
    train.del_wagon
  end

  def menu_train_set_route
    train = hash_select(@trains)
    return if train.nil?
    puts 'Выберите маршрут:'
    route = hash_select(@routes)
    return if route.nil?
    train.set_route(route)
  end

  def menu_train_set_next
    train = hash_select(@trains)
    return if train.nil?
    train.next
  end

  def menu_train_set_prev
    train = hash_select(@trains)
    return if train.nil?
    train.prev
  end

end

railway = Railway.new

railway.greeting

railway.main_menu
