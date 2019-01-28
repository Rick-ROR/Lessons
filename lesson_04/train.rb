#!/usr/bin/ruby -w
# coding: utf-8

class Train
  attr_reader :number, :type, :wagons, :speed, :current_station

  def initialize(number, type, wagons)
    @number = number
    @wagons = wagons
    @speed = 0
    # устаналиваем тип поезда
    if type.include?('груз')
      @type = :freight
    else
      @type = :passenger
    end
  end

# ускрояем поезд на +10
  def speed_up
    unless :current_station
      puts 'Сначала нужно задать маршрут!'
      return
    end
    @speed += 10
    puts "Внимание! Поезд #{@number} увеличивает скорость."
  end

# вовзращает true если 0
  def stopped?
    @speed == 0
  end

# останаливаем поезд
  def speed_stop
    puts "Внимание! Поезд #{@number} останаливается."
    @speed = 0
  end

# добавляем один вагон
  def add_wagon
    # останваливаем поезд прежде чем отсоединить вагон
    self.speed_stop unless stopped?
    @wagons += 1
    puts "Поезд #{@number} присоединил вагон и может продолжить движение."
  end

# отсоединяем один вагон
  def del_wagon
    # если вагонов уже нет, выводим сообщение и выходим
    if @wagons == 0
      puts "Нет присоединённых вагонов к поезду #{@name}."
      return
    end
    # останваливаем поезд прежде чем отсоединить вагон
    self.speed_stop unless stopped?
    @wagons -= 1
    puts "Поезд #{@number} отсоединил вагон и может продолжить движение."
  end

# передаём поезду маршрут
  def set_route(route)
    # поидее надо проверять, что route это объект класса Route
    @route = route
    puts "Новый маршрут установлен."
    # ставим поезд на начальную станцию маршрута и устаналиваем @current_station
    route_hsh = route.route_hsh
    @current_station = route_hsh.keys.first
    puts "Поезд находится на станции #{@current_station}"
  end

# отправляем поезд на следующую станцию
  def next
    route_hsh = @route.route_hsh
    stations = route_hsh.keys
    index = stations.index(@current_station)
    # если @current_station это конечная станция, то ехать больше некуда
    if @current_station == stations.last
      puts "Cтанция #{@current_station} является конечной в маршруте."
      return
    end
    #отправляем поезд из станции departure_trains
    route_hsh[@current_station].departure_trains(self)
    puts "Поезд отправляется со станции #{@current_station}.."
    #принимаем поезд на станции arrival_train и устанавливаем новую текущую @current_station
    @current_station = stations[index+1]
    route_hsh[@current_station].arrival_train(self)
    puts "Поезд прибыл на станцию #{@current_station}."
  end

# отправляем поезд на предыдущую станцию
  def prev
    route = @route.route_hsh
    stations = route.keys
    index = stations.index(@current_station)
    # если @current_station это начальная станция, то ехать больше некуда
    if @current_station == stations.first
      puts "Cтанция #{@current_station} является начальной в маршруте."
      return
    end
    #отправляем поезд из станции departure_trains
    puts "Поезд отправляется со станции #{@current_station}.."
    route[@current_station].departure_trains(self)
    #принимаем поезд на станции arrival_train и устанавливаем новую текущую @current_station
    @current_station = stations[index - 1]
    route[@current_station].arrival_train(self)
    puts "Поезд прибыл на станцию #{@current_station}."
  end

# показывем следующую станцию
  def next_show
    stations = @route.route_hsh.keys
    index = stations.index(@current_station)
    if index + 1 == stations.size
      puts "Текущая станция #{@current_station} является конечной в маршруте."
      return
    end
    puts "Следующая станция #{stations[index + 1]}."
  end

# показывем прошлую станцию
  def prev_show
    stations = @route.route_hsh.keys
    index = stations.index(@current_station)
    if index == 0
      puts "Текущая станция #{@current_station} является начальной в маршруте."
      return
    end
    puts "Предыдущая станция была #{stations[index - 1]}."
  end

end
