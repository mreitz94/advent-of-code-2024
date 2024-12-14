file_path = '/day_13/input.txt'
dir = File.expand_path(File.dirname(File.dirname(__FILE__)))
input = File.read([dir, file_path].join)

total = 0
tolerance = 0.0001

input.split("\n\n").each do |machine|
  ax, ay, bx, by, x, y = machine.scan(/\d+/).map(&:to_i)
  a = (bx * y - by * x).to_f / (bx * ay - by * ax).to_f
  b = (x - ax * a).to_f / bx.to_f

  if (a - a.round).abs < tolerance && (b - b.round).abs < tolerance
    total += a * 3 + b
  end
end

puts "p1 total: #{total.to_i}"

total = 0

input.split("\n\n").each do |machine|
  ax, ay, bx, by, x, y = machine.scan(/\d+/).map(&:to_i)
  x += 10000000000000
  y += 10000000000000
  a = (bx * y - by * x).to_f / (bx * ay - by * ax).to_f
  b = (x - ax * a).to_f / bx.to_f

  if (a - a.round).abs < tolerance && (b - b.round).abs < tolerance
    total += a * 3 + b
  end
end

puts "p2 total: #{total.to_i}"