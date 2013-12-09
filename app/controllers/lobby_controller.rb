class LobbyController < ApplicationController
  before_action :ensure_logged_in
  # before_action :set_incoming_challenge, only: [:accrej]

  def status
    if current_user.table.nil?
      current_user.update_attribute(:last_lobby_poll, Time.now.to_i)
    else
      render json: {currently_in_game: true}
    end
  end

  def challenge
    if params[:challengeeField]
      challengee = User.find_by_username(params[:challengeeField])
    end

    if !challengee.nil?
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

  def accrej
    if params[:challengerField]
      challenger = User.find_by_username(params[:challengerField])
      if (challenger && challenger.outgoing_challenge && challenger.outgoing_challenge.challengee == current_user)
        @challenge = challenger.outgoing_challenge
      end
    end

    if !@challenge.nil?
      if params[:challengeStatusField] == 'Accept'
        # Accept the challenge
        table = Table.create(fiends: [current_user, @challenge.challenger])
        current_user.incoming_challenges.destroy_all
        @challenge.challenger.incoming_challenges.destroy_all
      else
        # Reject the challenge
        @challenge.reject!
      end
    end
    render :status
  end

  def withdraw
    if !current_user.outgoing_challenge.nil?
      current_user.outgoing_challenge.destroy
    end
    render :status
  end

  private

    def ensure_logged_in
      if !signed_in?
        redirect_to log_in_url
      end
    end
    
    def set_incoming_challenge
      challenger = User.find_by_username(params[:username])
      if (challenger && challenger.outgoing_challenge && challenger.outgoing_challenge.challengee == current_user)
        @challenge = challenger.outgoing_challenge
      end
    end
end
