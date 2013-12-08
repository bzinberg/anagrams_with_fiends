class LobbyController < ApplicationController
  before_action :ensure_logged_in
  before_action :set_challenge, only: [:accept, :reject]

  def status
    current_user.update_attribute(:last_lobby_poll, Time.now.to_i)
  end

  def reject
  end

  private

    def ensure_logged_in
      # TODO implement
    end
    
    def set_challenge
      challenger = User.find_by_username(params[:challenger])
      @challenge = current_user.incoming_challenges.find_by_challenger(challenger)
      if 
    end
end
