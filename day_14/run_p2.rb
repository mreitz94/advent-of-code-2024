file_path = '/day_14/input.txt'
dir = File.expand_path(File.dirname(File.dirname(__FILE__)))

class Robot
  attr_accessor :position, :velocity, :width, :height

  def initialize(position:, velocity:, width:, height:)
    @position = position
    @velocity = velocity
    @width = width
    @height = height
  end

  def move
    # puts "moving robot.. current position #{position}"
    position[0] += velocity[0]
    position[1] += velocity[1]

    # puts "new position: #{position} before teleport"
    position[0] = width + position[0] if position[0] < 0
    position[0] = position[0] - width if position[0] >= width
    position[1] = height + position[1] if position[1] < 0
    position[1] = position[1] - height if position[1] >= height
    # puts "new position: #{position} after teleport"
  end


end

robots = []
File.foreach([dir, file_path].join) do |line|
  px, py, vx, vy = line.scan(/-?\d+/).map(&:to_i)
  robots << Robot.new(position: [px, py], velocity: [vx, vy], width: 101, height: 103)
end

def longest_line_and_formation(robots)
  width = 101
  height = 103
  formation = Array.new(height) { Array.new(width, ".") }

  robots.each do |robot|
    x, y = robot.position
    formation[y][x] = "#"
  end

  longest_line = 0
  current_line = 0
  formation.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      if cell == "#"
        current_line += 1
      else
        if current_line > longest_line
          longest_line = current_line
        end
        current_line = 0
      end
    end
  end

  [longest_line, formation.map { |row| row.join("") }.join("\n")]
end

def get_quadrant(position, width, height)
  x, y = position
  return nil if x == (width - 1) / 2 || y == (height - 1) / 2

  if x < width / 2 && y < height / 2
    return 1
  elsif x >= width / 2 && y < height / 2
    return 2
  elsif x < width / 2 && y >= height / 2
    return 3
  else
    return 4
  end
end



10000.times do |i|
  robots.each do |robot|
    robot.move
  end

  line_size, formation = longest_line_and_formation(robots)

  if line_size > 5
    puts "iteration: #{i+1} (#{line_size})"
    puts formation
    puts "-------------"
  end
end
