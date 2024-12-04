file_path = '/day_4/input.txt'
dir = File.expand_path(File.dirname(File.dirname(__FILE__)))
grid = []

File.foreach([dir, file_path].join) do |line|
  grid << line.chomp("\n").split("")
end

def invalid_coordinates?(grid, x, y)
  x < 0 || y < 0 || x >= grid.size || y >= grid[0].size
end

def find_word(index, word, grid, x, y, x_dir, y_dir)
  return true if index == word.size
  return false if invalid_coordinates?(grid, x, y)
  return find_word(index + 1, word, grid, x + x_dir, y + y_dir, x_dir, y_dir) if grid[x][y] == word[index]

  false
end

def search_for_word(grid, word)
  occurrences = 0
  m = grid.size
  n = grid[0].size
  x_dirs = [-1, 0, 1]
  y_dirs = [-1, 0, 1]

  (0..(m - 1)).each do |x|
    (0..(n - 1)).each do |y|

      x_dirs.each do |x_dir|
        y_dirs.each do |y_dir|
          next if x_dir.zero? && y_dir.zero?

          occurrences += 1 if find_word(0, word, grid, x, y, x_dir, y_dir)
        end
      end
    end
  end
  occurrences
end

puts "XMAS occurrences: #{search_for_word(grid, "XMAS")}"
