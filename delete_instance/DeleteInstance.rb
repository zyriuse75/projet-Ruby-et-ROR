###+++++++++++++++++++++++++++++##
# script for delete an instance   #
#                                 #
# version :1.0                    #
# dev : omr@google-software.com #
###++++++++++++++++++++++++++++###

require 'rubygems' if RUBY_VERSION < '1.9'
require 'fileutils'
require 'net/ssh'
require_relative 'BackupMysql.rb'

class DeleteInstance
##-------------------------------------------------------------------------##
#1 lire le fichier configuration de l'instance                   ok
#2 chercher le parametre dbname                                  ok
#3 creer un backup de la base de l'instance                      ok
#4 supprimer les fichiers present de l'instance dans config      ok
#5 supprimer la base de donnée
  #
##--------------------------------------------------------------------------##

#attr_reader :uid_instance

  def initialize(uid_instance)
    if uid_instance.nil?
      puts "please give the url of your instance !"
      puts "exemple : qa.google.net"
      @uid_instance = gets.chomp
	@srv = "IP-SERVER"
	@user = "USER-SSH"
        @pass = "PASSWORD-SSH"	
        @url_instance = @uid_instance.strip
        @base_dir ="/data/google/bkweb"
        @cache_dir ="/web/cache"
        @conf_dir ="/application/config"
        @paramfile= ["licence_","configuration_","customUser_", "extMapping_"]
      get_name
     get_uid
    end
  end


  def get_name
    @name = @url_instance[/[^.]+/]
    puts "Instance name ---> #{@name}"
  end


  def get_uid

      FileUtils.cd("#@base_dir#@conf_dir")
                if  File.exists?("#{@paramfile[1]}#{@url_instance}.php")

                   @get_uid_instance =  File.foreach("configuration_#{@url_instance}.php", "r").grep(/config\[['"]uid['"]\]/)
                   #@get_uid_instance =  File.open("configuration_#{@url_instance}.php", "r").grep(/config\[['"]uid['"]\]/)
                   @res_uid = @get_uid_instance[0].match(/uid(\S*)(.*)/)
                  del_instance_file @uid = @res_uid[2].delete(";'\"\=").strip
		  backup_mysql @uid
                   puts "Instance uid  ---> #{@uid}"
              else
                puts "cant find file ..#{@paramfile[1]}#{@url_instance}.php"
          end

  end


  def del_instance_file(uid)

               if  File.exists?("#{@paramfile[1]}#{@url_instance}.php")
      puts "Delete instance cache #{@url_instance}"
        FileUtils.cd("#{@base_dir}#{@cache_dir}")
          puts "up_file_instance uid -->#{@uid}"
           @dir =FileUtils.pwd
            FileUtils.rm_r(Dir.glob(@uid), :force => true).first
               FileUtils.cd("#{@base_dir}#{@conf_dir}")

          @paramfile.each do |rm_uid|
                   FileUtils.rm_f("#{rm_uid}#{@url_instance}.php")
                   FileUtils.rm_f("#{rm_uid}#{@url_instance}.xml")
          end

                else
#                 puts"cant find the file: "
                end
   end


  def backup_mysql(uid)
   backup_mysql =  BackupMysql.new(@uid)
   backup_mysql.backup	
	puts "backup_mysql variable pass from Deleteinstance ->< #{@uid}"
	puts "res of #{backup_mysql}"
	puts "backup_mysl_from_DeleteInstance #{@uid}"
  end	
end

DeleteInstance.new(@uid_instance)


