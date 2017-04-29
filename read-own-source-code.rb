file = File.open($0, "r")
file.readlines.each do |line|
    puts line
end