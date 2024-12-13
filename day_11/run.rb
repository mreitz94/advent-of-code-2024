file_path = '/day_11/input.txt'
dir = File.expand_path(File.dirname(File.dirname(__FILE__)))
input = File.read([dir, file_path].join)
stones = input.split(" ").map(&:to_i)
stones_by_count = Hash.new(0)
stones.each do |stone|
  stones_by_count[stone] += 1
end

def replace(stone, count)
  return [[1, count]] if stone.zero?

  stone_str = stone.to_s
  size = stone_str.size
  if size.even?
    stone1 = stone_str[..(size / 2) - 1].to_i
    stone2 = stone_str[(size / 2)..].to_i
    return [[stone1, count], [stone2, count]]
  end

  return [[stone * 2024, count]]
end

def blink(stones_by_count)
  stones_by_count.each_with_object({}) do |(stone, count), new_stones_by_count|
    new_stone_counts = replace(stone, count)

    new_stone_counts.each do |stone_and_count|
      new_stone, new_count = stone_and_count
      new_stones_by_count[new_stone] ||= 0
      new_stones_by_count[new_stone] += new_count
    end
  end
end

25.times do |i|
  puts "blinking stones #{i + 1} times..."
  stones_by_count = blink(stones_by_count)
end

puts "Total stones after 25 blinks: #{stones_by_count.values.sum}"

50.times do |i|
  puts "blinking stones #{i + 26} times..."
  stones_by_count = blink(stones_by_count)
end

puts "Total stones after 75 blinks: #{stones_by_count.values.sum}"
