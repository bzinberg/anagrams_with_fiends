class Table < ActiveRecord::Base
  has_many :fiends, class_name: 'User', inverse_of: :table
  has_many :turns, inverse_of: :table

  # One greater than the largest turn number of a turn at this
  # table, or 1 if this table has no turns
  def next_turn_number
    (turns.maximum(:turn_number) || 0) + 1
  end

  # Checks whether all fiends have requested a flip at the next turn number. If
  # so, creates the requested flip.
  def register_flip_requests
    n = next_turn_number
    if fiends.all? {|u| u.flip_request_turn_number == n}
      flip = Flip.new(turn_number: n)
      turns.append(flip)
    end
  end

end
