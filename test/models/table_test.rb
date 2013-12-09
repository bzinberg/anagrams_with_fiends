# @author jiangty
require 'test_helper'

class TableTest < ActiveSupport::TestCase
  def test_create_singleplayer_table
    _user = User.create(username: "_test_user_1", password: "password", password_confirmation: "password")
    _user.save(validate: false)

    _table = Table.create(fiends: [_user])
    _table.save(validate: false)

    assert _table.fiends.length == 1
    assert _table.fiends[0] == _user
    assert !_table.uuid.nil?
    assert _table.current_state.bag.length == _table.initial_bag.length
  end

  def test_create_multiplayer_table
    _user1 = User.create(username: "_test_user_1", password: "password", password_confirmation: "password")
    _user1.save(validate: false)
    _user2 = User.create(username: "_test_user_2", password: "password", password_confirmation: "password")
    _user2.save(validate: false)

    _table = Table.create(fiends: [_user1, _user2])
    _table.save(validate: false)

    assert _table.fiends.length == 2
    assert _table.fiends[0] == _user1
    assert _table.fiends[1] == _user2
    assert !_table.uuid.nil?
  end

  def test_game_moves
    _user = User.create(username: "_test_user_1", password: "password", password_confirmation: "password")
    _user.save(validate: false)

    testbag = 'rubyeonrails'

    _table = Table.create(fiends: [_user])
    _table.initial_bag = testbag 
    _table.save(validate: false)

    # initial game state
    assert _table.current_state.next_turn_number == 1
    assert _table.current_state.valid
    assert _table.current_state.score == 0
    assert _table.current_state.bag.length == _table.initial_bag.length
    assert _table.current_state.stashes[_user].length == 0

    # flip 4 tiles, 'r', 'u', 'b', 'y'
    [1,2,3,4].each {|i| _user.request_flip!(i)}

    # pool should have grown, bag decreased, and it's now turn 5
    assert _table.current_state.pool.length == 4
    assert _table.current_state.bag.length == _table.initial_bag.length-4
    assert _table.current_state.next_turn_number == 5

    # attempt two bad builds: "incorrect letters," "not a word"
    assert !_user.submit_build('rails')
    assert !_user.submit_build('yrub')

    # make sure nothing changed
    assert _table.current_state.next_turn_number == 5
    assert _table.current_state.score == -1
    assert _table.current_state.pool.length == 4
    assert _table.current_state.bag.length == _table.initial_bag.length-4
    assert _table.current_state.stashes[_user].length == 0

    # attempt good build
    assert _user.submit_build('ruby')

    # check that things changed
    assert _table.current_state.next_turn_number == 6
    assert _table.current_state.score == 5
    assert _table.current_state.pool.length == 0
    assert _table.current_state.bag.length == _table.initial_bag.length-4
    assert _table.current_state.stashes[_user].length == 1

    # flip 'e'
    _user.request_flip!(6)

    # get turn object corresponding to the word 'ruby' in the stash
    _turnobj = _table.current_state.stashes[_user].to_a[0]

    # attempt bad morphs: "word not contained in stash+pool", "not a word"
    assert !_user.submit_morph(_turnobj, 'buyers')
    assert !_user.submit_morph(_turnobj, 'rbuye')

    # check that nothing changed
    assert _table.current_state.next_turn_number == 7
    assert _table.current_state.score == 5
    assert _table.current_state.pool.length == 1
    assert _table.current_state.bag.length == _table.initial_bag.length-5
    assert _table.current_state.stashes[_user].length == 1

    # attempt good morph
    assert _user.submit_morph(_turnobj, 'buyer')

    # check that nothing changed
    assert _table.current_state.next_turn_number == 8
    assert _table.current_state.score == 11
    assert _table.current_state.pool.length == 0
    assert _table.current_state.bag.length == _table.initial_bag.length-5
    assert _table.current_state.stashes[_user].length == 1
  end

  def test_multiplayer_game_moves
    _user = User.create(username: "_test_user_1", password: "password", password_confirmation: "password")
    _user.save(validate: false)
    _user2 = User.create(username: "_test_user_2", password: "password", password_confirmation: "password")
    _user2.save(validate: false)

    testbag = 'rubyeonrails'

    _table = Table.create(fiends: [_user, _user2])
    _table.initial_bag = testbag 
    _table.save(validate: false)

    # initial game state
    assert _table.current_state.next_turn_number == 1
    assert _table.current_state.valid
    assert _table.current_state.bag.length == _table.initial_bag.length
    assert _table.current_state.stashes[_user].length == 0
    assert _table.current_state.stashes[_user2].length == 0

    # flip 4 tiles, 'r', 'u', 'b', 'y'
    [1,2,3,4].each {|i| 
        _user.request_flip!(i) 
        assert _table.current_state.next_turn_number == i
        _user2.request_flip!(i)
        assert _table.current_state.next_turn_number == i+1
    }

    # pool should have grown, bag decreased
    assert _table.current_state.pool.length == 4
    assert _table.current_state.bag.length == _table.initial_bag.length-4

    # attempt two bad builds: "incorrect letters," "not a word"
    assert !_user2.submit_build('rails')
    assert !_user.submit_build('yrub')

    # make sure nothing changed
    assert _table.current_state.next_turn_number == 5
    assert _table.current_state.pool.length == 4
    assert _table.current_state.bag.length == _table.initial_bag.length-4
    assert _table.current_state.stashes[_user].length == 0
    assert _table.current_state.stashes[_user2].length == 0

    # attempt good build with one user
    assert _user2.submit_build('ruby')

    # check that things changed
    assert _table.current_state.next_turn_number == 6
    assert _table.current_state.pool.length == 0
    assert _table.current_state.bag.length == _table.initial_bag.length-4
    assert _table.current_state.stashes[_user].length == 0
    assert _table.current_state.stashes[_user2].length == 1

    # flip 'e'
    _user.request_flip!(6)
    _user2.request_flip!(6)

    # get turn object corresponding to the word 'ruby' in the stash
    _turnobj = _table.current_state.stashes[_user2].to_a[0]

    # attempt bad morphs: "word not contained in stash+pool", "not a word"
    assert !_user.submit_morph(_turnobj, 'buyers')
    assert !_user.submit_morph(_turnobj, 'rbuye')

    # check that nothing changed
    assert _table.current_state.next_turn_number == 7
    assert _table.current_state.pool.length == 1
    assert _table.current_state.bag.length == _table.initial_bag.length-5
    assert _table.current_state.stashes[_user].length == 0
    assert _table.current_state.stashes[_user2].length == 1

    # attempt good morph
    assert _user.submit_morph(_turnobj, 'buyer')

    # check that nothing changed
    assert _table.current_state.next_turn_number == 8
    assert _table.current_state.pool.length == 0
    assert _table.current_state.bag.length == _table.initial_bag.length-5
    assert _table.current_state.stashes[_user].length == 1
    assert _table.current_state.stashes[_user2].length == 0
  end

end
