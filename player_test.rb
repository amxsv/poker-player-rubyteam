require './test_helper'

class PlayerTest < Test::Unit::TestCase
  def setup
    @player = Player.new
  end

  def test_rank
    game_state = "hui"
    hand = @player.say(game_state)
    assert { hand == "huiui" }
  end
end
