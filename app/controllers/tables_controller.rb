class TablesController < ApplicationController
  require 'json'
  before_action :ensure_logged_in
  before_action :set_table, except: [:show_table]
  # before_action :ensure_user_belongs_to_table


  #def show_my_table
    #if @table.nil?
      #redirect_to root_url
      #return
    #end
    #render 'show'
  #end
  
  def force_new_table
    current_user.table = nil
    current_user.save
    redirect_to show_table_path
  end
  
  def show_table
    respond_to do |format|
      if current_user.table.nil?
        @table = Table.create
        current_user.table = @table
        current_user.save
        # just in case?
        @table.save
        puts 'new table ' + @table.uuid
      else 
        @table = current_user.table
        puts 'old table ' + @table.uuid
      end
      format.html{render "show_table"}
      puts JSON.pretty_generate(@table.to_h)
      format.js {render "index"}
    end
  end

  def flip
    respond_to do |format|
      format.js{}
  	end
  end

  private
    
    def set_table
      puts 'set table!'
      @table = current_user.table
    end

    #def ensure_user_belongs_to_table
      #if current_user.table != @table
        #redirect_to root_url, message: "helo"
      #end
    #end

end
