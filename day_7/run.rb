file_path = '/day_7/input.txt'
dir = File.expand_path(File.dirname(File.dirname(__FILE__)))
equations = []
P1_VALID_OPERATORS = ["+", "*"]
P2_VALID_OPERATORS = ["+", "*", "||"]

class Equation
  def initialize(test_value, equation_values)
    @test_value = test_value
    @equation_values = equation_values
  end

  def valid?(valid_operators)
    values = [equation_values.first]
    equation_values.each_with_index do |ev, i|
      next if i.zero?

      values = valid_operators.flat_map do |operator|
        new_values = values.dup

        if operator == "||"
          new_values.map { |v| (v.to_s + ev.to_s).to_i }
        else
          new_values.map { |v| v.send(operator, ev) }
        end
      end

      # ignore values greater than the test value since it will be impossible for their end result to be equal to the test value
      values.reject! { |v| v > test_value }
    end

    values.any? { |v| v == test_value }
  end

  attr_reader :test_value, :equation_values
end

File.foreach([dir, file_path].join) do |line|
  test_value, equation_values = line.chomp("\n").split(": ")

  equations << Equation.new(test_value.to_i, equation_values.split(" ").map(&:to_i))
end

p1_result = 0
equations.each do |equation|
  p1_result += equation.test_value if equation.valid?(P1_VALID_OPERATORS)
end

puts "P1 Total calibration result: #{p1_result}"

p2_result = 0
equations.each do |equation|
  p2_result += equation.test_value if equation.valid?(P2_VALID_OPERATORS)
end

puts "P2 Total calibration result: #{p2_result}"