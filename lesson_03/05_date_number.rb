#!/usr/bin/ruby -w
# coding: utf-8
require 'date'

print 'Ввведите дату в формате 2019.1.24: '
year, month, day = gets.chomp.split(/[\s.,]/).map(&:to_i)

months = [0]
for i in 1..12
  months << Date.civil(2019, i, -1).day
end

months[month] = day

if year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
  puts "Опа! Оказывается #{year} високосный год!"
  months[2] = 29
else
  months[2] = 28
end

day_num = months[0..month].inject(0, :+)

puts "#{year}.#{month}.#{day} это #{day_num} день в году."
