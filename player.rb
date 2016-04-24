
class Player

  VERSION = "SuperRubyTeam"

  def say(h)
    "huiui"
  end

  def bet_request(game_state)
    p game_state
    # get_coefficient(game_state) * 1000
    300
  end

  def showdown(game_state)

  end

  def our_hand(game_state)
    our_team = game_state["players"].select { |team|
      team["name"] == "RubyTeam"
    }.first
    our_team["hole_cards"]
  end

    # def rank_hand(our_hand(game_state))

    # end
end
