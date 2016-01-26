$LOAD_PATH << './lib'

require 'net/ldap'
require 'rubygems'
require_relative 'log_api' 

include Logging
#class Ldap_connect 
    
puts "your login"
 login = gets.chomp

puts "your password"
 pwd = gets.chomp

ldap = Net::LDAP.new
ldap.host = "78.109.82.49"
ldap.port = 389
ldap.auth "cn=admin,dc=XXX.XX,dc=com", "password"


filter = Net::LDAP::Filter.eq("uid","#{login}")
dn = ["dn"]
result = ldap.bind_as(:base => "dc=xxx.xxx,dc=com", :filter => filter, :attributes => dn, :password => "#{pwd}")


if result
    return login
#   puts "User has been authenticated : #{login} "
   logger.info "ldap authentified with: #{login} "
else
   return "#{login}"
 # puts "User has been not authenticated : #{login} "
 logger.error "ERR :#{ldap.get_operation_result}"
 logger.error "ERR : cannot authenticate the user #{login}"

end

