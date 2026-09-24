--- Kasino: comodines con tematica de casino para Balatro (Steamodded)

SMODS.Atlas {
    key = "jokers",
    path = "kasino_jokers.png",
    px = 71,
    py = 95,
}

local function prob()
    return (G.GAME and G.GAME.probabilities.normal) or 1
end

-- Animacion de destruccion (la misma que usa Gros Michel en el juego base)
local function destruir(card)
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
                end,
            }))
            return true
        end,
    }))
end

-- 1. Tragaperras: 1 entre 4 de X3 multi
SMODS.Joker {
    key = "tragaperras",
    loc_txt = {
        name = "Tragaperras",
        text = {
            "{C:green}#1# entre #2#{} probabilidades",
            "de dar {X:mult,C:white} X#3# {} multi",
        },
    },
    config = { extra = { odds = 4, xmult = 3 } },
    rarity = 2,
    cost = 6,
    atlas = "jokers",
    pos = { x = 0, y = 0 },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { prob(), card.ability.extra.odds, card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and pseudorandom('kas_tragaperras') < prob() / card.ability.extra.odds then
            return { xmult = card.ability.extra.xmult }
        end
    end,
}

-- 2. Crupier: cada 7 jugado da +7 multi al puntuar
SMODS.Joker {
    key = "crupier",
    loc_txt = {
        name = "Crupier",
        text = {
            "Cada {C:attention}7{} jugado da",
            "{C:mult}+#1#{} multi al puntuar",
        },
    },
    config = { extra = { mult = 7 } },
    rarity = 1,
    cost = 5,
    atlas = "jokers",
    pos = { x = 1, y = 0 },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 7 then
            return { mult = card.ability.extra.mult }
        end
    end,
}

-- 3. Ruleta: rojas dan multi, negras dan fichas
SMODS.Joker {
    key = "ruleta",
    loc_txt = {
        name = "Ruleta",
        text = {
            "Cartas de {C:hearts}Corazones{} y {C:diamonds}Diamantes{}",
            "dan {C:mult}+#1#{} multi al puntuar",
            "Cartas de {C:spades}Picas{} y {C:clubs}Tréboles{}",
            "dan {C:chips}+#2#{} fichas al puntuar",
        },
    },
    config = { extra = { mult = 3, chips = 20 } },
    rarity = 1,
    cost = 5,
    atlas = "jokers",
    pos = { x = 2, y = 0 },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local c = context.other_card
            if c:is_suit('Hearts') or c:is_suit('Diamonds') then
                return { mult = card.ability.extra.mult }
            elseif c:is_suit('Spades') or c:is_suit('Clubs') then
                return { chips = card.ability.extra.chips }
            end
        end
    end,
}

-- 4. Full de Ases: gana X0.25 multi cada vez que juegas un Full
SMODS.Joker {
    key = "full_de_ases",
    loc_txt = {
        name = "Full de Ases",
        text = {
            "Gana {X:mult,C:white} X#1# {} multi cada vez",
            "que juegas un {C:attention}Full{}",
            "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
        },
    },
    config = { extra = { gain = 0.25, xmult = 1 } },
    rarity = 2,
    cost = 7,
    atlas = "jokers",
    pos = { x = 3, y = 0 },
    blueprint_compat = true,
    perishable_compat = false,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and next(context.poker_hands['Full House']) then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
            return { message = localize('k_upgrade_ex'), colour = G.C.MULT }
        end
        if context.joker_main and card.ability.extra.xmult > 1 then
            return { xmult = card.ability.extra.xmult }
        end
    end,
}

-- 5. La Banca: da dinero al final de la ronda y sube con cada jefe derrotado
SMODS.Joker {
    key = "la_banca",
    loc_txt = {
        name = "La Banca",
        text = {
            "Ganas {C:money}$#1#{} al final de la ronda",
            "Aumenta en {C:money}$#2#{} al derrotar",
            "una {C:attention}ciega jefe{}",
        },
    },
    config = { extra = { dollars = 2, gain = 1 } },
    rarity = 2,
    cost = 6,
    atlas = "jokers",
    pos = { x = 4, y = 0 },
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.gain } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint
            and G.GAME.blind.boss then
            card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.gain
            return { message = localize('k_upgrade_ex'), colour = G.C.MONEY }
        end
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end,
}

-- 6. Doble o Nada: X2.5 multi, pero puede romperse al final de la ronda
SMODS.Joker {
    key = "doble_o_nada",
    loc_txt = {
        name = "Doble o Nada",
        text = {
            "{X:mult,C:white} X#1# {} multi",
            "{C:green}#2# entre #3#{} probabilidades de",
            "destruirse al final de la ronda",
        },
    },
    config = { extra = { xmult = 2.5, odds = 4 } },
    rarity = 2,
    cost = 6,
    atlas = "jokers",
    pos = { x = 5, y = 0 },
    blueprint_compat = true,
    eternal_compat = false,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, prob(), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = card.ability.extra.xmult }
        end
        if context.end_of_round and context.main_eval and not context.blueprint then
            if pseudorandom('kas_doble_o_nada') < prob() / card.ability.extra.odds then
                destruir(card)
                return { message = "¡Nada!", colour = G.C.RED }
            end
            return { message = localize('k_safe_ex') }
        end
    end,
}

-- 7. Contador de Cartas: +2 multi por cada carta descartada esta ronda
SMODS.Joker {
    key = "contador",
    loc_txt = {
        name = "Contador de Cartas",
        text = {
            "{C:mult}+#1#{} multi por cada carta",
            "{C:attention}descartada{} esta ronda",
            "{C:inactive}(Actual: {C:mult}+#2#{C:inactive} multi)",
        },
    },
    config = { extra = { gain = 2, mult = 0 } },
    rarity = 1,
    cost = 5,
    atlas = "jokers",
    pos = { x = 6, y = 0 },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
            return { message = localize('k_upgrade_ex'), colour = G.C.MULT }
        end
        if context.end_of_round and context.main_eval and not context.blueprint
            and card.ability.extra.mult > 0 then
            card.ability.extra.mult = 0
            return { message = localize('k_reset'), colour = G.C.RED }
        end
        if context.joker_main and card.ability.extra.mult > 0 then
            return { mult = card.ability.extra.mult }
        end
    end,
}

-- 8. As en la Manga: reactiva cada As jugado
SMODS.Joker {
    key = "as_en_la_manga",
    loc_txt = {
        name = "As en la Manga",
        text = {
            "Reactiva cada {C:attention}As{}",
            "jugado {C:attention}#1#{} vez adicional",
        },
    },
    config = { extra = { repetitions = 1 } },
    rarity = 2,
    cost = 7,
    atlas = "jokers",
    pos = { x = 7, y = 0 },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card:get_id() == 14 then
            return { repetitions = card.ability.extra.repetitions }
        end
    end,
}
