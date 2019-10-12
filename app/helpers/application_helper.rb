module ApplicationHelper
  def hilite(field)
  	if params[:sort] == field
    	"hilite"
   	end
  end
end
