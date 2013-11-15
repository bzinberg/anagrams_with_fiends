class User < ActiveRecord::Base
  belongs_to :table, inverse_of: :fiends
  has_many :turns

  # Have self request a flip at the next turn number, and have self.table check
  # whether it's time to grant the request (i.e., whether all other users have
  # also requested a flip at the next turn number).
  def request_flip!
    self.flip_request_turn_number = table.next_turn_number
    # TODO Do we have to save self to db before running this?  Test.
    # (Apparently we do; also, if table.fiends has already been loaded to
    # memory, we may have to run table.fiends.reload)
    save
    table.register_flip_requests
  end

end
