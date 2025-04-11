-- Bone Melody
SMODS.Joker{
  key = 'melbone',
  loc_txt = {
    name = 'Melody (Bone Form)',
	  text = {
	    '{C:attention}+#2#{} hand size,',
	    '{C:red}-#1#{} discards each round',
    },
    unlock = {
      'Play a hand',
      'that contains',
      '{E:1,C:attention}five 6s{}'
    },
  },
  rarity = 2,
  cost = 7,
  unlocked = false,
	unlock_condition = {type = 'hand_contents'},
  blueprint_compat = false,
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

-- Wolf
SMODS.Joker{
  key = 'wolf',
  loc_txt = {
    name = 'Olivia (Wolf Form)',
      text = {
      '{C:red}+#1#{} Mult',
      'At end of round, {C:green}#3# in #4#{} chance',
      'to {C:attention}destroy{} a random Joker',
      '{C:red}+#2#{} Mult per {C:attention}Boss Blind{} played',
      '{C:green}-#5#{} to chance ({C:green}#4#{}) per {C:attention}Boss Blind{} played'
    },
    unlock = {
      'Prevent Death with {E:1,C:attention}Olivia'
    },
  },
  rarity = 2,
  cost = 5,
  unlocked = false,
	unlock_condition = {type = 'round_win'},
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  tolg = true,
  atlas = 'Jokers',
  pos = {x = 1, y = 2},
  config = {extra = {mult_bonus = 15, mult = 30, odds = 7, odds_bonus = 1}},
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sketchy'}
    if not center.ability.tolg_stick then
      info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
    end
    return {vars = {center.ability.extra.mult,center.ability.extra.mult_bonus,G.GAME.probabilities.normal,center.ability.extra.odds,center.ability.extra.odds_bonus}}
  end,
  calculate = function(self,card,context)
    if context.end_of_round and not context.repetition and not context.blueprint and not context.individual then
      if G.GAME.blind:get_type() == 'Boss' then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_bonus
        if card.ability.extra.odds > 1 then
          card.ability.extra.odds = card.ability.extra.odds - card.ability.extra.odds_bonus
        end
      end
      if pseudorandom('wolf') < G.GAME.probabilities.normal/card.ability.extra.odds then
        local destructable_jokers = {}
        for i = 1, #G.jokers.cards do
          if G.jokers.cards[i] ~= card and not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i] end
        end
        local joker_to_destroy = #destructable_jokers > 0 and pseudorandom_element(destructable_jokers, pseudoseed('wolf')) or nil
        if joker_to_destroy and not (context.blueprint_card or card).getting_sliced then 
          joker_to_destroy.getting_sliced = true
          G.E_MANAGER:add_event(Event({func = function()
            (context.blueprint_card or card):juice_up(0.8, 0.8)
            joker_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
          return true end }))
        end
        return {message = "Danger!"}
      elseif G.GAME.blind:get_type() == 'Boss' then
        return {
          message = localize('k_level_up_ex')
        }
      else
        return {message = localize('k_safe_ex')}
      end
    elseif context.joker_main then
      return {
        message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}, 
        colour = G.C.MULT,
        mult_mod = card.ability.extra.mult
      }
    end
  end
}

-- Feesh
SMODS.Joker{
  key = 'feesh',
  loc_txt = {
    name = 'Feesh',
      text = {
      'Scored {C:attention}6{}s and {C:attention}8{}s give',
      'random effects, ranging from:',
      '{C:chips}[+#1#-#2#{} Chips{C:chips}]{} {C:mult}[+#3#-#4#{} Mult{C:mult}]',
      '{C:mult}[{X:mult,C:white}X#5#{C:mult}-{X:mult,C:white}X#6#{} Mult{C:mult}]{}  {C:money}[$#7#-#8#]'
    },
    unlock = {
      'Scale {E:1,C:attention}Fish{} to his {E:1,C:red}Maximum'
    },
  },
  rarity = 1,
  cost = 3,
  unlocked = false,
	unlock_condition = {type = 'round_win'},
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  tolg = true,
  atlas = 'Jokers',
  pos = {x = 2, y = 2},
  config = {
		chip_min = 5, chip_max = 30,
		mult_min = 1,	mult_max = 8,
		xmult_min = 1.1, xmult_max = 1.5,
		money_min = 1, money_max = 4
	},
  set_ability = function(self, card, initial, delay_sprites)
    if card.config.center.discovered or self.bypass_discovery_center then
      card.children.center.scale.y = card.children.center.scale.x
      card.T.h = card.T.w
      card.T.w = card.T.w
    end
  end,
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sketchy'}
    if not center.ability.tolg_stick then
      info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
    end
    return { vars = {
			center.ability.chip_min,center.ability.chip_max,center.ability.mult_min,center.ability.mult_max,
			center.ability.xmult_min,center.ability.xmult_max,center.ability.money_min,center.ability.money_max
		} }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and (context.other_card:get_id() == 8 or context.other_card:get_id() == 6) then
      local rand = pseudorandom("feesh")
      local zeroth = 0
      local first = 1 / 4
      local second = 2 / 4
      local third = 3 / 4
      local fourth = 1
      
      if zeroth < rand and rand < first then
        return {
          chips = math.floor(pseudorandom("feesh_chips") * 25) + 5
        }
      elseif first < rand and rand < second then
        return {
          mult = math.floor(pseudorandom("feesh_mult") * 8)
        }
      elseif second < rand and rand < third then
        return {
          xmult = 1 + (math.floor(pseudorandom("feesh_xmult") * 4) / 10)
        }
      elseif third < rand and rand < fourth then
        return {
          dollars = math.floor(pseudorandom("feesh_money") * 4)
        }
      end
    end
  end
}

-- Purple guy
SMODS.Joker{
  key = 'ardcrown',
  loc_txt = {
    name = 'Ardric (Crown)',
      text = {
      '{C:attention}+1{} card slot',
      'available in shop',
      '{C:red}1 {C:green}in #1#{} {C:inactive}({C:green}#3#{C:inactive}x#2#){} chance this card',
      'is destroyed at end of round',
      '{s:0.8}{C:inactive}(Probability scales on right side)'
    },
    unlock = {
      'Clear a Run with {E:1,C:attention}Ardric'
    },
  },
  rarity = 2,
  cost = 5,
  unlocked = false,
	unlock_condition = {type = 'win_custom'},
  blueprint_compat = false,
  perishable_compat = true, 
  eternal_compat = true,
  tolg = true,
  atlas = 'Jokers',
  pos = {x = 3, y = 2},
  config = {extra = {odds = 10,jason=false}},
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sicko'}
    if not center.ability.tolg_stick then
      info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
    end
    return {vars = {center.ability.extra.odds*(G.GAME.probabilities.normal or 1),center.ability.extra.odds,G.GAME.probabilities.normal}}
  end,
  calculate = function(self,card,context)
    if context.first_hand_drawn and not context.blueprint then
      card.ability.extra.jason = false
    elseif context.other_joker then
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
  end,
  add_to_deck = function(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({func = function()
      change_shop_size(1)
      return true end }))
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({func = function()
      change_shop_size(-1)
      return true end }))
  end
}

-- Eye Emi
SMODS.Joker{
  key = 'eyemi',
  loc_txt = {
    name = 'Emi (Infected)',
      text = {
      'Each card held in hand',
      'with {V:1}#2#{} suit',
      'gives {X:mult,C:white} X#1# {} Mult,',
      'suit changes every round'
    },
    unlock = {
      'Have {E:1,C:attention}Emiliana{} Score at least',
      '{E:1,C:red}+20{} Mult in one hand'
    },
  },
  rarity = 3,
  cost = 6,
  unlocked = false,
	unlock_condition = {type = 'jimbo_score'},
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  tolg = true,
  atlas = 'Jokers',
  pos = {x = 4, y = 2},
  config = {extra = {Xmult = 1.5}},
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sketchy'}
    if not center.ability.tolg_stick then
      info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
    end
    return {vars = {center.ability.extra.Xmult, localize(G.GAME.current_round.emi_card.suit, 'suits_singular'), colours = {G.C.SUITS[G.GAME.current_round.emi_card.suit]}}}
  end,
  calculate = function(self,card,context)
    if context.cardarea == G.hand and context.individual and not context.end_of_round then
      if context.other_card:is_suit(G.GAME.current_round.emi_card.suit) then
        return {
          x_mult = card.ability.extra.Xmult,
          card = card
        }
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
    },
    unlock = {
      'Sell {E:1,C:attention}Olivia{} and then',
      'bring her back',
      '{C:inactive}(Obtain her a 2nd time)'
    },
  },
  rarity = 2,
  cost = 7,
  unlocked = false,
  unlock_condition = {type = 'add_joker'},
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

-- rAVEn
SMODS.Joker{
  key = 'raven',
  loc_txt = {
    name = 'Ave (Raven Queen)',
      text = {
      'This Joker gains {X:mult,C:white}X#2#{} Mult',
      'when a playing card is destroyed',
      '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)'
    },
    unlock = {
      'Sell {E:1,C:attention}Ave{} when she has',
      'a {E:1,C:attention}Sell Value{} of at least {E:1,C:money}$15'
    },
  },
  rarity = 3,
  cost = 6,
  unlocked = false,
  unlock_condition = {type = 'sell_joker'},
  blueprint_compat = true,
  perishable_compat = false, 
  eternal_compat = true,
  tolg = true,
  atlas = 'Jokers',
  pos = {x = 5, y = 2},
  config = {extra = {Xmult = 1, Xmult_bonus = 0.25}},
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sketchy'}
    if not center.ability.tolg_stick then
      info_queue[#info_queue + 1] = { key = "tolg_stick", set = "Other", vars = {} }
      return {vars = {center.ability.extra.Xmult,center.ability.extra.Xmult_bonus}}
    end
  end,
  calculate = function(self,card,context)
    if context.joker_main and card.ability.extra.Xmult > 1 then return{
      card = card,
      Xmult_mod = card.ability.extra.Xmult,
      message = 'X' .. card.ability.extra.Xmult .. ' Mult',
      colour = G.C.MULT}
    elseif context.remove_playing_cards and not context.blueprint then
      for k, val in ipairs(context.removed) do
        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_bonus
      end
      card_eval_status_text(card,"extra",nil,nil,nil,{message = localize({ type = "variable", key = "a_xmult", vars = {card.ability.extra.Xmult}})})
    end
  end
}

-- Viva
SMODS.Joker{
  key = 'viva',
  loc_txt = {
    name = 'Viva',
	  text = {
      'Retriggers used {C:planet}Planet{} cards,',
      'Expires after #2# Retriggers {C:inactive}({C:attention}#1#{C:inactive}/{C:attention}#2#{C:inactive})'
    },
    unlock = {
      'Have {E:1,C:attention}Advena{} Score at least',
      '{E:1,C:red}+18{} Mult in one hand'
    },
  },
  rarity = 1,
  cost = 3,
  unlocked = false,
	unlock_condition = {type = 'jimbo_score'},
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
        else
          return {
            message = card.ability.extra.uses .. '/' .. card.ability.extra.extinct
          }
        end
      end
    end
  end
}

-- jason with a fuckibg jetpack
SMODS.Joker{
  key = 'jasonpack',
  loc_txt = {
    name = 'Jason (Jetpack)',
      text = {
      '{C:inactive}({C:attention}#1#{C:inactive}/{C:attention}#2#{C:inactive}) Charges',
      'If this is the {C:attention}rightmost{} Joker,',
      'Spends {C:attention}#6#{} charges for {X:mult,C:white}X#4#{} Mult',
      'Otherwise, if {C:red}not{} the {C:attention}leftmost{} Joker,',
      'Spends {C:attention}#5#{} charge for {X:mult,C:white}X#3#{} Mult'
    },
    unlock = {
      'Protect {E:1,C:attention}Ardric{} with {E:1,C:attention}Jason{}'
    },
  },
  rarity = 2,
  cost = 5,
  unlocked = false,
	unlock_condition = {type = 'round_win'},
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 6, y = 2},
  config = {extra = {Xmult1 = 1.5,Xmult2 = 3,cost1 = 1,cost2 = 3,charges = 5, chargemax = 5}},
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'pecu'}
    info_queue[#info_queue + 1] = {generate_ui = tolg_joker_tooltip, key = 'charges', title = 'Charges'}
    return {vars = {center.ability.extra.charges,center.ability.extra.chargemax, 
    center.ability.extra.Xmult1,center.ability.extra.Xmult2,center.ability.extra.cost1,center.ability.extra.cost2}}
  end,
  calculate = function(self,card,context)
    if context.end_of_round and not context.repetition and not context.blueprint and not context.individual then
      if G.GAME.blind:get_type() == 'Boss' then
        card.ability.extra.charges = card.ability.extra.chargemax
      elseif card.ability.extra.charges < card.ability.extra.chargemax then
        card.ability.extra.charges = card.ability.extra.charges + 1
      end
      return {
        card = card,
        message = "Recharged!"
      }
    elseif context.joker_main then
      local self_pos = 0
      local normal_pos = 0
      local first_pos = nil
      for i = 1, #G.jokers.cards do
        if not first_pos then first_pos = i end
        if G.jokers.cards[i] == card then
          self_pos = i
        else
          normal_pos = i
        end
      end
      -- if there isnt another joker to the right of this one
      if not(normal_pos > self_pos) and card.ability.extra.charges >= card.ability.extra.cost2 then
        card.ability.extra.charges = card.ability.extra.charges - card.ability.extra.cost2
        return {
          message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult2}},
          Xmult_mod = card.ability.extra.Xmult2}
      -- otherwise, as long as its not in the first position
      elseif not (self_pos == first_pos) then
        if card.ability.extra.charges >= card.ability.extra.cost1 then
          card.ability.extra.charges = card.ability.extra.charges - card.ability.extra.cost1
          return {
            message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult1}},
            Xmult_mod = card.ability.extra.Xmult1}
        else return {message = 'No Charges!'} end
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
	    "Retrigger {C:attention}Wild{} Cards",
			"played or held in hand"
    },
    unlock = {
      'Sell {E:1,C:attention}Cain'
    },
  },
  rarity = 2,
  cost = 6,
  unlocked = false,
  unlock_condition = {type = 'sell_joker'},
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 5, y = 1},
  loc_vars = function(self,info_queue,center)
    info_queue[#info_queue + 1] = {generate_ui = tolg_artist_tooltip, key = 'sketchy'}
		info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
  end,
  calculate = function(self,card,context)
    if context.repetition then 
      if context.cardarea == G.play and context.other_card.config.center_key == "m_wild" then
      return {
        message = localize('k_again_ex'),
        repetitions = 1,
        card = context.blueprint_card or card
      }
      elseif context.cardarea == G.hand then
        if (next(context.card_effects[1]) or #context.card_effects > 1) and context.other_card.config.center_key == "m_wild" then
          return {
            message = localize('k_again_ex'),
            repetitions = 1,
            card = context.blueprint_card or card
          }
        end
      end
    end
  end
}