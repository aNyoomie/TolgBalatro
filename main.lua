--- STEAMODDED HEADER
--- MOD_NAME: TOLG Content
--- MOD_ID: tolgContent
--- MOD_AUTHOR: [aNyoomie]
--- MOD_DESCRIPTION: New TOLG Themed Jokers, Deck and more! Also includes TOLG Themed Card Customization!
--- PREFIX: tolg
--- BADGE_COLOUR: 5EB631
--- PRIORITY: 9007199254740991
--- VERSION: 1.2.1

----------------------------------------------
------------MOD CODE -------------------------
TOLG = SMODS.current_mod
SMODS.Atlas { -- modicon
  key = 'modicon',
  path = 'tolgicon.png',
  px = 32,
  py = 32
}

SMODS.Atlas{
  key = 'Jokers',
  path = 'Jokers.png',
  px = 71,
  py = 95
  }

SMODS.Atlas({
  key = "tolgdeck",
  path = "tolgdeck.png",
  px = 71,
  py = 95
})

SMODS.Atlas({
  key = "tolgSpectral",
  path = "spectral.png",
  px = 71,
  py = 95
})

SMODS.Atlas{
  key = 'tolgVouchers',
  path = 'bless.png',
  px = 71,
  py = 95
  }

SMODS.Atlas{
  key = 'tolgSticker',
  path = 'sticker.png',
  px = 71,
  py = 95
  }

SMODS.Atlas{
  key = 'tolgSleeves',
  path = "sleeves.png",
	px = 73,
	py = 95
}

SMODS.Sound({
	key = "deltarune_explosion",
	path = "deltarune_explosion2.ogg",
})

-- Deck Skin
local atlas_key = 'tolg' -- Format: PREFIX_KEY
local atlas_path = 'CustomCards.png' -- Filename for the image in the asset folder
local atlas_path_hc = 'CustomCardsHC.png' -- Filename for the high-contrast version of the texture, if existing

local suits = {'clubs', 'diamonds', 'spades'} -- Which suits to replace
local otherranks = {"King", 'Queen', 'Jack'}
local clubsranks = {'Ace', 'King', 'Queen', 'Jack', '10', '9', '8', '7', '6', '5', '4', '3', '2'} -- Which ranks to replace
local description = "TOLG"
local rank = {}

SMODS.Atlas{  
  key = atlas_key..'_lc',
  px = 71,
  py = 95,
  path = atlas_path,
  prefix_config = {key = false}
}

SMODS.Atlas{  
    key = atlas_key..'_hc',
    px = 71,
    py = 95,
    path = atlas_path_hc,
    prefix_config = {key = false}
}

for _, suit in ipairs(suits) do
  if suit == 'clubs' then
    rank = clubsranks
  else
    rank = otherranks
  end
  SMODS.DeckSkin{
    key = suit.."_skin",
    suit = suit:gsub("^%l", string.upper),
    ranks = rank,
    lc_atlas = atlas_key..'_lc',
    hc_atlas = (atlas_path_hc and atlas_key..'_hc') or atlas_key..'_lc',
    loc_txt = {
      ['en-us'] = description
    },
    posStyle = 'deck'
  }
end

loc_colour('red')

SMODS.load_file('util/artists.lua')()

local BackApply_to_run_ref = Back.apply_to_run
function Back.apply_to_run(arg_56_0)
  BackApply_to_run_ref(arg_56_0)
  G.GAME.pool_flags.dontdothat = false
  if tolgMulti then
    G.GAME.pool_flags.balatmulti = true
  else
    G.GAME.pool_flags.balatmulti = false
  end
end

-- Melody
SMODS.Joker{
  key = 'melody',
  loc_txt = {
    name = 'Melody',
	  text = {
	    '{C:blue}-1{} hand',
	    '{C:green}Oops! All 6s {}effect',
	    'Retrigger all played {C:attention}6{}s'
    },
  },
  rarity = 2,
  cost = 6,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  tolg= true,
  atlas = 'Jokers',
  pos = {x = 8, y = 1},
  config = {extra = {h_plays = 1}},
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sketchy'}
		info_queue[#info_queue + 1] = G.P_CENTERS.j_oops
    if not center.ability.tolg_stick then
      info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
    end
  end,
  load = function(self, card, cardTable, other_card)
    local scale = 1
    card.T.h = card.T.h*scale*scale*(63/71)
    card.T.w = card.T.w*scale*scale*(63/71)
  end,
  set_ability = function(self, card, initial, delay_sprites)
    local scale = 1
    card.children.center.scale.y = (55/95)*card.children.center.scale.y
    card.children.center.scale.x = (63/71)*card.children.center.scale.x
    card.T.h = card.T.h*(55/95)*scale
    card.T.w = card.T.w*(63/71)*scale
  end,
  calculate = function(self,card,context)
    if context.cardarea == G.play then
      if context.other_card then
        if context.other_card:get_id() == 6 then
          if context.repetition then
            return {
              repetitions = 1,
              card = card,
              message = localize('k_again_ex')
            }
          else
            return {
              repetitions = 1,
              card = card
            }
          end
        end
      end
  end
  end,
  add_to_deck = function(self, card, from_debuff)
    for k, v in pairs(G.GAME.probabilities) do 
      G.GAME.probabilities[k] = v*2
    end
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.h_plays
    ease_hands_played(-card.ability.extra.h_plays)
  end,
  remove_from_deck = function(self, card, from_debuff)
    for k, v in pairs(G.GAME.probabilities) do 
      G.GAME.probabilities[k] = v/2
    end
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.h_plays
    ease_hands_played(card.ability.extra.h_plays)
  end
}

-- Ardric
SMODS.Joker{
  key = 'ardric',
  loc_txt = {
    name = 'Ardric',
	  text = {
	    'Disables effect of',
	    'every {C:attention}Boss Blind',
	    '{C:red}1 {C:green}in #1#{} {C:inactive}({C:green}#3#{C:inactive}x#2#){} chance this card',
      'is destroyed at end of round',
      '{C:inactive}(Probability scales on right side)'
    }
  },
  rarity = 2,
  cost = 5,
  unlocked = true,
  discovered = true,
  tolg= true,
  perishable_compat = true, 
  eternal_compat = false,
  atlas = 'Jokers',
  pos = {x = 1, y = 0},
  config = {extra = {odds = 10,jason=false},
  },
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'aqua'}
    if not center.ability.tolg_stick then
      info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
    end
    return {vars = {center.ability.extra.odds*(G.GAME.probabilities.normal or 1),center.ability.extra.odds,G.GAME.probabilities.normal}}
  end,
  calculate = function(self,card,context)
    if context.first_hand_drawn and not context.blueprint then
      card.ability.extra.jason = false
      if G.GAME.blind and G.GAME.blind:get_type() == 'Boss' then 
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
        G.GAME.blind:disable()
      end
    end
    if context.other_joker then
      if context.other_joker.config.center.key == 'j_tolg_jason' then
        card.ability.extra.jason = true
      end
    end
    if not context.repetition and not context.individual and not card.ability.extra.jason
    and pseudorandom('ardric') < 1/(G.GAME.probabilities.normal*card.ability.extra.odds)
    and context.end_of_round and not context.blueprint then
      G.E_MANAGER:add_event(Event({
        func = function()
          play_sound('tarot1')
          card.T.r = -0.2
          card:juice_up(0.3, 0.4)
          card.states.drag.is = true
          card.children.center.pinch.x = true
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            blockable = false,
            func = function()
              G.jokers:remove_card(card)
              card:remove()
              return true
            end
            }))
          return true
          end
      }))
      return {
        message = localize('k_extinct_ex')
      }
    elseif not context.repetition and not context.individual 
    and context.end_of_round and not context.blueprint then
      if card.ability.extra.jason then
        return {message = 'Protected!'}
      else
        return {message = localize('k_safe_ex')}
      end
    end
  end
}

-- Fish
SMODS.Joker{
  key = 'fish',
  loc_txt = {
    name = 'Fish',
    text={
      "Scored {C:attention}6{}s and {C:attention}8{}s give {X:mult,C:white} X#1# {} Mult",
      'raises Mult by {X:mult,C:white}X0.1{} at end of round',
      "{C:inactive} (Max of {X:mult,C:white}X#3#{C:inactive})"
    },
  },
  rarity = 3,
  cost = 6,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false, 
  eternal_compat = true,
  tolg= true,
  atlas = 'Jokers',
  pos = {x = 2, y = 0},
  config = {extra = {
    Xmult = 1.1,
    Xmult_bonus = 0.1,
    Xmult_cap = 1.75
    },
  },
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sketchy'}
    if not center.ability.tolg_stick then
      info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
    end
    return {vars = {center.ability.extra.Xmult,center.ability.extra.Xmult_bonus,center.ability.extra.Xmult_cap}}
  end,
  calculate = function(self,card,context)
    if context.end_of_round and not context.blueprint and not context.repetition and not context.individual
    and not (card.ability.extra.Xmult >= card.ability.extra.Xmult_cap) then
      if not (card.ability.extra.Xmult >= card.ability.extra.Xmult_cap) then
        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_bonus
        card.ability.extra.canLevel = false
        if card.ability.extra.Xmult >= card.ability.extra.Xmult_cap then
          card.ability.extra.Xmult = card.ability.extra.Xmult_cap
          return {
            card = card,
            message = 'Max Level!'
          }
        else
        return {
          card = card,
          message = localize('k_level_up_ex')
        }
        end
      else
        return {
          card = card,
          message = localize('k_nope_ex')
        }
        end
    end
    if context.cardarea == G.play then
      if context.other_card then
        if (context.other_card:get_id() == 8 or context.other_card:get_id() == 6) then
          return {
            x_mult = card.ability.extra.Xmult,
            card = card
          }
        end
      end
    end
  end
}

-- Olivia
SMODS.Joker{
  key = 'olivia',
  loc_txt = {
    name = 'Olivia',
	  text = {
      'This Joker gains {C:chips}+#1#{} Chips',
      'per scored {C:diamonds}Diamond{} card',
      'Spends {C:chips}#3#{} Chips to Prevent Death',
      '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)'
    }
  },
  rarity = 2,
  cost = 5,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  tolg= true,
  atlas = 'Jokers',
  pos = {x = 3, y = 0},
  config = {extra = {chip_bonus = 4, chips = 0, chip_cost = 300}},
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sketchy'}
    if not center.ability.tolg_stick then
      info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
    end
    return {vars = {center.ability.extra.chip_bonus,center.ability.extra.chips,center.ability.extra.chip_cost}}
  end,
  calculate = function(self,card,context)
    if context.individual and context.cardarea == G.play then
      if context.other_card:is_suit("Diamonds") and (not context.other_card.debuff) and not context.blueprint then
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_bonus
        return {
          extra = {focus = card, message = localize('k_upgrade_ex')},
          card = card,
          colour = G.C.CHIPS
        }
      end
    elseif context.joker_main then
      return{
        card = card,
        chip_mod = card.ability.extra.chips,
        message = '+' .. card.ability.extra.chips,
        colour = G.C.CHIPS
      }
    elseif context.game_over and card.ability.extra.chips >= card.ability.extra.chip_cost and not context.blueprint then
      card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_cost
      return {
        message = 'Revived!',
        saved = true,
        colour = G.C.Diamond
      }
    end
  end
}

-- Emiliana
SMODS.Joker{
  key = 'emiliana',
  loc_txt = {
    name = 'Emiliana',
	  text = {
	    'If {C:attention}first discard{} of round',
      'has {C:attention}#5#{} cards, each card has a',
      '{C:green}#1# in #2#{} chance to be destroyed',
      '{C:red}+#3#{} Mult per destroyed card',
      '{C:inactive}(Currently {C:red}+#4#{} {C:inactive}Mult)'
    }
  },
  rarity = 2,
  cost = 6,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false, 
  eternal_compat = true,
  tolg= true,
  atlas = 'Jokers',
  pos = {x = 4, y = 0},
  config = {extra = {odds = 5,mult=0,mult_mod=2,required=4},
  },
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'ssick'}
    info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
    return {vars = {G.GAME.probabilities.normal or 1,center.ability.extra.odds,
    center.ability.extra.mult_mod,center.ability.extra.mult,center.ability.extra.required}}
  end,
  calculate = function(self, card, context)
    if context.first_hand_drawn and not context.blueprint then
      local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end
    if context.discard and not context.blueprint then
      if G.GAME.current_round.discards_used == 0 and #context.full_hand == 4 then
        if pseudorandom('emi') < G.GAME.probabilities.normal/card.ability.extra.odds then
          card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
          return {
              remove = true,
              delay = 0.2,
              message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult_mod}},
              colour = G.C.RED
          }
        end
      end
    end
    if context.joker_main and card.ability.extra.mult > 0 then
      return {
        message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}, 
        colour = G.C.MULT,
        mult_mod = card.ability.extra.mult
      }
    end
  end
}

-- Cedric
SMODS.Joker{
  key = 'cedric',
  loc_txt = {
    name = 'Cedric',
	  text = {
      'Gains {C:chips}+#2#{} Chips when {C:attention}Blind{} is selected',
      'Dissapears after #4# rounds {C:inactive}({C:attention}#3#{C:inactive}/{C:attention}#4#{C:inactive})',
      'If found after, {C:chips}Chips{} carry over',
      '{C:inactive}(Currently {C:chips}+#1#{} {C:inactive}Chips)'
    }
  },
  rarity = 1,
  cost = 4,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false, 
  eternal_compat = false,
  tolg= true,
  atlas = 'Jokers',
  pos = {x = 5, y = 0},
  config = {extra = {chips = 0,chip_bonus=25,played_rounds=0,extinct=6}},
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'aqua'}
    if not center.ability.tolg_stick then
      info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
    end
    return {vars = {center.ability.extra.chips,center.ability.extra.chip_bonus,center.ability.extra.played_rounds,center.ability.extra.extinct}}
  end,
  calculate = function(self,card,context)
    if context.setting_blind and (not context.blueprint) then
      card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_bonus
      G.E_MANAGER:add_event(Event({
        func = (function()
          card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'),colour = G.C.CHIPS,})
        return true
      end)}))
      card.ability.extra.played_rounds = card.ability.extra.played_rounds + 1
    end
    if context.joker_main then
      if card.ability.extra.chips > 0 then
        return{
          card = card,
          chip_mod = card.ability.extra.chips,
          message = '+' .. card.ability.extra.chips,
          colour = G.C.CHIPS
        }
      end
    end
    if context.first_hand_drawn and (not context.blueprint) then
      local eval = function() return (card.ability.extra.played_rounds>card.ability.extra.extinct-1) and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end
    if not context.repetition and not context.individual and context.end_of_round 
    and not context.blueprint and (card.ability.extra.played_rounds>card.ability.extra.extinct-1) then
      G.GAME.pool_flags.cedric_carryover = card.ability.extra.chips
      G.E_MANAGER:add_event(Event({
        func = function()
          play_sound('tarot1')
          card.T.r = -0.2
          card:juice_up(0.3, 0.4)
          card.states.drag.is = true
          card.children.center.pinch.x = true
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            blockable = false,
            func = function()
              G.jokers:remove_card(card)
              card:remove()
              return true
            end
            }))
          return true
          end
      }))
      return {
        message = 'Gone!'
      }
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if G.GAME.pool_flags.cedric_carryover then
      if G.GAME.pool_flags.cedric_carryover > 0 then
        card.ability.extra.chips = G.GAME.pool_flags.cedric_carryover
        G.E_MANAGER:add_event(Event({
          func = (function()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'),colour = G.C.CHIPS,})
          return true
        end)}))
        end
        G.GAME.pool_flags.cedric_carryover = nil
      end
    end
}

-- Ave
SMODS.Joker{
  key = 'ave',
  loc_txt = {
    name = 'Ave',
	  text = {
      'When {C:attention}Blind{} is selected,',
	    'create a {C:dark_edition}Negative{} {C:attention}Bomb{}',
	    'Sell this card to create a number of',
      '{C:dark_edition}Negative{} {C:attention}Bombs{} equal to own {C:attention}sell value'
    }
  },
  rarity = 1,
  cost = 3,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = false,
  tolg= true,
  atlas = 'Jokers',
  pos = {x = 6, y = 0},
  config = {ave_check=true
  },
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sketchy'}
    info_queue[#info_queue + 1] = {generate_ui = tolg_joker_tooltip, key = 'bomb', title = 'Bomb'}
    if not center.ability.tolg_stick then
      info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
    end
  end,
  calculate = function(self,card,context)
    if context.setting_blind then
      local jokers_to_create = math.min(1,
        G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
      G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
      G.E_MANAGER:add_event(Event({
        func = function()
          local card = create_card('Joker', G.jokers, nil, 0, nil, nil,
            'j_tolg_bomb', nil)
          card.ability.tolg_stick = false
          local edition = {negative = true}
          card:set_edition(edition, true)
          card:add_to_deck()
          G.jokers:emplace(card)
          card:start_materialize()
          G.GAME.joker_buffer = 0
          return true
        end
      }))
    elseif context.selling_self and not context.blueprint then
      local bombs = 1+card.ability.extra_value
      if card.edition then
        if card.edition.foil then
          bombs = bombs+1
        elseif card.edition.holo then
          bombs = bombs+2
        elseif card.edition.negative or card.edition.polychrome then
          bombs = bombs+3
        end
      end
      for i=1,bombs do
        local jokers_to_create = math.min(1,
          G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
        G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
        G.E_MANAGER:add_event(Event({
          func = function()
            local card = create_card('Joker', G.jokers, nil, 0, nil, nil,
              'j_tolg_bomb', nil)
            local edition = {negative = true}
            card:set_edition(edition, true)
            card:add_to_deck()
            G.jokers:emplace(card)
            card:start_materialize()
            G.GAME.joker_buffer = 0
            return true
          end
        }))
      end
    end
  end
}

-- Advena
SMODS.Joker{
  key = 'advena',
  loc_txt = {
    name = 'Advena',
	  text = {
      '{C:green}#1# in #2#{} chance to',
      'Retrigger used {C:planet}Planet{} card,',
      'Gives {C:mult}+#3#{} Mult per unique',
      '{C:planet}Planet{} card used this run',
      '{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult)'
    }
  },
  rarity = 3,
  cost = 6,
  unlocked = true,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true, 
  eternal_compat = true,
  tolg= true,
  atlas = 'Jokers',
  pos = {x = 7, y = 0},
  config = {extra = {
    odds = 3,
    mult_bonus = 2
  }
  },
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sketchy'}
    if not center.ability.tolg_stick then
      info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
    end
    local planets_used = 0
      for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'Planet' then planets_used = planets_used + 1 end end
    return {vars = {G.GAME.probabilities.normal, center.ability.extra.odds,center.ability.extra.mult_bonus,planets_used*center.ability.extra.mult_bonus}}
  end,
  calculate = function(self,card,context)
    if context.consumeable and not context.blueprint then
			if context.consumeable.ability.set == "Planet" then
        if pseudorandom('adv') < G.GAME.probabilities.normal/card.ability.extra.odds then
          if context.consumeable.config.center.key == "c_mp_asteroid" then
            G.MULTIPLAYER.asteroid()
            card_eval_status_text(card, 'extra', nil, nil, nil,{message = 'Again!', nil})
          else
            card_eval_status_text(card, 'extra', nil, nil, nil,{message = 'Again!', nil})
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(context.consumeable.ability.consumeable.hand_type, 'poker_hands'),chips = G.GAME.hands[context.consumeable.ability.consumeable.hand_type].chips, mult = G.GAME.hands[context.consumeable.ability.consumeable.hand_type].mult, level=G.GAME.hands[context.consumeable.ability.consumeable.hand_type].level})
            level_up_hand(context.consumeable,context.consumeable.ability.hand_type)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
          end
          if next(find_joker("Constellation")) then
            for i, v in pairs(G.jokers.cards) do
              if v.ability.name ==  "Constellation" then
                v.ability.x_mult = v.ability.x_mult + v.ability.extra
                G.E_MANAGER:add_event(Event({
                  func = function() card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={v.ability.x_mult - v.ability.extra}}}); return true
                  end}))
                return
              end
            end
          return
          end
        else
          card_eval_status_text(card, 'extra', nil, nil, nil,{message = localize('k_nope_ex'), nil})
        end
      end
    end
    if context.joker_main then
      local planets_used = 0
      for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'Planet' then planets_used = planets_used + 1 end end
      if planets_used > 0 then
        return {
          message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult_bonus*planets_used}}, 
          colour = G.C.MULT,
          mult_mod = card.ability.extra.mult_bonus*planets_used
        }
      end
    end
  end
}

-- Bob
SMODS.Joker{
  key = 'bob',
  loc_txt = {
    name = 'Bob',
	  text = {
      "This Joker gains {C:mult}+#1#{} Mult",
      "per {C:attention}consecutive{} hand",
      "played without using",
      "a {C:attention}Discard{}",
      "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
    }
  },
  rarity = 1,
  cost = 5,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false, 
  eternal_compat = true,
  tolg= true,
  atlas = 'Jokers',
  pos = {x = 8, y = 0},
  config = {extra = {mult_bonus = 2, mult = 0}},
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'aqua'}
    if not center.ability.tolg_stick then
      info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
    end
    return {vars = {center.ability.extra.mult_bonus, center.ability.extra.mult}}
  end,
  calculate = function(self,card,context)
    if context.joker_main then
      card.ability.extra.mult = card.ability.extra.mult+card.ability.extra.mult_bonus
      return {
        message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}, 
        colour = G.C.MULT,
        mult_mod = card.ability.extra.mult
      }
    elseif context.discard and card.ability.extra.mult > 0 then
      card.ability.extra.mult = 0
      return {
        message = localize('k_reset')
      }
    end
  end
}

-- Jason
SMODS.Joker{
  key = 'jason',
  loc_txt = {
    name = 'Jason',
	  text = {
      'If {C:attention}Ardric{} is owned,',
      'this Joker becomes {C:dark_edition}Negative{}',
      'and {C:attention}Ardric{} will not be destroyed',
      '{C:red}+#1#{} Mult'
    }
  },
  rarity = 1,
  cost = 3,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 0, y = 0},
  config = {extra = {mult = 3,ardric=false}
  },
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'blurr'}
    info_queue[#info_queue + 1] = {generate_ui = tolg_joker_tooltip, key = 'ardric', title = 'Ardric'}
    return {vars = {center.ability.extra.mult}}
  end,
  calculate = function(self,card,context)
    if context.first_hand_drawn and not context.blueprint then
      card.ability.extra.ardric = false
    end
    if context.other_joker then
      if context.other_joker.config.center.key == 'j_tolg_ardric' then
        if not (card.edition and card.edition.negative) then
          local edition = {negative = true}
          card:set_edition(edition, true)
        end
        card.ability.extra.ardric = true
      end
    end
    if context.joker_main then
      return {
        message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}, 
        colour = G.C.MULT,
        mult_mod = card.ability.extra.mult
      }
    end
  end
}

-- Bone Melody
SMODS.Joker{
  key = 'melbone',
  loc_txt = {
    name = 'Melody (Bone Form)',
	  text = {
	    '{C:attention}+#2#{} hand size,',
	    '{C:red}-#1#{} discards each round',
    },
  },
  rarity = 2,
  cost = 7,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  tolg= true,
  atlas = 'Jokers',
  pos = {x = 6, y = 1},
  config = {extra = {discards = 2, h_size = 2}},
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'waffer'}
    if not center.ability.tolg_stick then
      info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
    end
    return {vars = {center.ability.extra.discards,center.ability.extra.h_size}}
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
    ease_discard(-card.ability.extra.discards)
    G.hand:change_size(card.ability.extra.h_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
    ease_discard(card.ability.extra.discards)
    G.hand:change_size(-card.ability.extra.h_size)
  end
}

-- Bomb
SMODS.Joker{
  key = 'bomb',
  loc_txt = {
    name = 'Bomb',
	  text = {
	    '{X:mult,C:white}X#1#{} Mult',
      'Destroyed at end of round',
      'Sell this card to add',
      '{C:money}$#2#{} of {C:attention}sell value{} to {C:attention}Ave{}'
    },
  },
  rarity = 1,
  cost = -2,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false, 
  eternal_compat = false,
  inpool = false,
  atlas = 'Jokers',
  pos = {x = 7, y = 1},
  config = {extra = {Xmult = 1.5,value_bonus=1}},
  yes_pool_flag = 'dontdothat',
  set_ability = function(self, card, initial, delay_sprites)
    card.children.center.scale.y = card.children.center.scale.x
    card.T.h = card.T.w
    card.T.w = card.T.w
  end,
  loc_vars = function(self,info_queue,center)
    return {vars = {center.ability.extra.Xmult,center.ability.extra.value_bonus}}
  end,
  calculate = function(self,card,context)
    if not (card.edition and card.edition.negative) then
      local edition = {negative = true}
      card:set_edition(edition, true)
    end
    if context.first_hand_drawn and (not context.blueprint) then
      local eval = function() return true and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end
    if not context.repetition and not context.individual and context.end_of_round and not context.blueprint then
      G.E_MANAGER:add_event(Event({
        func = function()
          play_sound('tolg_deltarune_explosion')
          card.T.r = -0.2
          card:juice_up(0.3, 0.4)
          card.states.drag.is = true
          card.children.center.pinch.x = true
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            blockable = false,
            func = function()
              G.jokers:remove_card(card)
              card:remove()
              return true
            end
            }))
          return true
          end
      }))
    elseif context.selling_self and not context.blueprint then
      for k, v in ipairs(G.jokers.cards) do
        if v.set_cost then 
          local checker = v.ability.ave_check or 0
          if checker==true then
            v.ability.extra_value = (v.ability.extra_value or 0) + card.ability.extra.value_bonus
            v:set_cost()
          end
        end
      end
    elseif context.joker_main then
      return{
        card = card,
        Xmult_mod = card.ability.extra.Xmult,
        message = 'X' .. card.ability.extra.Xmult .. ' Mult',
        colour = G.C.MULT
      }
    end
  end,
}

-- Copyvena
SMODS.Joker{
  key = 'copyvena',
  loc_txt = {
    name = 'Advena (Copy)',
	  text = {
      'Retriggers used {C:planet}Planet{} cards,',
      'Expires after #2# Retriggers {C:inactive}({C:attention}#1#{C:inactive}/{C:attention}#2#{C:inactive})'
    }
  },
  rarity = 1,
  cost = 3,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false, 
  eternal_compat = false,
  atlas = 'Jokers',
  pos = {x = 0, y = 2},
  config = {extra = {uses=0,extinct=3}},
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sketchy'}
    return {vars = {center.ability.extra.uses,center.ability.extra.extinct}}
  end,
  calculate = function(self,card,context)
    if context.consumeable and not context.blueprint then
			if context.consumeable.ability.set == "Planet" then
        if true then
          card.ability.extra.uses = card.ability.extra.uses+1
          if context.consumeable.config.center.key == "c_mp_asteroid" then
            G.MULTIPLAYER.asteroid()
            card_eval_status_text(card, 'extra', nil, nil, nil,{message = 'Again!', nil})
          else
            card_eval_status_text(card, 'extra', nil, nil, nil,{message = 'Again!', nil})
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(context.consumeable.ability.consumeable.hand_type, 'poker_hands'),chips = G.GAME.hands[context.consumeable.ability.consumeable.hand_type].chips, mult = G.GAME.hands[context.consumeable.ability.consumeable.hand_type].mult, level=G.GAME.hands[context.consumeable.ability.consumeable.hand_type].level})
            level_up_hand(context.consumeable,context.consumeable.ability.hand_type)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
          end
          if next(find_joker("Constellation")) then
            for i, v in pairs(G.jokers.cards) do
              if v.ability.name ==  "Constellation" then
                v.ability.x_mult = v.ability.x_mult + v.ability.extra
                G.E_MANAGER:add_event(Event({
                  func = function() card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={v.ability.x_mult - v.ability.extra}}}); return true
                  end}))
                return
              end
            end
          return
          end
          if card.ability.extra.uses == card.ability.extra.extinct then
            G.E_MANAGER:add_event(Event({
              func = function()
                play_sound('tarot1')
                card.T.r = -0.2
                card:juice_up(0.3, 0.4)
                card.states.drag.is = true
                card.children.center.pinch.x = true
                G.E_MANAGER:add_event(Event({
                  trigger = 'after',
                  delay = 0.3,
                  blockable = false,
                  func = function()
                    G.jokers:remove_card(card)
                    card:remove()
                    return true
                  end
                  }))
                return true
                end
            }))
            return {
              message = localize('k_extinct_ex')
            }
          end
        else
          card_eval_status_text(card, 'extra', nil, nil, nil,{message = localize('k_nope_ex'), nil})
        end
      end
    end
  end
}

-- Isla
SMODS.Joker{
  key = 'isla',
  loc_txt = {
    name = 'Isla',
	  text = {
      '{C:dark_edition}Team One Large Guy{}',
      'Jokers each give {X:mult,C:white} X#1# {} Mult',
      'and gain {C:money}$#2#{} of {C:attention}sell value',
      'at end of round'
    }
  },
  rarity = 2,
  cost = 7,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 2, y = 1},
  config = {extra = {
    Xmult = 1.5, value = 1,
  }
  },
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'espeon'}
    return {vars = {center.ability.extra.Xmult,center.ability.extra.value}}
  end,
  calculate = function(self,card,context)
    if context.setting_blind and (not context.blueprint) then
    end
    if context.other_joker then
      if context.other_joker.config.center.tolg or context.other_joker.ability.tolg_stick then
        G.E_MANAGER:add_event(Event({
          func = function()
            context.other_joker:juice_up(0.5, 0.5)
            return true
          end
        })) 
        return {
          message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
          Xmult_mod = card.ability.extra.Xmult}
      end
    end
    if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
      for k, v in ipairs(G.jokers.cards) do
        if v.set_cost and (v.config.center.tolg or v.ability.tolg_stick) then 
          v.ability.extra_value = (v.ability.extra_value or 0) + card.ability.extra.value
          v:set_cost()
          G.E_MANAGER:add_event(Event({
            func = function()
              v:juice_up(0.5, 0.5)
              return true
            end
          })) 
          card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_val_up'),colour = G.C.MONEY,})
        end
      end
    end
  end
}

-- Vesta
SMODS.Joker{
  key = 'vesta',
  loc_txt = {
    name = 'Vesta',
	  text = {
	    'Scored {C:attention}Wild Cards{}',
	    'give {X:mult,C:white} X#1# {} Mult'
    },
  },
  rarity = 2,
  cost = 6,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 5, y = 1},
  config = {extra = {x_mult = 1.5}},
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sketchy'}
		info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
    return {vars = {center.ability.extra.x_mult}}
  end,
  calculate = function(self,card,context)
    if context.cardarea == G.play then
      if context.other_card then
        if context.other_card.ability.name == "Wild Card" then
          return {
            x_mult = card.ability.extra.x_mult,
            card = card
          }
        end
      end
  end
  end
}

-- Cain
SMODS.Joker{
  key = 'cain',
  loc_txt = {
    name = 'Cain',
	  text = {
      'Creates a {C:tarot}Wheel of Fortune{} card',
      'when a {C:attention}face{} card is destroyed',
      'Gains {X:mult,C:white}X#1#{} Mult every',
	    'time {C:tarot}Wheel of Fortune{} is used',
	    '{C:inactive}(Currently {X:mult,C:white}X#2#{} {C:inactive}Mult)'
    }
  },
  rarity = 3,
  cost = 6,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 0, y = 1},
  config = {extra = {Xmult = 1,Xmult_bonus = 0.25}},
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sketchy'}
		info_queue[#info_queue + 1] = G.P_CENTERS.c_wheel_of_fortune
    return {vars = {center.ability.extra.Xmult_bonus,center.ability.extra.Xmult}}
  end,
  calculate = function(self,card,context)
    if context.joker_main and card.ability.extra.Xmult > 1 then return{
      card = card,
      Xmult_mod = card.ability.extra.Xmult,
      message = 'X' .. card.ability.extra.Xmult .. ' Mult',
      colour = G.C.MULT}
    end
    if context.consumeable then
			if context.consumeable.ability.name == "The Wheel of Fortune" then
				card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_bonus
				card_eval_status_text(card,"extra",nil,nil,nil,
					{ message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.Xmult } }) }
				)
				return nil, true
			end
		end
    if context.remove_playing_cards then
      if not context.blueprint then
        local face_cards = 0
        for k, val in ipairs(context.removed) do
          if val:is_face() then face_cards = face_cards + 1 end
        end
        if face_cards > 0 then
          for i=1,face_cards do
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
              local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_wheel_of_fortune', 'cain')
              card:add_to_deck()
              G.consumeables:emplace(card)
              card_eval_status_text(card, 'extra', nil, nil, nil,
                { message = localize('k_plus_tarot'), colour = G.C.SET.Tarot })
            end
          end
        end
      end
    end
  end
}

-- Eye
SMODS.Joker{
  key = 'eye',
  loc_txt = {
    name = 'The Great Eye',
	  text = {
      'After {C:attention}first hand{} of round,',
      'destroy Joker to the right',
      'and gain {C:attention}one-fifth{} of',
      'its sell value as {X:mult,C:white} XMult {}',
      '{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult)'
    }
  },
  rarity = 3,
  cost = 8,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 1, y = 1},
  config = {extra = {Xmult = 1}},
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sketchy'}
    return {vars = {center.ability.extra.Xmult}}
  end,
  calculate = function(self,card,context)
    if context.joker_main and card.ability.extra.Xmult > 1 then return{
      card = card,
      Xmult_mod = card.ability.extra.Xmult,
      message = 'X' .. card.ability.extra.Xmult .. ' Mult'}
    end
    if context.setting_blind and not context.blueprint then
      return{
        G.E_MANAGER:add_event(Event({
          func = (function()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = (localize('k_active_ex')),colour = G.C.FILTER})
          return true
        end)}))
      }
    elseif context.first_hand_drawn and (not context.blueprint) then
      local eval = function() return (G.GAME.current_round.hands_played == 0 == true) and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end
    if context.after and not context.blueprint and not context.repeatable then
      local my_pos = nil
      for i = 1, #G.jokers.cards do
          if G.jokers.cards[i] == card then my_pos = i; break end
      end
      if my_pos and G.jokers.cards[my_pos+1] and not card.getting_sliced and not G.jokers.cards[my_pos+1].ability.eternal 
      and not G.jokers.cards[my_pos+1].getting_sliced and G.GAME.current_round.hands_played == 0 then 
          local sliced_card = G.jokers.cards[my_pos+1]
          sliced_card.getting_sliced = true
          G.GAME.joker_buffer = G.GAME.joker_buffer - 1
          G.E_MANAGER:add_event(Event({func = function()
              G.GAME.joker_buffer = 0
              card.ability.extra.Xmult = card.ability.extra.Xmult + (sliced_card.sell_cost/5)
              card:juice_up(0.8, 0.8)
              sliced_card:start_dissolve({HEX("3f0d58")}, nil, 1.6)
              play_sound('slice1', 0.96+math.random()*0.08)
          return true end }))
          card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult+(sliced_card.sell_cost/5)}}, colour = G.C.Tarot, no_juice = true})
      end
  end
  end
}

-- Gab
SMODS.Joker{
  key = 'gab',
  loc_txt = {
    name = 'The DM',
	  text = {
      "{C:green}#1# in #2#{} chance to",
	    "Create a {C:dark_edition}Negative{} {C:attention}Joker",
      "with a {C:green}TOLG Sticker{}",
      "at the end of the {C:attention}shop"
    },
  },
  rarity = 4,
  cost = 20,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false, 
  eternal_compat = false,
  inpool = false,
  atlas = 'Jokers',
  pos = {x = 9, y = 0},
  soul_pos = {x = 9, y = 1},
  config = {extra = {odds = 2}},
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sketchy'}
    info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
    return {vars = {G.GAME.probabilities.normal, center.ability.extra.odds}}
  end,
  calculate = function(self,card,context)
    if context.ending_shop and pseudorandom('gab') < G.GAME.probabilities.normal/card.ability.extra.odds then
      local jokers_to_create = math.min(1,
        G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
      G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
      G.E_MANAGER:add_event(Event({
        func = function()
          local card = create_card('Joker', G.jokers, nil, nil, nil, nil,nil, nil)
          card.ability.tolg_stick = true
          local edition = {negative = true}
          card:set_edition(edition, true)
          card:add_to_deck()
          G.jokers:emplace(card)
          card:start_materialize()
          G.GAME.joker_buffer = 0
          return true
        end
      }))
    end
  end,
}

-- Belphegor
SMODS.Joker{
  key = 'belphegor',
  loc_txt = {
    name = 'Belphegor',
	  text = {
      "Prevents Death",
      "and becomes a",
      "{S:1.1,C:attention,E:2}Dracolich"
    }
  },
  rarity = 3,
  cost = 6,
  unlocked = true,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = false, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 3, y = 1},
  config = {extra = {
  }
  },
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sketchy'}
    info_queue[#info_queue + 1] = {generate_ui = tolg_joker_tooltip, key = 'dracolich', title = 'Dracolich'}
  end,
  calculate = function(self,card,context)
    if context.game_over and not context.blueprint then
      if card.edition then
        previous_edition = card.edition
      end
      local jokers_to_create = math.min(1,
        G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
      G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
      G.E_MANAGER:add_event(Event({
        func = function()
          G.hand_text_area.blind_chips:juice_up()
          G.hand_text_area.game_chips:juice_up()
          play_sound('tarot1')
          card:start_dissolve({HEX("6EB172")}, nil, nil)
          return true
        end
      })) 
      G.E_MANAGER:add_event(Event({
        func = function()
          local card = create_card('Joker', G.jokers, nil, 0, nil, nil,
            'j_tolg_dracolich', nil)
          if previous_edition then
            card:set_edition(previous_edition, true)
          else
            card:set_edition(nil, true)
          end
          card:add_to_deck()
          G.jokers:emplace(card)
          card:start_materialize()
          G.GAME.joker_buffer = 0
          return true
        end
      }))
      return {
        message = localize('k_saved_ex'),
        saved = true,
        colour = G.C.RED
      }
    end
  end
}

-- Dracolich
SMODS.Joker{
  key = 'dracolich',
  loc_txt = {
    name = 'Belphegor (Dracolich)',
	  text = {
      'This Joker gives an',
			'additional {X:mult,C:white}X#1#{} for',
			'every {C:attention}hand remaining{}',
	    '{C:inactive}(Will score {X:mult,C:white}X#2#{} {C:inactive}Mult)'
    }
  },
  rarity = 3,
  cost = 10,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false, 
  eternal_compat = true,
  yes_pool_flag = 'balatmulti',
  atlas = 'Jokers',
  pos = {x = 4, y = 1},
  config = {extra = {
    Xmult_bonus = 0.5,
    Xmult = 1
  }
  },
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'chaos-draco'}
    return {vars = {center.ability.extra.Xmult_bonus,(center.ability.extra.Xmult+(center.ability.extra.Xmult_bonus*(G.GAME.current_round.hands_left-1)))}}
  end,
  calculate = function(self,card,context)
    if context.joker_main and (card.ability.extra.Xmult+(card.ability.extra.Xmult_bonus*G.GAME.current_round.hands_left)) > 1 then return{
      card = card,
      Xmult_mod = (card.ability.extra.Xmult+(card.ability.extra.Xmult_bonus*G.GAME.current_round.hands_left)),
      message = 'X' .. (card.ability.extra.Xmult+(card.ability.extra.Xmult_bonus*G.GAME.current_round.hands_left)) .. ' Mult'}
    end
  end,
}

create_tolg_joker = function(pseed)
  local tolg_keys = tolg_joker_list()
  local tolg_key = "j_tolg_melody"
  local create_args = {set = "Joker", area = G.jokers, key = ''}
  
  if #tolg_keys > 0 then
    tolg_key = pseudorandom_element(tolg_keys, pseudoseed(G.GAME.pseudorandom.seed))
  end
  return tolg_key
end

tolg_joker_list = function()
  local tolg_keys = {}
  for k, v in pairs(G.P_CENTERS) do
    if v.tolg and not G.GAME.used_jokers[v.key] then
      table.insert(tolg_keys, v.key)
    end
  end
  return tolg_keys
end

-- sending stone
SMODS.Consumable{
  key = "sending",
  set = 'Spectral',
  loc_txt = {
    name = 'Sending Stone',
	  text = {
      'Summon a {C:attention}Joker{} from',
      '{C:dark_edition}Team One Large Guy'
    }
  },
  unlocked = true,
  discovered = true,
  atlas = 'tolgSpectral',
  pos = { x = 0, y = 0 },
	cost = 6,
  can_use = function(self, card)
    if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
      return true
    else
      return false
    end
  end,
  use = function(self, card, area, copier)
		local card = create_card('Joker', G.jokers, nil, 0, nil, nil,
    create_tolg_joker(), nil)
    card.ability.tolg_stick = false
		card:add_to_deck()
		G.jokers:emplace(card)
	end,
}

-- honorary badge
SMODS.Consumable{
  key = "badge",
  set = 'Spectral',
  loc_txt = {
    name = 'Honorary Badge',
	  text = {
      'Add a {C:green}TOLG Sticker{}',
      'to selected {C:attention}Joker'
    }
  },
  unlocked = true,
  discovered = true,
  atlas = 'tolgSpectral',
  pos = { x = 1, y = 0 },
	cost = 6,
  can_use = function(self, card)
		return #G.jokers.highlighted
			== 1
	end,
  loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
	end,
  use = function(self, card, area, copier)
		if area then
			area:remove_from_highlighted(card)
		end
		if G.jokers.highlighted[1] then
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.3,
        func = function()
          G.jokers.highlighted[1]:juice_up(0.3, 0.3)
          play_sound('gold_seal', 1.2, 0.4)
        return true
        end
      }))
			G.jokers.highlighted[1].ability.tolg_stick = true
		end
  end,
}

-- elixir
SMODS.Consumable{
  key = "elixir",
  set = 'Spectral',
  loc_txt = {
    name = 'Elixir of Health',
	  text = {
      'Cleanses one selected',
      '{C:attention}Joker {}or {C:attention}Playing Card{}',
      '{C:inactive}(Removes {C:dark_edition}Edition{C:inactive}, {C:attention}Enhancement{},',
      '{C:attention}Stickers{C:inactive} and becomes un-debuffed)'
    }
  },
  unlocked = true,
  discovered = true,
  atlas = 'tolgSpectral',
  pos = { x = 2, y = 0 },
	cost = 6,
  config = {mod_conv = 'card'},
  can_use = function(self, card)
		return #G.jokers.highlighted
				+ #G.hand.highlighted
			== 1
	end,
  use = function(self, card, area, copier)
		if area then
			area:remove_from_highlighted(card)
		end
    local edition = {foil = false, holo = false, polychrome = false, negative = false}
		if G.jokers.highlighted[1] then
      G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.jokers.highlighted[1]:juice_up(0.3, 0.3);return true end }))
      delay(0.2)
			G.jokers.highlighted[1].ability.tolg_stick = false
      G.jokers.highlighted[1].ability.eternal = false
      G.jokers.highlighted[1].ability.rental = false
      G.jokers.highlighted[1].ability.perishable = false
      G.jokers.highlighted[1].debuff = false
      G.jokers.highlighted[1]:set_edition(edition, true)
    elseif G.hand.highlighted[1] or G.pack_cards.highlighted[1] then
      local _card = false
      if G.hand.highlighted[1] then
        _card = G.hand.highlighted[1]
      elseif G.pack_cards.highlighted[1] then
        _card = G.pack_cards.highlighted[1]
      end
      G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() _card:juice_up(0.3, 0.3);return true end }))
      _card.vampired = true
      _card:set_ability(G.P_CENTERS.c_base, nil, true)
      delay(0.2)
      _card:set_edition(edition, true)
      _card:set_seal(false)
      _card:set_debuff(false)
    end
  end,
}

-- spiral
SMODS.Consumable{
  key = "spiral",
  set = 'Tarot',
  loc_txt = {
    name = 'Spiralling Eye',
	  text = {
      'Add {C:money}$2{} of {C:attention}Sell Value{}',
      'to selected {C:attention}Joker{}'
    }
  },
  unlocked = true,
  discovered = true,
  atlas = 'tolgSpectral',
  pos = { x = 3, y = 0 },
	cost = 3,
  effect = "Enhance",
  can_use = function(self, card)
		--the card itself and one joker
		return #G.jokers.highlighted
			== 1
	end,
  use = function(self, card, area, copier)
		if area then
			area:remove_from_highlighted(card)
		end
		if G.jokers.highlighted[1] then
			G.jokers.highlighted[1].ability.extra_value = (G.jokers.highlighted[1].ability.extra_value or 0) + 2
			G.jokers.highlighted[1]:set_cost()
      card_eval_status_text(G.jokers.highlighted[1], 'extra', nil, nil, nil, {message = localize('k_val_up'),colour = G.C.MONEY,})
		end
  end,
}

-- bag
SMODS.Consumable{
  key = "bag",
  set = 'Tarot',
  loc_txt = {
    name = 'Bag of Holding',
	  text = {
      'Creates a random',
      '{C:attention}Consumable',
      '{C:inactive}({C:tarot}Tarot{C:inactive}, {C:planet}Planet{C:inactive} or {C:spectral}Spectral{C:inactive})'
    }
  },
  unlocked = true,
  discovered = true,
  atlas = 'tolgSpectral',
  pos = { x = 6, y = 0 },
	cost = 3,
  effect = "Enhance",
  can_use = function(self, card)
    if #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables then
      return true
    end
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
      if G.consumeables.config.card_limit > #G.consumeables.cards then
        play_sound('timpani')
        local makecard = create_card((pseudorandom('bagSpec') < 1/20 and 'Spectral') or ((pseudorandom('bagPlanet') < 1/2 and 'Planet') or 'Tarot'), 
          G.consumeables, nil, nil, nil, nil, nil, ('bag'))
        makecard:add_to_deck()
        G.consumeables:emplace(makecard)
        card:juice_up(0.3, 0.5)
      end
      return true end }))
  end,
}

-- pay
SMODS.Consumable{
  key = "paycheck",
  set = 'Tarot',
  loc_txt = {
    name = 'Paycheck',
	  text = {
      'Gives {C:money}$5{} for every',
      '{C:dark_edition}Team One Large Guy {C:attention}Joker{}'
    }
  },
  unlocked = true,
  discovered = true,
  atlas = 'tolgSpectral',
  pos = { x = 5, y = 0 },
	cost = 3,
  effect = "Enhance",
  can_use = function(self, card)
    return true
  end,
  use = function(self, card, area, copier)
    local output = 0
		for k, v in ipairs(G.jokers.cards) do
      if v.config.center.tolg or v.ability.tolg_stick then 
        output = output + 5
      end
    end
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
      ease_dollars(output)
      play_sound('timpani')
      card:juice_up(0.3, 0.5)
      return true end }))
  delay(0.6)
  end,
}

SMODS.Sticker{
	key = "tolg_stick",
  loc_txt = {
    name = 'TOLG',
	  text = {
      'This Joker{} counts',
      'as a member of',
      '{C:dark_edition}Team One Large Guy'
    },
    label = "TOLG"
  },
	atlas = "tolgSticker",
  sets = {Joker = true},
  rate = 0.1,
  default_compat = true,
  compat_exceptions = tolg_joker_list(),
	pos = { x = 0, y = 0},
	no_sticker_sheet = true,
	prefix_config = { key = false },
	badge_colour = HEX("5EB631"),
  needs_enable_flag = false,
  apply = function(self, card, val)
    card.ability.tolg_stick = true
  end,
}

-- tolg deck
SMODS.Back{
  key = "tolgdeck",
  loc_txt = {
    name = 'Team One Large Guy Deck',
	  text = {
      'Start with {C:green}Bless{}',
      'and a {C:spectral}Sending Stone{}'
    }
  },
  unlocked = true,
  discovered = true,
  order = '17',
  atlas = 'tolgdeck',
	config = {vouchers = {'v_tolg_bless'},consumables = {'c_tolg_sending'}},
	pos = { x = 0, y = 0 },
}

-- bless
SMODS.Voucher{
	key = "bless",
  loc_txt = {
    name = 'Bless',
	  text = {
      'Increase all {C:attention}listed',
      '{C:green,E:1,S:1.1}probabilities{} by {X:green,C:white}X1.5{}',
      '{C:inactive}(ex: {C:green}1 in 3{C:inactive} -> {C:green}1.5 in 3{C:inactive})'
    }
  },
	atlas = "tolgVouchers",
  order = 33,
  set = "Voucher",
	pos = { x = 0, y = 0 },
  config = {},
  discovered = true,
  unlocked = true,
  available = true,
  cost = 10,
	loc_vars = function(self, info_queue)
		return { vars = {} }
	end,
  redeem = function(self)
    for k, v in pairs(G.GAME.probabilities) do 
      G.GAME.probabilities[k] = v*1.5
    end
  end,
  unredeem = function(self)
    for k, v in pairs(G.GAME.probabilities) do 
      G.GAME.probabilities[k] = v/1.5
    end
  end
}

-- emboldening bond
SMODS.Voucher{
	key = "embolden",
  loc_txt = {
    name = 'Emboldening Bond',
	  text = {
      'Increase all {C:attention}listed',
      '{C:green,E:1,S:1.1}probabilities{} to {X:green,C:white}X2{}',
      '{C:inactive}(ex: {C:green}1.5 in 3{C:inactive} -> {C:green}2 in 3{C:inactive})'
    }
  },
	atlas = "tolgVouchers",
  order = 34,
  set = "Voucher",
	pos = { x = 0, y = 1 },
  config = {},
  discovered = true,
  unlocked = true,
  available = true,
  requires = {"v_bless"},
  cost = 10,
	loc_vars = function(self, info_queue)
		return { vars = {} }
	end,
  redeem = function(self)
    for k, v in pairs(G.GAME.probabilities) do 
      G.GAME.probabilities[k] = (v/1.5)*2
    end
  end,
  unredeem = function(self)
    for k, v in pairs(G.GAME.probabilities) do 
    G.GAME.probabilities[k] = (v/2)*1.5
    end
  end
}

-- Sleeves Patch
tolgSleeves = (SMODS.Mods['CardSleeves'] or {}).can_load
if tolgSleeves then
	NFS.load(TOLG.path .. 'util/sleeves/tolgsleeve.lua')()
end

-- Multiplayer Patch
tolgMulti = (SMODS.Mods["VirtualizedMultiplayer"] or {}).can_load
if tolgMulti then
  tolgBanned = {
  { id = "j_tolg_olivia" },
  { id = "j_tolg_ardric" },
  { id = "j_tolg_jason" },
  { id = "j_tolg_belphegor" }
  }
  for k, v in pairs(tolgBanned) do
    table.insert(G.MULTIPLAYER.DECK.BANNED_CARDS, v)
  end
end

----------------------------------------------
------------MOD CODE END----------------------
