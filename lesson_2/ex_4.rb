#4

# letters = ('а'..'я').to_a   # не знает про ё
letters = "абвгдеёжзиклмнопрстуфхцчшщъыьэюя".chars

string_of_letters = letters.join
indexed_vowes = Hash.new

letters.each do |l|
  vow_index = l =~ /[аеёиоуэыэюя]/
  if vow_index != nil
    val = string_of_letters =~ /[#{l}]/
  end
  indexed_vowes[l] = val+1 if val != nil  # +1 для соответствия требованиям задания
end

puts indexed_vowes