require './test_helper'

class PlayerTest < Test::Unit::TestCase
  def setup
    @player = Player.new
    @game_state = {"tournament_id"=>"571260c407f6720003000002",
      "game_id"=>"571c6c75368a420003000029",
      "round"=>87,
      "players"=>[
        {"name"=>"DedicatedTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default C# folding player", "id"=>0},
        {"name"=>"RubyTeam", "stack"=>5267, "status"=>"active", "bet"=>0,
          "hole_cards"=>[{"rank"=>"8", "suit"=>"diamonds"}, {"rank"=>"Q", "suit"=>"hearts"}], "version"=>"SuperRubyTeam", "id"=>1},
        {"name"=>"Comfortable Bear", "stack"=>400, "status"=>"active", "bet"=>300, "version"=>"Default Ruby folding player", "id"=>2},
        {"name"=>"DmitracoffAndCompany", "stack"=>642, "status"=>"active", "bet"=>30, "version"=>"Default C++ folding player", "id"=>3},
        {"name"=>"POXEP", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"POHER", "id"=>4},
        {"name"=>"JSTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default JavaScript folding player", "id"=>5},
        {"name"=>"Pasha Team", "stack"=>646, "status"=>"folded", "bet"=>0, "version"=>"Default Go folding player", "id"=>6}],
        "small_blind"=>15, "big_blind"=>30, "orbits"=>12, "dealer"=>1,
        "community_cards"=>[{"rank"=>"10", "suit"=>"diamonds"}, {"rank"=>"9", "suit"=>"spades"},
          {"rank"=>"9", "suit"=>"hearts"}, {"rank"=>"8", "suit"=>"spades"},
          {"rank"=>"Q", "suit"=>"diamonds"}],
        "current_buy_in"=>30, "pot"=>45, "in_action"=>1, "minimum_raise"=>15, "bet_index"=>6}
    @game_state_start = {"tournament_id"=>"571260c407f6720003000002",
      "game_id"=>"571c6c75368a420003000029",
      "round"=>87,
      "players"=>[
        {"name"=>"DedicatedTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default C# folding player", "id"=>0},
        {"name"=>"RubyTeam", "stack"=>5267, "status"=>"active", "bet"=>0,
          "hole_cards"=>[{"rank"=>"8", "suit"=>"diamonds"}, {"rank"=>"8", "suit"=>"hearts"}], "version"=>"SuperRubyTeam", "id"=>1},
        {"name"=>"Comfortable Bear", "stack"=>400, "status"=>"active", "bet"=>15, "version"=>"Default Ruby folding player", "id"=>2},
        {"name"=>"DmitracoffAndCompany", "stack"=>642, "status"=>"active", "bet"=>30, "version"=>"Default C++ folding player", "id"=>3},
        {"name"=>"POXEP", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"POHER", "id"=>4},
        {"name"=>"JSTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default JavaScript folding player", "id"=>5},
        {"name"=>"Pasha Team", "stack"=>646, "status"=>"folded", "bet"=>0, "version"=>"Default Go folding player", "id"=>6}],
        "small_blind"=>15, "big_blind"=>30, "orbits"=>12, "dealer"=>1,
        "community_cards"=>[],
        "current_buy_in"=>30, "pot"=>45, "in_action"=>1, "minimum_raise"=>15, "bet_index"=>6}
  end

  def test_get_our_hand
    hand = @player.our_hand(@game_state)
    assert { hand == [{"rank"=>"8", "suit"=>"diamonds"}, {"rank"=>"Q", "suit"=>"hearts"}] }
  end

  def test_dmitracoff
    zero = @player.is_dmitracof_zero(@game_state_start)
    assert { !zero }
  end

  def test_bear_rank
    rank = @player.bear_rank(@game_state)
    assert { rank == 3 }
  end

  def test_get_community_hands
    community_cards = @player.community_cards(@game_state)
    assert { community_cards == [{"rank"=>"10", "suit"=>"diamonds"}, {"rank"=>"9", "suit"=>"spades"}, {"rank"=>"9", "suit"=>"hearts"}, {"rank"=>"8", "suit"=>"spades"}, {"rank"=>"Q", "suit"=>"diamonds"}] }
  end

  def test_check_exception
    bet = @player.bet_request("")
    assert { bet == 0 }
  end

  def test_call_bet
    game_state = {"tournament_id"=>"571260c407f6720003000002", "game_id"=>"571c6c75368a420003000029", "round"=>87, "players"=>[{"name"=>"DedicatedTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default C# folding player", "id"=>0}, {"name"=>"RubyTeam", "stack"=>5267, "status"=>"active", "bet"=>0, "hole_cards"=>[{"rank"=>"8", "suit"=>"diamonds"}, {"rank"=>"Q", "suit"=>"hearts"}], "version"=>"SuperRubyTeam", "id"=>1}, {"name"=>"Comfortable Bear", "stack"=>400, "status"=>"active", "bet"=>15, "version"=>"Default Ruby folding player", "id"=>2}, {"name"=>"DmitracoffAndCompany", "stack"=>642, "status"=>"active", "bet"=>30, "version"=>"Default C++ folding player", "id"=>3}, {"name"=>"POXEP", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"POHER", "id"=>4}, {"name"=>"JSTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default JavaScript folding player", "id"=>5}, {"name"=>"Pasha Team", "stack"=>646, "status"=>"folded", "bet"=>0, "version"=>"Default Go folding player", "id"=>6}], "small_blind"=>15, "big_blind"=>30, "orbits"=>12, "dealer"=>1, "community_cards"=>[{"rank"=>"7", "suit"=>"diamonds"}, {"rank"=>"4", "suit"=>"diamonds"}, {"rank"=>"K", "suit"=>"spades"}], "current_buy_in"=>30, "pot"=>45, "in_action"=>1, "minimum_raise"=>15, "bet_index"=>6}
    bet = @player.call_bet(game_state)
    assert { bet == 0 }
  end

  def test_call_bet_rank_7
    game_state = {"tournament_id"=>"571260c407f6720003000002", "game_id"=>"571c6c75368a420003000029", "round"=>87, "players"=>[{"name"=>"DedicatedTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default C# folding player", "id"=>0}, {"name"=>"RubyTeam", "stack"=>5267, "status"=>"active", "bet"=>0, "hole_cards"=>[{"rank"=>"K", "suit"=>"diamonds"}, {"rank"=>"Q", "suit"=>"hearts"}], "version"=>"SuperRubyTeam", "id"=>1}, {"name"=>"Comfortable Bear", "stack"=>400, "status"=>"active", "bet"=>15, "version"=>"Default Ruby folding player", "id"=>2}, {"name"=>"DmitracoffAndCompany", "stack"=>642, "status"=>"active", "bet"=>30, "version"=>"Default C++ folding player", "id"=>3}, {"name"=>"POXEP", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"POHER", "id"=>4}, {"name"=>"JSTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default JavaScript folding player", "id"=>5}, {"name"=>"Pasha Team", "stack"=>646, "status"=>"folded", "bet"=>0, "version"=>"Default Go folding player", "id"=>6}], "small_blind"=>15, "big_blind"=>30, "orbits"=>12, "dealer"=>1, "community_cards"=>[{"rank"=>"K", "suit"=>"diamonds"}, {"rank"=>"K", "suit"=>"diamonds"}, {"rank"=>"K", "suit"=>"spades"}], "current_buy_in"=>30, "pot"=>45, "in_action"=>1, "minimum_raise"=>15, "bet_index"=>6}
    bet = @player.call_bet(game_state)
    assert { bet >= 515 && bet <= 539}
  end

  # def test_call_bet_many
  #   game_state = {"tournament_id"=>"571260c407f6720003000002", "game_id"=>"571c6c75368a420003000029", "round"=>87, "players"=>[{"name"=>"DedicatedTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default C# folding player", "id"=>0}, {"name"=>"RubyTeam", "stack"=>5267, "status"=>"active", "bet"=>0, "hole_cards"=>[{"rank"=>"8", "suit"=>"diamonds"}, {"rank"=>"Q", "suit"=>"hearts"}], "version"=>"SuperRubyTeam", "id"=>1}, {"name"=>"Comfortable Bear", "stack"=>400, "status"=>"active", "bet"=>15, "version"=>"Default Ruby folding player", "id"=>2}, {"name"=>"DmitracoffAndCompany", "stack"=>642, "status"=>"active", "bet"=>200, "version"=>"Default C++ folding player", "id"=>3}, {"name"=>"POXEP", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"POHER", "id"=>4}, {"name"=>"JSTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default JavaScript folding player", "id"=>5}, {"name"=>"Pasha Team", "stack"=>646, "status"=>"folded", "bet"=>0, "version"=>"Default Go folding player", "id"=>6}], "small_blind"=>15, "big_blind"=>30, "orbits"=>12, "dealer"=>1, "community_cards"=>[{"rank"=>"7", "suit"=>"diamonds"}, {"rank"=>"4", "suit"=>"diamonds"}, {"rank"=>"K", "suit"=>"spades"}], "current_buy_in"=>200, "pot"=>45, "in_action"=>1, "minimum_raise"=>15, "bet_index"=>6}
  #   bet = @player.call_bet(game_state)
  #   assert { bet == 0 }
  # end

  def test_rank_hand
    game_state = {"tournament_id"=>"571260c407f6720003000002", "game_id"=>"571c6c75368a420003000029", "round"=>87, "players"=>[{"name"=>"DedicatedTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default C# folding player", "id"=>0}, {"name"=>"RubyTeam", "stack"=>5267, "status"=>"active", "bet"=>0, "hole_cards"=>[{"rank"=>"8", "suit"=>"diamonds"}, {"rank"=>"Q", "suit"=>"hearts"}], "version"=>"SuperRubyTeam", "id"=>1}, {"name"=>"Comfortable Bear", "stack"=>400, "status"=>"active", "bet"=>15, "version"=>"Default Ruby folding player", "id"=>2}, {"name"=>"DmitracoffAndCompany", "stack"=>642, "status"=>"active", "bet"=>200, "version"=>"Default C++ folding player", "id"=>3}, {"name"=>"POXEP", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"POHER", "id"=>4}, {"name"=>"JSTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default JavaScript folding player", "id"=>5}, {"name"=>"Pasha Team", "stack"=>646, "status"=>"folded", "bet"=>0, "version"=>"Default Go folding player", "id"=>6}], "small_blind"=>15, "big_blind"=>30, "orbits"=>12, "dealer"=>1, "community_cards"=>[{"rank"=>"7", "suit"=>"diamonds"}, {"rank"=>"7", "suit"=>"diamonds"}, {"rank"=>"K", "suit"=>"spades"}], "current_buy_in"=>200, "pot"=>45, "in_action"=>1, "minimum_raise"=>15, "bet_index"=>6}
    rank_hand = @player.rank_hand(game_state)
    assert { rank_hand == 1 }
  end

  def test_is_pair
    cards = [
      {"rank"=>"9", "suit"=>"spades"},
      {"rank"=>"9", "suit"=>"hearts"}]
    assert { @player.pair?(cards) == true }
  end

  def test_is_pair2
    cards = [{"rank"=>"10", "suit"=>"diamonds"},
      {"rank"=>"9", "suit"=>"spades"}]
    assert { @player.pair?(cards) == false }
  end

  def test_rank_hand_lower_5
    game_state = {"tournament_id"=>"571260c407f6720003000002", "game_id"=>"571c6c75368a420003000029", "round"=>87, "players"=>[{"name"=>"DedicatedTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default C# folding player", "id"=>0}, {"name"=>"RubyTeam", "stack"=>5267, "status"=>"active", "bet"=>0, "hole_cards"=>[{"rank"=>"8", "suit"=>"diamonds"}, {"rank"=>"Q", "suit"=>"hearts"}], "version"=>"SuperRubyTeam", "id"=>1}, {"name"=>"Comfortable Bear", "stack"=>400, "status"=>"active", "bet"=>15, "version"=>"Default Ruby folding player", "id"=>2}, {"name"=>"DmitracoffAndCompany", "stack"=>642, "status"=>"active", "bet"=>200, "version"=>"Default C++ folding player", "id"=>3}, {"name"=>"POXEP", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"POHER", "id"=>4}, {"name"=>"JSTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default JavaScript folding player", "id"=>5}, {"name"=>"Pasha Team", "stack"=>646, "status"=>"folded", "bet"=>0, "version"=>"Default Go folding player", "id"=>6}], "small_blind"=>15, "big_blind"=>30, "orbits"=>12, "dealer"=>1, "community_cards"=>[{"rank"=>"4", "suit"=>"diamonds"}, {"rank"=>"K", "suit"=>"spades"}], "current_buy_in"=>200, "pot"=>45, "in_action"=>1, "minimum_raise"=>15, "bet_index"=>6}
    rank_hand = @player.rank_hand(game_state)
    assert { rank_hand == 0 }
  end

  def test_raise_when_pair
    assert { @player.call_bet(@game_state_start) == 135 }
  end
end
