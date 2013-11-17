class User < ActiveRecord::Base
  belongs_to :table, inverse_of: :fiends
  has_secure_password
  validates :username, presence: true, uniqueness: true
  has_many :turns

  # Have self request a flip at the next turn number, and have self.table check
  # whether it's time to grant the request (i.e., whether all other users have
  # also requested a flip at the next turn number).
  def request_flip!(turn_number)
    self.flip_request_turn_number = turn_number
    # TODO Do we have to save self to db before running this?  Test.
    # (Apparently we do; also, if table.fiends has already been loaded to
    # memory, we may have to run table.fiends.reload)
    save
    table.register_flip_requests
  end

  def submit_build(word)
    build = Build.new(doer: self, word: word, table: table)
    puts "Upon submit: #{word}, #{build.word}"
    table.process_submitted_buildmorph(build)
  end

  def submit_morph(changed_turn, word)
    puts "Classes: changed_turn #{changed_turn.class}"
    morph = Morph.new(doer: self, changed_turn: changed_turn, word: word, table: table)
    puts "Oh btw, I'm trying to submit a morph of #{changed_turn.word} into #{word}"
    table.process_submitted_buildmorph(morph)
  end

  # Find all matches and partial matches of the username
  def self.search username
	   User.where("username like ?","%"+username.to_s+"%");
  end
end
