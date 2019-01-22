#!/usr/bin/ruby -w
# coding: utf-8

print "Ваше имя: "
name = gets.chomp

print "Каков ваш рост: "
height = gets.chomp.to_i

optimal_weight = height - 110

if optimal_weight.positive?
	puts "#{name}, твой оптимальный вес #{optimal_weight}."
else
	puts "#{name}, ты уже имеешь оптимальный вес!"
end
