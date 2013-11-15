class Table < ActiveRecord::Base
  has_many :fiends, class_name: 'User'
  has_many :turns

  # One greater than the largest turn number of a turn at this
  # table, or 1 if this table has no turns
  def next_turn_number
    (turns.maximum(:turn_number) || 0) + 1
  end
end
