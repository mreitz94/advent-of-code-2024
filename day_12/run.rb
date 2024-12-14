file_path = '/day_12/input.txt'
dir = File.expand_path(File.dirname(File.dirname(__FILE__)))
grid = []

File.foreach([dir, file_path].join) do |line|
  grid << line.chomp("\n").split("")
end

class Grid
  attr_reader :coordinates

  def initialize(grid)
    @coordinates = grid
  end

  def at(x, y)
    return unless valid_coordinates?(x, y)

    coordinates[x][y]
  end

  def valid_coordinates?(x, y)
    x >= 0 && y >= 0 && x < coordinates.size && y < coordinates[0].size
  end

  def set_coordinate(x, y, value)
    return false unless valid_coordinates?(x, y)

    coordinates[x][y] = value
  end
end

class Region
  attr_reader :coordinates, :grid, :type

  def initialize(grid, type)
    @grid = grid
    @type = type
    @coordinates = []
  end

  def add_coordinate(x, y)
    @coordinates << [x, y]
  end

  def area = coordinates.size

  def perimeter
    coordinates.sum do |coordinate|
      x, y = coordinate

      neighbors = [
        [x + 1, y],
        [x - 1, y],
        [x, y + 1],
        [x, y - 1],
      ]

      like_neighbors = neighbors.count do |neighbor_coordinate|
        grid.at(*neighbor_coordinate) == type
      end

      4 - like_neighbors
    end
  end

  def sides
    coordinates.sum do |coordinate|
      x, y = coordinate

      s = grid.at(x + 1, y)
      n = grid.at(x - 1, y)
      e = grid.at(x, y + 1)
      w = grid.at(x, y - 1)
      se = grid.at(x + 1, y + 1)
      sw = grid.at(x + 1, y - 1)
      ne = grid.at(x - 1, y + 1)
      nw = grid.at(x - 1, y - 1)
      
      interior_corners = [
        [s, e, se],
        [s, w, sw],
        [n, e, ne],
        [n, w, nw],
      ].count { |neighbors| neighbors[0] == type && neighbors[1] == type && neighbors[2] != type }

      exterior_corners = [
        [s, e],
        [s, w],
        [n, e],
        [n, w],
      ].count { |neighbors| neighbors.none? { |neighbor| neighbor == type } }

      interior_corners + exterior_corners
    end
  end
end

visited_grid = Grid.new(Array.new(grid.size) { Array.new(grid[0].size, false) })
grid = Grid.new(grid)

def build_region(grid, visited_grid, i, j, region = nil)
  region ||= Region.new(grid, grid.at(i, j))
  region.add_coordinate(i, j)
  visited_grid.set_coordinate(i, j, true)

  next_positions = [
    [i + 1, j],
    [i - 1, j],
    [i, j + 1],
    [i, j - 1],
  ]

  next_positions.each do |next_position|
    x, y = next_position
    next unless grid.valid_coordinates?(x, y)
    next if visited_grid.at(x, y) || grid.at(x, y) != region.type

    build_region(grid, visited_grid, x, y, region)
  end

  region
end

regions = []

grid.coordinates.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    next if visited_grid.at(i, j)

    regions << build_region(grid, visited_grid, i, j)
  end
end

region_prices = 0
regions.each do |region|
  region_prices += region.area * region.perimeter
end

puts "Total region prices p1: #{region_prices}"

region_prices = 0
regions.each do |region|
  region_prices += region.area * region.sides
end

puts "Total region prices p2: #{region_prices}"