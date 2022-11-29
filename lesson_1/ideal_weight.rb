#Идеальный вес

puts "Как вас зовут?"
user_name = gets.chomp
puts "Каков ваш рост (см)?"
user_height = gets.to_i

ideal_weight = (user_height - 110) * 1.15
# отрицательный вес - это рост менее 110 см?

if ideal_weight < 0
  puts "Ваш вес уже оптимальный"
else
  puts format("#{user_name.capitalize}, ваш идеальный вес составляет %0.1f кг", ideal_weight)
end
