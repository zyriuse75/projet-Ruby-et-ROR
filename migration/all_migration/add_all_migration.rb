#!/usr/bin/env ruby

###################################
#  Script for pass all migration  #
###################################
# dev: Olivier Morel
## Chuck Norris writes code that optimizes itself.

require "fileutils"

class RubyPassMigration

	def initialize
#		@source = File.expand_path(migration_name)
#		@name =	File.basename(@source, "")
		@dir_source= ("../db/migrate")
		@dir_migration_source = Dir.entries("PATH-OF-YOUR-MIGRATION")
		@pwd =Dir.getwd 
	end
	
	def get_name_migration
           FileUtils.cd("#{@dir_source}") do

	      @dir_migration_source.each { |t|
	       	   $res_name_migration = "rake db:migrate:up VERSION=#{t.split("_")[-0]}"
			run $res_name_migration
		}
	   end
	end

	def run(command)
		puts"Running migration : #{command}"
		system(command)	
	end
	

end

RubyPassMigration.new.get_name_migration
