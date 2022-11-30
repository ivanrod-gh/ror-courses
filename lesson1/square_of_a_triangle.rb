#Площадь треугольника

puts "Введите ширину основания треугольника:"
width = gets.to_f
puts "Введите высоту треугольника:"
height = gets.to_f

square = width * height / 2
if square / square.to_i == 1  # вывод целых чисел без дробной составляющей, если она == 0
  square = square.to_i
end
puts "Площадь треугольника равна #{square}"
