file_path = '/day_10/input.txt'
dir = File.expand_path(File.dirname(File.dirname(__FILE__)))
grid = []

File.foreach([dir, file_path].join) do |line|
  grid << line.chomp("\n").split("").map(&:to_i)
end

def invalid_coordinates?(grid, x, y)
  x < 0 || y < 0 || x >= grid.size || y >= grid[0].size
end

def num_trails(grid, x, y, peaks = Set.new, distinct_paths = 0)
  return [peaks, distinct_paths] if invalid_coordinates?(grid, x, y)

  # at top elevation, trail found
  current_elevation = grid[x][y]
  if current_elevation == 9
    peaks.add([x, y])
    return [peaks, distinct_paths + 1]
  end

  next_positions = [
    [x + 1, y],
    [x - 1, y],
    [x, y + 1],
    [x, y - 1],
  ]

  possible_trails = next_positions.select do |next_position|
    !invalid_coordinates?(grid, *next_position) && grid[next_position[0]][next_position[1]] == current_elevation + 1
  end

  distinct_paths = possible_trails.sum { |position| _, path_count = num_trails(grid, *position, peaks, distinct_paths); path_count }
  return [peaks, distinct_paths]
end

num_peaks = 0
num_paths = 0
grid.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    next unless cell == 0

    peaks, distinct_paths = num_trails(grid, i, j)
    puts "found #{peaks.size} peaks, #{distinct_paths} paths at #{i}, #{j}"
    num_peaks += peaks.size
    num_paths += distinct_paths
  end
end

puts "num trail peaks: #{num_peaks}"
puts "num trail paths: #{num_paths}"
