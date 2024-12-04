file_path = '/day_4/input.txt'
dir = File.expand_path(File.dirname(File.dirname(__FILE__)))
grid = []

File.foreach([dir, file_path].join) do |line|
  grid << line.chomp("\n").split("")
end

def valid_space?(grid, x, y)
  x + 2 < grid.size && y + 2 < grid[0].size
end

def find_xmas(grid, x, y)
  valid_starting_points = %w[M S]
  # Check if the starting point is valid, has to be an M or S
  return false unless valid_starting_points.include?(grid[x][y])

  # Make sure we have enough space to form the words, need at least 2 spaces from starting x and y
  return false unless valid_space?(grid, x, y)

  cross_word1 = [grid[x][y], grid[x+1][y+1], grid[x+2][y+2]].join
  cross_word2 = [grid[x+2][y], grid[x+1][y+1], grid[x][y+2]].join

  valid_words = %w[SAM MAS]
  [cross_word1, cross_word2].all? { |word| valid_words.include?(word) }
end

def search_for_xmas(grid)
  occurrences = 0
  m = grid.size
  n = grid[0].size

  (0..(m - 1)).each do |x|
    (0..(n - 1)).each do |y|
      occurrences += 1 if find_xmas(grid, x, y)
    end
  end
  occurrences
end

puts "XMAS occurrences: #{search_for_xmas(grid)}"
