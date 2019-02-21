#!/usr/bin/ruby -w

# модуль валидации номеров и имён
module ValidateOld
  REGEX = /^[a-zа-я0-9]+$/i.freeze

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  protected

  def validate!
    raise 'Должны быть цифры и/или буквы!' unless name.match? REGEX
    raise 'Нужно ввести больше 2 знаков!' if name.length < 3
  end
end
