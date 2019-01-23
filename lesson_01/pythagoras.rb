#!/usr/bin/ruby -w
# coding: utf-8

print 'Ввведите стороны треугольника A B C через пробел: '
abc = gets.chomp.split(" ")

a, b, c = abc.map!{ |x| x.to_f }.sort!

if a**2 + b**2 == c**2
  puts 'Этот треугольник прямоугольный.'
  puts 'Он у нас ещё и равнобедренный!' if a == b
elsif a == b && b == c
  puts 'Шок! Этот треугольник равносторонний!'
else
  puts 'Этот треугольник нам не подходит.'
end
