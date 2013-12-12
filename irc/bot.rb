#!/usr/bin/env ruby

require 'socket'

class Irc_Bot

  def initialize(server, port, channel)
    @channel = channel
    @server = server
    @port = port
#    say "NICK IrcBotbk"
#    say "USER olivier_bk O * olivier_bk"
#    say "JOIN #{channel}"
#  say_to_chan "I coming for kill you !!"
  #say_to_chan "#{1.chr}I coming for kill you !!#{1.chr}"
   connect
  end

  def connect
   @connection = TCPSocket.open(@server,@port)
    say_to_chan("USER olivier_")
    say_to_chan("NICK olivier2_")
    join(@channel)
  end

  def say(msg)
    @connection.puts msg
  end

  def join(channel)
   say_to_chan("JOIN ##{channel}")
#    @channel = channel
  end

  def say_to_chan(msg)
    puts ">> #{msg.strip}"
    @connection.puts(msg)
  #  say "PRIVMSG #{@channel} : #{msg}"
  end

  def run
    until @connection.eof? do
      msg = @connection.gets
      puts msg
    end
  end

  def send
    @command = "!listrequestedrevs"
    @connection.send "#{command}\n",
  end

end

bot = Irc_Bot.new("irc.freenode.net", 6667, "NAME-OF-CHANNEL")
bot.run
