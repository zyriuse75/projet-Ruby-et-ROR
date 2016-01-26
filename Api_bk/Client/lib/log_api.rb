require  'logger'

module Logging

	def logger
	 # @logger ||= Logging.logger_for(self.class.name)
          Logging.logger
	end



	def self.logger
	  @logger ||= Logger.new('/tmp/Api.log')
#	  @logger.datetime_format = "%G-W%V "
	  @logger.formatter = proc { |severity, datetime, progname, msg|
	                            "[#{datetime.strftime('%F %T')}] #{msg}\n"
	                           }

	end
end


