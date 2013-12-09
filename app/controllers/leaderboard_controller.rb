class LeaderboardController < ApplicationController
  def index
  	@users = User.order(id: :desc)
  end
end
