class HomeController < ApplicationController

  
  def index
	respond_to do |format|
		if session[:user_id] != nil
			format.html{render "index_logged_in"}
		else
			format.html{render "index_not_logged_in"}
		end
	end
  end

end
