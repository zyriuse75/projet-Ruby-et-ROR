require 'socket' 
require 'date'
$LOAD_PATH << './lib'
require_relative 'lib/log_api'

class Socket_BK
  include Logging


	def initialize(server, port) 
	  logger.info"LC port: #{port}"
	     @server = server
	     @port   = port	
	    connect
	  
	end

	def connect
	   @connect = TCPSocket.open(@server, @port)
	     #say_to_chan("update_endDate 2016-05-20")
	  logger.info"CL connect: #{@connect}"
	     say_to_chan("update_endDate to 2019-05-05")	
            check
	end
        
	def get_date(date)
	  @date ||= Date.strptime(date, "%Y-%m-%d")
	end
	
	def check 
#	    given_date = Socket_BK.new
#          puts "res #{given_date}" 
	      date ="2014-02-29"
               format = "%Y-%m-%d"
               given_date = Date.strptime(date, format)
		rescue ArgumentError => err
           logger.info"CL value given date: #{err}"
           if given_date.nil?
		return nil
               puts "nothing"
	  logger.info"CL nothing in given_date"
           else 
               puts "something"
	  logger.info"CL something in given"
           end 
	end 


	def say_to_chan(msg)
	     @connect.write(msg)
	     puts "got back:" + @connect.recv(1024)
             @connect.close
	end
	
	def run
	    until @connect do 
               puts "#{connect}"
            end
	end

end 

connect_bk = Socket_BK.new('localhost', 20000 )
connect_bk.run

