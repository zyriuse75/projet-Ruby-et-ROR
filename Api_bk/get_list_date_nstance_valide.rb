require "fileutils"
require "date"

licence_path = "/xxx/xxx/xxx"

FileUtils.cd("#{licence_path}")
 array = Dir.glob('licence_*')

array.each do |file|
File.open("#{file}") do | f|
     f.each_line do |line|
        if line =~ /endDate/
	 date_in_file =line.match(/(\d+)-(\d+)-(\d+)/)
	   if Date.parse("#{date_in_file}") > Date.today 
		puts "\033[34m : =>  #{file}\033[0m"
	    end 
	end
     end
   end
end
