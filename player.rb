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
    bet = (game_state["current_buy_in"] - players[in_action]["bet"]) + 5
    rank = rank_hand(game_state)
    p "#{game_state["current_buy_in"]} - #{players[in_action]["bet"]} + 5 = #{bet}; rank #{rank}"
    if (rank > 6)
      bet += rank * Random.new.rand(69..72)
    elsif (rank > 0)
      bet += rank * Random.new.rand(18..23)
    elsif community_cards(game_state).empty? && pair?(our_hand(game_state))
      bet += 100
    elsif community_cards(game_state).empty? && is_dmitracof_zero(game_state)
      bet = bet > 222 ? 0 : bet
    else
      bet = 0
    end
    p "result bet #{bet}"
    bet
  end

  def is_dmitracof_zero(game_state)
    dmitracof_team = players.select{ |team|
      team["name"] == "DmitracoffAndCompany"
    }.first
    dmitracof_team["stack"] == 0
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
    full_cards = community_cards(game_state) + our_hand(game_state)
    if full_cards.size < 5
      return 0
    end
    puts full_cards.inspect

    respond = HTTParty.get('http://rainman.leanpoker.org/rank',
                           headers: {'Content-Type' => 'application/x-www-form-urlencoded'},
                           body: "cards=#{CGI.escape(full_cards.to_json)}"
                          )
    JSON.parse(respond)['rank']
  end

  def pair?(cards)
    cards[0]["rank"] == cards[1]["rank"]
  end

end
