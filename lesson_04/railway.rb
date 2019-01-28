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

class Route
  attr_reader :route_hsh

  def initialize(first, last)
    @route_hsh = {first.name => first, last.name => last}
  end

  # возвращает список станций hash-ем,
  # можно было задать attr_reader :route, чтобы получать hash,
  # но писать потом в коде других классов route.route как-то не очень
  def to_hash
    @route_hsh
  end

  # можно добавить станцию указав её номер на маршруте
  def add_station(station, number)
    # если такая станцию уже есть
    if @route_hsh[station.name]
      puts "Станция #{station.name} уже находится на этом маршруте!"
      return
    end

    # нельзя переписать начальную станцию и конечную
    if number == 0
      puts "Начальную станцию нельзя изменить!"
      return
    elsif number >= @route_hsh.keys.size
      puts "Конечную станцию нельзя изменить!"
      return
    end

    # переписываем маршрут с учётом новой станции
    # возможно можно сделать красивее или есть что-то типа insert для хеша
    name_stations = @route_hsh.keys.insert(number, station.name)
    new_route = {}
    name_stations.each do |name_station|
      new_route[name_station] = @route_hsh[name_station]
    end
    new_route[station.name] = station
    @route_hsh = new_route
  end

  # удаляем станцию из маршрута
  def del_station(station)
    # получаем начальную и конечную станции
    route_ends = @route_hsh.keys.values_at(0,-1)
    # проверяем что станция есть на маршруте и что она не начальная или конечная
    if !@route_hsh.key?(station.name)
      puts "Станция #{station.name} не существует на данном маршруте!"
    elsif route_ends.include?(station.name)
      puts "Это начальная или конечная станция маршрута, их нельзя изменять!"
    else
      @route_hsh.delete(station.name)
      puts "Станция #{station.name} удалена с данного маршрута."
    end
  end

  # выводит список станций на маршруте с нумерацией
  def print_stations
    puts "Данный маршрут состоит из следующих станций:"
    @route_hsh.keys.each_with_index {|station, index| print "= #{index}# #{station} = "}
    puts
  end
end

class Train
  attr_reader :number, :type, :wagons, :speed, :current_station

  def initialize(number, type, wagons)
    @number = number
    @wagons = wagons
    @speed = 0
    @route = nil
    @current_station = nil
    # устаналиваем тип поезда
    if type.include?('груз')
      @type = :freight
    else
      @type = :passenger
    end
  end

# ускрояем поезд на +10
  def speed_up
    (puts 'Сначала нужно задать маршрут'; return) unless :current_station
    @speed += 10
    puts "Внимание! Поезд #{@number} увеличивает скорость."
  end

# останаливаем поезд
  def speed_stop
    puts "Внимание! Поезд #{@number} останаливается."
    @speed = 0
  end

# добавляем один вагон
  def add_wagon
    # останваливаем поезд прежде чем отсоединить вагон
    self.speed_stop if @speed > 0
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
    self.speed_stop if @speed > 0
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
    # если stations.size это конечная станция и ехать больше некуда
    if index + 1 == stations.size
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
    # если 0 это начальная станция и ехать больше некуда
    if index == 0
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
