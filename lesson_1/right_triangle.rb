#Прямоугольный треугольник

puts "Введите первую сторону треугольника:"
side_a = gets.to_f
puts "Введите вторую сторону треугольника:"
side_b = gets.to_f
puts "Введите третью сторону треугольника:"
side_c = gets.to_f

triangle_type = ""
if side_a == side_b && side_b == side_c
  triangle_type = "равносторонний равнобедренный"
elsif side_a == side_b || side_a == side_c || side_b == side_c
  triangle_type = "равнобедренный"
end

# в нормальном режиме пользователь не сможет ввести стороны прямоугольного треугольника
# я ограничил точность вычисления десятыми долями

if side_a > side_b && side_a > side_c
  if (side_a**2 * 10).to_i == (side_b**2 + side_c**2) * 10.to_i
    triangle_type = "прямоугольный " + triangle_type
  end
elsif side_b > side_a && side_b > side_c
  if (side_b**2 * 10).to_i == (side_a**2 + side_c**2) * 10.to_i
    triangle_type = "прямоугольный " + triangle_type
  end
else
  if (side_c**2 * 10).to_i == (side_a**2 + side_b**2) * 10.to_i
    triangle_type = "прямоугольный " + triangle_type
  end
end

if triangle_type == ""
  puts "Треугольник не является ни прямоугольным, ни равнобедренным, ни равносторонним"
else
  puts "Это #{triangle_type} треугольник"
end
