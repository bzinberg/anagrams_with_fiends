class TablesController < ApplicationController

  
  def index
	respond_to do |format|
		@user = User.find_by_id(session[:user_id])
		if @user.table === nil
			@table = Table.new
			@user.table = @table
			@user.save
		else 
			@table = @user.table
		end
		format.html{render "index"}
	end
  end

end
