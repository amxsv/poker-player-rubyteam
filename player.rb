require 'httparty'
require 'cgi'

class Player

  VERSION = "SuperRubyTeam call_bet"

  def say(h)
    "huiui"
  end

  def call_bet(game_state)
    in_action = game_state["in_action"]
    players = game_state["players"]
    bet = (game_state["current_buy_in"] - players[in_action]["bet"]) + 1
    bet = bet > 51 ? 0 : bet

    bet
  end

  def bet_request(game_state)
    p game_state
    # get_coefficient(game_state) * 1000
    call_bet(game_state)
  rescue Exception => e
    p "ERRORERROR, but we alive"
    p e.inspect
    0
  end

  def showdown(game_state)

  end

  def our_hand(game_state)
    our_team = game_state["players"].select { |team|
      team["name"] == "RubyTeam"
    }.first
    our_team["hole_cards"]
  end

  def community_cards(game_state)
    game_state["community_cards"]
  end

  def rank_hand(game_state)
    HTTParty.get('http://rainman.leanpoker.org/rank',
                 headers: {'Content-Type' => 'application/x-www-form-urlencoded'},
                 body: "cards=#{CGI.escape(our_hand(game_state).to_json)}"
                )
  end
end
