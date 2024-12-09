file_path = '/day_9/input.txt'
dir = File.expand_path(File.dirname(File.dirname(__FILE__)))
diskmap = []
formatted_file = []

File.foreach([dir, file_path].join) do |line|
  line = line.chomp("\n").split("")
  diskmap += line
end

diskmap.each_with_index do |blocksize, i|
  blocksize = blocksize.to_i
  char = i.odd? ? "." : (i.to_f / 2.0).to_i
  formatted_file += Array.new(blocksize, char)
end

def find_space(formatted_file, before_index, size)
  current_space = 0

  (0..before_index).each do |i|
    if formatted_file[i] != "."
      current_space = 0
      next
    end

    current_space += 1
    return (i - size + 1) if current_space == size
  end
  -1
end

eof_cursor = formatted_file.size - 1
freespace_cursor = 0

while eof_cursor > 1
  if formatted_file[eof_cursor] == "."
    eof_cursor -= 1
    next
  end

  if formatted_file[freespace_cursor] != "."
    freespace_cursor += 1
    next
  end

  file_char = formatted_file[eof_cursor]
  file_size = 0
  while formatted_file[eof_cursor] == file_char
    file_size += 1
    eof_cursor -= 1
  end

  insert_at = find_space(formatted_file, eof_cursor, file_size)
  next if insert_at == -1

  # insert file into the free space
  (insert_at..(insert_at + file_size - 1)).each do |i|
    formatted_file[i] = file_char
  end

  # replace old file location with free space
  ((eof_cursor + 1)..(eof_cursor + file_size)).each do |i|
    formatted_file[i] = "."
  end
end

p2_checksum = 0
formatted_file.each_with_index do |char, i|
  next if char == "."

  p2_checksum += (i * char)
end

puts "p2 checksum: #{p2_checksum}"

