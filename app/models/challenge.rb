# Author: Ben

class Challenge < ActiveRecord::Base
  belongs_to :challenger, class_name: 'User', foreign_key: 'challenger_id'
  belongs_to :challengee, class_name: 'User', foreign_key: 'challengee_id'

  def pending?
    self.accepted.nil?
  end

  def rejected?
    self.accepted == false
  end

  def reject!
    self.accepted = false
    save
  end
end
