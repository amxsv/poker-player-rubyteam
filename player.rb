
class Player

  VERSION = "SuperRubyTeam"

  def bet_request(game_state)
    p game_state
    1000
  end

  def showdown(game_state)

  end

  class << self
    def our_hand(game_state)
      our_team = game_state["players"].select { |team|
        team["name"] == "RubyTeam"
      }.first
      our_team["hole_cards"]
    end

    def rank_hand(our_hand(game_state))
    end
  end
end
