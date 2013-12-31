#! usr/bin/env ruby

[0, 1, 4, 5, 7].each do |f|

puts '**********************************************'
puts "ESC[#{f};Foreground;Background"
 30.upto(37) do |fg|
    40.upto(47) do |bg|
        print "\033[#{f};#{fg};#{bg}m #{fg};#{bg} "
    end
  puts "\033[0m"
  end
end
