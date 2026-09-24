--- GENERADO por tools/generar_comodines.py: no editar a mano.
--- Comodines de las hojas de sprites de assets/fuente.

SMODS.Atlas { key = "cartas", path = "kasino_cartas.png", px = 71, py = 95 }
SMODS.Atlas { key = "cartas2", path = "kasino_cartas_2.png", px = 71, py = 95 }
SMODS.Atlas { key = "cartas3", path = "kasino_cartas_3.png", px = 71, py = 95 }

-- 1. Bufón Clásico
do
    SMODS.Joker {
        key = "bufon_clasico",
        loc_txt = {
            name = "Bufón Clásico",
            text = {
                "{C:mult}+#1#{} multi por cada comodín",
                "{C:blue}Común{} que tengas",
            },
        },
        config = { extra = { mult = 4 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 0, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = 0 for _, j in ipairs(G.jokers.cards) do if j.config.center.rarity == 1 then n = n + 1 end end if n > 0 then return { mult = e.mult * n } end end),
    }
end

-- 2. Bufón Sombrío
do
    SMODS.Joker {
        key = "bufon_sombrio",
        loc_txt = {
            name = "Bufón Sombrío",
            text = {
                "{C:mult}+#1#{} multi si todas las cartas",
                "puntuadas son de {C:spades}Picas{}",
            },
        },
        config = { extra = { mult = 25 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 1, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.suit('Spades')) == #context.scoring_hand end),
    }
end

-- 3. Rey Bufón
do
    SMODS.Joker {
        key = "rey_bufon",
        loc_txt = {
            name = "Rey Bufón",
            text = {
                "Cada {C:attention}Rey{} puntuado",
                "da {X:mult,C:white} X#1# {} multi",
            },
        },
        config = { extra = { xmult = 1.25 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas",
        pos = { x = 2, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.per_card(KAS.rank(13)),
    }
end

-- 4. Bufón Violeta
do
    SMODS.Joker {
        key = "bufon_violeta",
        loc_txt = {
            name = "Bufón Violeta",
            text = {
                "Gana {C:mult}+#1#{} multi cada vez que",
                "juegas una {C:attention}Doble pareja{}",
                "{C:inactive}(Actual: {C:mult}+#2#{C:inactive} multi)",
            },
        },
        config = { extra = { gain = 2, mult = 0 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 3, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.mult } }
        end,
        calculate = KAS.scale{ field = 'mult', on = KAS.T.hand_type('Two Pair') },
    }
end

-- 5. Bufón Alegre
do
    SMODS.Joker {
        key = "bufon_alegre",
        loc_txt = {
            name = "Bufón Alegre",
            text = {
                "Si la mano jugada es {C:attention}Pareja{},",
                "cada carta puntuada da {C:chips}+#1#{} fichas",
            },
        },
        config = { extra = { chips = 25 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 4, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.per_card(KAS.jugada('Pair')),
    }
end

-- 6. Bufón de Cascabeles
do
    SMODS.Joker {
        key = "bufon_cascabeles",
        loc_txt = {
            name = "Bufón de Cascabeles",
            text = {
                "Al final de la ronda ganas {C:money}$#1#{}",
                "por cada {C:attention}mano{} jugada",
            },
        },
        config = { extra = { dollars = 1 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 5, y = 0 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calc_dollar_bonus = function(self, card) local n = G.GAME.current_round.hands_played if n > 0 then return n * card.ability.extra.dollars end end,
    }
end

-- 7. Bufón Puntiagudo
do
    SMODS.Joker {
        key = "bufon_puntiagudo",
        loc_txt = {
            name = "Bufón Puntiagudo",
            text = {
                "{C:mult}+#1#{} multi por cada",
                "{C:attention}mano{} restante",
            },
        },
        config = { extra = { mult = 3 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 6, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = G.GAME.current_round.hands_left if n > 0 then return { mult = e.mult * n } end end),
    }
end

-- 8. Reina Bufona
do
    SMODS.Joker {
        key = "reina_bufona",
        loc_txt = {
            name = "Reina Bufona",
            text = {
                "Cada {C:attention}Reina{} puntuada da",
                "{C:mult}+#1#{} multi y {C:chips}+#2#{} fichas",
            },
        },
        config = { extra = { mult = 8, chips = 20 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 7, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult, e.chips } }
        end,
        calculate = KAS.per_card(KAS.rank(12)),
    }
end

-- 9. Bufón Siniestro
do
    SMODS.Joker {
        key = "bufon_siniestro",
        loc_txt = {
            name = "Bufón Siniestro",
            text = {
                "{X:mult,C:white} X#1# {} multi si aún no has",
                "conseguido la {C:attention}mitad{} de la ciega",
            },
        },
        config = { extra = { xmult = 2 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 8, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(function() return G.GAME.chips < G.GAME.blind.chips / 2 end),
    }
end

-- 10. Bufón Fantasma
do
    SMODS.Joker {
        key = "bufon_fantasma",
        loc_txt = {
            name = "Bufón Fantasma",
            text = {
                "Al {C:attention}venderlo{}, crea una",
                "carta {C:spectral}Espectral{}",
            },
        },
        config = { extra = {  } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 9, y = 0 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.sell_create("Spectral"),
    }
end

-- 11. Arlequín de Retales
do
    SMODS.Joker {
        key = "arlequin_retales",
        loc_txt = {
            name = "Arlequín de Retales",
            text = {
                "{C:mult}+#1#{} multi por cada {C:attention}palo{}",
                "distinto en la mano puntuada",
            },
        },
        config = { extra = { mult = 10 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 0, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = KAS.palos_distintos(context) if n > 0 then return { mult = e.mult * n } end end),
    }
end

-- 12. Bufón Danzarín
do
    SMODS.Joker {
        key = "bufon_danzarin",
        loc_txt = {
            name = "Bufón Danzarín",
            text = {
                "Gana {C:chips}+#1#{} fichas por cada carta descartada;",
                "se reinicia al final de la ronda",
                "{C:inactive}(Actual: {C:chips}+#2#{C:inactive} fichas)",
            },
        },
        config = { extra = { gain = 6, chips = 0 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 1, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.chips } }
        end,
        calculate = KAS.scale{ field = 'chips', on = KAS.T.discard, reset = KAS.T.round_end },
    }
end

-- 13. Máscara Vampira
do
    SMODS.Joker {
        key = "mascara_vampira",
        loc_txt = {
            name = "Máscara Vampira",
            text = {
                "Gana {X:mult,C:white} X#1# {} multi por cada",
                "carta de {C:attention}figura{} puntuada",
                "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
            },
        },
        config = { extra = { gain = 0.1, xmult = 1 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas",
        pos = { x = 2, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.xmult } }
        end,
        calculate = KAS.scale{ field = 'xmult', on = function(context) return context.before and KAS.contar(context.scoring_hand, KAS.face) end },
    }
end

-- 14. Bufón Bicolor
do
    SMODS.Joker {
        key = "bufon_bicolor",
        loc_txt = {
            name = "Bufón Bicolor",
            text = {
                "{X:mult,C:white} X#1# {} multi si todas las cartas",
                "puntuadas son {C:attention}pares{}",
            },
        },
        config = { extra = { xmult = 1.5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 3, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.even) == #context.scoring_hand end),
    }
end

-- 15. Bufón Verde
do
    SMODS.Joker {
        key = "bufon_verde",
        loc_txt = {
            name = "Bufón Verde",
            text = {
                "Gana {C:mult}+#1#{} multi por cada mano jugada;",
                "pierde la {C:attention}mitad{} al final de la ronda",
                "{C:inactive}(Actual: {C:mult}+#2#{C:inactive} multi)",
            },
        },
        config = { extra = { gain = 2, mult = 0 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 4, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.mult } }
        end,
        calculate = function(self, card, context) local e = card.ability.extra if context.before and not context.blueprint then e.mult = e.mult + e.gain return { message = localize('k_upgrade_ex'), colour = G.C.MULT } end if KAS.T.round_end(context) and not context.blueprint and e.mult > 0 then e.mult = math.floor(e.mult / 2) return { message = '-50%', colour = G.C.RED } end if context.joker_main and e.mult > 0 then return { mult = e.mult } end end,
    }
end

-- 16. Bufón Estrella
do
    SMODS.Joker {
        key = "bufon_estrella",
        loc_txt = {
            name = "Bufón Estrella",
            text = {
                "{X:mult,C:white} X#1# {} multi si la mano puntuada",
                "tiene {C:attention}#2#{} Ases o más",
            },
        },
        config = { extra = { xmult = 2, min = 2 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 5, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult, e.min } }
        end,
        calculate = KAS.cond(function(card, context, e) return KAS.contar(context.scoring_hand, KAS.rank(14)) >= e.min end),
    }
end

-- 17. Noche Estrellada
do
    SMODS.Joker {
        key = "noche_estrellada",
        loc_txt = {
            name = "Noche Estrellada",
            text = {
                "Crea una carta de {C:planet}Planeta{}",
                "al final de la ronda",
                "{C:inactive}(Debe haber espacio)",
            },
        },
        config = { extra = {  } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 6, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.create(KAS.T.round_end, "Planet", nil),
    }
end

-- 18. Bufón Confuso
do
    SMODS.Joker {
        key = "bufon_confuso",
        loc_txt = {
            name = "Bufón Confuso",
            text = {
                "{C:green}#1# entre #2#{} probabilidades",
                "de dar {C:mult}+#3#{} multi",
            },
        },
        config = { extra = { odds = 2, mult = 20 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 7, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { KAS.prob(), e.odds, e.mult } }
        end,
        calculate = KAS.chance("kas_bufon_confuso"),
    }
end

-- 19. Caja Sorpresa
do
    SMODS.Joker {
        key = "caja_sorpresa",
        loc_txt = {
            name = "Caja Sorpresa",
            text = {
                "Al seleccionar la {C:attention}ciega{}, crea una",
                "carta de {C:tarot}Tarot{}, {C:planet}Planeta{} o",
                "{C:spectral}Espectral{} al azar",
                "{C:inactive}(Debe haber espacio)",
            },
        },
        config = { extra = {  } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 8, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = function(self, card, context) if context.setting_blind then local r = pseudorandom('kas_caja_sorpresa') return KAS.crear(r < 0.45 and 'Tarot' or r < 0.9 and 'Planet' or 'Spectral') end end,
    }
end

-- 20. Arlequín
do
    SMODS.Joker {
        key = "arlequin",
        loc_txt = {
            name = "Arlequín",
            text = {
                "{X:mult,C:white} +X#1# {} multi por cada",
                "comodín a su {C:attention}izquierda{}",
            },
        },
        config = { extra = { step = 0.2 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 9, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.step } }
        end,
        calculate = KAS.dyn(function(card, context, e) for i, j in ipairs(G.jokers.cards) do if j == card then if i > 1 then return { xmult = 1 + e.step * (i - 1) } end return end end end),
    }
end

-- 21. Gato Negro
do
    SMODS.Joker {
        key = "gato_negro",
        loc_txt = {
            name = "Gato Negro",
            text = {
                "Cada {C:attention}7{} puntuado tiene",
                "{C:green}#1# entre #2#{} probabilidades",
                "de dar {X:mult,C:white} X#3# {} multi",
            },
        },
        config = { extra = { odds = 2, xmult = 1.5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 0, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { KAS.prob(), e.odds, e.xmult } }
        end,
        calculate = KAS.per_card(KAS.rank(7), "kas_gato_negro"),
    }
end

-- 22. Zorro Astuto
do
    SMODS.Joker {
        key = "zorro_astuto",
        loc_txt = {
            name = "Zorro Astuto",
            text = {
                "Ganas {C:money}$#1#{} por cada carta",
                "de {C:attention}figura{} descartada",
            },
        },
        config = { extra = { dollars = 1 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 1, y = 2 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calculate = function(self, card, context) if context.discard and context.other_card:is_face() then KAS.dinero(card, card.ability.extra.dollars) end end,
    }
end

-- 23. Conejo de la Suerte
do
    SMODS.Joker {
        key = "conejo_suerte",
        loc_txt = {
            name = "Conejo de la Suerte",
            text = {
                "Cada carta puntuada tiene",
                "{C:green}#1# entre #2#{} probabilidades de",
                "{C:attention}reactivarse{}",
            },
        },
        config = { extra = { odds = 4, reps = 1 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas",
        pos = { x = 2, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { KAS.prob(), e.odds } }
        end,
        calculate = KAS.retrigger(function(c, context, e) return pseudorandom('kas_conejo_suerte') < KAS.prob() / e.odds end),
    }
end

-- 24. Rey Rana
do
    SMODS.Joker {
        key = "rey_rana",
        loc_txt = {
            name = "Rey Rana",
            text = {
                "{X:mult,C:white} +X#1# {} multi por cada carta",
                "que juegues por debajo de {C:attention}5{}",
            },
        },
        config = { extra = { step = 0.5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 3, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.step } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = 5 - #context.full_hand if n > 0 then return { xmult = 1 + e.step * n } end end),
    }
end

-- 25. Pingüino
do
    SMODS.Joker {
        key = "pinguino",
        loc_txt = {
            name = "Pingüino",
            text = {
                "Cada carta de {C:clubs}Tréboles{} puntuada",
                "da {C:chips}+#1#{} fichas",
            },
        },
        config = { extra = { chips = 30 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 4, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.per_card(KAS.suit("Clubs")),
    }
end

-- 26. Cuervo
do
    SMODS.Joker {
        key = "cuervo",
        loc_txt = {
            name = "Cuervo",
            text = {
                "Gana {C:money}$#1#{} de {C:attention}valor de venta{} cada",
                "vez que juegas una {C:attention}Carta alta{}",
            },
        },
        config = { extra = { gain = 1 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 5, y = 2 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain } }
        end,
        calculate = function(self, card, context) if context.before and not context.blueprint and context.scoring_name == 'High Card' then card.ability.extra_value = (card.ability.extra_value or 0) + card.ability.extra.gain card:set_cost() return { message = localize('k_val_up'), colour = G.C.MONEY } end end,
    }
end

-- 27. Tigre
do
    SMODS.Joker {
        key = "tigre",
        loc_txt = {
            name = "Tigre",
            text = {
                "{X:mult,C:white} X#1# {} multi si la mano contiene",
                "una {C:attention}Escalera{} con un {C:attention}As{}",
            },
        },
        config = { extra = { xmult = 3 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas",
        pos = { x = 6, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(function(card, context) return next(context.poker_hands['Straight']) ~= nil and KAS.contar(context.scoring_hand, KAS.rank(14)) > 0 end),
    }
end

-- 28. Lobo Solitario
do
    SMODS.Joker {
        key = "lobo_solitario",
        loc_txt = {
            name = "Lobo Solitario",
            text = {
                "{X:mult,C:white} X#1# {} multi si tienes",
                "{C:attention}#2#{} comodines o menos",
            },
        },
        config = { extra = { xmult = 2.5, max = 2 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas",
        pos = { x = 7, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult, e.max } }
        end,
        calculate = KAS.cond(function(card, context, e) return #G.jokers.cards <= e.max end),
    }
end

-- 29. Dragón
do
    SMODS.Joker {
        key = "dragon",
        loc_txt = {
            name = "Dragón",
            text = {
                "Gana {X:mult,C:white} X#1# {} multi por cada mano",
                "jugada; se reinicia al {C:attention}descartar{}",
                "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
            },
        },
        config = { extra = { gain = 0.15, xmult = 1 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas",
        pos = { x = 8, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.xmult } }
        end,
        calculate = KAS.scale{ field = 'xmult', on = KAS.T.hand_played, reset = KAS.T.pre_discard },
    }
end

-- 30. Serpiente
do
    local al_entrar, al_salir = KAS.passive({ hand_size = 2, discards = -1 })
    SMODS.Joker {
        key = "serpiente",
        loc_txt = {
            name = "Serpiente",
            text = {
                "{C:attention}+#1#{} tamaño de mano,",
                "{C:red}-#2#{} descarte por ronda",
            },
        },
        config = { extra = { n = 2, m = 1 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 9, y = 2 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.n, e.m } }
        end,
        add_to_deck = al_entrar,
        remove_from_deck = al_salir,
    }
end

-- 31. Reloj de Arena
do
    local al_entrar, al_salir = KAS.passive({ hands = 1 })
    SMODS.Joker {
        key = "reloj_arena",
        loc_txt = {
            name = "Reloj de Arena",
            text = {
                "{C:blue}+#1#{} mano por ronda",
            },
        },
        config = { extra = { n = 1 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas",
        pos = { x = 0, y = 3 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.n } }
        end,
        add_to_deck = al_entrar,
        remove_from_deck = al_salir,
    }
end

-- 32. Saturno
do
    SMODS.Joker {
        key = "saturno",
        loc_txt = {
            name = "Saturno",
            text = {
                "Si la mano contiene una {C:attention}Escalera{},",
                "crea una carta de {C:planet}Planeta{}",
                "{C:inactive}(Debe haber espacio)",
            },
        },
        config = { extra = {  } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 1, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.create(KAS.T.hand_type("Straight"), "Planet", nil),
    }
end

-- 33. Galaxia
do
    SMODS.Joker {
        key = "galaxia",
        loc_txt = {
            name = "Galaxia",
            text = {
                "{X:mult,C:white} +X#1# {} multi por cada carta",
                "de {C:planet}Planeta{} que tengas",
            },
        },
        config = { extra = { step = 0.5 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas",
        pos = { x = 2, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.step } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = 0 for _, c in ipairs(G.consumeables.cards) do if c.ability.set == 'Planet' then n = n + 1 end end if n > 0 then return { xmult = 1 + e.step * n } end end),
    }
end

-- 34. Estrella Polar
do
    SMODS.Joker {
        key = "estrella_polar",
        loc_txt = {
            name = "Estrella Polar",
            text = {
                "Cada carta de {C:diamonds}Diamantes{} puntuada da",
                "{C:mult}+#1#{} multi por cada {C:money}$#2#{} que tengas",
            },
        },
        config = { extra = { mult = 1, per = 10 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 3, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult, e.per } }
        end,
        calculate = KAS.per_card_fn(KAS.suit('Diamonds'), function(c, context, e) local n = math.floor(G.GAME.dollars / e.per) if n > 0 then return { mult = e.mult * n } end end),
    }
end

-- 35. Sol Radiante
do
    SMODS.Joker {
        key = "sol_radiante",
        loc_txt = {
            name = "Sol Radiante",
            text = {
                "{X:mult,C:white} X#1# {} multi en la",
                "{C:attention}primera mano{} de la ronda",
            },
        },
        config = { extra = { xmult = 2 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas",
        pos = { x = 4, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(KAS.first_hand),
    }
end

-- 36. Luna Menguante
do
    SMODS.Joker {
        key = "luna_menguante",
        loc_txt = {
            name = "Luna Menguante",
            text = {
                "Crea una carta de {C:tarot}Tarot{}",
                "al final de la ronda",
                "{C:inactive}(Debe haber espacio)",
            },
        },
        config = { extra = {  } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 5, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.create(KAS.T.round_end, "Tarot", nil),
    }
end

-- 37. Bufón Cósmico
do
    SMODS.Joker {
        key = "bufon_cosmico",
        loc_txt = {
            name = "Bufón Cósmico",
            text = {
                "Crea una carta de {C:planet}Planeta{}",
                "cada vez que juegas una mano",
                "{C:inactive}(Debe haber espacio)",
            },
        },
        config = { extra = {  } },
        rarity = 4,
        cost = 20,
        atlas = "cartas",
        pos = { x = 6, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.create(KAS.T.hand_played, "Planet"),
    }
end

-- 38. Bola de Cristal
do
    local al_entrar, al_salir = KAS.passive({ consumable_slots = 1 })
    SMODS.Joker {
        key = "bola_cristal",
        loc_txt = {
            name = "Bola de Cristal",
            text = {
                "{C:attention}+#1#{} espacio de consumible",
            },
        },
        config = { extra = { n = 1 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 7, y = 3 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.n } }
        end,
        add_to_deck = al_entrar,
        remove_from_deck = al_salir,
    }
end

-- 39. Sombrero de Mago
do
    SMODS.Joker {
        key = "sombrero_mago",
        loc_txt = {
            name = "Sombrero de Mago",
            text = {
                "Gana {C:chips}+#1#{} fichas por cada consumible usado;",
                "se reinicia al final de la ronda",
                "{C:inactive}(Actual: {C:chips}+#2#{C:inactive} fichas)",
            },
        },
        config = { extra = { gain = 15, chips = 0 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 8, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.chips } }
        end,
        calculate = KAS.scale{ field = 'chips', on = KAS.T.any_consumable, reset = KAS.T.round_end },
    }
end

-- 40. Demonio de Fuego
do
    local al_entrar, al_salir = KAS.passive({ discards = -1 })
    SMODS.Joker {
        key = "demonio_fuego",
        loc_txt = {
            name = "Demonio de Fuego",
            text = {
                "{X:mult,C:white} X#1# {} multi,",
                "{C:red}-#2#{} descarte por ronda",
            },
        },
        config = { extra = { xmult = 3, n = 1 } },
        rarity = 3,
        cost = 9,
        atlas = "cartas",
        pos = { x = 9, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult, e.n } }
        end,
        calculate = KAS.flat(),
        add_to_deck = al_entrar,
        remove_from_deck = al_salir,
    }
end

-- 41. Bufón de Hielo
do
    SMODS.Joker {
        key = "bufon_hielo",
        loc_txt = {
            name = "Bufón de Hielo",
            text = {
                "{C:chips}+#1#{} fichas si no has usado",
                "{C:attention}descartes{} esta ronda",
            },
        },
        config = { extra = { chips = 100 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 0, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.cond(KAS.no_discards),
    }
end

-- 42. Bufón Venenoso
do
    SMODS.Joker {
        key = "bufon_venenoso",
        loc_txt = {
            name = "Bufón Venenoso",
            text = {
                "{X:mult,C:white} X#1# {} multi si la mano puntuada",
                "tiene {C:attention}#2#{} o más {C:clubs}Tréboles{}",
            },
        },
        config = { extra = { xmult = 1.5, min = 3 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 1, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult, e.min } }
        end,
        calculate = KAS.cond(function(card, context, e) return KAS.contar(context.scoring_hand, KAS.suit('Clubs')) >= e.min end),
    }
end

-- 43. Bufón de Piedra
do
    SMODS.Joker {
        key = "bufon_piedra",
        loc_txt = {
            name = "Bufón de Piedra",
            text = {
                "{C:chips}+#1#{} fichas por cada carta",
                "de {C:attention}Piedra{} en tu baraja",
            },
        },
        config = { extra = { chips = 50 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 2, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = KAS.contar(G.playing_cards, KAS.mejora('m_stone')) if n > 0 then return { chips = e.chips * n } end end),
    }
end

-- 44. Bufón de Fuego
do
    SMODS.Joker {
        key = "bufon_fuego",
        loc_txt = {
            name = "Bufón de Fuego",
            text = {
                "Gana {C:mult}+#1#{} multi por cada mano",
                "jugada; se reinicia al final de la ronda",
                "{C:inactive}(Actual: {C:mult}+#2#{C:inactive} multi)",
            },
        },
        config = { extra = { gain = 3, mult = 0 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 3, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.mult } }
        end,
        calculate = KAS.scale{ field = 'mult', on = KAS.T.hand_played, reset = KAS.T.round_end },
    }
end

-- 45. Bufón de Agua
do
    SMODS.Joker {
        key = "bufon_agua",
        loc_txt = {
            name = "Bufón de Agua",
            text = {
                "{C:chips}+#1#{} fichas por cada carta",
                "que tengas en la {C:attention}mano{}",
            },
        },
        config = { extra = { chips = 10 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 4, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.dyn(function(card, context, e) if #G.hand.cards > 0 then return { chips = e.chips * #G.hand.cards } end end),
    }
end

-- 46. Bufón Arcano
do
    SMODS.Joker {
        key = "bufon_arcano",
        loc_txt = {
            name = "Bufón Arcano",
            text = {
                "{X:mult,C:white} +X#1# {} multi por cada",
                "{C:attention}consumible{} que tengas",
            },
        },
        config = { extra = { step = 0.25 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 5, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.step } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = #G.consumeables.cards if n > 0 then return { xmult = 1 + e.step * n } end end),
    }
end

-- 47. Bufón Rubí
do
    SMODS.Joker {
        key = "bufon_rubi",
        loc_txt = {
            name = "Bufón Rubí",
            text = {
                "{X:mult,C:white} X#1# {} multi si la mano puntuada",
                "tiene exactamente {C:attention}un{} {C:hearts}Corazón{}",
            },
        },
        config = { extra = { xmult = 2 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 6, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.suit('Hearts')) == 1 end),
    }
end

-- 48. Bufón Diamante
do
    SMODS.Joker {
        key = "bufon_diamante",
        loc_txt = {
            name = "Bufón Diamante",
            text = {
                "Cada carta de {C:diamonds}Diamantes{} puntuada",
                "sube {C:money}$#1#{} su {C:attention}valor de venta{}",
            },
        },
        config = { extra = { gain = 1 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 7, y = 4 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain } }
        end,
        calculate = function(self, card, context) if context.individual and context.cardarea == G.play and not context.blueprint and context.other_card:is_suit('Diamonds') then card.ability.extra_value = (card.ability.extra_value or 0) + card.ability.extra.gain card:set_cost() return { message = localize('k_val_up'), colour = G.C.MONEY, card = card } end end,
    }
end

-- 49. Diablillo
do
    SMODS.Joker {
        key = "diablillo",
        loc_txt = {
            name = "Diablillo",
            text = {
                "Cada {C:attention}6{} puntuado",
                "da {X:mult,C:white} X#1# {} multi",
            },
        },
        config = { extra = { xmult = 1.5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 8, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.per_card(KAS.rank(6)),
    }
end

-- 50. Bufón Calavera
do
    SMODS.Joker {
        key = "bufon_calavera",
        loc_txt = {
            name = "Bufón Calavera",
            text = {
                "Gana {C:mult}+#1#{} multi por cada",
                "carta {C:attention}descartada{}",
                "{C:inactive}(Actual: {C:mult}+#2#{C:inactive} multi)",
            },
        },
        config = { extra = { gain = 1, mult = 0 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 9, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.mult } }
        end,
        calculate = KAS.scale{ field = 'mult', on = KAS.T.discard },
    }
end

-- 51. El Caballero
do
    SMODS.Joker {
        key = "el_caballero",
        loc_txt = {
            name = "El Caballero",
            text = {
                "Al final de la ronda ganas {C:money}$1{}",
                "por cada {C:money}$#1#{} que tengas",
                "{C:inactive}(Máximo {C:money}$#2#{C:inactive})",
            },
        },
        config = { extra = { per = 10, max = 5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 0, y = 5 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.per, e.max } }
        end,
        calc_dollar_bonus = function(self, card) local e = card.ability.extra local n = math.min(e.max, math.floor(G.GAME.dollars / e.per)) if n > 0 then return n end end,
    }
end

-- 52. Médico de la Peste
do
    SMODS.Joker {
        key = "medico_peste",
        loc_txt = {
            name = "Médico de la Peste",
            text = {
                "{X:mult,C:white} X#1# {} multi si la mano",
                "jugada es {C:attention}Carta alta{}",
            },
        },
        config = { extra = { xmult = 2.5 } },
        rarity = 2,
        cost = 5,
        atlas = "cartas",
        pos = { x = 1, y = 5 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(function(card, context) return context.scoring_name == 'High Card' end),
    }
end

-- 53. Tahúr
do
    SMODS.Joker {
        key = "tahur",
        loc_txt = {
            name = "Tahúr",
            text = {
                "Reactiva la {C:attention}última{} carta",
                "puntuada {C:attention}#1#{} veces más",
            },
        },
        config = { extra = { reps = 2 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas",
        pos = { x = 2, y = 5 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.reps } }
        end,
        calculate = KAS.retrigger(function(c, context) return c == context.scoring_hand[#context.scoring_hand] end),
    }
end

-- 54. Enterrador
do
    SMODS.Joker {
        key = "enterrador",
        loc_txt = {
            name = "Enterrador",
            text = {
                "Gana {X:mult,C:white} X#1# {} multi por cada",
                "carta {C:attention}destruida{}",
                "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
            },
        },
        config = { extra = { gain = 0.2, xmult = 1 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas",
        pos = { x = 3, y = 5 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.xmult } }
        end,
        calculate = KAS.scale{ field = 'xmult', on = KAS.T.remove_cards },
    }
end

-- 55. Bufón del Tesoro
do
    SMODS.Joker {
        key = "bufon_tesoro",
        loc_txt = {
            name = "Bufón del Tesoro",
            text = {
                "Ganas {C:money}$#1#{} al seleccionar",
                "la {C:attention}ciega{}",
            },
        },
        config = { extra = { dollars = 4 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 4, y = 5 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calculate = function(self, card, context) if context.setting_blind then KAS.dinero(card, card.ability.extra.dollars) end end,
    }
end

-- 56. Bardo
do
    SMODS.Joker {
        key = "bardo",
        loc_txt = {
            name = "Bardo",
            text = {
                "Cada {C:attention}Rey{} o {C:attention}Reina{}",
                "puntuado da {C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 4 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 5, y = 5 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.per_card(KAS.rank(12, 13)),
    }
end

-- 57. Bufón Enamorado
do
    SMODS.Joker {
        key = "bufon_enamorado",
        loc_txt = {
            name = "Bufón Enamorado",
            text = {
                "Cada carta de {C:hearts}Corazones{} puntuada",
                "da tanto {C:mult}multi{} como su valor",
                "{C:inactive}(Figuras 10, As 11)",
            },
        },
        config = { extra = {  } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 6, y = 5 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.per_card_fn(KAS.suit('Hearts'), function(c) return { mult = KAS.valor(c) } end),
    }
end

-- 58. Bufón Duelista
do
    SMODS.Joker {
        key = "bufon_duelista",
        loc_txt = {
            name = "Bufón Duelista",
            text = {
                "Gana {C:mult}+#1#{} multi por cada {C:attention}Pareja{} jugada;",
                "se reinicia al final de la ronda",
                "{C:inactive}(Actual: {C:mult}+#2#{C:inactive} multi)",
            },
        },
        config = { extra = { gain = 4, mult = 0 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 7, y = 5 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.mult } }
        end,
        calculate = KAS.scale{ field = 'mult', on = KAS.T.hand_type('Pair'), reset = KAS.T.round_end },
    }
end

-- 59. Malabarista
do
    SMODS.Joker {
        key = "malabarista",
        loc_txt = {
            name = "Malabarista",
            text = {
                "Si descartas exactamente",
                "{C:attention}#1#{} cartas, ganas {C:blue}+1{} mano",
            },
        },
        config = { extra = { cards = 5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 8, y = 5 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.cards } }
        end,
        calculate = function(self, card, context) if context.pre_discard and not context.blueprint and #G.hand.highlighted == card.ability.extra.cards then ease_hands_played(1) return { message = '+1', colour = G.C.BLUE } end end,
    }
end

-- 60. Ladrón
do
    SMODS.Joker {
        key = "ladron",
        loc_txt = {
            name = "Ladrón",
            text = {
                "Al vender otro {C:attention}comodín{},",
                "ganas su valor de venta otra vez",
            },
        },
        config = { extra = {  } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 9, y = 5 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = function(self, card, context) if KAS.T.sell_other_joker(context, card) and not context.blueprint then KAS.dinero(card, context.card.sell_cost) end end,
    }
end

-- 61. Maestro de Pista
do
    local al_entrar, al_salir = KAS.passive({ joker_slots = 1 })
    SMODS.Joker {
        key = "maestro_pista",
        loc_txt = {
            name = "Maestro de Pista",
            text = {
                "{C:dark_edition}+#1#{} espacio de comodín",
            },
        },
        config = { extra = { n = 1 } },
        rarity = 3,
        cost = 10,
        atlas = "cartas",
        pos = { x = 0, y = 6 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.n } }
        end,
        add_to_deck = al_entrar,
        remove_from_deck = al_salir,
    }
end

-- 62. Bufón de la Rosa
do
    SMODS.Joker {
        key = "bufon_rosa",
        loc_txt = {
            name = "Bufón de la Rosa",
            text = {
                "Reactiva cada {C:attention}Reina{}",
                "puntuada {C:attention}#1#{} vez más",
            },
        },
        config = { extra = { reps = 1 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 1, y = 6 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.reps } }
        end,
        calculate = KAS.retrigger(KAS.rank(12)),
    }
end

-- 63. Piruleta
do
    SMODS.Joker {
        key = "piruleta",
        loc_txt = {
            name = "Piruleta",
            text = {
                "{C:mult}+#1#{} multi,",
                "pierde {C:mult}#2#{} multi cada vez que descartas",
            },
        },
        config = { extra = { mult = 20, loss = 4, gain = -4 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 2, y = 6 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult, e.loss } }
        end,
        calculate = KAS.scale{ field = 'mult', on = KAS.T.pre_discard, destroy_at = 0 },
    }
end

-- 64. Bufón Feliz
do
    SMODS.Joker {
        key = "bufon_feliz",
        loc_txt = {
            name = "Bufón Feliz",
            text = {
                "Si la mano jugada es un {C:attention}Trío{},",
                "reactiva todas las cartas puntuadas",
            },
        },
        config = { extra = { reps = 1 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 3, y = 6 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.retrigger(KAS.jugada('Three of a Kind')),
    }
end

-- 65. Mago de la Moneda
do
    SMODS.Joker {
        key = "mago_moneda",
        loc_txt = {
            name = "Mago de la Moneda",
            text = {
                "{X:mult,C:white} +X#1# {} multi por cada",
                "{C:money}$#2#{} que tengas",
            },
        },
        config = { extra = { step = 0.1, per = 10 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas",
        pos = { x = 4, y = 6 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.step, e.per } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = math.floor(G.GAME.dollars / e.per) if n > 0 then return { xmult = 1 + e.step * n } end end),
    }
end

-- 66. Guitarrista
do
    SMODS.Joker {
        key = "guitarrista",
        loc_txt = {
            name = "Guitarrista",
            text = {
                "Si la mano contiene una {C:attention}Escalera{},",
                "reactiva todas las cartas puntuadas",
            },
        },
        config = { extra = { reps = 1 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas",
        pos = { x = 5, y = 6 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.retrigger(KAS.jugada('Straight', 'Straight Flush')),
    }
end

-- 67. Bufón de los Globos
do
    SMODS.Joker {
        key = "bufon_globos",
        loc_txt = {
            name = "Bufón de los Globos",
            text = {
                "Gana {C:mult}+#1#{} multi por cada mano jugada;",
                "{C:green}#2# entre #3#{} probabilidades de",
                "{C:attention}explotar{} y volver a 0",
                "{C:inactive}(Actual: {C:mult}+#4#{C:inactive} multi)",
            },
        },
        config = { extra = { gain = 3, odds = 6, mult = 0 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 6, y = 6 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, KAS.prob(), e.odds, e.mult } }
        end,
        calculate = function(self, card, context) local e = card.ability.extra if context.before and not context.blueprint then if pseudorandom('kas_bufon_globos') < KAS.prob() / e.odds then e.mult = 0 return { message = '¡Pop!', colour = G.C.RED } end e.mult = e.mult + e.gain return { message = localize('k_upgrade_ex'), colour = G.C.MULT } end if context.joker_main and e.mult > 0 then return { mult = e.mult } end end,
    }
end

-- 68. Bufón Sonriente
do
    SMODS.Joker {
        key = "bufon_sonriente",
        loc_txt = {
            name = "Bufón Sonriente",
            text = {
                "Cada carta de {C:attention}figura{} puntuada da",
                "{C:mult}+#1#{} multi por cada figura puntuada",
            },
        },
        config = { extra = { mult = 2 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 7, y = 6 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.per_card_fn(KAS.face, function(c, context, e) return { mult = e.mult * KAS.contar(context.scoring_hand, KAS.face) } end),
    }
end

-- 69. Bola 8
do
    SMODS.Joker {
        key = "bola_ocho",
        loc_txt = {
            name = "Bola 8",
            text = {
                "Si la mano puntuada tiene un {C:attention}8{},",
                "{C:green}#1# entre #2#{} probabilidades de crear",
                "una carta {C:spectral}Espectral{}",
            },
        },
        config = { extra = { odds = 8 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 8, y = 6 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { KAS.prob(), e.odds } }
        end,
        calculate = KAS.create(function(context) return context.before and KAS.contar(context.scoring_hand, KAS.rank(8)) > 0 end, 'Spectral', 'kas_bola_ocho'),
    }
end

-- 70. Bufón Molón
do
    SMODS.Joker {
        key = "bufon_molon",
        loc_txt = {
            name = "Bufón Molón",
            text = {
                "Gana {C:mult}+#1#{} multi cada vez",
                "que juegas una {C:attention}Escalera{}",
                "{C:inactive}(Actual: {C:mult}+#2#{C:inactive} multi)",
            },
        },
        config = { extra = { gain = 4, mult = 0 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 9, y = 6 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.mult } }
        end,
        calculate = KAS.scale{ field = 'mult', on = KAS.T.hand_type('Straight') },
    }
end

-- 71. Príncipe Bufón
do
    SMODS.Joker {
        key = "principe_bufon",
        loc_txt = {
            name = "Príncipe Bufón",
            text = {
                "Cada {C:attention}J{} puntuada",
                "da {C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 8 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 0, y = 7 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.per_card(KAS.rank(11)),
    }
end

-- 72. Bufón Guiñador
do
    SMODS.Joker {
        key = "bufon_guinador",
        loc_txt = {
            name = "Bufón Guiñador",
            text = {
                "{C:green}#1# entre #2#{} probabilidades de",
                "ganar {C:money}$#3#{} al jugar una mano",
            },
        },
        config = { extra = { odds = 3, dollars = 3 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 1, y = 7 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { KAS.prob(), e.odds, e.dollars } }
        end,
        calculate = KAS.chance("kas_bufon_guinador"),
    }
end

-- 73. Bufón del Puñal
do
    SMODS.Joker {
        key = "bufon_punal",
        loc_txt = {
            name = "Bufón del Puñal",
            text = {
                "{X:mult,C:white} X#1# {} multi si juegas",
                "exactamente {C:attention}#2#{} cartas",
            },
        },
        config = { extra = { xmult = 1.5, cards = 5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 2, y = 7 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult, e.cards } }
        end,
        calculate = KAS.cond(function(card, context, e) return #context.full_hand == e.cards end),
    }
end

-- 74. Bufón Azul
do
    SMODS.Joker {
        key = "bufon_azul",
        loc_txt = {
            name = "Bufón Azul",
            text = {
                "{C:chips}+#1#{} fichas por cada",
                "{C:attention}mano{} restante",
            },
        },
        config = { extra = { chips = 25 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 3, y = 7 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = G.GAME.current_round.hands_left if n > 0 then return { chips = e.chips * n } end end),
    }
end

-- 75. Cofre del Tesoro
do
    SMODS.Joker {
        key = "cofre_tesoro",
        loc_txt = {
            name = "Cofre del Tesoro",
            text = {
                "Al final de la ronda ganas {C:money}$1{} por cada",
                "{C:attention}#1#{} cartas que queden en tu baraja",
            },
        },
        config = { extra = { per = 10 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 4, y = 7 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.per } }
        end,
        calc_dollar_bonus = function(self, card) local n = math.floor(#G.deck.cards / card.ability.extra.per) if n > 0 then return n end end,
    }
end

-- 76. Calaverita
do
    SMODS.Joker {
        key = "calaverita",
        loc_txt = {
            name = "Calaverita",
            text = {
                "{X:mult,C:white} X#1# {} multi si todas las cartas",
                "puntuadas son {C:attention}impares{}",
            },
        },
        config = { extra = { xmult = 1.5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 5, y = 7 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.odd) == #context.scoring_hand end),
    }
end

-- 77. Bufón Relajado
do
    SMODS.Joker {
        key = "bufon_relajado",
        loc_txt = {
            name = "Bufón Relajado",
            text = {
                "{C:mult}+#1#{} multi por cada",
                "{C:attention}descarte{} restante",
            },
        },
        config = { extra = { mult = 4 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 6, y = 7 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = G.GAME.current_round.discards_left if n > 0 then return { mult = e.mult * n } end end),
    }
end

-- 78. Bufón Hippie
do
    SMODS.Joker {
        key = "bufon_hippie",
        loc_txt = {
            name = "Bufón Hippie",
            text = {
                "{X:mult,C:white} X#1# {} multi si la mano puntuada",
                "no tiene cartas de {C:attention}figura{}",
            },
        },
        config = { extra = { xmult = 1.5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 7, y = 7 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.face) == 0 end),
    }
end

-- 79. Bola Mágica
do
    SMODS.Joker {
        key = "bola_magica",
        loc_txt = {
            name = "Bola Mágica",
            text = {
                "Cada {C:attention}8{} puntuado",
                "da {X:mult,C:white} X#1# {} multi",
            },
        },
        config = { extra = { xmult = 1.5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 8, y = 7 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.per_card(KAS.rank(8)),
    }
end

-- 80. Bufón MLG
do
    SMODS.Joker {
        key = "bufon_mlg",
        loc_txt = {
            name = "Bufón MLG",
            text = {
                "{X:mult,C:white} X#1# {} multi si la mano",
                "jugada contiene {C:attention}Escalera de color{}",
            },
        },
        config = { extra = { xmult = 4 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas",
        pos = { x = 9, y = 7 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.hand("Straight Flush"),
    }
end

-- 81. Bufón del Barril
do
    SMODS.Joker {
        key = "bufon_barril",
        loc_txt = {
            name = "Bufón del Barril",
            text = {
                "Gana {C:chips}+#1#{} fichas al final",
                "de cada ronda",
                "{C:inactive}(Actual: {C:chips}+#2#{C:inactive} fichas)",
            },
        },
        config = { extra = { gain = 10, chips = 0 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 0, y = 8 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.chips } }
        end,
        calculate = KAS.scale{ field = 'chips', on = KAS.T.round_end },
    }
end

-- 82. Bufón de los Dados
do
    SMODS.Joker {
        key = "bufon_dados",
        loc_txt = {
            name = "Bufón de los Dados",
            text = {
                "Cada carta puntuada tira un dado",
                "y da entre {C:mult}+#1#{} y {C:mult}+#2#{} multi",
            },
        },
        config = { extra = { min = 1, max = 6 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 1, y = 8 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.min, e.max } }
        end,
        calculate = KAS.per_card_fn(KAS.any, function(c, context, e) return { mult = pseudorandom('kas_bufon_dados', e.min, e.max) } end),
    }
end

-- 83. Espadachín
do
    SMODS.Joker {
        key = "espadachin",
        loc_txt = {
            name = "Espadachín",
            text = {
                "Cada {C:attention}10{} puntuado",
                "da {C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 10 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 2, y = 8 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.per_card(KAS.rank(10)),
    }
end

-- 84. Corazón Oscuro
do
    SMODS.Joker {
        key = "corazon_oscuro",
        loc_txt = {
            name = "Corazón Oscuro",
            text = {
                "{X:mult,C:white} X#1# {} multi si todas las cartas",
                "puntuadas son de {C:hearts}Corazones{}",
            },
        },
        config = { extra = { xmult = 2 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 3, y = 8 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.suit('Hearts')) == #context.scoring_hand end),
    }
end

-- 85. Farolero
do
    SMODS.Joker {
        key = "farolero",
        loc_txt = {
            name = "Farolero",
            text = {
                "{X:mult,C:white} X#1# {} multi si quedan {C:attention}#2#{}",
                "cartas o menos en tu baraja",
            },
        },
        config = { extra = { xmult = 1.5, cards = 10 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 4, y = 8 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult, e.cards } }
        end,
        calculate = KAS.cond(function(card, context, e) return #G.deck.cards <= e.cards end),
    }
end

-- 86. Mimo
do
    SMODS.Joker {
        key = "mimo",
        loc_txt = {
            name = "Mimo",
            text = {
                "Si juegas {C:attention}una sola{} carta,",
                "se reactiva {C:attention}#1#{} veces más",
            },
        },
        config = { extra = { reps = 2 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 5, y = 8 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.reps } }
        end,
        calculate = KAS.retrigger(function(c, context) return #context.full_hand == 1 end),
    }
end

-- 87. Pulpo
do
    SMODS.Joker {
        key = "pulpo",
        loc_txt = {
            name = "Pulpo",
            text = {
                "{X:mult,C:white} X#1# {} multi si la mano puntuada",
                "tiene {C:attention}dos 8{} o más",
            },
        },
        config = { extra = { xmult = 1.8 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 6, y = 8 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.rank(8)) >= 2 end),
    }
end

-- 88. Linterna Espectral
do
    SMODS.Joker {
        key = "linterna_espectral",
        loc_txt = {
            name = "Linterna Espectral",
            text = {
                "{C:green}#1# entre #2#{} probabilidades de crear",
                "una carta {C:spectral}Espectral{}",
                "al final de la ronda",
            },
        },
        config = { extra = { odds = 4 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas",
        pos = { x = 7, y = 8 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { KAS.prob(), e.odds } }
        end,
        calculate = KAS.create(KAS.T.round_end, "Spectral", "kas_linterna_espectral"),
    }
end

-- 89. Alma en Pena
do
    SMODS.Joker {
        key = "alma_en_pena",
        loc_txt = {
            name = "Alma en Pena",
            text = {
                "Gana {X:mult,C:white} X#1# {} multi al derrotar",
                "una {C:attention}ciega jefe{}",
                "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
            },
        },
        config = { extra = { gain = 0.5, xmult = 1 } },
        rarity = 3,
        cost = 9,
        atlas = "cartas",
        pos = { x = 8, y = 8 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.xmult } }
        end,
        calculate = KAS.scale{ field = 'xmult', on = KAS.T.boss },
    }
end

-- 90. Poción
do
    SMODS.Joker {
        key = "pocion",
        loc_txt = {
            name = "Poción",
            text = {
                "Al {C:attention}venderla{}, crea una",
                "carta de {C:tarot}Tarot{}",
            },
        },
        config = { extra = {  } },
        rarity = 1,
        cost = 3,
        atlas = "cartas",
        pos = { x = 9, y = 8 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.sell_create("Tarot"),
    }
end

-- 91. Ojo Omnisciente
do
    SMODS.Joker {
        key = "ojo_omnisciente",
        loc_txt = {
            name = "Ojo Omnisciente",
            text = {
                "Gana {X:mult,C:white} X#1# {} multi si juegas una mano",
                "{C:attention}distinta{} a la anterior;",
                "se reinicia si la repites",
                "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
            },
        },
        config = { extra = { gain = 0.5, xmult = 1, last = "" } },
        rarity = 4,
        cost = 20,
        atlas = "cartas",
        pos = { x = 0, y = 9 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.xmult } }
        end,
        calculate = function(self, card, context) local e = card.ability.extra if context.before and not context.blueprint then local distinta = context.scoring_name ~= e.last e.last = context.scoring_name if distinta then e.xmult = e.xmult + e.gain return { message = localize('k_upgrade_ex'), colour = G.C.FILTER } elseif e.xmult > 1 then e.xmult = 1 return { message = localize('k_reset'), colour = G.C.RED } end end if context.joker_main and e.xmult > 1 then return { xmult = e.xmult } end end,
    }
end

-- 92. Dos Caras
do
    SMODS.Joker {
        key = "dos_caras",
        loc_txt = {
            name = "Dos Caras",
            text = {
                "{C:green}#1# entre #2#{} probabilidades",
                "de dar {X:mult,C:white} X#3# {} multi",
            },
        },
        config = { extra = { odds = 2, xmult = 2 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 1, y = 9 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { KAS.prob(), e.odds, e.xmult } }
        end,
        calculate = KAS.chance("kas_dos_caras"),
    }
end

-- 93. Hipnosis
do
    SMODS.Joker {
        key = "hipnosis",
        loc_txt = {
            name = "Hipnosis",
            text = {
                "Si juegas la {C:attention}misma{} mano que la",
                "anterior, reactiva todas las",
                "cartas puntuadas",
            },
        },
        config = { extra = { reps = 1, last = "", repite = 0 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas",
        pos = { x = 2, y = 9 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = function(self, card, context) local e = card.ability.extra if context.before and not context.blueprint then e.repite = (e.last == G.GAME.last_hand_played) and 1 or 0 e.last = G.GAME.last_hand_played end if context.repetition and context.cardarea == G.play and e.repite == 1 then return { repetitions = e.reps } end end,
    }
end

-- 94. Corazón Diabólico
do
    local al_entrar, al_salir = KAS.passive({ hands = -1 })
    SMODS.Joker {
        key = "corazon_diabolico",
        loc_txt = {
            name = "Corazón Diabólico",
            text = {
                "{X:mult,C:white} X#1# {} multi,",
                "{C:blue}-#2#{} mano por ronda",
            },
        },
        config = { extra = { xmult = 3, n = 1 } },
        rarity = 3,
        cost = 9,
        atlas = "cartas",
        pos = { x = 3, y = 9 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult, e.n } }
        end,
        calculate = KAS.flat(),
        add_to_deck = al_entrar,
        remove_from_deck = al_salir,
    }
end

-- 95. Estrella Fugaz
do
    SMODS.Joker {
        key = "estrella_fugaz",
        loc_txt = {
            name = "Estrella Fugaz",
            text = {
                "Si la mano contiene un {C:attention}Color{},",
                "crea una carta de {C:planet}Planeta{}",
                "{C:inactive}(Debe haber espacio)",
            },
        },
        config = { extra = {  } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 4, y = 9 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.create(KAS.T.hand_type("Flush"), "Planet", nil),
    }
end

-- 96. Bufón Ajedrecista
do
    SMODS.Joker {
        key = "bufon_ajedrecista",
        loc_txt = {
            name = "Bufón Ajedrecista",
            text = {
                "Manos {C:attention}impares{}: {X:mult,C:white} X#1# {} multi",
                "Manos {C:attention}pares{}: {C:chips}+#2#{} fichas",
            },
        },
        config = { extra = { xmult = 2, chips = 60, count = 0 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas",
        pos = { x = 5, y = 9 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult, e.chips } }
        end,
        calculate = function(self, card, context) local e = card.ability.extra if context.before and not context.blueprint then e.count = e.count + 1 end if context.joker_main then if e.count % 2 == 1 then return { xmult = e.xmult } end return { chips = e.chips } end end,
    }
end

-- 97. Máscara Solar
do
    SMODS.Joker {
        key = "mascara_solar",
        loc_txt = {
            name = "Máscara Solar",
            text = {
                "Cada carta de {C:attention}figura{}",
                "puntuada da {X:mult,C:white} X#1# {} multi",
            },
        },
        config = { extra = { xmult = 1.25 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas",
        pos = { x = 6, y = 9 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.per_card(KAS.face),
    }
end

-- 98. Bufón del Mundo
do
    SMODS.Joker {
        key = "bufon_mundo",
        loc_txt = {
            name = "Bufón del Mundo",
            text = {
                "Reactiva {C:attention}todas{} las",
                "cartas puntuadas",
            },
        },
        config = { extra = { reps = 1 } },
        rarity = 4,
        cost = 20,
        atlas = "cartas",
        pos = { x = 7, y = 9 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.retrigger(KAS.any),
    }
end

-- 99. Corona Cósmica
do
    SMODS.Joker {
        key = "corona_cosmica",
        loc_txt = {
            name = "Corona Cósmica",
            text = {
                "Gana {X:mult,C:white} X#1# {} multi al derrotar",
                "una {C:attention}ciega jefe{}",
                "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
            },
        },
        config = { extra = { gain = 1, xmult = 1 } },
        rarity = 4,
        cost = 20,
        atlas = "cartas",
        pos = { x = 8, y = 9 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.xmult } }
        end,
        calculate = KAS.scale{ field = 'xmult', on = KAS.T.boss },
    }
end

-- 100. Bufón Arcoíris
do
    SMODS.Joker {
        key = "bufon_arcoiris",
        loc_txt = {
            name = "Bufón Arcoíris",
            text = {
                "{X:mult,C:white} X#1# {} multi por cada {C:attention}palo{}",
                "distinto en la mano puntuada",
            },
        },
        config = { extra = { xmult = 1.5 } },
        rarity = 4,
        cost = 20,
        atlas = "cartas",
        pos = { x = 9, y = 9 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = KAS.palos_distintos(context) if n > 0 then return { xmult = e.xmult ^ n } end end),
    }
end

-- 101. Bufón Infernal
do
    SMODS.Joker {
        key = "bufon_infernal",
        loc_txt = {
            name = "Bufón Infernal",
            text = {
                "Gana {X:mult,C:white} X#1# {} multi por cada",
                "mano jugada en la partida",
                "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
            },
        },
        config = { extra = { gain = 0.05, xmult = 1 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas2",
        pos = { x = 0, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.xmult } }
        end,
        calculate = KAS.scale{ field = 'xmult', on = KAS.T.hand_played },
    }
end

-- 102. Aprendiz de Mago
do
    SMODS.Joker {
        key = "aprendiz_mago",
        loc_txt = {
            name = "Aprendiz de Mago",
            text = {
                "Si la mano contiene un {C:attention}Full{},",
                "crea una carta de {C:tarot}Tarot{}",
                "{C:inactive}(Debe haber espacio)",
            },
        },
        config = { extra = {  } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 1, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.create(KAS.T.hand_type("Full House"), "Tarot", nil),
    }
end

-- 103. Espíritu de Hielo
do
    SMODS.Joker {
        key = "espiritu_hielo",
        loc_txt = {
            name = "Espíritu de Hielo",
            text = {
                "Cada carta de {C:spades}Picas{} que tengas",
                "en la mano da {C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 3 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas2",
        pos = { x = 2, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.held(KAS.suit("Spades")),
    }
end

-- 104. Robot Dorado
do
    SMODS.Joker {
        key = "robot_dorado",
        loc_txt = {
            name = "Robot Dorado",
            text = {
                "{X:mult,C:white} X#1# {} multi si tienes",
                "{C:money}$#2#{} o más",
            },
        },
        config = { extra = { xmult = 1.5, min = 20 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 3, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult, e.min } }
        end,
        calculate = KAS.cond(function(card, context, e) return G.GAME.dollars >= e.min end),
    }
end

-- 105. Ciprés Esmeralda
do
    SMODS.Joker {
        key = "cipres_esmeralda",
        loc_txt = {
            name = "Ciprés Esmeralda",
            text = {
                "Si la mano contiene un {C:attention}Color{},",
                "cada carta puntuada da {C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 3 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas2",
        pos = { x = 4, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.per_card(KAS.jugada('Flush', 'Straight Flush', 'Flush House', 'Flush Five')),
    }
end

-- 106. Galaxia Espiral
do
    SMODS.Joker {
        key = "galaxia_espiral",
        loc_txt = {
            name = "Galaxia Espiral",
            text = {
                "Si la mano jugada es {C:attention}Carta alta{},",
                "crea una carta de {C:planet}Planeta{}",
                "{C:inactive}(Debe haber espacio)",
            },
        },
        config = { extra = {  } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 5, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.create(function(context) return context.before and context.scoring_name == 'High Card' end, "Planet", nil),
    }
end

-- 107. El Anciano
do
    SMODS.Joker {
        key = "el_anciano",
        loc_txt = {
            name = "El Anciano",
            text = {
                "{C:chips}+#1#{} fichas por cada",
                "{C:attention}ronda{} de la partida",
            },
        },
        config = { extra = { chips = 5 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas2",
        pos = { x = 6, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.dyn(function(card, context, e) return { chips = e.chips * G.GAME.round } end),
    }
end

-- 108. Zorro Nocturno
do
    SMODS.Joker {
        key = "zorro_nocturno",
        loc_txt = {
            name = "Zorro Nocturno",
            text = {
                "Cada carta de {C:diamonds}Diamantes{} puntuada",
                "da {C:chips}+#1#{} fichas",
            },
        },
        config = { extra = { chips = 30 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas2",
        pos = { x = 7, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.per_card(KAS.suit("Diamonds")),
    }
end

-- 109. Gato de Esmoquin
do
    SMODS.Joker {
        key = "gato_esmoquin",
        loc_txt = {
            name = "Gato de Esmoquin",
            text = {
                "Cada carta de {C:spades}Picas{} puntuada da",
                "el {C:attention}doble{} de su valor en {C:chips}fichas{}",
            },
        },
        config = { extra = {  } },
        rarity = 1,
        cost = 4,
        atlas = "cartas2",
        pos = { x = 8, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.per_card_fn(KAS.suit('Spades'), function(c) return { chips = 2 * KAS.valor(c) } end),
    }
end

-- 110. Perro Santo
do
    SMODS.Joker {
        key = "perro_santo",
        loc_txt = {
            name = "Perro Santo",
            text = {
                "Ganas {C:money}$#1#{} si la mano puntuada",
                "tiene {C:attention}5{} cartas de {C:hearts}Corazones{}",
            },
        },
        config = { extra = { dollars = 5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 9, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calculate = KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.suit('Hearts')) >= 5 end),
    }
end

-- 111. Gato Murciélago
do
    SMODS.Joker {
        key = "gato_murcielago",
        loc_txt = {
            name = "Gato Murciélago",
            text = {
                "Gana {C:mult}+#1#{} multi por cada carta",
                "de {C:spades}Picas{} puntuada",
                "{C:inactive}(Actual: {C:mult}+#2#{C:inactive} multi)",
            },
        },
        config = { extra = { gain = 1, mult = 0 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 10, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.mult } }
        end,
        calculate = KAS.scale{ field = 'mult', on = function(context) return context.before and KAS.contar(context.scoring_hand, KAS.suit('Spades')) end },
    }
end

-- 112. Estrella Azul
do
    SMODS.Joker {
        key = "estrella_azul",
        loc_txt = {
            name = "Estrella Azul",
            text = {
                "Si la mano contiene un {C:attention}Color{},",
                "cada carta puntuada da {X:mult,C:white} X#1# {} multi",
            },
        },
        config = { extra = { xmult = 1.1 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas2",
        pos = { x = 11, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.per_card(KAS.jugada('Flush', 'Straight Flush', 'Flush House', 'Flush Five')),
    }
end

-- 113. Payaso Psicodélico
do
    SMODS.Joker {
        key = "payaso_psicodelico",
        loc_txt = {
            name = "Payaso Psicodélico",
            text = {
                "Da entre {X:mult,C:white} X#1# {} y {X:mult,C:white} X#2# {}",
                "multi al azar",
            },
        },
        config = { extra = { min = 1, max = 3 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas2",
        pos = { x = 12, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.min, e.max } }
        end,
        calculate = KAS.dyn(function(card, context, e) local x = e.min + (e.max - e.min) * pseudorandom('kas_payaso_psicodelico') return { xmult = math.floor(x * 10 + 0.5) / 10 } end),
    }
end

-- 114. Sombra Encapuchada
do
    SMODS.Joker {
        key = "sombra_encapuchada",
        loc_txt = {
            name = "Sombra Encapuchada",
            text = {
                "{X:mult,C:white} X#1# {} multi en la {C:attention}última mano{}",
                "si no te quedan {C:attention}descartes{}",
            },
        },
        config = { extra = { xmult = 2.5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 0, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(function() return G.GAME.current_round.hands_left == 0 and G.GAME.current_round.discards_left == 0 end),
    }
end

-- 115. Payaso Mago
do
    SMODS.Joker {
        key = "payaso_mago",
        loc_txt = {
            name = "Payaso Mago",
            text = {
                "{C:mult}+#1#{} multi por cada carta",
                "de {C:tarot}Tarot{} que tengas",
            },
        },
        config = { extra = { mult = 5 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas2",
        pos = { x = 1, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = 0 for _, c in ipairs(G.consumeables.cards) do if c.ability.set == 'Tarot' then n = n + 1 end end if n > 0 then return { mult = e.mult * n } end end),
    }
end

-- 116. Máscara de Calabaza
do
    SMODS.Joker {
        key = "mascara_calabaza",
        loc_txt = {
            name = "Máscara de Calabaza",
            text = {
                "{C:mult}+#1#{} multi si juegas",
                "exactamente {C:attention}#2#{} cartas",
            },
        },
        config = { extra = { mult = 13, cards = 4 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas2",
        pos = { x = 2, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult, e.cards } }
        end,
        calculate = KAS.cond(function(card, context, e) return #context.full_hand == e.cards end),
    }
end

-- 117. Bufón Carmesí
do
    SMODS.Joker {
        key = "bufon_carmesi",
        loc_txt = {
            name = "Bufón Carmesí",
            text = {
                "Cada carta de {C:hearts}Corazones{} puntuada",
                "da {C:chips}+#1#{} fichas",
            },
        },
        config = { extra = { chips = 30 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas2",
        pos = { x = 3, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.per_card(KAS.suit("Hearts")),
    }
end

-- 118. Runa Lunar
do
    SMODS.Joker {
        key = "runa_lunar",
        loc_txt = {
            name = "Runa Lunar",
            text = {
                "{C:green}#1# entre #2#{} probabilidades de crear",
                "una carta de {C:tarot}Tarot{} al",
                "seleccionar la {C:attention}ciega{}",
            },
        },
        config = { extra = { odds = 2 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 4, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { KAS.prob(), e.odds } }
        end,
        calculate = KAS.create(KAS.T.blind, "Tarot", "kas_runa_lunar"),
    }
end

-- 119. Pantera
do
    SMODS.Joker {
        key = "pantera",
        loc_txt = {
            name = "Pantera",
            text = {
                "Gana {X:mult,C:white} X#1# {} multi cada vez que",
                "juegas {C:attention}5{} cartas",
                "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
            },
        },
        config = { extra = { gain = 0.1, xmult = 1 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas2",
        pos = { x = 5, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.xmult } }
        end,
        calculate = KAS.scale{ field = 'xmult', on = function(context) return context.before and #context.full_hand == 5 end },
    }
end

-- 120. Payaso Rockero
do
    SMODS.Joker {
        key = "payaso_rockero",
        loc_txt = {
            name = "Payaso Rockero",
            text = {
                "{C:mult}+#1#{} multi si la mano",
                "jugada contiene {C:attention}Póker{}",
            },
        },
        config = { extra = { mult = 20 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas2",
        pos = { x = 6, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.hand("Four of a Kind"),
    }
end

-- 121. Rey Oscuro
do
    SMODS.Joker {
        key = "rey_oscuro",
        loc_txt = {
            name = "Rey Oscuro",
            text = {
                "Cada {C:attention}Rey{} puntuado da {C:money}$#1#{}",
                "por cada Rey que tengas en la mano",
            },
        },
        config = { extra = { dollars = 1 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas2",
        pos = { x = 7, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calculate = KAS.per_card_fn(KAS.rank(13), function(c, context, e) local n = KAS.contar(G.hand.cards, KAS.rank(13)) if n > 0 then return { dollars = e.dollars * n } end end),
    }
end

-- 122. Máscara Alada
do
    SMODS.Joker {
        key = "mascara_alada",
        loc_txt = {
            name = "Máscara Alada",
            text = {
                "Reactiva cada carta",
                "de {C:diamonds}Diamantes{} puntuada",
            },
        },
        config = { extra = { reps = 1 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas2",
        pos = { x = 8, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.retrigger(KAS.suit("Diamonds")),
    }
end

-- 123. Emperador
do
    SMODS.Joker {
        key = "emperador",
        loc_txt = {
            name = "Emperador",
            text = {
                "Cada carta de {C:attention}figura{} que tengas",
                "en la mano da {X:mult,C:white} X#1# {} multi",
            },
        },
        config = { extra = { xmult = 1.2 } },
        rarity = 3,
        cost = 9,
        atlas = "cartas2",
        pos = { x = 9, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.held(KAS.face),
    }
end

-- 124. Ídolo Dorado
do
    SMODS.Joker {
        key = "idolo_dorado",
        loc_txt = {
            name = "Ídolo Dorado",
            text = {
                "Cada {C:attention}As{} puntuado",
                "da {C:money}$#1#{}",
            },
        },
        config = { extra = { dollars = 2 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas2",
        pos = { x = 10, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calculate = KAS.per_card(KAS.rank(14)),
    }
end

-- 125. Demonio Rojo
do
    SMODS.Joker {
        key = "demonio_rojo",
        loc_txt = {
            name = "Demonio Rojo",
            text = {
                "Gana {C:mult}+#1#{} multi cada vez",
                "que juegas un {C:attention}Trío{}",
                "{C:inactive}(Actual: {C:mult}+#2#{C:inactive} multi)",
            },
        },
        config = { extra = { gain = 3, mult = 0 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas2",
        pos = { x = 11, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.mult } }
        end,
        calculate = KAS.scale{ field = 'mult', on = KAS.T.hand_type('Three of a Kind') },
    }
end

-- 126. Cíclope
do
    SMODS.Joker {
        key = "ciclope",
        loc_txt = {
            name = "Cíclope",
            text = {
                "{X:mult,C:white} X#1# {} multi si juegas",
                "{C:attention}una sola{} carta",
            },
        },
        config = { extra = { xmult = 3 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 12, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(function(card, context) return #context.full_hand == 1 end),
    }
end

-- 127. Encapuchado Llameante
do
    SMODS.Joker {
        key = "encapuchado_llameante",
        loc_txt = {
            name = "Encapuchado Llameante",
            text = {
                "Gana {C:mult}+#1#{} multi por cada carta",
                "de {C:hearts}Corazones{} descartada",
                "{C:inactive}(Actual: {C:mult}+#2#{C:inactive} multi)",
            },
        },
        config = { extra = { gain = 2, mult = 0 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas2",
        pos = { x = 0, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.mult } }
        end,
        calculate = KAS.scale{ field = 'mult', on = function(context) return context.discard and context.other_card:is_suit('Hearts') end },
    }
end

-- 128. Duende Naranja
do
    SMODS.Joker {
        key = "duende_naranja",
        loc_txt = {
            name = "Duende Naranja",
            text = {
                "Ganas {C:money}$#1#{} por cada carta",
                "de {C:diamonds}Diamantes{} descartada",
            },
        },
        config = { extra = { dollars = 1 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas2",
        pos = { x = 1, y = 2 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calculate = KAS.discard_money(KAS.suit("Diamonds")),
    }
end

-- 129. Espíritu Violeta
do
    SMODS.Joker {
        key = "espiritu_violeta",
        loc_txt = {
            name = "Espíritu Violeta",
            text = {
                "Al {C:attention}venderlo{}, crea una",
                "carta de {C:planet}Planeta{}",
            },
        },
        config = { extra = {  } },
        rarity = 1,
        cost = 3,
        atlas = "cartas2",
        pos = { x = 2, y = 2 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.sell_create("Planet"),
    }
end

-- 130. Fantasma Azul
do
    SMODS.Joker {
        key = "fantasma_azul",
        loc_txt = {
            name = "Fantasma Azul",
            text = {
                "{C:chips}+#1#{} fichas por cada",
                "{C:attention}descarte{} usado esta ronda",
            },
        },
        config = { extra = { chips = 20 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas2",
        pos = { x = 3, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = G.GAME.current_round.discards_used if n > 0 then return { chips = e.chips * n } end end),
    }
end

-- 131. Cuchilla de Cristal
do
    SMODS.Joker {
        key = "cuchilla_cristal",
        loc_txt = {
            name = "Cuchilla de Cristal",
            text = {
                "Gana {X:mult,C:white} X#1# {} multi cada vez",
                "que juegas un {C:attention}Color{}",
                "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
            },
        },
        config = { extra = { gain = 0.2, xmult = 1 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas2",
        pos = { x = 4, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.xmult } }
        end,
        calculate = KAS.scale{ field = 'xmult', on = KAS.T.hand_type('Flush') },
    }
end

-- 132. Bufón Dorado
do
    SMODS.Joker {
        key = "bufon_dorado",
        loc_txt = {
            name = "Bufón Dorado",
            text = {
                "Ganas {C:money}$#1#{} al final de la ronda por",
                "cada carta de {C:attention}Oro{} de tu baraja",
            },
        },
        config = { extra = { dollars = 2 } },
        rarity = 1,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 5, y = 2 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calc_dollar_bonus = function(self, card) local n = KAS.contar(G.playing_cards, KAS.mejora('m_gold')) if n > 0 then return n * card.ability.extra.dollars end end,
    }
end

-- 133. Caballero Oscuro
do
    SMODS.Joker {
        key = "caballero_oscuro",
        loc_txt = {
            name = "Caballero Oscuro",
            text = {
                "Cada {C:attention}J{} puntuado",
                "da {X:mult,C:white} X#1# {} multi",
            },
        },
        config = { extra = { xmult = 1.5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 6, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.per_card(KAS.rank(11)),
    }
end

-- 134. Payaso Demonio
do
    SMODS.Joker {
        key = "payaso_demonio",
        loc_txt = {
            name = "Payaso Demonio",
            text = {
                "Cada {C:attention}4{} puntuado",
                "da {C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 8 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas2",
        pos = { x = 7, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.per_card(KAS.rank(4)),
    }
end

-- 135. Bruja
do
    SMODS.Joker {
        key = "bruja",
        loc_txt = {
            name = "Bruja",
            text = {
                "Crea una carta {C:spectral}Espectral{}",
                "al derrotar una {C:attention}ciega jefe{}",
                "{C:inactive}(Debe haber espacio)",
            },
        },
        config = { extra = {  } },
        rarity = 2,
        cost = 7,
        atlas = "cartas2",
        pos = { x = 8, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.create(KAS.T.boss, "Spectral", nil),
    }
end

-- 136. Lince
do
    SMODS.Joker {
        key = "lince",
        loc_txt = {
            name = "Lince",
            text = {
                "Cada {C:attention}9{} puntuado",
                "da {C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 9 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas2",
        pos = { x = 9, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.per_card(KAS.rank(9)),
    }
end

-- 137. Cohete
do
    SMODS.Joker {
        key = "cohete",
        loc_txt = {
            name = "Cohete",
            text = {
                "Gana {C:chips}+#1#{} fichas por cada",
                "mano jugada",
                "{C:inactive}(Actual: {C:chips}+#2#{C:inactive} fichas)",
            },
        },
        config = { extra = { gain = 8, chips = 0 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas2",
        pos = { x = 10, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.chips } }
        end,
        calculate = KAS.scale{ field = 'chips', on = KAS.T.hand_played },
    }
end

-- 138. Bufón Brujo
do
    SMODS.Joker {
        key = "bufon_brujo",
        loc_txt = {
            name = "Bufón Brujo",
            text = {
                "Crea una carta de {C:planet}Planeta{}",
                "al seleccionar la {C:attention}ciega{}",
                "{C:inactive}(Debe haber espacio)",
            },
        },
        config = { extra = {  } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 11, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.create(KAS.T.blind, "Planet", nil),
    }
end

-- 139. Farol Naranja
do
    SMODS.Joker {
        key = "farol_naranja",
        loc_txt = {
            name = "Farol Naranja",
            text = {
                "{C:mult}+#1#{} multi por cada carta",
                "que tengas en la {C:attention}mano{}",
            },
        },
        config = { extra = { mult = 2 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas2",
        pos = { x = 12, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.dyn(function(card, context, e) if #G.hand.cards > 0 then return { mult = e.mult * #G.hand.cards } end end),
    }
end

-- 140. Payaso Fantasma
do
    SMODS.Joker {
        key = "payaso_fantasma",
        loc_txt = {
            name = "Payaso Fantasma",
            text = {
                "{C:green}#1# entre #2#{} probabilidades",
                "de dar {X:mult,C:white} X#3# {} multi",
            },
        },
        config = { extra = { odds = 3, xmult = 3 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 0, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { KAS.prob(), e.odds, e.xmult } }
        end,
        calculate = KAS.chance("kas_payaso_fantasma"),
    }
end

-- 141. Cáliz Dorado
do
    SMODS.Joker {
        key = "caliz_dorado",
        loc_txt = {
            name = "Cáliz Dorado",
            text = {
                "Al final de la ronda ganas {C:money}$#1#{}",
                "por cada {C:attention}mano{} restante",
            },
        },
        config = { extra = { dollars = 1 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas2",
        pos = { x = 1, y = 3 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calc_dollar_bonus = function(self, card) local n = G.GAME.current_round.hands_left if n > 0 then return n * card.ability.extra.dollars end end,
    }
end

-- 142. Hombre Misterioso
do
    SMODS.Joker {
        key = "hombre_misterioso",
        loc_txt = {
            name = "Hombre Misterioso",
            text = {
                "{C:mult}+#1#{} multi si la mano",
                "jugada es {C:attention}Carta alta{}",
            },
        },
        config = { extra = { mult = 15 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas2",
        pos = { x = 2, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.cond(function(card, context) return context.scoring_name == 'High Card' end),
    }
end

-- 143. Pulpo Mago
do
    SMODS.Joker {
        key = "pulpo_mago",
        loc_txt = {
            name = "Pulpo Mago",
            text = {
                "Reactiva cada {C:attention}8{}",
                "puntuado",
            },
        },
        config = { extra = { reps = 1 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 3, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.retrigger(KAS.rank(8)),
    }
end

-- 144. León Solar
do
    SMODS.Joker {
        key = "leon_solar",
        loc_txt = {
            name = "León Solar",
            text = {
                "Cada carta de {C:diamonds}Diamantes{} puntuada",
                "da {X:mult,C:white} X#1# {} multi",
            },
        },
        config = { extra = { xmult = 1.2 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas2",
        pos = { x = 4, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.per_card(KAS.suit("Diamonds")),
    }
end

-- 145. Gato de Saturno
do
    SMODS.Joker {
        key = "gato_saturno",
        loc_txt = {
            name = "Gato de Saturno",
            text = {
                "{C:mult}+#1#{} multi si tienes al menos",
                "una carta de {C:planet}Planeta{}",
            },
        },
        config = { extra = { mult = 15 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas2",
        pos = { x = 5, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.cond(function() for _, c in ipairs(G.consumeables.cards) do if c.ability.set == 'Planet' then return true end end return false end),
    }
end

-- 146. Sol Ardiente
do
    SMODS.Joker {
        key = "sol_ardiente",
        loc_txt = {
            name = "Sol Ardiente",
            text = {
                "{C:mult}+#1#{} multi en la",
                "{C:attention}primera mano{} de la ronda",
            },
        },
        config = { extra = { mult = 20 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas2",
        pos = { x = 6, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.cond(KAS.first_hand),
    }
end

-- 147. Ojo del Mosaico
do
    SMODS.Joker {
        key = "ojo_mosaico",
        loc_txt = {
            name = "Ojo del Mosaico",
            text = {
                "{C:chips}+#1#{} fichas por cada carta de",
                "{C:attention}figura{} en tu baraja completa",
            },
        },
        config = { extra = { chips = 3 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas2",
        pos = { x = 7, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = KAS.contar(G.playing_cards, KAS.face) if n > 0 then return { chips = e.chips * n } end end),
    }
end

-- 148. Bufón Colorido
do
    SMODS.Joker {
        key = "bufon_colorido",
        loc_txt = {
            name = "Bufón Colorido",
            text = {
                "{C:mult}+#1#{} multi y {C:chips}+#2#{} fichas",
            },
        },
        config = { extra = { mult = 4, chips = 30 } },
        rarity = 1,
        cost = 3,
        atlas = "cartas2",
        pos = { x = 8, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult, e.chips } }
        end,
        calculate = KAS.flat(),
    }
end

-- 149. Rey León
do
    SMODS.Joker {
        key = "rey_leon",
        loc_txt = {
            name = "Rey León",
            text = {
                "{X:mult,C:white} X#1# {} multi si la mano",
                "puntuada contiene un {C:attention}Rey{}",
            },
        },
        config = { extra = { xmult = 2 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas2",
        pos = { x = 9, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.rank(13)) > 0 end),
    }
end

-- 150. Calavera Maga
do
    SMODS.Joker {
        key = "calavera_maga",
        loc_txt = {
            name = "Calavera Maga",
            text = {
                "Ganas {C:money}$#1#{} cada vez que",
                "usas una carta de {C:tarot}Tarot{}",
            },
        },
        config = { extra = { dollars = 2 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas2",
        pos = { x = 10, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calculate = function(self, card, context) if KAS.T.consumable('Tarot')(context) then KAS.dinero(card, card.ability.extra.dollars) end end,
    }
end

-- 151. Esqueleto Mecánico
do
    SMODS.Joker {
        key = "esqueleto_mecanico",
        loc_txt = {
            name = "Esqueleto Mecánico",
            text = {
                "Cada {C:attention}2{} o {C:attention}3{} puntuado",
                "da {C:chips}+#1#{} fichas y {C:mult}+#2#{} multi",
            },
        },
        config = { extra = { chips = 20, mult = 2 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas2",
        pos = { x = 11, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips, e.mult } }
        end,
        calculate = KAS.per_card(KAS.rank(2, 3)),
    }
end

-- 152. Rey de los Bufones
do
    SMODS.Joker {
        key = "rey_de_los_bufones",
        loc_txt = {
            name = "Rey de los Bufones",
            text = {
                "Cada carta de {C:attention}figura{} puntuada",
                "se reactiva una vez por cada",
                "{C:attention}Rey{} en la mano puntuada",
            },
        },
        config = { extra = {  } },
        rarity = 4,
        cost = 20,
        atlas = "cartas2",
        pos = { x = 12, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = function(self, card, context) if context.repetition and context.cardarea == G.play and context.other_card:is_face() then local n = KAS.contar(context.scoring_hand, KAS.rank(13)) if n > 0 then return { repetitions = n } end end end,
    }
end

-- 153. Lince Marrón
do
    SMODS.Joker {
        key = "lince_marron",
        loc_txt = {
            name = "Lince Marrón",
            text = {
                "Cada {C:attention}5{} puntuado",
                "da {C:mult}+#1#{} multi y {C:chips}+#2#{} fichas",
            },
        },
        config = { extra = { mult = 5, chips = 25 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas2",
        pos = { x = 0, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult, e.chips } }
        end,
        calculate = KAS.per_card(KAS.rank(5)),
    }
end

-- 154. Perro Lila
do
    SMODS.Joker {
        key = "perro_lila",
        loc_txt = {
            name = "Perro Lila",
            text = {
                "{X:mult,C:white} X#1# {} multi si la mano",
                "jugada contiene {C:attention}Doble pareja{}",
            },
        },
        config = { extra = { xmult = 1.5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 1, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.hand("Two Pair"),
    }
end

-- 155. Hombre Lobo
do
    SMODS.Joker {
        key = "hombre_lobo",
        loc_txt = {
            name = "Hombre Lobo",
            text = {
                "Gana {X:mult,C:white} X#1# {} multi cada vez",
                "que juegas un {C:attention}Póker{}",
                "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
            },
        },
        config = { extra = { gain = 1, xmult = 1 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas2",
        pos = { x = 2, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.xmult } }
        end,
        calculate = KAS.scale{ field = 'xmult', on = KAS.T.hand_type('Four of a Kind') },
    }
end

-- 156. Duende Verde
do
    SMODS.Joker {
        key = "duende_verde",
        loc_txt = {
            name = "Duende Verde",
            text = {
                "Ganas {C:money}$#1#{} si la mano",
                "jugada contiene una {C:attention}Pareja{}",
            },
        },
        config = { extra = { dollars = 1 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas2",
        pos = { x = 3, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calculate = KAS.hand("Pair"),
    }
end

-- 157. Bestia Sombría
do
    SMODS.Joker {
        key = "bestia_sombria",
        loc_txt = {
            name = "Bestia Sombría",
            text = {
                "{X:mult,C:white} +X#1# {} multi por cada",
                "espacio de {C:attention}consumible{} vacío",
            },
        },
        config = { extra = { step = 0.5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 4, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.step } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = G.consumeables.config.card_limit - #G.consumeables.cards if n > 0 then return { xmult = 1 + e.step * n } end end),
    }
end

-- 158. Gato Bufón
do
    SMODS.Joker {
        key = "gato_bufon",
        loc_txt = {
            name = "Gato Bufón",
            text = {
                "Cada carta de {C:clubs}Tréboles{} puntuada",
                "da {C:money}$#1#{}",
            },
        },
        config = { extra = { dollars = 1 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 5, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calculate = KAS.per_card(KAS.suit("Clubs")),
    }
end

-- 159. Sumo Sacerdote
do
    SMODS.Joker {
        key = "sumo_sacerdote",
        loc_txt = {
            name = "Sumo Sacerdote",
            text = {
                "Crea una carta de {C:tarot}Tarot{}",
                "cada vez que usas un {C:planet}Planeta{}",
                "{C:inactive}(Debe haber espacio)",
            },
        },
        config = { extra = {  } },
        rarity = 2,
        cost = 7,
        atlas = "cartas2",
        pos = { x = 6, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.create(KAS.T.consumable('Planet'), "Tarot", nil),
    }
end

-- 160. Rueda de la Fortuna
do
    SMODS.Joker {
        key = "rueda_fortuna",
        loc_txt = {
            name = "Rueda de la Fortuna",
            text = {
                "{C:green}#1# entre #2#{} probabilidades de",
                "ganar {C:money}$#3#{} al jugar una mano",
            },
        },
        config = { extra = { odds = 5, dollars = 10 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 7, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { KAS.prob(), e.odds, e.dollars } }
        end,
        calculate = KAS.chance("kas_rueda_fortuna"),
    }
end

-- 161. Calabaza Duende
do
    SMODS.Joker {
        key = "calabaza_duende",
        loc_txt = {
            name = "Calabaza Duende",
            text = {
                "{C:mult}+#1#{} multi,",
                "pierde {C:mult}#2#{} multi por mano jugada",
            },
        },
        config = { extra = { mult = 25, loss = 1, gain = -1 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas2",
        pos = { x = 8, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult, e.loss } }
        end,
        calculate = KAS.scale{ field = 'mult', on = KAS.T.hand_played, destroy_at = 0 },
    }
end

-- 162. Luna Partida
do
    SMODS.Joker {
        key = "luna_partida",
        loc_txt = {
            name = "Luna Partida",
            text = {
                "{X:mult,C:white} X#1# {} multi si la mano puntuada",
                "tiene cartas {C:hearts}rojas{} y {C:spades}negras{}",
            },
        },
        config = { extra = { xmult = 1.5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas2",
        pos = { x = 9, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.suit('Hearts', 'Diamonds')) > 0 and KAS.contar(context.scoring_hand, KAS.suit('Spades', 'Clubs')) > 0 end),
    }
end

-- 163. Esqueleto Dorado
do
    SMODS.Joker {
        key = "esqueleto_dorado",
        loc_txt = {
            name = "Esqueleto Dorado",
            text = {
                "Ganas {C:money}$#1#{} al final de la ronda",
                "si tienes menos de {C:money}$#2#{}",
            },
        },
        config = { extra = { dollars = 4, max = 10 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas2",
        pos = { x = 10, y = 4 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars, e.max } }
        end,
        calc_dollar_bonus = function(self, card) local e = card.ability.extra if G.GAME.dollars < e.max then return e.dollars end end,
    }
end

-- 164. Ojo del Vacío
do
    SMODS.Joker {
        key = "ojo_vacio",
        loc_txt = {
            name = "Ojo del Vacío",
            text = {
                "Gana {X:mult,C:white} X#1# {} multi cada vez",
                "que usas una carta {C:spectral}Espectral{}",
                "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
            },
        },
        config = { extra = { gain = 0.5, xmult = 1 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas2",
        pos = { x = 11, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.xmult } }
        end,
        calculate = KAS.scale{ field = 'xmult', on = KAS.T.consumable('Spectral') },
    }
end

-- 165. Tótem Verde
do
    SMODS.Joker {
        key = "totem_verde",
        loc_txt = {
            name = "Tótem Verde",
            text = {
                "En la {C:attention}primera mano{} de la ronda:",
                "{X:mult,C:white} X#1# {} multi y reactiva todas",
                "las cartas puntuadas",
            },
        },
        config = { extra = { xmult = 2, reps = 1 } },
        rarity = 4,
        cost = 20,
        atlas = "cartas2",
        pos = { x = 12, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.combine(KAS.retrigger(KAS.first_hand), KAS.cond(KAS.first_hand)),
    }
end

-- 166. Bufón Azur
do
    SMODS.Joker {
        key = "bufon_azur",
        loc_txt = {
            name = "Bufón Azur",
            text = {
                "{C:chips}+#1#{} fichas; el {C:attention}doble{} en la",
                "primera mano de la ronda",
            },
        },
        config = { extra = { chips = 50 } },
        rarity = 1,
        cost = 3,
        atlas = "cartas3",
        pos = { x = 0, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.dyn(function(card, context, e) return { chips = KAS.first_hand() and e.chips * 2 or e.chips } end),
    }
end

-- 167. Bufoncillo
do
    SMODS.Joker {
        key = "bufoncillo",
        loc_txt = {
            name = "Bufoncillo",
            text = {
                "{C:mult}+#1#{} multi por cada carta de valor",
                "{C:attention}5 o menos{} puntuada",
            },
        },
        config = { extra = { mult = 3 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas3",
        pos = { x = 1, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = KAS.contar(context.scoring_hand, KAS.rank(2, 3, 4, 5)) if n > 0 then return { mult = e.mult * n } end end),
    }
end

-- 168. Gran Bufón
do
    SMODS.Joker {
        key = "gran_bufon",
        loc_txt = {
            name = "Gran Bufón",
            text = {
                "{C:mult}+#1#{} multi por cada",
                "carta puntuada",
            },
        },
        config = { extra = { mult = 3 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas3",
        pos = { x = 2, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.dyn(function(card, context, e) return { mult = e.mult * #context.scoring_hand } end),
    }
end

-- 169. Bufón Morado
do
    SMODS.Joker {
        key = "bufon_morado",
        loc_txt = {
            name = "Bufón Morado",
            text = {
                "Gana {X:mult,C:white} X#1# {} multi cada vez",
                "que juegas una {C:attention}Pareja{}",
                "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
            },
        },
        config = { extra = { gain = 0.1, xmult = 1 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas3",
        pos = { x = 3, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.xmult } }
        end,
        calculate = KAS.scale{ field = 'xmult', on = KAS.T.hand_type('Pair') },
    }
end

-- 170. Calavera de Espadas
do
    SMODS.Joker {
        key = "calavera_espadas",
        loc_txt = {
            name = "Calavera de Espadas",
            text = {
                "Cada carta de {C:spades}Picas{} puntuada",
                "tiene {C:green}#1# entre #2#{} probabilidades",
                "de dar {X:mult,C:white} X#3# {} multi",
            },
        },
        config = { extra = { odds = 2, xmult = 1.5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas3",
        pos = { x = 4, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { KAS.prob(), e.odds, e.xmult } }
        end,
        calculate = KAS.per_card(KAS.suit("Spades"), "kas_calavera_espadas"),
    }
end

-- 171. Bufón del Bosque
do
    SMODS.Joker {
        key = "bufon_bosque",
        loc_txt = {
            name = "Bufón del Bosque",
            text = {
                "Cada carta de {C:clubs}Tréboles{} que tengas",
                "en la mano da {C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 3 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas3",
        pos = { x = 5, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.held(KAS.suit("Clubs")),
    }
end

-- 172. Gato Esmeralda
do
    SMODS.Joker {
        key = "gato_esmeralda",
        loc_txt = {
            name = "Gato Esmeralda",
            text = {
                "Reactiva cada carta",
                "de {C:clubs}Tréboles{} puntuada",
            },
        },
        config = { extra = { reps = 1 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas3",
        pos = { x = 6, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.retrigger(KAS.suit("Clubs")),
    }
end

-- 173. Simio Fantasma
do
    SMODS.Joker {
        key = "simio_fantasma",
        loc_txt = {
            name = "Simio Fantasma",
            text = {
                "{C:chips}+#1#{} fichas por cada comodín",
                "{C:green}Poco común{} o mejor que tengas",
            },
        },
        config = { extra = { chips = 25 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas3",
        pos = { x = 7, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = 0 for _, j in ipairs(G.jokers.cards) do if j.config.center.rarity ~= 1 then n = n + 1 end end if n > 0 then return { chips = e.chips * n } end end),
    }
end

-- 174. Zorro Rojo
do
    SMODS.Joker {
        key = "zorro_rojo",
        loc_txt = {
            name = "Zorro Rojo",
            text = {
                "Ganas {C:money}$#1#{} por cada carta",
                "de {C:hearts}Corazones{} descartada",
            },
        },
        config = { extra = { dollars = 1 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas3",
        pos = { x = 8, y = 0 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calculate = KAS.discard_money(KAS.suit("Hearts")),
    }
end

-- 175. Gato Azul
do
    SMODS.Joker {
        key = "gato_azul",
        loc_txt = {
            name = "Gato Azul",
            text = {
                "Reactiva cada carta",
                "de {C:spades}Picas{} puntuada",
            },
        },
        config = { extra = { reps = 1 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas3",
        pos = { x = 9, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.retrigger(KAS.suit("Spades")),
    }
end

-- 176. Simio Bufón
do
    SMODS.Joker {
        key = "simio_bufon",
        loc_txt = {
            name = "Simio Bufón",
            text = {
                "{C:mult}+#1#{} multi por cada mano",
                "ya jugada esta ronda",
            },
        },
        config = { extra = { mult = 4 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas3",
        pos = { x = 10, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = G.GAME.current_round.hands_played if n > 0 then return { mult = e.mult * n } end end),
    }
end

-- 177. León Dorado
do
    SMODS.Joker {
        key = "leon_dorado",
        loc_txt = {
            name = "León Dorado",
            text = {
                "Cada carta de {C:attention}figura{} puntuada",
                "da {C:mult}+#1#{} multi y {C:money}$#2#{}",
            },
        },
        config = { extra = { mult = 3, dollars = 1 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas3",
        pos = { x = 11, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult, e.dollars } }
        end,
        calculate = KAS.per_card(KAS.face),
    }
end

-- 178. Demonio Blanco
do
    SMODS.Joker {
        key = "demonio_blanco",
        loc_txt = {
            name = "Demonio Blanco",
            text = {
                "{X:mult,C:white} X#1# {} multi;",
                "{C:green}#2# entre #3#{} probabilidades de",
                "destruirse cada vez que {C:attention}descartas{}",
            },
        },
        config = { extra = { xmult = 3, break_odds = 4 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas3",
        pos = { x = 12, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult, KAS.prob(), e.break_odds } }
        end,
        calculate = KAS.combine(KAS.flat(), function(self, card, context) if context.pre_discard and not context.blueprint and pseudorandom('kas_demonio_blanco') < KAS.prob() / card.ability.extra.break_odds then KAS.destruir(card) return { message = localize('k_extinct_ex'), colour = G.C.RED } end end),
        eternal_compat = false,
    }
end

-- 179. Bufón Real
do
    SMODS.Joker {
        key = "bufon_real",
        loc_txt = {
            name = "Bufón Real",
            text = {
                "Reactiva cada {C:attention}Rey{}",
                "puntuado",
            },
        },
        config = { extra = { reps = 1 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas3",
        pos = { x = 0, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.retrigger(KAS.rank(13)),
    }
end

-- 180. Científico Loco
do
    SMODS.Joker {
        key = "cientifico_loco",
        loc_txt = {
            name = "Científico Loco",
            text = {
                "{C:green}#1# entre #2#{} probabilidades de crear",
                "una carta de {C:planet}Planeta{} cada",
                "vez que usas un {C:tarot}Tarot{}",
            },
        },
        config = { extra = { odds = 3 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas3",
        pos = { x = 1, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { KAS.prob(), e.odds } }
        end,
        calculate = KAS.create(KAS.T.consumable('Tarot'), "Planet", "kas_cientifico_loco"),
    }
end

-- 181. Duende del Sombrero
do
    SMODS.Joker {
        key = "duende_sombrero",
        loc_txt = {
            name = "Duende del Sombrero",
            text = {
                "Ganas {C:money}$#1#{} si la mano",
                "jugada contiene una {C:attention}Escalera{}",
            },
        },
        config = { extra = { dollars = 3 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas3",
        pos = { x = 2, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calculate = KAS.hand("Straight"),
    }
end

-- 182. Conejo Rosa
do
    SMODS.Joker {
        key = "conejo_rosa",
        loc_txt = {
            name = "Conejo Rosa",
            text = {
                "Cada {C:attention}2{} puntuado da {C:mult}+#1#{} multi",
                "por cada 2 de tu baraja completa",
            },
        },
        config = { extra = { mult = 1 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas3",
        pos = { x = 3, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.per_card_fn(KAS.rank(2), function(c, context, e) return { mult = e.mult * KAS.contar(G.playing_cards, KAS.rank(2)) } end),
    }
end

-- 183. Bufón de la Llama
do
    SMODS.Joker {
        key = "bufon_llama",
        loc_txt = {
            name = "Bufón de la Llama",
            text = {
                "Gana {C:mult}+#1#{} multi cada vez",
                "que juegas un {C:attention}Color{}",
                "{C:inactive}(Actual: {C:mult}+#2#{C:inactive} multi)",
            },
        },
        config = { extra = { gain = 5, mult = 0 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas3",
        pos = { x = 4, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.mult } }
        end,
        calculate = KAS.scale{ field = 'mult', on = KAS.T.hand_type('Flush') },
    }
end

-- 184. Husky
do
    SMODS.Joker {
        key = "husky",
        loc_txt = {
            name = "Husky",
            text = {
                "Cada {C:attention}7{} u {C:attention}8{} puntuado",
                "da {C:chips}+#1#{} fichas",
            },
        },
        config = { extra = { chips = 20 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas3",
        pos = { x = 5, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.per_card(KAS.rank(7, 8)),
    }
end

-- 185. Bufón Cortesano
do
    SMODS.Joker {
        key = "bufon_cortesano",
        loc_txt = {
            name = "Bufón Cortesano",
            text = {
                "Cada {C:attention}Reina{} puntuada da {C:mult}+#1#{} multi",
                "por cada {C:attention}Rey{} que tengas en la mano",
            },
        },
        config = { extra = { mult = 6 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas3",
        pos = { x = 6, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.per_card_fn(KAS.rank(12), function(c, context, e) local n = KAS.contar(G.hand.cards, KAS.rank(13)) if n > 0 then return { mult = e.mult * n } end end),
    }
end

-- 186. Gata Bufona
do
    SMODS.Joker {
        key = "gata_bufona",
        loc_txt = {
            name = "Gata Bufona",
            text = {
                "{X:mult,C:white} +X#1# {} multi por cada carta",
                "de {C:hearts}Corazones{} puntuada",
            },
        },
        config = { extra = { step = 0.2 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas3",
        pos = { x = 7, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.step } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = KAS.contar(context.scoring_hand, KAS.suit('Hearts')) if n > 0 then return { xmult = 1 + e.step * n } end end),
    }
end

-- 187. Gato de la Suerte
do
    SMODS.Joker {
        key = "gato_suerte",
        loc_txt = {
            name = "Gato de la Suerte",
            text = {
                "{C:green}#1# entre #2#{} probabilidades",
                "de dar {X:mult,C:white} X#3# {} multi",
            },
        },
        config = { extra = { odds = 7, xmult = 7 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas3",
        pos = { x = 8, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { KAS.prob(), e.odds, e.xmult } }
        end,
        calculate = KAS.chance("kas_gato_suerte"),
    }
end

-- 188. Planeta Azul
do
    SMODS.Joker {
        key = "planeta_azul",
        loc_txt = {
            name = "Planeta Azul",
            text = {
                "{C:chips}+#1#{} fichas por cada {C:attention}nivel{}",
                "de la mano jugada",
            },
        },
        config = { extra = { chips = 10 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas3",
        pos = { x = 9, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.dyn(function(card, context, e) local h = G.GAME.hands[context.scoring_name] if h then return { chips = e.chips * h.level } end end),
    }
end

-- 189. Fantasma Mago
do
    SMODS.Joker {
        key = "fantasma_mago",
        loc_txt = {
            name = "Fantasma Mago",
            text = {
                "Gana {C:mult}+#1#{} multi cada vez",
                "que usas una carta {C:spectral}Espectral{}",
                "{C:inactive}(Actual: {C:mult}+#2#{C:inactive} multi)",
            },
        },
        config = { extra = { gain = 5, mult = 0 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas3",
        pos = { x = 10, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.mult } }
        end,
        calculate = KAS.scale{ field = 'mult', on = KAS.T.consumable('Spectral') },
    }
end

-- 190. Faro
do
    SMODS.Joker {
        key = "faro",
        loc_txt = {
            name = "Faro",
            text = {
                "{X:mult,C:white} X#1# {} multi si te quedan",
                "{C:attention}#2#{} o más cartas en la mano",
            },
        },
        config = { extra = { xmult = 1.5, cards = 4 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas3",
        pos = { x = 11, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult, e.cards } }
        end,
        calculate = KAS.cond(function(card, context, e) return #G.hand.cards >= e.cards end),
    }
end

-- 191. Gato Brujo
do
    SMODS.Joker {
        key = "gato_brujo",
        loc_txt = {
            name = "Gato Brujo",
            text = {
                "Al seleccionar la {C:attention}ciega{}, ganas",
                "{C:blue}+1{} mano o {C:red}+1{} descarte al azar",
            },
        },
        config = { extra = {  } },
        rarity = 2,
        cost = 6,
        atlas = "cartas3",
        pos = { x = 12, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = function(self, card, context) if context.setting_blind then if pseudorandom('kas_gato_brujo') < 0.5 then ease_hands_played(1) return { message = '+1', colour = G.C.BLUE } end ease_discard(1) return { message = '+1', colour = G.C.RED } end end,
    }
end

-- 192. Perro Calavera
do
    SMODS.Joker {
        key = "perro_calavera",
        loc_txt = {
            name = "Perro Calavera",
            text = {
                "Gana {C:chips}+#1#{} fichas por cada",
                "carta {C:attention}descartada{}",
                "{C:inactive}(Actual: {C:chips}+#2#{C:inactive} fichas)",
            },
        },
        config = { extra = { gain = 3, chips = 0 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas3",
        pos = { x = 0, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.chips } }
        end,
        calculate = KAS.scale{ field = 'chips', on = KAS.T.discard },
    }
end

-- 193. Brujo Sombrío
do
    SMODS.Joker {
        key = "brujo_sombrio",
        loc_txt = {
            name = "Brujo Sombrío",
            text = {
                "{X:mult,C:white} X#1# {} multi si tienes al menos",
                "una carta de {C:tarot}Tarot{}",
            },
        },
        config = { extra = { xmult = 2 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas3",
        pos = { x = 1, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(function() for _, c in ipairs(G.consumeables.cards) do if c.ability.set == 'Tarot' then return true end end return false end),
    }
end

-- 194. Conejo Blanco
do
    local al_entrar, al_salir = KAS.passive({ hands = 1, discards = -2 })
    SMODS.Joker {
        key = "conejo_blanco",
        loc_txt = {
            name = "Conejo Blanco",
            text = {
                "{C:blue}+#1#{} mano por ronda,",
                "{C:red}-#2#{} descartes por ronda",
            },
        },
        config = { extra = { n = 1, m = 2 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas3",
        pos = { x = 2, y = 2 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.n, e.m } }
        end,
        add_to_deck = al_entrar,
        remove_from_deck = al_salir,
    }
end

-- 195. Luna Violeta
do
    SMODS.Joker {
        key = "luna_violeta",
        loc_txt = {
            name = "Luna Violeta",
            text = {
                "Si la mano contiene una {C:attention}Doble pareja{},",
                "crea una carta de {C:tarot}Tarot{}",
                "{C:inactive}(Debe haber espacio)",
            },
        },
        config = { extra = {  } },
        rarity = 1,
        cost = 5,
        atlas = "cartas3",
        pos = { x = 3, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.create(KAS.T.hand_type("Two Pair"), "Tarot", nil),
    }
end

-- 196. Oso Carmesí
do
    SMODS.Joker {
        key = "oso_carmesi",
        loc_txt = {
            name = "Oso Carmesí",
            text = {
                "{C:mult}+#1#{} multi si la mano",
                "jugada contiene {C:attention}Full{}",
            },
        },
        config = { extra = { mult = 20 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas3",
        pos = { x = 4, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.hand("Full House"),
    }
end

-- 197. Boston Terrier
do
    SMODS.Joker {
        key = "boston_terrier",
        loc_txt = {
            name = "Boston Terrier",
            text = {
                "Cada carta {C:attention}par{} que tengas",
                "en la mano da {C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 2 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas3",
        pos = { x = 5, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.held(KAS.even),
    }
end

-- 198. Lingote de Oro
do
    SMODS.Joker {
        key = "lingote_oro",
        loc_txt = {
            name = "Lingote de Oro",
            text = {
                "Ganas {C:money}$#1#{} al final de la ronda",
                "si la superas con {C:attention}una sola{} mano",
            },
        },
        config = { extra = { dollars = 6 } },
        rarity = 1,
        cost = 6,
        atlas = "cartas3",
        pos = { x = 6, y = 2 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calc_dollar_bonus = function(self, card) if G.GAME.current_round.hands_played == 1 then return card.ability.extra.dollars end end,
    }
end

-- 199. Cristal Rosa
do
    SMODS.Joker {
        key = "cristal_rosa",
        loc_txt = {
            name = "Cristal Rosa",
            text = {
                "Cada {C:attention}Reina{} puntuado",
                "da {X:mult,C:white} X#1# {} multi",
            },
        },
        config = { extra = { xmult = 1.5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas3",
        pos = { x = 7, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.per_card(KAS.rank(12)),
    }
end

-- 200. Cubo de Hielo
do
    SMODS.Joker {
        key = "cubo_hielo",
        loc_txt = {
            name = "Cubo de Hielo",
            text = {
                "{C:chips}+#1#{} fichas,",
                "pierde {C:chips}#2#{} fichas cada vez que descartas",
            },
        },
        config = { extra = { chips = 120, loss = 10, gain = -10 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas3",
        pos = { x = 8, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips, e.loss } }
        end,
        calculate = KAS.scale{ field = 'chips', on = KAS.T.pre_discard, destroy_at = 0 },
    }
end

-- 201. Zorro Paciente
do
    SMODS.Joker {
        key = "zorro_paciente",
        loc_txt = {
            name = "Zorro Paciente",
            text = {
                "Gana {C:mult}+#1#{} multi al final",
                "de cada ronda",
                "{C:inactive}(Actual: {C:mult}+#2#{C:inactive} multi)",
            },
        },
        config = { extra = { gain = 2, mult = 0 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas3",
        pos = { x = 9, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.mult } }
        end,
        calculate = KAS.scale{ field = 'mult', on = KAS.T.round_end },
    }
end

-- 202. Rey Demonio
do
    SMODS.Joker {
        key = "rey_demonio",
        loc_txt = {
            name = "Rey Demonio",
            text = {
                "{X:mult,C:white} X#1# {} multi por cada {C:attention}Rey{}",
                "en la mano puntuada",
            },
        },
        config = { extra = { xmult = 1.5 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas3",
        pos = { x = 10, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = KAS.contar(context.scoring_hand, KAS.rank(13)) if n > 0 then return { xmult = e.xmult ^ n } end end),
    }
end

-- 203. El Encapuchado
do
    SMODS.Joker {
        key = "el_encapuchado",
        loc_txt = {
            name = "El Encapuchado",
            text = {
                "{X:mult,C:white} X#1# {} multi si todas las cartas puntuadas",
                "son {C:spades}Picas{} o {C:clubs}Tréboles{}",
            },
        },
        config = { extra = { xmult = 2 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas3",
        pos = { x = 11, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.suit('Spades', 'Clubs')) == #context.scoring_hand end),
    }
end

-- 204. Lámpara Dorada
do
    SMODS.Joker {
        key = "lampara_dorada",
        loc_txt = {
            name = "Lámpara Dorada",
            text = {
                "{X:mult,C:white} X#1# {} multi",
                "Crea una carta {C:spectral}Espectral{}",
                "al seleccionar la {C:attention}ciega{}",
            },
        },
        config = { extra = { xmult = 2 } },
        rarity = 4,
        cost = 20,
        atlas = "cartas3",
        pos = { x = 12, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.combine(KAS.flat(), KAS.create(KAS.T.blind, "Spectral")),
    }
end

-- 205. Lobo Violeta
do
    SMODS.Joker {
        key = "lobo_violeta",
        loc_txt = {
            name = "Lobo Violeta",
            text = {
                "{C:mult}+#1#{} multi si tienes",
                "{C:attention}#2#{} comodines o más",
            },
        },
        config = { extra = { mult = 10, min = 3 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas3",
        pos = { x = 0, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult, e.min } }
        end,
        calculate = KAS.cond(function(card, context, e) return #G.jokers.cards >= e.min end),
    }
end

-- 206. Bufón del Sol
do
    SMODS.Joker {
        key = "bufon_sol",
        loc_txt = {
            name = "Bufón del Sol",
            text = {
                "Cada carta {C:hearts}roja{} puntuada",
                "da {C:mult}+#1#{} multi y {C:chips}+#2#{} fichas",
            },
        },
        config = { extra = { mult = 2, chips = 10 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas3",
        pos = { x = 1, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult, e.chips } }
        end,
        calculate = KAS.per_card(KAS.suit("Hearts", "Diamonds")),
    }
end

-- 207. Calavera Dorada
do
    SMODS.Joker {
        key = "calavera_dorada",
        loc_txt = {
            name = "Calavera Dorada",
            text = {
                "Cada {C:attention}As{} puntuado",
                "da {X:mult,C:white} X#1# {} multi",
            },
        },
        config = { extra = { xmult = 1.5 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas3",
        pos = { x = 2, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.per_card(KAS.rank(14)),
    }
end

-- 208. Bufón Nocturno
do
    SMODS.Joker {
        key = "bufon_nocturno",
        loc_txt = {
            name = "Bufón Nocturno",
            text = {
                "{C:mult}+#1#{} multi si la mano puntuada",
                "no tiene {C:attention}figuras{} ni {C:attention}Ases{}",
            },
        },
        config = { extra = { mult = 25 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas3",
        pos = { x = 3, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, function(c) return c:is_face() or c:get_id() == 14 end) == 0 end),
    }
end

-- 209. Duende Bufón
do
    SMODS.Joker {
        key = "duende_bufon",
        loc_txt = {
            name = "Duende Bufón",
            text = {
                "Cada {C:attention}J{} o {C:attention}Reina{} puntuado",
                "da {C:chips}+#1#{} fichas",
            },
        },
        config = { extra = { chips = 20 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas3",
        pos = { x = 4, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.per_card(KAS.rank(11, 12)),
    }
end

-- 210. Llama Azul
do
    SMODS.Joker {
        key = "llama_azul",
        loc_txt = {
            name = "Llama Azul",
            text = {
                "Gana {X:mult,C:white} X#1# {} multi por cada carta",
                "de {C:spades}Picas{} puntuada",
                "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
            },
        },
        config = { extra = { gain = 0.05, xmult = 1 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas3",
        pos = { x = 5, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.xmult } }
        end,
        calculate = KAS.scale{ field = 'xmult', on = function(context) return context.before and KAS.contar(context.scoring_hand, KAS.suit('Spades')) end },
    }
end

-- 211. Dado Rojo
do
    SMODS.Joker {
        key = "dado_rojo",
        loc_txt = {
            name = "Dado Rojo",
            text = {
                "{C:green}#1# entre #2#{} probabilidades",
                "de dar {X:mult,C:white} X#3# {} multi",
            },
        },
        config = { extra = { odds = 6, xmult = 6 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas3",
        pos = { x = 6, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { KAS.prob(), e.odds, e.xmult } }
        end,
        calculate = KAS.chance("kas_dado_rojo"),
    }
end

-- 212. Conde Vampiro
do
    SMODS.Joker {
        key = "conde_vampiro",
        loc_txt = {
            name = "Conde Vampiro",
            text = {
                "Gana {X:mult,C:white} X#1# {} multi por cada carta",
                "de {C:hearts}Corazones{} puntuada",
                "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
            },
        },
        config = { extra = { gain = 0.1, xmult = 1 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas3",
        pos = { x = 7, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.xmult } }
        end,
        calculate = KAS.scale{ field = 'xmult', on = function(context) return context.before and KAS.contar(context.scoring_hand, KAS.suit('Hearts')) end },
    }
end

-- 213. Orbe Demoníaco
do
    SMODS.Joker {
        key = "orbe_demoniaco",
        loc_txt = {
            name = "Orbe Demoníaco",
            text = {
                "{X:mult,C:white} X#1# {} multi, pierde {X:mult,C:white} X#2# {}",
                "por mano jugada",
            },
        },
        config = { extra = { xmult = 2, loss = 0.1, gain = -0.1 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas3",
        pos = { x = 8, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult, e.loss } }
        end,
        calculate = KAS.scale{ field = 'xmult', on = KAS.T.hand_played, destroy_at = 1 },
    }
end

-- 214. Meteorito
do
    SMODS.Joker {
        key = "meteorito",
        loc_txt = {
            name = "Meteorito",
            text = {
                "{C:chips}+#1#{} fichas por cada {C:attention}nivel{}",
                "sumando todas tus manos de póker",
            },
        },
        config = { extra = { chips = 2 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas3",
        pos = { x = 9, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = 0 for _, h in pairs(G.GAME.hands) do n = n + h.level end return { chips = e.chips * n } end),
    }
end

-- 215. Calavera Bruja
do
    SMODS.Joker {
        key = "calavera_bruja",
        loc_txt = {
            name = "Calavera Bruja",
            text = {
                "{C:chips}+#1#{} fichas por cada consumible",
                "usado en la partida",
            },
        },
        config = { extra = { chips = 5 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas3",
        pos = { x = 10, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.all) or 0 if n > 0 then return { chips = e.chips * n } end end),
    }
end

-- 216. Dado Azul
do
    SMODS.Joker {
        key = "dado_azul",
        loc_txt = {
            name = "Dado Azul",
            text = {
                "Da entre {C:chips}+#1#{} y {C:chips}+#2#{}",
                "fichas al azar",
            },
        },
        config = { extra = { min = 10, max = 100 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas3",
        pos = { x = 11, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.min, e.max } }
        end,
        calculate = KAS.dyn(function(card, context, e) return { chips = pseudorandom('kas_dado_azul', e.min, e.max) } end),
    }
end

-- 217. Máscara Dorada
do
    SMODS.Joker {
        key = "mascara_dorada",
        loc_txt = {
            name = "Máscara Dorada",
            text = {
                "Cada carta de {C:attention}figura{}",
                "puntuada da {X:mult,C:white} X#1# {} multi",
            },
        },
        config = { extra = { xmult = 1.5 } },
        rarity = 4,
        cost = 20,
        atlas = "cartas3",
        pos = { x = 12, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.per_card(KAS.face),
    }
end
