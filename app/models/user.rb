class User < ActiveRecord::Base
  belongs_to :table, inverse_of: :fiends
  has_one :outgoing_challenge, class_name: 'Challenge', foreign_key: 'challenger_id'
  has_many :incoming_challenges, class_name: 'Challenge', foreign_key: 'challengee_id'
  has_secure_password
  validates :username, presence: true, uniqueness: true
  has_many :turns

  # If a user hasn't polled lobby in more than LOBBY_TIMEOUT seconds, he is
  # considered to "not be in the lobby."
  # TODO Change to something reasonable, like 5 or 10
  LOBBY_TIMEOUT = 100

  # Return the collection of online users
  def self.online
    where('last_lobby_poll >= ?', Time.now.to_i - LOBBY_TIMEOUT)
  end

  require 'saulabs/trueskill'
  include Saulabs::TrueSkill
  # for client-facing use
  def rank
    return self.rating_mean - 3*self.rating_deviation
  end

  # DON'T CONFUSE WITH RANK!
  # Returns a trueskill Rating object
  def rating
    return [Rating.new(self.rating_mean, self.rating_deviation)]
  end

  def rating=(new_rating)
    self.rating_mean = new_rating.mean
    self.rating_deviation = new_rating.deviation
    save
  end

  def set_challengee(other_user)
    challenge = Challenge.new(challenger: self, challengee: other_user)
    self.outgoing_challenge = challenge
    save
  end

  # Have self request a flip at the next turn number, and have self.table check
  # whether it's time to grant the request (i.e., whether all other users have
  # also requested a flip at the next turn number).
  def request_flip!(turn_number)
    self.flip_request_turn_number = turn_number
    # TODO Do we have to save self to db before running this?  Test.
    # (Apparently we do; also, if table.fiends has already been loaded to
    # memory, we may have to run table.fiends.reload)
    save
    return table.register_flip_requests
  end

  # Have self submit a request to 'build' the given word.  Returns false if the
  # build request was denied due to illegality.
  def submit_build(word)
    build = Build.new(doer: self, word: word, table: table)
    puts "Upon submit: #{word}, #{build.word}"
    return table.process_submitted_buildmorph(build)
  end

  # Have self submit a request to morph (i.e., 'swipe' or 'upgrade').  The
  # changed word is that created in changed_turn, and the word to create from
  # it is word.  Returns false if the morph request was denied due to
  # illegality.  Pre-condition: changed_turn is a turn that represents a word
  # that is currently in a player's stash in self.table.
  def submit_morph(changed_turn, word)
    puts "Classes: changed_turn #{changed_turn.class}"
    puts "Word: #{word}; Table: #{table.id}"
    morph = Morph.new(doer: self, changed_turn: changed_turn, word: word, table: table)
    puts "Oh btw, I'm trying to submit a morph of #{changed_turn.word} into #{word}"
    return table.process_submitted_buildmorph(morph)
  end

  # Find all matches and partial matches of the username
  def self.search username
	   User.where("username like ?","%"+username.to_s+"%");
  end
end
