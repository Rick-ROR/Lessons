#!/usr/bin/ruby -w
# coding: utf-8
#
# класс Маршрутов
class Route
  include InstanceCounter
  include Validate

  attr_reader :route_hsh

  def initialize(first, last)
    @route_hsh = {first.name => first, last.name => last}
    validate!
    register_instance
  end

  # можно добавить станцию указав её номер на маршруте
  def add_station(station, number)
    # если такая станцию уже есть
    if @route_hsh[station.name]
      puts "Станция #{station.name} уже находится на этом маршруте!"
      return
    end

    # нельзя переписать начальную станцию и конечную
    if number.zero?
      puts 'Начальную станцию нельзя изменить!'
      return
    elsif number >= @route_hsh.keys.size
      puts 'Конечную станцию нельзя изменить!'
      return
    end

    # переписываем маршрут с учётом новой станции
    name_stations = @route_hsh.keys.insert(number, station.name)
    new_route = {}
    name_stations.each do |name_station|
      new_route[name_station] = @route_hsh[name_station]
    end
    new_route[station.name] = station
    @route_hsh = new_route
    puts "Маршрут обновлён. Станция #{station.name} добавлена."
  end

  # удаляем станцию из маршрута
  def del_station(station)
    # получаем начальную и конечную станции
    route_ends = @route_hsh.keys.values_at(0,-1)
    # проверяем что станция есть на маршруте и что она не начальная или конечная
    if !@route_hsh.key?(station.name)
      puts "Станция #{station.name} не существует на данном маршруте!"
    elsif route_ends.include?(station.name)
      puts 'Это начальная или конечная станция маршрута, их нельзя изменять!'
    else
      @route_hsh.delete(station.name)
      puts "Станция #{station.name} удалена с данного маршрута."
    end
  end

  # выводит список станций на маршруте с нумерацией
  def print_stations
    puts 'Данный маршрут состоит из следующих станций:'
    @route_hsh.keys.each_with_index { |station, index| print "= #{index}# #{station} = " }
    puts
  end

  protected

  def validate!
    station = route_hsh.values
    station.each do |station|
      unless station.is_a?(Station)
        raise 'Для создании маршрута используются только станции!'
      end
    end

    if station.first.name == station.last.name
      raise 'Конечные станции на маршруте не могут совпадать!'
    end
  end

end
