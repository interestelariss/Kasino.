--- Kasino: mecanicas nuevas
--  1. Fusion de comodines: boton FUSIONAR en cada comodin. Si el comodin de su
--     derecha es de la misma rareza, los dos se convierten en uno de la rareza
--     siguiente (Comun -> Poco comun -> Raro -> Legendario de Kasino).
--  2. La Fusion (carta de Tarot): junta dos cartas del mismo valor en una mejor.
--  3. Doble o Nada: en la ultima mano de la ronda aparece el boton APOSTAR.
--     Si apuestas, al puntuar esa mano se lanza una moneda: x2 o x0.

KAS.ui = { apuesta = "APOSTAR" }

---------------------------------------------------------------------------
-- 1. Fusion de comodines
---------------------------------------------------------------------------

-- Rareza que se obtiene al fusionar dos comodines de cada rareza
KAS.SIGUIENTE_RAREZA = { [1] = "Uncommon", [2] = "Rare", [3] = "kas_legendario" }

-- Devuelve el comodin con el que se puede fusionar `card` (el de su derecha) o nil
function KAS.pareja_fusion(card)
    if not (G.jokers and card.area == G.jokers) then return nil end
    local rareza = card.config.center.rarity
    if not KAS.SIGUIENTE_RAREZA[rareza] or card.ability.eternal then return nil end
    for i, j in ipairs(G.jokers.cards) do
        if j == card then
            local otro = G.jokers.cards[i + 1]
            if otro and otro.config.center.rarity == rareza and not otro.ability.eternal
                and not otro.getting_sliced then
                return otro
            end
            return nil
        end
    end
end

G.FUNCS.kas_puede_fusionar = function(e)
    local card = e.config.ref_table
    if KAS.pareja_fusion(card) and not card.getting_sliced then
        e.config.colour = G.C.PURPLE
        e.config.button = 'kas_fusionar'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.kas_fusionar = function(e)
    local card = e.config.ref_table
    local otro = KAS.pareja_fusion(card)
    if not otro then return end
    local destino = KAS.SIGUIENTE_RAREZA[card.config.center.rarity]
    G.jokers:unhighlight_all()
    for _, c in ipairs({ card, otro }) do
        c.getting_sliced = true
        c:start_dissolve({ G.C.PURPLE, G.C.WHITE })
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.8,
        func = function()
            local nuevo = SMODS.add_card({ set = 'Joker', rarity = destino, key_append = 'kas_fusion' })
            if nuevo then nuevo:juice_up(0.5, 0.5) end
            play_sound('tarot2', 1.2)
            return true
        end,
    }))
end

local function boton_fusionar(card)
    return {
        n = G.UIT.C, config = { align = "cr" }, nodes = {
            {
                n = G.UIT.C,
                config = {
                    ref_table = card, align = "cr", padding = 0.1, r = 0.08, minw = 1.25, minh = 0.6,
                    hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true,
                    button = 'kas_fusionar', func = 'kas_puede_fusionar',
                },
                nodes = {
                    { n = G.UIT.B, config = { w = 0.1, h = 0.4 } },
                    { n = G.UIT.T, config = { text = "FUSIONAR", colour = G.C.UI.TEXT_LIGHT, scale = 0.35, shadow = true } },
                },
            },
        },
    }
end

-- Anade el boton FUSIONAR debajo del de vender en los comodines
local use_and_sell_original = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local t = use_and_sell_original(card)
    if card.area == G.jokers and card.ability.set == 'Joker'
        and t and t.nodes and t.nodes[1] and t.nodes[1].nodes then
        table.insert(t.nodes[1].nodes, { n = G.UIT.R, config = { align = 'cl' }, nodes = { boton_fusionar(card) } })
    end
    return t
end

---------------------------------------------------------------------------
-- 2. La Fusion: carta de Tarot que junta dos cartas del mismo valor
---------------------------------------------------------------------------

-- `a` absorbe a `b`: suma sus fichas, hereda su sello y gana una mejora si no tenia
function KAS.fusionar_cartas(a, b)
    a.ability.perma_bonus = (a.ability.perma_bonus or 0) + b.base.nominal + (b.ability.perma_bonus or 0)
    if b.seal and not a.seal then a:set_seal(b.seal, nil, true) end
    if a.config.center == G.P_CENTERS.c_base then
        local mejora = pseudorandom_element(G.P_CENTER_POOLS.Enhanced, pseudoseed('kas_fusion'))
        a:set_ability(mejora, nil, true)
    end
end

SMODS.Consumable {
    key = "fusion",
    set = "Tarot",
    loc_txt = {
        name = "La Fusión",
        text = {
            "Junta {C:attention}2{} cartas seleccionadas",
            "del {C:attention}mismo valor{} en una sola:",
            "suma sus {C:chips}fichas{}, hereda el {C:attention}sello{}",
            "y gana una {C:attention}mejora{} si no tenía",
        },
    },
    atlas = "consumibles",
    pos = { x = 0, y = 0 },
    cost = 3,
    can_use = function(self, card)
        local sel = G.hand and G.hand.highlighted
        return sel and #sel == 2 and sel[1]:get_id() == sel[2]:get_id()
    end,
    use = function(self, card, area, copier)
        local sel = { G.hand.highlighted[1], G.hand.highlighted[2] }
        table.sort(sel, function(x, y) return x.T.x < y.T.x end)
        local a, b = sel[1], sel[2]
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                KAS.fusionar_cartas(a, b)
                a:juice_up(0.5, 0.5)
                b:start_dissolve({ G.C.PURPLE })
                return true
            end,
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            func = function()
                G.hand:unhighlight_all()
                SMODS.calculate_context({ remove_playing_cards = true, removed = { b } })
                return true
            end,
        }))
    end,
}

---------------------------------------------------------------------------
-- 3. Doble o Nada en la ultima mano
---------------------------------------------------------------------------

-- Se puede apostar en la ultima mano (o en todas con el Mazo del Casino)
function KAS.es_ultima_mano()
    return G.GAME and G.GAME.current_round
        and (G.GAME.current_round.hands_left == 1 or G.GAME.modifiers.kas_apuesta_siempre)
end

G.FUNCS.kas_puede_apostar = function(e)
    if KAS.es_ultima_mano() and G.STATE == G.STATES.SELECTING_HAND then
        e.config.colour = G.GAME.kas_apuesta and G.C.GREEN or G.C.GOLD
        e.config.button = 'kas_apostar'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
    KAS.ui.apuesta = G.GAME.kas_apuesta and "¡APOSTADO!" or "APOSTAR"
end

G.FUNCS.kas_apostar = function(e)
    G.GAME.kas_apuesta = not G.GAME.kas_apuesta
    play_sound(G.GAME.kas_apuesta and 'coin1' or 'cancel')
end

-- Se llama en el ultimo paso de puntuacion: multiplica la mano por 2 o por 0
function KAS.resolver_apuesta()
    -- En el desafio Todo o Nada todas las manos van a Doble o Nada
    if not (G.GAME.kas_apuesta or G.GAME.modifiers.kas_todo_o_nada) then return end
    G.GAME.kas_apuesta = false
    local gana = pseudorandom('kas_apuesta') < KAS.prob_apuesta()
    mult = mod_mult(mult * (gana and 2 or 0))
    update_hand_text({ delay = 0 }, { mult = mult })
    G.E_MANAGER:add_event(Event({
        func = function()
            play_sound(gana and 'multhit2' or 'glass1')
            attention_text({
                text = gana and "¡DOBLE!" or "¡NADA!",
                scale = 1.3, hold = 1.4, major = G.play, align = 'cm', offset = { x = 0, y = -2.7 },
                backdrop_colour = gana and G.C.GREEN or G.C.RED, silent = true,
            })
            return true
        end,
    }))
end

local calculate_context_original = SMODS.calculate_context
function SMODS.calculate_context(context, ...)
    local r = calculate_context_original(context, ...)
    if context.final_scoring_step then KAS.resolver_apuesta() end
    if context.setting_blind then G.GAME.kas_apuesta = false end
    -- Osiris revive el ultimo comodin vendido
    if context.selling_card and context.card and context.card.ability.set == 'Joker' then
        G.GAME.kas_ultimo_vendido = context.card.config.center.key
    end
    return r
end

-- Anade el boton APOSTAR junto a los de jugar y descartar
local botones_original = create_UIBox_buttons
function create_UIBox_buttons()
    local t = botones_original()
    table.insert(t.nodes, {
        n = G.UIT.C,
        config = {
            align = "cm", minw = 2.2, minh = 1.3, padding = 0.2, r = 0.1, hover = true, shadow = true,
            colour = G.C.UI.BACKGROUND_INACTIVE, button = 'kas_apostar', func = 'kas_puede_apostar',
        },
        nodes = {
            {
                n = G.UIT.R, config = { align = "cm", padding = 0 }, nodes = {
                    { n = G.UIT.T, config = { text = "DOBLE O NADA", scale = 0.3, colour = G.C.UI.TEXT_LIGHT } },
                },
            },
            {
                n = G.UIT.R, config = { align = "cm", padding = 0 }, nodes = {
                    { n = G.UIT.T, config = { ref_table = KAS.ui, ref_value = 'apuesta', scale = 0.45,
                        colour = G.C.UI.TEXT_LIGHT, shadow = true } },
                },
            },
        },
    })
    return t
end
