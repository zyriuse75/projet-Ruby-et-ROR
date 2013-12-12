#!/usr/bin/ruby
######################################
# script for create a vhost in nginx #
# creation date : 2012-05-20         #
######################################
# Chuck Norris writes code that optimizes itself.

require 'fileutils'; FileUtils
puts "We are going to creat a Vhost"

Directory = "PATH" # where you want your vhost /var/www etc..
Domaine = "DOMAINE-NAME"
Access= "access.log"
Error= "error.log"
VhostsAvailabe= "/usr/local/centOs/sources/nginx-Passenger3.0.9/vhosts"

## 
 puts "Name of your VHOST"
   NameVhost = gets.chomp 

  puts "what kind of environment staging/production/dev"
   Environment = gets.chomp
### Creat directory if doesn't exist
	
if File.exists?("#{VhostsAvailabe}/#{NameVhost}")
	puts "the #{NameVhost} already exist!"
	exit
end
 
       FileUtils.mkdir_p "#{Directory}#{NameVhost}"
       FileUtils.mkdir_p "#{Directory}#{NameVhost}"  
       FileUtils.mkdir_p "home/logs/#{NameVhost}"
       FileUtils.touch "#{Directory}/#{NameVhost}/#{Access}"



## adding vhost 
File.open("#{VhostsAvailabe}/#{NameVhost}.conf",'a') do |vhost|
vhost.puts <<EOF
server {  
        listen          80;
        server_name     #{NameVhost}.#{Domaine}; 
                
        error_page  404 /404.html;
        error_page  500 502 503 504 /50x.html;
        
       # == Document ROOT
 
       root #{Directory}#{NameVhost}/current/public;
        rails_env #{Environment};
        # == Définition des logs ==

        access_log /home/logs/#{NameVhost}/access.log;
        error_log /home/logs/#{NameVhost}/error.log;

        }

EOF

end

puts "Restarting nginx\n"
system ('/etc/init.d/nginx restart')
puts "DONE!"
