#!/usr/bin/ruby -w
# coding: utf-8

print "Ввведите стороны треугольника A B C через пробел: "
abc = gets.chomp.split(" ")

a, b, c = abc.map!{ |x| x.to_i }.sort!

if a**2 + b**2 == c**2
    puts 'Этот треугольник прямоугольный.'
elsif a == b && b == c
    puts 'Шок! Этот треугольник равнобедренный!'
else
    puts 'Этот треугольник нам не подходит.'
end
