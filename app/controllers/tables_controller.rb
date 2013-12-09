# Author: Ben

class TablesController < ApplicationController
  require 'json'
  before_action :ensure_logged_in
  before_action :set_table, except: [:show_table]

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
      else 
        @table = current_user.table
      end
      format.html{render "show_table"}
      format.js {render "index"}
    end
  end

  def flip
    respond_to do |format|
      format.js{}
  	end
  end

  def quit_single_player
    if @table.one_player?
      @table.remove_all_fiends
    end
    redirect_to root_url
  end

  def forfeit
    if @table.two_player? and !@table.game_over?
      # using id's because of stale record issues
      other_fiend = @table.fiends.select{|u| u.id != current_user.id}.pop
      @table.winner = other_fiend
      @table.save
    end
    render :show_table
  end

  def clear_finished_table
    if @table and @table.game_over?
      @table.remove_all_fiends
    end
    redirect_to root_url
  end

  private
    
    def set_table
      @table = current_user.table
    end

end
