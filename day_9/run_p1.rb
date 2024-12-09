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

eof_cursor = formatted_file.size - 1
freespace_cursor = 0

while eof_cursor > freespace_cursor
  if formatted_file[eof_cursor] == "."
    eof_cursor -= 1
    next
  end

  if formatted_file[freespace_cursor] != "."
    freespace_cursor += 1
    next
  end

  formatted_file[freespace_cursor] = formatted_file[eof_cursor]
  formatted_file[eof_cursor] = "."
end

p1_checksum = 0

formatted_file.each_with_index do |char, i|
  break if char == "."

  p1_checksum += (i * char)
end

puts "p1 checksum: #{p1_checksum}"

