require "fileutils"
require "date"

licence_path = "$PATH"

FileUtils.cd("#{licence_path}")
 array = Dir.glob('licence_*')

array.each do |file|
File.open("#{file}") do | f|
     f.each_line do |line|
        if line =~ /endDate/
	 date_in_file =line.match(/(\d+)-(\d+)-(\d+)/)
	   if Date.parse("#{date_in_file}") <= Date.today 
		print "\033[34m : =>  #{file}\033[0m"
                puts " #{ date_in_file}"  
	    end 
	end
     end
   end
end
