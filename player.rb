
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

  def pair?(cards)
    cards[0]["rank"] == cards[1]["rank"]
  end

    # def rank_hand(our_hand(game_state))

    # end

  def royal_flash?(cards)
    royal_flash_queue = ["A", "K", "Q", "J", "10"]
    royal_flash_container = []
    default_suit = cards[0]["suit"]

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

    return keys_five_card.count >= 1
  end
end
