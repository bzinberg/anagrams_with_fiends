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

  def state_before_turn_number(n)
    state = State.new
    turns.where(turn_number: (1..n-1)).each do |turn|
      state.register_turn(turn)
    end
    return state
  end

  def process_submitted_buildmorph(turn)
    # For builds and morphs, unlike flips, we assume a player wouldn't want to
    # "take back" his attempted move based on new developments in the game.
    # Also, we don't want users to be able to screw up the game by submitting a
    # build or morph with an earlier turn number than the current one.  Thus we
    # might as well do:
    turn.turn_number = next_turn_number

    state = state_before_turn_number(turn.turn_number)
    if state.register_turn(turn)
      turns.append(turn)
      save
      # TODO have something that increments and tries next turn number upon
      # save failure, to deal with races in the final product
      return state
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

    def initialize
      # if an entry is queried that doesn't exist, creates a new Set to fill
      # the entry
      @stashes = Hash.new {|h,key| h[key] = Set.new}
      @bag = initial_bag
      # We think of the pool as an array of characters
      @pool = ''
      @next_turn_number = 1

      # If there are errors, we will set this flag to false
      @valid = true
    end

    def register_turn(turn)
      case turn.class
      when Flip
        register_flip(turn)
      when Build
        register_build(turn)
      when Morph
        register_morph(turn)
      end
      @next_turn_number = turn.turn_number + 1
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
      if !(
        @pool.contain_anagram_of?(build.word) and
        # check whether word is in dictionary (or should this go in the
        # validation?)
        true # FIXME
      )
        @valid = false
        return false
      end

      @stashes[build.doer].add(build)
    end

    def register_morph(morph)
      need_from_pool = morph.word.charwise_remove(morph.changed_turn.word)
      if !(
        # TODO maybe validation should be done elsewhere
        morph.valid? and
        need_from_pool and
        # does the word we're trying to change still exist in a stash?
        @stashes[morph.changed_turn.doer].contain?(morph.changed_turn) and
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

end
