class TablesController < ApplicationController

  def show
  end
  
  def index
    respond_to do |format|
      if current_user.table.nil?
        @table = Table.new
        current_user.table = @table
        current_user.save
      else 
        @table = current_user.table
      end
      format.html{render "index"}
    end
  end

end
