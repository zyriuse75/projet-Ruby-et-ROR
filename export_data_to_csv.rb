require 'fileutils'
require 'csv'


FileUtils.cd('/$PATH')
configs = {}
Dir.glob('configuration_*').each do |filename|
 configs[filename]= Hash.new
  File.foreach(filename) do |line|


	 if line.include? 'uid'
	      next unless line.match(/(?=uid).*?[\'\"].*?[\'\"](.*?)[\'\"](.*?)[\;\"]/)
		field, value = line.split("=",2);
             ( configs[filename] = []  <<  value.strip.gsub("';", "").gsub("'","")) 
             #( configs[filename][:uid] ||= [] ) <<  value.strip.gsub("';", "").gsub("'","")        # params with key 
	 end 
	
	 if line.include? 'url'
	     next unless line.match(/(?=url).*?[\'\"].*?[\'\"](.*?)[\'\"]/)
                field, value = line.split("=",2);
		( configs[filename] ||= [] ) << value.strip.gsub("';", "").gsub("'","")
		#( configs[filename][:url] ||= [] ) << value.strip.gsub("';", "").gsub("'","")      # Params with key 
 
         end 
	
	 if line.include? 'xxx'
	     next unless line.match(/(?=xxx).*?[\'\"].*?[\'\"](.*?)[\'\"]/)
                field, value = line.split("=",2);
	 	( configs[filename] ||= [] ) << value.strip.gsub("';", "").gsub("'","")
		#( configs[filename][:dbname] ||= [] ) << value.strip.gsub("';", "").gsub("'","")   # Params with key 
	 end 
	 
	CSV.open("/tmp/data.csv", "wb", Options = {quote_char: "\0", write_headers: true, headers:["file_conf","uid","url","dbname"]}) do |csv| 
	configs.each { |input| column_header = nil; csv << input} 
	end


        file  = File.new("/tmp/data_instance.csv","w")

	File.open("/tmp/data.csv").each do |f|
	line = f.gsub(/["]/,"").gsub("[","").gsub("]","")
          file.puts line 
	end
   end
 end

