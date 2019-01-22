#!/usr/bin/ruby -w
# coding: utf-8

print "Введите основание треугольника: "
a = gets.chomp.to_i

print "Введите высоту треугольника: "
h = gets.chomp.to_i

area = 1 / 2.0 * a * h
puts "Площадь данного треугольника равна #{area}."
