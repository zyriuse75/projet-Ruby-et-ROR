require 'logger'

class BkWindowWidget

  def new_frame
    root = TkRoot.new
    root.title = "Window"

msgBox = Tk.messageBox(
     'type'    => "ok",
     'icon'    => "info",
     'title'   => "This is title",
     'message' => "This is message"
)
  end


  def print_error_message
@logger.debug"call method print_error_message"
     Tk.messageBox(
        'type'    => "ok",
        'icon'    => "warning",
        'title'   => "Error",
        'message' => "Wrong password or Login!"
        )
  end


  def term(conn)
    if conn
      begin
        conn.quit
      ensure
        conn.close
      end
    end
    exit
  end


end
