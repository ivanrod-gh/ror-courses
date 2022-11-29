#Квадратное уравнение

puts "Дано квадратное уравнение формата a*x^2 + b*x + c = 0"

puts "Введите коэффициент квадратного уравнения a:"
coefficient_a = gets.to_f
puts "Введите коэффициент квадратного уравнения b:"
coefficient_b = gets.to_f
puts "Введите коэффициент квадратного уравнения c:"
coefficient_c = gets.to_f

discriminant = coefficient_b**2 - coefficient_a * coefficient_c * 4

if discriminant < 0
  puts "У квадратного уравнения нет корней"
else
  if discriminant == 0
    x1 = -coefficient_b / (coefficient_a * 2)
    puts "У квадратного уравнения оба корня равны #{x1}"
  else
    x1 = (-coefficient_b + discriminant**0.5) / 2 * coefficient_a
    x2 = (-coefficient_b - discriminant**0.5) / 2 * coefficient_a
    puts "У квадратного уравнения корни равны: #{x1} и #{x2}"
  end
end