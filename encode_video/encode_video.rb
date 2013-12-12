#!/usr/bin/env ruby


############################
#script for encode video   #
#--------------------------#
## Chuck Norris writes code that optimizes itself.


require "fileutils"

class EncodeVideo
  def initialize(path)
    @source = File.expand_path(path)
    @name = File.basename(@source, ".*")
    @out_dir = "#{File.dirname(@source)}/video"
  end

  def process
    FileUtils.mkdir_p(@out_dir)
    
    compress "avi" do |input, output|
	puts "iiii: #{@name}"
      run "avconv -y -i '#{input}' -pass 1 -vtag xvid -c:a ac3 -b:a 128k -b:v 1500k -f avi /dev/null"
      run "avconv -y -i '#{input}' -pass 2 -vtag xvid -c:a ac3 -b:a 128k -b:v 1500k -f avi '#{output}'"
    end

     compress "ogv" do |input, output|
      run "ffmpeg -i '#{input}' -acodec libvorbis -vcodec libtheora '#{output}'" # -ac 1 -b 768k
     end

     compress "flv" do |input, output|
      run "ffmpeg -i '#{input}'-y -ab 56 -ar 44100 -b 200k -r 15 -f flv '#{output}'" # -b 1024k -s 780x480  -ar 44100  -r 25 -acodec mp3 -ab 64 -f flv
     end


  end

  def run(command)
    puts "Running: #{command}"
    system(command)
  end

  def compress(ext)
    out_file = "#{@out_dir}/#{@name}.#{ext}"
    if File.exist? out_file
      puts "Skipping #{@name} file already exists."
    else
	 yield(@source, out_file)
      puts "Encoding finished"
    end
  end
end

EncodeVideo.new($*.first).process

