require 'tk'
#require 'tkextlib/tile'
require 'net/ldap'
require 'logger'
require_relative 'lib/BkWindowCustomer'
require_relative 'lib/BkWindowWidget'


class LdapConnect < BkWindowWidget

  def initialize(main, customer)
    @logger = Logger.new('/tmp/Api.log')
    @connect = nil
    @customer = customer
    @frame = TkToplevel.new(main)
    @frame.title(' Authentication')

   bframe = TkFrame.new(@frame) {
      grid('row' => (row = 1), 'column' => 0, 'columnspan' => 1,
                     'sticky' => 'news', 'padx'=> 40)
    }

    @login = text_field(row = 2, 'Login:', 25)
    @pwd = text_field(row = 3, 'Password:', 25, true)

   image_bk("kiwi.gif")
 #validate button
  submit = TkButton.new(@frame, 'command' => proc { ldap_connect(@login,@pwd) }) {
         text 'Submit'
         grid('column' => 0, 'row'=> 4,'columnspan'=> 2, 'rowspan'=> 4, 'pady' => 10,'padx' => 0)
  }

 #Exit_button
    stop = TkButton.new(@frame, 'command' => proc { term(@connnect) } ) {
         text 'Exit'
         grid('column' => 1, 'row' => 4, 'columnspan' => 5, 'rowspan' => 4,'padx'=>130,'ipadx'=>19)
    }

  end


# pady = hauteur
# padx = largeur
def text_field(row, text, width, ispwd=false)
      tbut = TkLabel.new(@frame, 'text' => text) {
      grid('row' => row, 'column' => 0, 'sticky' => 'nse','padx'=>'0')
    }
     tvar = TkVariable.new('')
     lab = TkEntry.new(@frame) {
     textvariable tvar
     width width

     grid('row' => row, 'column' => 1, 'sticky' => 'nsw','pady'=>'3')
    }
    lab.configure('show' => '*') if ispwd

    return tvar
  end

#Connection to LDAP
  def ldap_connect(*args)
     ldap = Net::LDAP.new
     ldap.host = "ip"
     ldap.port = 389
     ldap.auth "cn=admin,dc=ldap_name,dc=com", "password  "

     filter = Net::LDAP::Filter.eq("uid","#{args[0]}") #args[0] = login
     dn = ["dn"]
     @connect = ldap.bind_as(:base => "dc=ldap_name,dc=com", :filter => filter, :attributes => dn, :password =>"#{args[1]}") #"

@logger.debug"value login =>  #{args[0]}"
@logger.debug"value password =>  #{args[1]}"
@logger.debug"value @connect =>  #{@connect}"
     connect?
  end

# Chek if the user is connected
  def connect?
    if !!@connect
      puts "okai"
      @frame.destroy()
    else
       print_error_message
       puts "wrong password or login"
      return
    end
  end

# Set up image method
  def image_bk(name)
    image = TkPhotoImage.new
    image.file = "./images/#{name}"
    label = TkLabel.new(@frame)
    label.image = image
    label.place('height' => image.height, 'width' => image.width,'x' => 290, 'y' => -15)
  end

  def exit_button
   @submit = TkButton.new(@frame, :text => "Exit", :command => "exit" , :width => 15).pack("side" => "left" , "padx"=>"20", "pady"=>"10" )
  end

end

class FileWindow < TkFrame
  def initialize(main)
    super

    # Set up the title appearance.
    titfont = 'arial 16 bold'
    titcolor = '#228800'

   # @conn = nil

    # Label at top.
    TkLabel.new(self) {
      text ' Customers '
      justify 'center'
      font titfont
      foreground titcolor
      pack('side' => 'top', 'fill' => 'x')
    }

    # Status label.
    @statuslab = TkLabel.new(self) {
      text 'Not Logged In'
      justify 'center'
      pack('side' => 'top', 'fill' => 'x')
    }

    # Exit button
    TkButton.new(self) {
      text 'Exit'
      command 'exit' # { term(@conn) }
      pack('side'=> 'bottom', 'fill' => 'x')
    }

    # List area with scroll bar.  The list area is disabled since we
    # don't want the user to type into it.
   @listarea = TkText.new(self) {
      height 10
      width 40
      cursor 'sb_left_arrow'
      state 'disabled'
      pack('side' => 'left')
      yscrollbar(TkScrollbar.new).pack('side' => 'right', 'fill' => 'y')
    }

    # Bind the system exit button to our exit.
   # main.protocol('WM_DELETE_WINDOW', proc { term(@conn) } )

    # Create the login window.
    LdapConnect.new(main, self)
    # Creation du menu
    MenuCustomer.new
  end
end

BG = '#FFFFFF'
root = TkRoot.new('background' => BG) { title "Customers " }
# Center the window on the screen
win_y, win_w, win_h = 50, 1000, 800
win_x = (root.winfo_screenwidth - win_w) / 2
root.geometry("#{win_w}x#{win_h}+#{win_x}+#{win_y}")
# Suppress resizing window
root.resizable(false, false)

TkOption.add("*background", BG)
TkOption.add("*activebackground", '#000000')
TkOption.add("*foreground", '#000000')
TkOption.add("*activeforeground", '#000000')
FileWindow.new(root).pack()

Tk.mainloop
