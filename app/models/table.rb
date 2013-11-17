class Table < ActiveRecord::Base
  require 'securerandom'

  INITIAL_BAG_LETTERS = 'jjkkqqxxzzbbbcccfffhhhmmmpppvvvwwwyyygggglllllddddddssssssuuuuuunnnnnnnntttttttttrrrrrrrrroooooooooooiiiiiiiiiiiiaaaaaaaaaaaaaeeeeeeeeeeeeeeeeee'
  has_many :fiends, class_name: 'User', inverse_of: :table
  has_many :turns, inverse_of: :table

  before_create :init_table

  # One greater than the largest turn number of a turn at this
  # table, or 1 if this table has no turns
  def next_turn_number
    (turns.maximum(:turn_number) || 0) + 1
  end

  # Checks whether all fiends have requested a flip at the next turn number. If
  # so, creates the requested flip.
  def register_flip_requests
    n = next_turn_number
    fiends.reload
    turns.reload
    if fiends.all? {|u| u.flip_request_turn_number == n}
      flip = Flip.new(turn_number: n)
      turns.append(flip)
      return true
    else
      return false
    end
  end

  def state_before_turn_number(n)
    state = State.new(self)
    turns.where(turn_number: (1..n-1)).each do |turn|
      state.register_turn(turn)
    end
    return state
  end

  def current_state
    state_before_turn_number(next_turn_number)
  end

  def process_submitted_buildmorph(turn)
    turns.reload
    # For builds and morphs, unlike flips, we assume a player wouldn't want to
    # "take back" his attempted move based on new developments in the game.
    # Also, we don't want users to be able to screw up the game by submitting a
    # build or morph with an earlier turn number than the current one.  Thus we
    # might as well do:
    turn.turn_number = next_turn_number

    # TODO this part is a bit messy
    state = state_before_turn_number(turn.turn_number)
    if state.register_turn(turn)
      turns.append(turn)
      if save
        return true
      else
        # TODO have something that increments and tries next turn number upon
        # save failure, to deal with races in the final product
        return false
      end
    else
      return false
    end
  end

  class State
    #TODO not finished yet
    attr_reader :next_turn_number
    attr_reader :valid
    def bag
      return String.new(@bag)
    end
    def pool
      return String.new(@pool)
    end
    def stashes
      # copy to avoid rep exposure
      return Hash[@stashes.map {|key,val| [key, Set.new(val)]}]
    end

    def initialize(table)
      @table = table
      # if an entry is queried that doesn't exist, creates a new Set to fill
      # the entry
      @stashes = Hash.new {|h,key| h[key] = Set.new}
      @bag = String.new(table.initial_bag)
      # We think of the pool as an array of characters
      @pool = ''
      @next_turn_number = 1

      # If there are errors, we will set this flag to false
      @valid = true
    end

    def register_turn(turn)
      # Because of ruby strangeness, we say "case turn" rather than "case
      # turn.class"
      case turn
      when Flip
        retval = register_flip
      when Build
        retval = register_build(turn)
      when Morph
        retval = register_morph(turn)
      end
      @next_turn_number = turn.turn_number + 1
      return retval
    end

    def register_flip
      if @bag.empty?
        @valid = false
        return false
      end
      @pool << @bag[0]
      @bag[0] = ''
    end

    def register_build(build)
      puts "Upon register_build: #{build.word}"
      if !(
        # check whether word is in dictionary (or should this go in the validation?)
        @pool.contain_anagram_of?(build.word) and true # FIXME
      )
        @valid = false
        return false
      end

      @stashes[build.doer].add(build)
      build.word.each_char do |c|
        @pool.sub!(c, '')
      end
    end

    def register_morph(morph)
      need_from_pool = morph.word.charwise_remove(morph.changed_turn.word)
      if !(
        # TODO maybe validation should be done elsewhere
        morph.valid? and
        need_from_pool and
        # does the word we're trying to change still exist in a stash?
        @stashes[morph.changed_turn.doer].include?(morph.changed_turn) and
        @pool.contain_anagram_of?(need_from_pool) and
        # TODO logic to check whether the change is not trivial (e.g.  no
        # change, or a simple pluralization) (or maybe this should go in the
        # validation?
        true # FIXME
      )
        @valid = false
        return false
      end

      @stashes[morph.changed_turn.doer].delete(morph.changed_turn)
      @stashes[morph.doer].add(morph)
      need_from_pool.each_char do |c|
        @pool.sub!(c, '')
      end
    end

  end

  # Generate a hash which can be passed to the client-side as json
  def to_h
    json = {}
    json['next_turn_number'] = next_turn_number
    state = current_state
    stashes_to_send = state.stashes.map do |user,turns|
      [user.username, turns.to_a.map{|turn| [turn.turn_number, turn.word]}] 
    end
    json['stashes'] =  Hash[stashes_to_send]
    json['pool'] = state.pool
    json['bag_size'] = state.bag.size
    return json
  end

  private
    
    def init_table
      self.uuid = SecureRandom.hex
      generate_initial_bag
    end

    def generate_initial_bag
        puts 'generating bag'
      self.initial_bag = INITIAL_BAG_LETTERS.split('').shuffle.join('')
    end

end
