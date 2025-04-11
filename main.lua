--- STEAMODDED HEADER
--- MOD_NAME: TOLG Content
--- MOD_ID: tolgContent
--- MOD_AUTHOR: [aNyoomie]
--- MOD_DESCRIPTION: New TOLG Themed Jokers, Deck and more! Also includes TOLG Themed Card Customization!
--- PREFIX: tolg
--- BADGE_COLOUR: 5EB631
--- PRIORITY: 9007199254740991
--- VERSION: 1.3

----------------------------------------------
------------MOD CODE -------------------------
TOLG = SMODS.current_mod

-- loads jokers
assert(SMODS.load_file('util/jokers/one.lua'))()
assert(SMODS.load_file('util/jokers/two.lua'))()

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
    if v.tolg and v.unlocked and not G.GAME.used_jokers[v.key] then
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
	pos = { x = 0, y = 0},
	no_sticker_sheet = true,
	prefix_config = { key = false },
	badge_colour = HEX("5EB631"),
  needs_enable_flag = false,
  apply = function(self, card, val)
    if not card.tolg then
      card.ability.tolg_stick = true
    end
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
    },
    unlock = {
      'Score a {C:attention}Lucky{} Card',
      'with a {C:green}guaranteed{} chance',
      'to add {C:red}+20{} Mult'
    },
  },
	atlas = "tolgVouchers",
  order = 34,
  set = "Voucher",
	pos = { x = 0, y = 1 },
  config = {},
  unlocked = false,
	unlock_condition = {type = 'hand_contents'},
  available = true,
  requires = {"v_tolg_bless"},
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
  { id = "j_tolg_belphegor" }
  }
  for k, v in pairs(tolgBanned) do
    table.insert(G.MULTIPLAYER.DECK.BANNED_CARDS, v)
  end
end

----------------------------------------------
------------MOD CODE END----------------------