#!/usr/bin/ruby -w
# coding: utf-8
require 'date'


# Сделать хеш, содеращий месяцы и количество дней в месяце. В цикле выводить те месяцы, у которых количество дней ровно 30
months = Hash.new

Date::MONTHNAMES.each_with_index do |month, i|
  next if month.nil?
  months[month] = Date.civil(2019, i, -1).day
end

for month in months
  puts month[0] if month[1] == 30
end


# Заполнить массив числами от 10 до 100 с шагом 5
array = (10...100).step(5).to_a
print "#{array}\n"


# Заполнить массив числами фибоначчи до 100
# PS не стал выводить в метод, тк задача этого не требует
fibonacci = []
new, old = 1, 0
while old < 100
  fibonacci << old
  new, old = new + old, new
end

print "#{fibonacci}\n"


# Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1).
vowels = Hash.new

('a'..'z').each.with_index(1) do |letter, i|
  vowels[letter] = i if letter =~ /[aeiou]/i
end

print "#{vowels}\n"
