file_path = '/day_5/input.txt'
dir = File.expand_path(File.dirname(File.dirname(__FILE__)))

# hash where the key is a page number and the value is a list of page numbers that cannot come after it in an update
ordering_rules = {}

# each item is a list of page numbers in an update
page_updates = []

File.foreach([dir, file_path].join) do |line|
  line = line.chomp("\n")
  next if line.empty?

  # ordering rule line
  if line.match?(/\d{2}\|\d{2}/)
    p1, p2 = line.split("|")
    ordering_rules[p2] ||= []
    ordering_rules[p2] << p1
  else # update line
    page_updates << line.split(",")
  end
end

ordering_rules.transform_values!(&:sort)
sum = 0

page_updates.each do |update|
  invalid_pages = []
  valid = true

  # navigate through the update list and check if the pages are in a valid order based on ordering rules
  update.each do |page|
    if invalid_pages.include?(page)
      valid = false
      break
    else
      invalid_pages += ordering_rules[page] if ordering_rules[page]
    end
  end

  # add the middle page number to the sum if the update is valid
  sum += update[update.length / 2].to_i if valid
end

puts "Sum: #{sum}"
