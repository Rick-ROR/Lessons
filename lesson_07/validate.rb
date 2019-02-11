#!/usr/bin/ruby -w
# coding: utf-8

module Validate
  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  protected
  def validate!
    raise 'Должны быть цифры и/или буквы!' unless name.match? /^[a-zа-я0-9]+$/i
    raise 'Нужно ввести больше 2 знаков!' if name.length < 3
  end
end
