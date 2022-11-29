#5

months = [31,28,31,30,31,30,31,31,30,31,30,31]
puts "Введите дату в формате ДД.ММ.ГГГГ:"
date = gets.chomp

if date.length != 10 # отслеживание ввода даты неверного формата
  puts "Ошибка ввода - неверный формат даты!"
else
  string_of_numeric = (0..9).to_a.join
  wrong_user_input = false
  nums = date.gsub(".","").chars
  nums.each do |num| 
    num_index = num.to_s =~ /[#{string_of_numeric}]/
    if num_index == nil # отслеживание ---
      puts "Ошибка ввода - неверный формат даты!"
      wrong_user_input = true
      break
    end
  end
  if wrong_user_input == false
    dates = date.split(".")
    if dates[1].to_i > 12  # отслеживание ---
      puts "Ошибка ввода - в году не может быть более 12 месяцев!"
    else
      days = months[dates[1].to_i-1]
      if dates[0].to_i > days.to_i  # отслеживание ---
        puts "Ошибка ввода - в этом месяце всего #{days.to_s} дней!"
      else

        # високосность
        if dates[2].to_i % 4 > 0
        else
          if dates[2].to_i % 100 > 0
            months[1] = 29
          else
            if dates[2].to_i % 400 > 0
            else
              months[1] = 29
            end
          end
        end

        # если месяц не первый, то к дню года прибавляются все дни прошедших месяцев
        day_of_year = 0
        dates[1].to_i.times do |i|
          break if dates[1].to_i == i+1
          day_of_year += months[i]
        end

        # и день текущего месяца
        day_of_year += dates[0].to_i 
        puts "Это #{day_of_year} день года"
      end
    end
  end
end
