#!/usr/bin/ruby -w
# coding: utf-8
cart = Hash.new

loop do
  print "Введите название товара:\t"
  product = gets.chomp
  break if product =~ /стоп|cnjg|stop|ыещз/

  print "Введите цену товара:\t"
  price = gets.chomp.to_f

  print "Введите количество товара:\t"
  quantity = gets.chomp.to_f

  cart[product] = {:price => price, :quantity => quantity}
  puts "============================================="
end

puts "\nТовары, которые вы добавили:"
printf("%2s | %-15s %6s %5s | %+8s\n", '#', 'название', 'цена', 'штук', 'суммарно')

total = 0
cart.each.with_index(1) do |product, index|
  sum = product[1][:price] * product[1][:quantity]
  printf("%2d | %-15s %6d %5d | %8d\n", index, product[0], product[1][:price], product[1][:quantity], sum)
  total += sum
end

puts "\nИтого за все товары в корзине с вас #{total} у.е."
