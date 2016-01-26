#!/usr/bin/env ruby
require 'fileutils'
require 'yaml'
require 'getoptlong'
require 'date'

# ------------------------------------------------------------------------------------------------#
#
#	████████╗ ██████╗       ██████╗  ██████╗ 
#	╚══██╔══╝██╔═══██╗      ██╔══██╗██╔═══██╗
#	   ██║   ██║   ██║█████╗██║  ██║██║   ██║
#	   ██║   ██║   ██║╚════╝██║  ██║██║   ██║
#	   ██║   ╚██████╔╝      ██████╔╝╚██████╔╝
#	   ╚═╝    ╚═════╝       ╚═════╝  ╚═════╝
#
#
# recuperer les fichiers de licence            			 				 ok 
# compresser l'ensembles des fichiers 								 ok
# updater une date d'un fichier licence qui se trouve dans /xxx 				
# Passage du parametre -instance=								
# Passage du parametre -endDate=								
# Passage du parametre -internalUser=								
# Passage du parametre -externalUser=								
# Passage du parametre -actualize 								
# Ajouter des logs
# web socket 

#class GetInfoInstance

 #  def initialize 
#getFile
#end 
#-------------------------param -actualize -------------------------------#
def actualize
  print "actualize"

### TRANSFORME FILE TO YML ###
FileUtils.cd("/data/xxx/bkweb/xxx/xxx/")
   array = Dir.glob('licence_*')
 array.each do |f|
   fg = f.gsub(/\.php/, '')
     output = File.new("/home/zyriuse/documents/Ruby-On-Rails/script/Api_BK/yml/""#{fg}.yml", 'w')
     output.puts "licence_Name : #{f}"
  file = File.read(f).to_yaml
   output.puts file.gsub(/=>/,':').gsub(/'/,'').gsub(');?>', '').sub(/\<\?\$licenceData = array \(/,'').gsub(/--- \|\-/, '')  
 end

FileUtils.cd('/home/zyriuse/documents/Ruby-On-Rails/script/Api_BK/')
	gz = %x[tar -cvf licence.tar.gz yml/ ]
end 
## -----------------------END YAML ---------------------------#
 
#---------------------------- param -actualize -----------------------#

#---------------------------- END param -actualize -----------------------#


#-------------------------param -externalUser= -------------------------------#
def externalUser(arg,inst)
puts "externalUser#{arg} in def externalUser"
puts "instance in externalUser #{inst}" 

#FileUtils.cd("/home/zyriuse/documents/Ruby-On-Rails/script/Api_BK/yml")
#params = open("licence_beta.xxx.net.yml",'r') { |f| f.each_line.detect { |line| /users_external/.match(line)}}
#new_External_params = params.sub(/\d+/,'23')

  FileUtils.cd("/data/xxx/bkweb/xxx/xxx")
	a = Array.new 
	a = File.readlines("xxx.xxx.net.php")
	a.delete_if {|f| f.include? "users_external"}
	a[-2,0] = "'users_external' => #{arg},\n"
  File.open("xxx.xxx.net.php","w") { |f| a.each {|line| f << line }}
 
end
 
#---------------------------- END param -externalUser= -----------------------#





#-------------------------param -endDate= -------------------------------#
def endDate?(argDate, format="%Y/%m/%d")

  FileUtils.cd("/data/xxx/bkweb/xxx/xxx")
	a = Array.new 
	a = File.readlines("licence_xxxxx.php")
	a.delete_if {|f| f.include? "endDate"}

   Date.strptime(argDate, format) rescue false 

	a[-2,0] = "'endDate' => #{argDate},\n"
  File.open("licence_xxxx.php","w") { |f| a.each {|line| f << line }}

end
#---------------------------- END param -endDate= -----------------------#





#-------------------------param -internalUser= -------------------------------#
#---------------------------- END param -internalUser= -----------------------#






#-------------------------param -instance= -------------------------------#
def instance

#instance = 

end 


#---------------------------- END param -instance= -----------------------#


opts = GetoptLong.new(
	['--actualize',  GetoptLong::NO_ARGUMENT],
	['--externalUser=', GetoptLong::OPTIONAL_ARGUMENT],
	['--internalUser=', GetoptLong::OPTIONAL_ARGUMENT],
	['--endDate=', GetoptLong::OPTIONAL_ARGUMENT],
	['--instance=', GetoptLong::OPTIONAL_ARGUMENT],
)

begin
  opts.each do |opt, arg|
    case opt
        when "--actualize" 
         actualize
        when "--externalUser="
	 externalUser = arg.to_i
	when "--endDate="
	 endDate = arg.to_i
	when "--internalUser="
	 internalUser = arg
	when "--instance="
	 instance = arg
     end
  end

end



#     def getFile
##------------------------- YAML ---------------------------#
#if ARGV.defined?

#opts = ' ' 
#opts << ARGV.shift while ARGV[0] && ARGV[0].start_with?('-')
# date = opts[/date/i] != nil

#begin 
#   name_licence = String(ARGV.shift)
#
#if date
# puts "date"
#   FileUtils.cd("/data/xxx/bkweb/xxx/xxx/")
#    file = File.open()
#else 
#puts "no date"
#end





#---------------------------- HASH -----------------------------#
# FileUtils.cd("/data/xxx/bkweb/xxx/xxx/")
#   array = Dir.glob('licence_*')
# array.each do |f|
#   fg = f.gsub(/\.php/, '')
#   output = File.new("/home/zyriuse/documents/Ruby-On-Rails/script/Api_BK/yml/""#{fg}", 'w')
#    file = File.read(f)
#   output.puts file.gsub(');?>', '').sub(/\<\?\$licenceData = array \(/,'') 
# end
#FileUtils.cd('/home/zyriuse/documents/Ruby-On-Rails/script/Api_BK/')
#        gz = %x[tar -cvf licence.tar.gz yml/ ]
#---------------------------- END HASH --------------------------#
#end 
