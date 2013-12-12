#!/usr/bin/env ruby


# dev: olivier morel
# Chuck Norris writes code that optimizes itself.

require 'fileutils'

class RubyPassMigration

        def initialize(path)
          @dir_migration_source = path 
#	  @array = @dir_migration_source[1].split('_',2)
	  @pwd_migration = Dir.getwd
	  @absolutePath = File.absolute_path("../db/migrate/") 
	end


	def check(check_file)
	 Dir.foreach(@absolutePath) do |f|
	    
	 end
	end

	def get_date_migration
	puts "#{@absolutePath}"
        puts "#{@dir_migration_source}"	

	  if File.exist?(@dir_migration_source)
	   
             Dir.chdir(@absolutePath)
               FileUtils.cd("#{@absolutePath}", :verbose => true) do 
		$res_name_migration = "rake db:migrate:up VERSION=#"
		    run $res_name_migration	   
              end	
           end
	end

	
	def run(command)
		puts"Running migration : #{command}"
		system(command)
	end

end

RubyPassMigration.new($*).get_date_migration
