#6

purchases = Hash.new

loop do
  puts "Введите название покупки"
  purchase = gets.chomp

  break if purchase == "стоп"

  puts "Введите цену за единицу товара"
  price = gets.to_f
  puts "Введите количество товара"
  quantity = gets.to_f

  purchases[purchase] = {"price" => price, "quantity" => quantity}
end

puts "В корзине:"
overal_price = 0
purchases.each do |name,data|
  # руби 0.7*34 считает как 23.799999999999997. округляю и считаю до сотых
  purchase_full_price = ((data["quantity"]*data["price"]*100).to_i).to_f/100
  overal_price += purchase_full_price
  print "#{name.capitalize}, #{data["quantity"]} шт. по #{data["price"]} у.е. за единицу, всего на #{purchase_full_price} у.е.\n"
end
puts "Всего товаров на #{overal_price} у.е."