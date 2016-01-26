
class MenuCustomer

  def initialize

    root = TkRoot.new
    bottom = TkFrame.new(root)

    $bottom = { 'padx'=>150, 'pady'=> 10 }        # 'fill' => 'x' place directement l'objet en haut de la page  
    $after_button_left = { 'side' => 'left', 'padx'=>10, 'pady'=>5 }

   sync = TkPhotoImage.new("file"=>"images/actualize.gif")
   TkButton.new(bottom) do
     image sync
     background "#606060"
      command proc { puts 'actualize' }
      pack $after_button_left
    end

   sync = TkPhotoImage.new("file"=>"images/info.gif")
   TkButton.new(bottom) do
      image sync
      background "#606060"
       command proc { puts 'info' }
       pack $after_button_left
    end

   sync = TkPhotoImage.new("file"=>"images/notes.gif")
   TkButton.new(bottom) do
     image sync
     background "#606060"
      command proc { puts 'actualize' }
      pack $after_button_left
    end

    bottom.pack $bottom
  end
end
