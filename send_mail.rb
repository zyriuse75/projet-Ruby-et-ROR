# for use this module  
# with file : Mail::SendMail.new("omr@bluekiwi-software.com", "/tmp/data.csv", "export_instance")
# without file: Mail::SendMail.new("omr@bluekiwi-software.com", "export_instance")


module Mail
  class SendMail

    require 'net/smtp'
    require 'date'
 

   def initialize(*args)
      send_mail(*args)
   end

   def itime
       time = Time.new
       @Dtime = time.strftime("%Y-%m-%d")
   end

   def send_mail(mail,*args)
      mail = mail.to_s
      file = args[1]
      subject = args[0]
 
    if !file.nil?
      begin
        filecontent = File.read(file)
        filename = File.basename(file)	
        encodedcontent = [filecontent].pack("m")   # base64
         rescue 
          raise "could not read file #{filename}"
       end

     else
     end 
	marker = "AUNIQUEMARKER"
	
body =<<EOF
   The task has been successfully completed. 
   

   best regards.
    It Departement
EOF

part1 =<<EOF
From: IT departement <root@localhost.net>
To:#{mail} 
Subject: #{subject}
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=#{marker}
--#{marker}
EOF

part2 =<<EOF
Content-Type: text/plain
Content-Transfer-Encoding:8bit

#{body}
--#{marker}
EOF

part3 =<<EOF
Content-Type: multipart/mixed; name=\"#{filename}\"
Content-Transfer-Encoding:base64
Content-Disposition: attachment; filename="#{filename}"

#{encodedcontent}
--#{marker}--
EOF
	
	
	if filename.nil?
	   mailtext = part1 + part2 
	else
	   mailtext = part1 + part2 + part3
	end
	
	begin 
	  Net::SMTP.start('localhost') do |smtp|
	     smtp.sendmail(mailtext, "root@localhost.net",
	                          ["#{mail}"])
	  end
	end  

    end
  end
end
