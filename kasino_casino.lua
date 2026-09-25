--- Kasino: cartas Casino, un tipo de consumible nuevo (como el Tarot) con los dioses egipcios.
-- Sprites: assets/*/kasino_casino.png, recortados de assets/fuente/cartas_casino.webp.

SMODS.Atlas { key = "casino", path = "kasino_casino.png", px = 71, py = 95 }

SMODS.ConsumableType {
    key = "Casino",
    primary_colour = HEX("D4A017"),
    secondary_colour = HEX("B8860B"),
    loc_txt = {
        name = "Casino",
        collection = "Cartas Casino",
        undiscovered = {
            name = "Carta no descubierta",
            text = { "Compra o usa esta carta", "en una partida para", "descubrir lo que hace" },
        },
    },
    collection_rows = { 8, 8 },
    shop_rate = 1,
    default = "c_kas_thoth",
}

local function en_ronda()
    return G.STATE == G.STATES.SELECTING_HAND
end

local function seleccionadas(min, max)
    local n = G.hand and #G.hand.highlighted or 0
    return n >= min and n <= max
end

-- Aplica fn a cada carta seleccionada con una pequena animacion
local function a_seleccionadas(card, fn)
    for _, c in ipairs(G.hand.highlighted) do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                fn(c)
                c:juice_up(0.3, 0.3)
                play_sound('tarot2', 0.9 + math.random() * 0.2)
                return true
            end,
        }))
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.3,
        func = function()
            G.hand:unhighlight_all()
            return true
        end,
    }))
end

-- Sube `n` niveles la mano de poker indicada mostrando la animacion de los Planetas
function KAS.subir_nivel(card, mano, n)
    local h = G.GAME.hands[mano]
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
        { handname = localize(mano, 'poker_hands'), chips = h.chips, mult = h.mult, level = h.level })
    level_up_hand(card, mano, nil, n)
    update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
        { mult = 0, chips = 0, handname = '', level = '' })
end

function KAS.mano_mas_jugada()
    local mejor, veces = 'High Card', -1
    for nombre, h in pairs(G.GAME.hands) do
        if h.visible and h.played > veces then mejor, veces = nombre, h.played end
    end
    return mejor
end

local function casino(t)
    t.set = "Casino"
    t.atlas = "casino"
    t.cost = t.cost or 4
    SMODS.Consumable(t)
end

casino {
    key = "thoth", pos = { x = 0, y = 0 },
    loc_txt = { name = "Thoth", text = { "Sube {C:attention}1{} nivel tu", "mano de póker {C:attention}más jugada{}" } },
    can_use = function(self, card) return true end,
    use = function(self, card) KAS.subir_nivel(card, KAS.mano_mas_jugada(), 1) end,
}

casino {
    key = "osiris", pos = { x = 1, y = 0 },
    loc_txt = { name = "Osiris", text = { "Revive el último", "{C:attention}comodín{} que vendiste", "{C:inactive}(Debe haber espacio)" } },
    can_use = function(self, card)
        return G.GAME.kas_ultimo_vendido and #G.jokers.cards < G.jokers.config.card_limit
    end,
    use = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4,
            func = function()
                SMODS.add_card({ key = G.GAME.kas_ultimo_vendido })
                play_sound('timpani')
                return true
            end,
        }))
    end,
}

casino {
    key = "isis", pos = { x = 2, y = 0 }, config = { max_highlighted = 2 },
    loc_txt = { name = "Isis", text = { "Convierte hasta {C:attention}2{} cartas", "seleccionadas en", "{C:attention}Cartas Marcadas{}" } },
    loc_vars = function(self, info_queue) info_queue[#info_queue + 1] = G.P_CENTERS.m_kas_marcada end,
    can_use = function(self, card) return seleccionadas(1, 2) end,
    use = function(self, card)
        a_seleccionadas(card, function(c) c:set_ability(G.P_CENTERS.m_kas_marcada, nil, true) end)
    end,
}

casino {
    key = "hermes", pos = { x = 3, y = 0 }, config = { max_highlighted = 2 },
    loc_txt = { name = "Hermes Trismegisto", text = { "Convierte hasta {C:attention}2{} cartas", "seleccionadas en", "{C:attention}Cartas Trucadas{}" } },
    loc_vars = function(self, info_queue) info_queue[#info_queue + 1] = G.P_CENTERS.m_kas_trucada end,
    can_use = function(self, card) return seleccionadas(1, 2) end,
    use = function(self, card)
        a_seleccionadas(card, function(c) c:set_ability(G.P_CENTERS.m_kas_trucada, nil, true) end)
    end,
}

casino {
    key = "ra", pos = { x = 4, y = 0 }, config = { extra = { chips = 10 } },
    loc_txt = { name = "Ra (Atum)", text = { "Todas las cartas de tu mano", "ganan {C:chips}+#1#{} fichas permanentes" } },
    loc_vars = function(self, info_queue, card) return { vars = { card.ability.extra.chips } } end,
    can_use = function(self, card) return G.hand and #G.hand.cards > 0 end,
    use = function(self, card)
        for _, c in ipairs(G.hand.cards) do
            c.ability.perma_bonus = (c.ability.perma_bonus or 0) + card.ability.extra.chips
            c:juice_up(0.2, 0.2)
        end
        play_sound('chips1')
    end,
}

casino {
    key = "anubis", pos = { x = 5, y = 0 }, config = { max_highlighted = 1 },
    loc_txt = { name = "Anubis", text = { "Destruye {C:attention}1{} carta seleccionada", "y ganas {C:money}${} igual a la", "mitad de su valor", "{C:inactive}(Figuras 10, As 11)" } },
    can_use = function(self, card) return seleccionadas(1, 1) end,
    use = function(self, card)
        local c = G.hand.highlighted[1]
        local premio = math.ceil(KAS.valor(c) / 2)
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.3,
            func = function()
                c:start_dissolve()
                ease_dollars(premio)
                return true
            end,
        }))
        SMODS.calculate_context({ remove_playing_cards = true, removed = { c } })
    end,
}

local VALORES = { '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace' }

casino {
    key = "set", pos = { x = 6, y = 0 }, config = { max_highlighted = 3 },
    loc_txt = { name = "Set (Seth)", text = { "Cambia a un {C:attention}valor aleatorio{}", "hasta {C:attention}3{} cartas seleccionadas" } },
    can_use = function(self, card) return seleccionadas(1, 3) end,
    use = function(self, card)
        a_seleccionadas(card, function(c)
            SMODS.change_base(c, nil, pseudorandom_element(VALORES, pseudoseed('kas_set')))
        end)
    end,
}

casino {
    key = "shu", pos = { x = 7, y = 0 }, config = { extra = { cartas = 3 } },
    loc_txt = { name = "Shu", text = { "Roba {C:attention}#1#{} cartas extra", "{C:inactive}(Solo durante una ronda)" } },
    loc_vars = function(self, info_queue, card) return { vars = { card.ability.extra.cartas } } end,
    can_use = function(self, card) return en_ronda() and #G.deck.cards > 0 end,
    use = function(self, card) G.FUNCS.draw_from_deck_to_hand(card.ability.extra.cartas) end,
}

casino {
    key = "tefnut", pos = { x = 0, y = 1 },
    loc_txt = { name = "Tefnut", text = { "{C:blue}+1{} mano en esta ronda", "{C:inactive}(Solo durante una ronda)" } },
    can_use = function(self, card) return en_ronda() end,
    use = function(self, card) ease_hands_played(1) end,
}

casino {
    key = "horus", pos = { x = 1, y = 1 },
    loc_txt = { name = "Horus", text = { "Da la edición {C:dark_edition}Laminada{}", "a un {C:attention}comodín{} aleatorio", "sin edición" } },
    loc_vars = function(self, info_queue) info_queue[#info_queue + 1] = G.P_CENTERS.e_foil end,
    can_use = function(self, card)
        for _, j in ipairs(G.jokers.cards) do if not j.edition then return true end end
        return false
    end,
    use = function(self, card)
        local sin_edicion = {}
        for _, j in ipairs(G.jokers.cards) do if not j.edition then sin_edicion[#sin_edicion + 1] = j end end
        local j = pseudorandom_element(sin_edicion, pseudoseed('kas_horus'))
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4,
            func = function() j:set_edition({ foil = true }, true) return true end,
        }))
    end,
}

casino {
    key = "neftis", pos = { x = 2, y = 1 },
    loc_txt = { name = "Neftis", text = { "Crea una carta", "{C:spectral}Espectral{}", "{C:inactive}(Debe haber espacio)" } },
    can_use = function(self, card)
        return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
    end,
    use = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4,
            func = function() KAS.crear('Spectral') return true end,
        }))
    end,
}

casino {
    key = "seshat", pos = { x = 3, y = 1 }, config = { extra = { dinero = 2, max = 20 } },
    loc_txt = { name = "Seshat", text = { "Ganas {C:money}$#1#{} por cada tipo de", "mano de póker que hayas", "jugado en la partida", "{C:inactive}(Máximo {C:money}$#2#{C:inactive})" } },
    loc_vars = function(self, info_queue, card) return { vars = { card.ability.extra.dinero, card.ability.extra.max } } end,
    can_use = function(self, card) return true end,
    use = function(self, card)
        local n = 0
        for _, h in pairs(G.GAME.hands) do if h.played > 0 then n = n + 1 end end
        ease_dollars(math.min(card.ability.extra.max, n * card.ability.extra.dinero))
    end,
}

casino {
    key = "maat", pos = { x = 4, y = 1 }, config = { extra = { gana = 10, pierde = 5 } },
    loc_txt = { name = "Ma'at", text = { "Pesa tu corazón:", "{C:green}1 entre 2{} de ganar {C:money}$#1#{};", "si no, pierdes {C:money}$#2#{}" } },
    loc_vars = function(self, info_queue, card) return { vars = { card.ability.extra.gana, card.ability.extra.pierde } } end,
    can_use = function(self, card) return true end,
    use = function(self, card)
        local e = card.ability.extra
        if pseudorandom('kas_maat') < KAS.prob_apuesta() then
            ease_dollars(e.gana)
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = "¡Justa!", colour = G.C.GREEN })
        else
            ease_dollars(-e.pierde)
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = "¡Culpable!", colour = G.C.RED })
        end
    end,
}

casino {
    key = "nut", pos = { x = 5, y = 1 },
    loc_txt = { name = "Nut", text = { "Sube {C:attention}2{} niveles una", "mano de póker {C:attention}aleatoria{}" } },
    can_use = function(self, card) return true end,
    use = function(self, card)
        local manos = {}
        for nombre, h in pairs(G.GAME.hands) do if h.visible then manos[#manos + 1] = nombre end end
        table.sort(manos)
        KAS.subir_nivel(card, pseudorandom_element(manos, pseudoseed('kas_nut')), 2)
    end,
}

casino {
    key = "geb", pos = { x = 6, y = 1 }, config = { max_highlighted = 3, extra = { chips = 20 } },
    loc_txt = { name = "Geb", text = { "Hasta {C:attention}3{} cartas seleccionadas", "ganan {C:chips}+#1#{} fichas permanentes" } },
    loc_vars = function(self, info_queue, card) return { vars = { card.ability.extra.chips } } end,
    can_use = function(self, card) return seleccionadas(1, 3) end,
    use = function(self, card)
        local extra = card.ability.extra.chips
        a_seleccionadas(card, function(c) c.ability.perma_bonus = (c.ability.perma_bonus or 0) + extra end)
    end,
}

casino {
    key = "iah", pos = { x = 7, y = 1 },
    loc_txt = { name = "Iah (Jonsu)", text = { "Recuperas todos los", "{C:red}descartes{} usados en", "esta ronda" } },
    can_use = function(self, card) return en_ronda() and G.GAME.current_round.discards_used > 0 end,
    use = function(self, card) ease_discard(G.GAME.current_round.discards_used) end,
}
