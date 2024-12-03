file_path = '/day_3/input.txt'
dir = File.expand_path(File.dirname(File.dirname(__FILE__)))
input = File.read([dir, file_path].join)
puts input.class
multis = input.scan(/(do\(\)|don't\(\))|mul\((\d{1,3}),(\d{1,3})\)/)

sum = 0
enabled = true

multis.each do |multi|
  instruct = multi[0]
  val1 = multi[1].to_i
  val2 = multi[2].to_i

  if instruct.nil?
    sum += (val1 * val2) if enabled
  else
    enabled = instruct == "do()"
  end
end

puts "Sum: #{sum}"
