class LobbyController < ApplicationController
  before_action :ensure_logged_in
  before_action :set_challenge, only: [:accept, :reject]

  def status
    if current_user.table.nil?
      current_user.update_attribute(:last_lobby_poll, Time.now.to_i)
    else
      render json: {currently_in_game: true}
    end
  end

  def challenge
    challengee = User.find_by_username(params[:challengee])
    if challengee
      challenge = Challenge.create(challenger: current_user, challengee: challengee)
      current_user.outgoing_challenge = challenge
      current_user.save
    end
    render :status
  end

  def reject
    if !@challenge.nil?
      @challenge.reject!
    end
    render :status
  end

  def accept
    if !@challenge.nil?
      table = Table.create(fiends: [current_user, @challenge.challenger])
      current_user.incoming_challenges.destroy_all
    end
    render :status
  end

  private

    def ensure_logged_in
      if !signed_in?
        redirect_to log_in_url
      end
    end
    
    def set_challenge
      challenger = User.find_by_username(params[:challenger])
      if (challenger && challenger.outgoing_challenge && challenger.outgoing_challenge.challengee == current_user)
        @challenge = challenger.outgoing_challenge
      end
    end
end
