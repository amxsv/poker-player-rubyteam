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
      brank = bear_rank(game_state)
      if brank >= 3 && rank < bear_rank
        bet = 0
      else
        bet += rank * Random.new.rand(18..23)
      end
    elsif community_cards(game_state).empty? && is_dmitracof_zero(game_state)
      bet = bet > 222 ? 0 : bet
    elsif community_cards(game_state).empty? && pair?(our_hand(game_state))
      bet += 100
    else
      bet = 0
    end
    p "result bet #{bet}"
    bet
  end

  def bear_rank(game_state)
    team = get_team_by_name(game_state, "Comfortable Bear")
    if team["bet"] < 250
      rank = 0
    else
      rank = team["bet"] / 100
    end

    rank
  end

  def is_dmitracof_zero(game_state)
    dmitracof_team = get_team_by_name(game_state, "DmitracoffAndCompany")
    dmitracof_team["stack"] == 0
  end

  def get_team_by_name(game_state, name)
    players = game_state["players"]
    players.select{ |team|
      team["name"] == name
    }.first
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
    if royal_flash?(full_cards)
      return 10
    end
    if full_cards.size < 5
      return 0
    end

    respond = HTTParty.get('http://rainman.leanpoker.org/rank',
                           headers: {'Content-Type' => 'application/x-www-form-urlencoded'},
                           body: "cards=#{CGI.escape(full_cards.to_json)}"
                          )
    JSON.parse(respond)['rank']
  end

  def pair?(cards)
    cards[0]["rank"] == cards[1]["rank"]
  end

  def royal_flash?(cards)
    royal_flash_queue = ["A", "K", "Q", "J", "10"]
    royal_flash_container = []

    for card in cards
      if (royal_flash_queue.include?(card["rank"]))
        royal_flash_container.push(card)
      end
    end

    if (royal_flash_container.length < 5)
      return false;
    end

    filtered = royal_flash_container.reduce({}) do |acc, item|
      if acc[item['suit']].nil?
        acc[item['suit']] = [item]
      else
        acc[item['suit']] << item
      end
      acc
    end

    keys_five_card = filtered.keys.select do |key|
      filtered[key].count == 5
    end

    if keys_five_card.count >= 1
      all_ranks = filtered[keys_five_card.first].map do |card|
        card['rank']
      end
      all_ranks.uniq.count == 5
    else
      false
    end
  end
end
