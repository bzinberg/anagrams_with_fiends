class TablesController < ApplicationController
  before_action :ensure_signed_in
  before_action :set_table
  # before_action :ensure_user_belongs_to_table


  def show_my_table
    if @table.nil?
      redirect_to root_url
    end
    render 'show'
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
  def flip
  	respond_to do |format|
  		format.js{}
  	end
  end

  private
    
    def ensure_signed_in
      if !signed_in?
        redirect_to root_url, message: "helo"
      end
    end

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
