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

# returns the index of the first invalid page in an update list
# if the update list is in a valid order, -1 is returned
def update_invalid_at(update, ordering_rules)
  invalid_pages = []
  invalid_at = -1

  # navigate through the update list and check if the pages are in a valid order based on ordering rules
  update.each_with_index do |page, i|
    if invalid_pages.include?(page)
      invalid_at = i
      break
    else
      invalid_pages += ordering_rules[page] if ordering_rules[page]
    end
  end

  invalid_at
end

page_updates.each_with_index do |update, j|
  invalid_index = update_invalid_at(update, ordering_rules)
  # if page is initially valid, skip to the next update
  next if invalid_index == -1
  count = 0

  # while the update is invalid, move the invalid page to a valid position
  while invalid_index != -1
    raise "Infinite loop detected" if count > 100
    puts "Invalid index: #{invalid_index} (#{j+1}/#{page_updates.size})"

    page_number = update.delete_at(invalid_index)
    
    insert_at = nil
    update.each_with_index do |page, i|
      if ordering_rules[page].include?(page_number)
        insert_at = i
        break
      end
    end
    update.insert(insert_at, page_number)
    invalid_index = update_invalid_at(update, ordering_rules)
    count += 1
  end

  sum += update[update.length / 2].to_i
end

puts "Sum: #{sum}"
