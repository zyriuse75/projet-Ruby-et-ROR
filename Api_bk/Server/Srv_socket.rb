require 'socket'
require 'fileutils'
$LOAD_PATH << './lib'
require_relative 'lib/log_api'
require 'date'
require 'yaml'
#require 'ldap_connect'



class Srv_Socket
include Logging

   def initialize(server, port)
        @server = server
        @port   =  port
      connect
   end

      def connect 
           val_array = ['actualize','update_externalUser','update_endDate','update_internalUser','instance']
              a = TCPServer.new('', @port)
    logger.info("SRV  => Api has been started".colorize("cyan", :style =>"strikethrough"))
          loop {
	       connection = a.accept
                msg =  connection.recv(1024)
	       puts "methode : #{msg}"  
    logger.info( "SRV => #{msg}".colorize("cyan", :style =>"strikethrough"))
	         hash_converter "#{msg}" 
	   
	       connection.write 'got something--closing now--here is your response message from the server'
	       connection.close
 	       }
        end	


	def hash_converter(msg, opts={})
    logger.info("SRV => in hash_converter".colorize("cyan", :style =>"strikethrough"))
              grouped = msg.split("  ").group_by { |s| s.split(" ")[0] }
              opts = Hash[grouped.map { |d, e| [d, e.map { |s| s.split(" ")[1] }] }]
    logger.info("SRV => after opts : #{opts}".colorize("cyan", :style =>"strikethrough"))
              grouped = msg.split("  ").group_by { |s| s.split(" ")[0] }
    logger.info("SRV => after grouped : #{grouped}".colorize("cyan", :style =>"strikethrough"))
	         opts.each do |k,v|
    logger.info("SRV => self: #{k}".colorize("cyan", :style =>"strikethrough"))
		   self.send "#{k}",v
	 	end
        end

############################################################################################
#	
# def: send 
#
#Invokes the method identified by symbol, passing it any arguments specified. You can use __send__ if the name send clashes with an existing method in obj.
#
# So then in the loop, it does this:
#self.send "name=", "John Smith"
#
#which is equivalent to
#self.name = "John Smith"
#############################################################################################

#http://apidock.com/rails/v4.0.2/String/indent 



    	def update_endDate(date)
              FileUtils.cd("/write_path/config")
                    a = File.readlines("licence_xx.net.php")
                    a.delete_if {|f| f.include? "endDate"}
		   #check date[0]	
            #   Date.strptime(date, format) rescue false
                    a[-2,0] = "'endDate' => #{date[0]},\n"

              File.open("licence_xxx.xxx.net.php","w") do
		         |f| a.each {|line| f << line }
                     end

       	        logger.info("SRV =>  update date with #{date}".colorize("cyan", :style =>"strikethrough"))
	end

          

	def actualize
            php_command =  system("which php")
	      json_encode = system('/usr/bin/php /home/zyriuse/documents/Ruby-On-Rails/script/Api_BK/Socket/json_encode.php')
               puts "json_encode: #{json_encode}"
		logger.info("SRV => json_encode: #{json_encode}".colorize("cyan", :style =>"strikethrough"))
	end 
       



	def update_externalUser(arg)

      logger.info("SRV =>  update_externalUser: #{arg[0]}".colorize("cyan", :style =>"strikethrough"))	
	  FileUtils.cd("/data/xxx/bkweb/application/config")
	        a = Array.new
	        a = File.readlines("xxx.xxx.net.php")
	        a.delete_if {|f| f.include? "users_external"}
	        a[-2,0] = "'users_external' => #{arg[0]},\n"
	  File.open("xxx.xxx.net.php","w") { |f| a.each {|line| f << line }}
	
	end

 
	def update_internalUser(arg)
	#def update_internalUser(arg,inst)

logger.info("SRV =>  update_internalUser: #{arg[0]}".colorize("cyan", :style =>"strikethrough"))	
	  FileUtils.cd("/data/xxx/bkweb/application/config")
	        a = Array.new
	        a = File.readlines("xxx.xxx.net.php")
	        a.delete_if {|f| f.include? "users_internal"}
	        a[-2,0] = "'users_internal' => #{arg[0]},\n"
	  File.open("xxx.xxx.net.php","w") { |f| a.each {|line| f << line }}
	
	end


	def run 
  	    until @server.eof? do 
	   end
	end 

end

class String
  def colorize(color, options = {})
    background = options[:background] || options[:bg] || false
    style = options[:style]
    offsets = ["gray","red", "green", "yellow", "blue", "magenta", "cyan","white"]
    styles = ["normal","bold","dark","italic","underline","xx","xx","underline","xx","strikethrough"]
    start = background ? 40 : 30
    color_code = start + (offsets.index(color) || 8)
    style_code = styles.index(style) || 0
    "\e[#{style_code};#{color_code}m#{self}\e[0m"
  end
end


srv_connect = Srv_Socket.new('localhost',20000)
srv_connect.run
