require './test_helper'

class PlayerTest < Test::Unit::TestCase
  def setup
    @player = Player.new
  end

  def test_get_our_hand
    game_state = {"tournament_id"=>"571260c407f6720003000002",
      "game_id"=>"571c6c75368a420003000029",
      "round"=>87,
      "players"=>[
        {"name"=>"DedicatedTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default C# folding player", "id"=>0},
        {"name"=>"RubyTeam", "stack"=>5267, "status"=>"active", "bet"=>0,
          "hole_cards"=>[{"rank"=>"8", "suit"=>"diamonds"}, {"rank"=>"Q", "suit"=>"hearts"}], "version"=>"SuperRubyTeam", "id"=>1},
        {"name"=>"Comfortable Bear", "stack"=>400, "status"=>"active", "bet"=>15, "version"=>"Default Ruby folding player", "id"=>2},
        {"name"=>"DmitracoffAndCompany", "stack"=>642, "status"=>"active", "bet"=>30, "version"=>"Default C++ folding player", "id"=>3},
        {"name"=>"POXEP", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"POHER", "id"=>4},
        {"name"=>"JSTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default JavaScript folding player", "id"=>5},
        {"name"=>"Pasha Team", "stack"=>646, "status"=>"folded", "bet"=>0, "version"=>"Default Go folding player", "id"=>6}],
        "small_blind"=>15, "big_blind"=>30, "orbits"=>12, "dealer"=>1, "community_cards"=>[],
        "current_buy_in"=>30, "pot"=>45, "in_action"=>1, "minimum_raise"=>15, "bet_index"=>6}
    hand = @player.our_hand(game_state)
    assert { hand == [{"rank"=>"8", "suit"=>"diamonds"}, {"rank"=>"Q", "suit"=>"hearts"}] }
  end

  def test_check_exception
    bet = @player.bet_request("")
    assert { bet == 0 }
  end

  def test_call_bet
    game_state = {"tournament_id"=>"571260c407f6720003000002", "game_id"=>"571c6c75368a420003000029", "round"=>87, "players"=>[{"name"=>"DedicatedTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default C# folding player", "id"=>0}, {"name"=>"RubyTeam", "stack"=>5267, "status"=>"active", "bet"=>0, "hole_cards"=>[{"rank"=>"8", "suit"=>"diamonds"}, {"rank"=>"Q", "suit"=>"hearts"}], "version"=>"SuperRubyTeam", "id"=>1}, {"name"=>"Comfortable Bear", "stack"=>400, "status"=>"active", "bet"=>15, "version"=>"Default Ruby folding player", "id"=>2}, {"name"=>"DmitracoffAndCompany", "stack"=>642, "status"=>"active", "bet"=>30, "version"=>"Default C++ folding player", "id"=>3}, {"name"=>"POXEP", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"POHER", "id"=>4}, {"name"=>"JSTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default JavaScript folding player", "id"=>5}, {"name"=>"Pasha Team", "stack"=>646, "status"=>"folded", "bet"=>0, "version"=>"Default Go folding player", "id"=>6}], "small_blind"=>15, "big_blind"=>30, "orbits"=>12, "dealer"=>1, "community_cards"=>[], "current_buy_in"=>30, "pot"=>45, "in_action"=>1, "minimum_raise"=>15, "bet_index"=>6}
    bet = @player.call_bet(game_state)
    assert { bet == 31 }
  end

  def test_call_bet_many
    game_state = {"tournament_id"=>"571260c407f6720003000002", "game_id"=>"571c6c75368a420003000029", "round"=>87, "players"=>[{"name"=>"DedicatedTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default C# folding player", "id"=>0}, {"name"=>"RubyTeam", "stack"=>5267, "status"=>"active", "bet"=>0, "hole_cards"=>[{"rank"=>"8", "suit"=>"diamonds"}, {"rank"=>"Q", "suit"=>"hearts"}], "version"=>"SuperRubyTeam", "id"=>1}, {"name"=>"Comfortable Bear", "stack"=>400, "status"=>"active", "bet"=>15, "version"=>"Default Ruby folding player", "id"=>2}, {"name"=>"DmitracoffAndCompany", "stack"=>642, "status"=>"active", "bet"=>200, "version"=>"Default C++ folding player", "id"=>3}, {"name"=>"POXEP", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"POHER", "id"=>4}, {"name"=>"JSTeam", "stack"=>0, "status"=>"out", "bet"=>0, "version"=>"Default JavaScript folding player", "id"=>5}, {"name"=>"Pasha Team", "stack"=>646, "status"=>"folded", "bet"=>0, "version"=>"Default Go folding player", "id"=>6}], "small_blind"=>15, "big_blind"=>30, "orbits"=>12, "dealer"=>1, "community_cards"=>[], "current_buy_in"=>200, "pot"=>45, "in_action"=>1, "minimum_raise"=>15, "bet_index"=>6}
    bet = @player.call_bet(game_state)
    assert { bet == 0 }
  end

end
