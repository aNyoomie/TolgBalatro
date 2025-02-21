-- Artist Colours
G.ARGS.LOC_COLOURS['sketchy'] = HEX('B8356B')
G.ARGS.LOC_COLOURS['aqua'] = HEX('8AAAD1')
G.ARGS.LOC_COLOURS['blurr'] = HEX('5A8DC6')
G.ARGS.LOC_COLOURS['ssick'] = HEX('6EB172')
G.ARGS.LOC_COLOURS['espeon'] = HEX('B296C6')
G.ARGS.LOC_COLOURS['chaos-draco'] = HEX('4F6367')

function tolg_artist_tooltip(_c, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    localize{type = 'descriptions', set = 'Tolg Artist', key = _c.key, nodes = desc_nodes, vars = specific_vars or _c.vars}
    desc_nodes['colour'] = G.ARGS.LOC_COLOURS[_c.key] or G.C.GREY
    desc_nodes.tolg_artist = true
    desc_nodes.title = _c.title or localize('tolg_artist')
end
function tolg_joker_tooltip(_c, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    localize{type = 'descriptions', set = 'Tolg Joker', key = _c.key, nodes = desc_nodes, vars = specific_vars or _c.vars}
    desc_nodes['colour'] = G.C.WHITE
    desc_nodes.tolg_joker = true
    desc_nodes.title = _c.title or localize('tolg_joker')
end
local itfr = info_tip_from_rows
function info_tip_from_rows(desc_nodes, name)
    if desc_nodes.tolg_artist then
        local t = {}
        for k, v in ipairs(desc_nodes) do
        t[#t+1] = {n=G.UIT.R, config={align = "cm"}, nodes=v}
        end
        return {n=G.UIT.R, config={align = "cm", colour = darken(desc_nodes.colour, 0.15), r = 0.1}, nodes={
            {n=G.UIT.R, config={align = "tm", minh = 0.36, padding = 0.03}, nodes={{n=G.UIT.T, config={text = desc_nodes.title, scale = 0.32, colour = G.C.UI.TEXT_LIGHT}}}},
            {n=G.UIT.R, config={align = "cm", minw = 1.5, minh = 0.4, r = 0.1, padding = 0.05, colour = lighten(desc_nodes.colour, 0.5)}, nodes={{n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes=t}}}
        }}
    elseif desc_nodes.tolg_joker then
        local t = {}
        for k, v in ipairs(desc_nodes) do
        t[#t+1] = {n=G.UIT.R, config={align = "cm"}, nodes=v}
        end
        return {n=G.UIT.R, config={align = "cm", colour = lighten(HEX('607174'), 0.15) , r = 0.1}, nodes={
            {n=G.UIT.R, config={align = "tm", minh = 0.36, padding = 0.03}, nodes={{n=G.UIT.T, config={text = desc_nodes.title, scale = 0.32, colour = G.C.UI.TEXT_LIGHT}}}},
            {n=G.UIT.R, config={align = "cm", minw = 1.5, minh = 0.4, r = 0.1, padding = 0.05, colour = lighten(desc_nodes.colour, 0.5)}, nodes={{n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes=t}}}
        }}
    else
        return itfr(desc_nodes, name)
    end
end