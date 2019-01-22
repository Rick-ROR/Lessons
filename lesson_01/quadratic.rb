#!/usr/bin/ruby -w
# coding: utf-8
print 'Ввведите коэффициенты A B C через пробел: '
abc = gets.chomp.split(" ")

a, b, c = abc.map{ |x| x.to_i }

dis = b**2 - 4 * a * c
puts "Дискриминант равен #{dis};"

sqrt_dis = Math.sqrt(dis)

if dis > 0
	x1 = (-b - sqrt_dis) / (2 * a)
	x2 = (-b + sqrt_dis) / (2 * a)
	puts "Дискриминант больше 0, x1 = #{x1}, x2 = #{x2}"
elsif dis == 0
	x =  -b / (2 * a)
	puts "Дискриминант равен 0, x = #{x}"
else
	puts 'Корней нет.'
end
