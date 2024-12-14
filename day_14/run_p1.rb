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

robots.each do |robot|
  100.times do |i|
    robot.move
  end
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

quadrant_counts = {
  1 => 0,
  2 => 0,
  3 => 0,
  4 => 0,
}

robots.each do |robot|
  quadrant = get_quadrant(robot.position, robot.width, robot.height)
  next unless quadrant

  quadrant_counts[quadrant] += 1
end

puts "safety factor: #{quadrant_counts.values.inject(:*)}"
