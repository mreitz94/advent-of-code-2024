# Open the input.txt file and read its contents
file_path = './input.txt'
numbers1 = []
numbers2 = []

File.foreach(file_path) do |line|
  num1, num2 = line.split.map(&:to_i)
  numbers1 << num1
  numbers2 << num2
end

# Sort the arrays
numbers1.sort!
numbers2.sort!

# Calculate the sum of differences between the arrays
sum_of_differences = numbers1.zip(numbers2).map { |a, b| (a - b).abs }.sum

# Output the sum of differences
puts "Sum of differences: #{sum_of_differences}"

numbers2_occurrences = numbers2.tally
similiarity_score = 0
numbers1.each do |num|
  similiarity_score += num * (numbers2_occurrences[num] || 0)
end

puts "Similiarity score: #{similiarity_score}"