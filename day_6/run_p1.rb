file_path = '/day_6/input.txt'
dir = File.expand_path(File.dirname(File.dirname(__FILE__)))
grid = []

DIRECTION_ORDER = [:up, :right, :down, :left]

DIRECTION_MAP = {
  up: [-1, 0],
  down: [1, 0],
  left: [0, -1],
  right: [0, 1],
}

File.foreach([dir, file_path].join) do |line|
  grid << line.chomp("\n").split("")
end

def invalid_coordinates?(grid, x, y)
  x < 0 || y < 0 || x >= grid.size || y >= grid[0].size
end

def obstacle?(grid, x, y)
  grid[x][y] == "#"
end

def visited?(grid, x, y)
  grid[x][y] == "X"
end

def get_next_position(grid, position, direction)
  [position[0] + DIRECTION_MAP[direction][0], position[1] + DIRECTION_MAP[direction][1]]
end

def turn_right(direction)
  DIRECTION_ORDER[(DIRECTION_ORDER.index(direction) + 1) % DIRECTION_ORDER.size]
end

position = nil
direction = :up
distinct_positions = 1
grid.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    if cell == "^"
      position = [i, j]
      break
    end
  end
end

# returns the new position OR nil if the position is invalid
def move(grid, position, direction)
  next_position = get_next_position(grid, position, direction)
  return if invalid_coordinates?(grid, *next_position)

  if obstacle?(grid, *next_position)
    new_direction = turn_right(direction)
    puts "obstacle at #{next_position}, turning #{new_direction}"
    move(grid, position, new_direction)
  else
    puts "moving to #{next_position}"
    [next_position, direction]
  end
end

while position
  grid[position[0]][position[1]] = "X"
  position, direction = move(grid, position, direction)
  break if position.nil?

  distinct_positions += 1 if !visited?(grid, *position)
end

puts "#{distinct_positions} distinct positions visited"