#!/usr/bin/env ruby
# dev : olivier Morel
#  Chuck Norris writes code that optimizes itself.

require 'fileutils'
require 'date'

HELP=<<EOS

 Delete files in YOUR_PATH that older than a given days.
   Options:
    -d     - dry run. It's like a test ,but do not delete files only show dir to be deleted
    -h     - Show this usage help

   exemple with dry-run:
     ruby clear_old_file.rb -d 5
   
EOS


opts =' '
opts << ARGV.shift while ARGV[0] && ARGV[0].start_with?('-')
dry_run = opts [/d/i] != nil
 if opts[/h/i]!= nil
   puts HELP
   exit
 end


  begin
   ddays= Integer(ARGV.shift) 
     rescue ArgumentError, TypeError
      $stderr.print "\e[1;31m The first argument must be a Integer. \e[0m \n " 
  exit 1
  end


  if ddays == 0
     $stderr.print "\e[1;31m Error: no argument specified; exiting. \e[0m \n"
    exit 1
  end

 path = "/data/deploy_tmp/"
 time_now = Time.now
 getime= (ddays*24*60*60).to_i
 time= time_now - getime
 
  to_delete=[]

 FileUtils.cd("#{path}")
   Dir.entries('.').each do  |f|

  to_delete << f if File.directory?(f) && File.mtime(f) < time
  end 
   

   if dry_run
     puts "\e[1;34m Directory to be deleted: \e[0m "
    to_delete.each {|f| puts "\e[1;37m #{f}\e[0m"}
   else
     to_delete.each do |f|
      
       puts " \e[1;34m Deleting directory \e[0m \"#{f}\""
       FileUtils.rm_rf f
     end
   end
