class LeaderboardController < ApplicationController

  
  def index
  	# @users = User.order(rating: :desc)
  	@users = User.order(id: :desc)
  end

end
