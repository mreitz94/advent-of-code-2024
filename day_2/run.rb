file_path = '/day_2/input.txt'
dir = File.expand_path(File.dirname(File.dirname(__FILE__)))

def report_safe?(report)
  # Build a set of reports with one element removed
  reports = (0..(report.size - 1)).map do |remove_idx|
    report.dup.tap { |r| r.delete_at(remove_idx) }
  end

  # check the original report first
  reports.unshift(report)

  # if any are safe, return true
  reports.any? { |r| report_unsafe_at(r) == -1 }
end

def report_unsafe_at(report)
  direction_change = nil

  report.each_with_index do |val, idx|
    next if idx.zero?

    diff = report[idx - 1] - val
    return idx if diff.zero? || diff.abs > 3

    current_direction = diff.positive? ? :inc : :dec
    return idx if !direction_change.nil? && current_direction != direction_change

    direction_change = current_direction
  end

  -1
end

reports = []
File.foreach([dir, file_path].join) do |line|
  reports << line.split.map(&:to_i)
end

num_safe_reports = 0
reports.each do |report|
  num_safe_reports += 1 if report_safe?(report)
end

puts "Safe reports: #{num_safe_reports}"