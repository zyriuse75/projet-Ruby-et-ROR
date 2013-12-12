############################################
#                                           #
# script de backup pour une instance donnee #
#                                           #
############################################

require 'rubygems' if RUBY_VERSION < '1.9'
require 'date'
require 'fileutils'
require 'net/ssh'
require 'open3' 
#require_relative 'DeleteInstance.rb'

class CommandFailed < StandardError
  end


class BackupMysql < StandardError
  
  def initialize(uid_instance)
      
#      if uid_instance.nil?
#	puts "please give a uid instance to backup"
#	 @uid_instance = gets.chomp 
#      else
           @uid_instance = uid_instance
	   @user ='root'
	   @res_uid_instance= @uid_instance
	   @host ='192.168.160.44'
#	   @pwd =""
           @mysl_dump ="/usr/bin/mysqldump"
	   @mysql_user = "USER-MYSQL"
           @mysql_password = "PASSWORD-MYSQL"
	 backup
#      end
   end
  
	def ssh_exec!(ssh, command)
	  stdout_data = ""
	  stderr_data = ""
	  exit_code = nil
	  exit_signal = nil
	  ssh.open_channel do |channel|
	    channel.exec(command) do |ch, success|
	      unless success
	        abort "FAILED: couldn't execute command (ssh.channel.exec)"
	      end
	      channel.on_data do |ch,data|
	        stdout_data+=data
	      end
	
	      channel.on_extended_data do |ch,type,data|
	        stderr_data+=data
		puts  "\033[31mError for execute mysqldump:\033[0m #{data}"
		puts "\033[31mcheck the path.\033[0m"
               raise CommandFailed, "Command \"#{command}\" returned exit code #{exit_code}" unless exit_code == 0

	      end
	       
	      channel.on_request("exit-status") do |ch,data|
	        exit_code = data.read_long
		puts "\033[32mBackup complete...\033[0m"
		 end
		end
	
	      channel.on_request("exit-signal") do |ch, data|
	        exit_signal = data.read_long

	      channel.on_close do |ch|
		 puts "channel is closing!"
	      end

	      end
	    end
	  
	  ssh.loop
	end


 
	def backup
	puts "uid pass for MysqlBackup-->#{@uid_instance}"
		@time = Time.new
		@Dtime = @time.strftime("%Y-%m-%d--%I:%M")

        	begin
                   ssh_exec!(Net::SSH.start(@host, @user, :port =>"22", :password=>@pwd), "#{@mysl_dump} -u #{@mysql_user} -p'#{@mysql_password}' #{@uid_instance} |bzip2  > /data/#{@uid_instance}.#{@Dtime}.sql.bz2")
                end 

	end
	


	def run(command)
	   puts "backup of data base #{@uid_instance} "
	   system(command)
	end	

end

