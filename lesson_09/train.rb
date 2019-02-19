#!/usr/bin/ruby -w

# класс Поездов
class Train
  include Validate
  include InstanceCounter

  class << self
    attr_accessor :trains

    def find(number)
      self.trains ||= {}
      @trains[number]
    end
  end

  include NameCompany
  attr_reader :number, :speed, :current_station, :wagons

  def initialize(number)
    @number = number.to_s
    validate!
    @wagons = []
    @speed = 0
    @route = nil
    self.class.trains ||= {}
    self.class.trains[number] = self
    register_instance
  end

  # добавляем один вагон
  def add_wagon(wagon)
    # останавливаем поезд прежде чем отсоединить вагон
    speed_stop unless stopped?
    @wagons << wagon
    puts "Поезд #{@number} присоединил вагон и может продолжить движение."
  end

  # отсоединяем один вагон
  def del_wagon
    # если вагонов уже нет, выводим сообщение и выходим
    if @wagons.size.zero?
      puts "Нет присоединённых вагонов к поезду #{@number}."
      return
    end
    # останваливаем поезд прежде чем отсоединить вагон
    speed_stop unless stopped?
    @wagons.delete_at(-1)
    puts "Поезд #{@number} отсоединил вагон и может продолжить движение."
  end

  # передаём поезду маршрут
  def route_set(route)
    # поидее надо проверять, что route это объект класса Route
    @route = route
    puts "#{@number}: Новый маршрут установлен."
    # ставим поезд на начальную станцию маршрута и устаналиваем @current_station
    route_hsh = route.route_hsh
    @current_station = route_hsh.keys.first
    route_hsh[@current_station].arrival_train(self)
    puts "Поезд #{@number} находится на станции #{@current_station}."
  end

  # отправляем поезд на следующую станцию
  def next
    if @route.nil?
      puts 'Сначала нужно задать маршрут!'
      return
    end
    route_hsh = @route.route_hsh
    stations = route_hsh.keys
    index = stations.index(@current_station)
    # если @current_station это конечная станция, то ехать больше некуда
    if @current_station == stations.last
      puts "Cтанция #{@current_station} является конечной в маршруте."
      return
    end
    # отправляем поезд из станции departure_trains
    route_hsh[@current_station].departure_trains(self)
    puts "Поезд #{@number} отправляется со станции #{@current_station}.."
    # принимаем поезд на станции arrival_train и
    # устанавливаем новую текущую @current_station
    @current_station = stations[index + 1]
    route_hsh[@current_station].arrival_train(self)
    puts "Поезд #{@number} прибыл на станцию #{@current_station}."
  end

  # отправляем поезд на предыдущую станцию
  def prev
    if @route.nil?
      puts 'Сначала нужно задать маршрут!'
      return
    end
    route = @route.route_hsh
    stations = route.keys
    index = stations.index(@current_station)
    # если @current_station это начальная станция, то ехать больше некуда
    if @current_station == stations.first
      puts "Cтанция #{@current_station} является начальной в маршруте."
      return
    end
    # отправляем поезд из станции departure_trains
    puts "Поезд #{@number} отправляется со станции #{@current_station}.."
    route[@current_station].departure_trains(self)
    # принимаем поезд на станции arrival_train и
    # устанавливаем новую текущую @current_station
    @current_station = stations[index - 1]
    route[@current_station].arrival_train(self)
    puts "Поезд #{@number} прибыл на станцию #{@current_station}."
  end

  # показывем следующую станцию
  def next_show
    if @route.nil?
      puts 'Сначала нужно задать маршрут!'
      return
    end
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
    if @route.nil?
      puts 'Сначала нужно задать маршрут!'
      return
    end
    stations = @route.route_hsh.keys
    index = stations.index(@current_station)
    if index.zero?
      puts "Текущая станция #{@current_station} является начальной в маршруте."
      return
    end
    puts "Предыдущая станция была #{stations[index - 1]}."
  end

  def each_wagon
    i = 0
    @wagons.each do |wagon|
      i += 1
      yield(wagon, i)
    end
  end

  # так как эти методы не указаны в ТЗ интерфейса и
  # используются только в методах объекта
  protected

  def validate!
    unless number.match?(/^[a-z0-9]{3}-?[a-z0-9]{2}$/i)
      raise 'Формат номера должен соотвествовать шаблону XXX-XX,'\
              'где X число или буква.'
    end
  end

  # возвращает true если 0
  def stopped?
    @speed.zero?
  end

  # ускрояем поезд на +10
  def speed_up
    if :current_station.nil?
      puts 'Сначала нужно задать маршрут!'
      return
    end
    @speed += 10
    puts "Внимание! Поезд #{@number} увеличивает скорость."
  end

  # останаливаем поезд
  def speed_stop
    puts "Внимание! Поезд #{@number} останаливается."
    @speed = 0
  end
end

class PassengerTrain < Train
  def initialize(number)
    super(number)
  end

  # добавляем один вагон
  def add_wagon(wagon)
    unless wagon.is_a?(PassengerWagon)
      puts 'Только пассажирские вагоны можно присоединить к данному составу!'
      return
    end
    super
  end
end

class CargoTrain < Train
  def initialize(number)
    super(number)
  end

  # добавляем один вагон
  def add_wagon(wagon)
    unless wagon.is_a?(CargoWagon)
      puts 'Только грузовые вагоны можно присоединить к данному составу!'
      return
    end
    super
  end
end
