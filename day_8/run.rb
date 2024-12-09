file_path = '/day_8/input.txt'
dir = File.expand_path(File.dirname(File.dirname(__FILE__)))
grid = []
antenna_positions = {}
p1_antinode_positions = Set.new
p2_antinode_positions = Set.new
antenna_pairings = []

File.foreach([dir, file_path].join) do |line|
  grid << line.chomp("\n").split("")
end

# get positions of each antenna
puts "inspecting grid for antennas..."
grid.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    next if cell == "."

    antenna_positions[cell] ||= []
    antenna_positions[cell] << [i, j]
  end
end

# get coordinates of each pairing of antennas
puts "getting antenna pairings..."
antenna_positions.each do |antenna, positions|
  puts "antenna: #{antenna}"
  next if positions.size < 2

  antenna_pairings += positions.combination(2).to_a
end

def valid_coordinates?(grid, x, y)
  x >= 0 && y >= 0 && x < grid.size && y < grid[0].size
end

puts "inspecting pairings for antinode positions..."
antenna_pairings.each do |pairing|
  position1, position2 = pairing
  x_diff = position1[0] - position2[0]
  y_diff = position1[1] - position2[1]
  antinode_position1 = [position1[0] + x_diff, position1[1] + y_diff]
  antinode_position2 = [position2[0] - x_diff, position2[1] - y_diff]
  p1_antinode_positions.add(antinode_position1) if valid_coordinates?(grid, *antinode_position1)
  p1_antinode_positions.add(antinode_position2) if valid_coordinates?(grid, *antinode_position2)

  [position1, position2].each_with_index do |position, i|
    current_position = position
    x_diff = -x_diff if i == 1
    y_diff = -y_diff if i == 1

    while valid_coordinates?(grid, *current_position)
      p2_antinode_positions.add(current_position)
      current_position = [current_position[0] + x_diff, current_position[1] + y_diff]
    end
  end
end

puts "unique p1 antinode positions: #{p1_antinode_positions.size}"
puts "unique p2 antinode positions: #{p2_antinode_positions.size}"