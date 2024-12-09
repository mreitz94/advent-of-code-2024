file_path = '/day_6/input.txt'
dir = File.expand_path(File.dirname(File.dirname(__FILE__)))
grid_coordinates = []

File.foreach([dir, file_path].join) do |line|
  grid_coordinates << line.chomp("\n").split("")
end

DIRECTION_ORDER = [:up, :right, :down, :left]
DIRECTION_MAP = {
  up: [-1, 0],
  down: [1, 0],
  left: [0, -1],
  right: [0, 1],
}

class Grid
  def initialize(coordinates)
    @coordinates = coordinates
  end

  attr_reader :coordinates

  def invalid_coordinates?(x, y)
    x < 0 || y < 0 || x >= @coordinates.size || y >= @coordinates[0].size
  end

  def obstacle?(x, y)
    @coordinates[x][y] == "#" || @coordinates[x][y] == "O"
  end
end

class GridCursor
  def initialize(grid:, position:, direction:)
    @grid = grid
    @position = position
    @starting_position = position
    @direction = direction
  end

  attr_reader :position

  def turn_right
    @direction = DIRECTION_ORDER[(DIRECTION_ORDER.index(@direction) + 1) % DIRECTION_ORDER.size]
  end

  def get_next_position
    [
      @position[0] + DIRECTION_MAP[@direction][0],
      @position[1] + DIRECTION_MAP[@direction][1]
    ]
  end

  def visited?
    @grid.coordinates[@position[0]][@position[1]] == "X"
  end

  def mark_position
    @grid.coordinates[@position[0]][@position[1]] = "X"
  end

  def move
    next_position = get_next_position
    if @grid.invalid_coordinates?(*next_position)
      @position = nil
      return
    end

    if @grid.obstacle?(*next_position)
      turn_right
      puts "obstacle at #{next_position}, turning #{@direction}"
      move
    else
      puts "moving to #{next_position}"
      @position = next_position
    end
  end

  def stuck_in_loop?
    history = Set.new

    while true
      move
      return false if position.nil?
      position_direction = { position:, direction: @direction }

      return true if history.include?(position_direction)
      history.add(position_direction)
    end

  end
end

cursor = nil
start_pos = nil
grid = Grid.new(grid_coordinates)
grid_coordinates.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    if cell == "^"
      start_pos = [i, j]
      cursor = GridCursor.new(grid:, position: start_pos, direction: :up)
      break
    end
  end
end

distinct_positions = 1
while true
  cursor.mark_position
  position = cursor.move
  break if position.nil?

  distinct_positions += 1 unless cursor.visited?
end

unique_obstacles = 0
grid_coordinates.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    # only check cells that were visited in p1 since these are the
    # only cells that could have obstacles creating an infinite loop
    next unless cell == "X"
    # cannot place obstacle on starting position
    next if [i, j] == start_pos

    new_coordinates = grid_coordinates.map(&:dup)
    new_coordinates[i][j] = "O"
    new_grid = Grid.new(new_coordinates)
    cursor = GridCursor.new(grid: new_grid, position: start_pos, direction: :up)
    unique_obstacles += 1 if cursor.stuck_in_loop?
  end
end

puts "#{distinct_positions} distinct positions visited"
puts "#{unique_obstacles} infinite loops"