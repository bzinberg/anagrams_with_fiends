class Challenge < ActiveRecord::Base
  belongs_to :challenger, class_name: 'User', foreign_key: 'challenger_id', dependent: :destroy
  belongs_to :challengee, class_name: 'User', foreign_key: 'challengee_id'

  def pending?
    accepted.nil?
  end

  def rejected?
    accepted == false
  end

  def reject!
    accepted = false
  end
end
