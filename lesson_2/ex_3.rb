#3

numbers = [0,1]
number = numbers[-1]

# числа до 100 включительно
while number <= 100
  numbers.push(number)
  number = number + numbers[-2]
end

puts numbers