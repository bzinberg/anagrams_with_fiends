class Challenge < ActiveRecord::Base
  belongs_to :challenger, class_name: 'User', foreign_key: 'challenger_id', dependent: :destroy
  belongs_to :challengee, class_name: 'User', foreign_key: 'challengee_id'

  def pending?
    challenge_status.nil?
  end

  def rejected?
    challenge_status == false
  end
end
