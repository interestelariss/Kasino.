--- GENERADO por tools/generar_comodines.py: no editar a mano.
--- Los 100 comodines de la hoja de sprites (atlas kasino_cartas).

-- 1. Bufón Clásico
do
    SMODS.Joker {
        key = "bufon_clasico",
        loc_txt = {
            name = "Bufón Clásico",
            text = {
                "{C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 5 } },
        rarity = 1,
        cost = 3,
        atlas = "cartas",
        pos = { x = 0, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.flat(),
    }
end

-- 2. Bufón Sombrío
do
    SMODS.Joker {
        key = "bufon_sombrio",
        loc_txt = {
            name = "Bufón Sombrío",
            text = {
                "Cada carta de {C:spades}Picas{} puntuada",
                "da {C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 3 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 1, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.per_card(KAS.suit("Spades")),
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
                "{C:mult}+#1#{} multi si la mano",
                "jugada contiene {C:attention}Doble pareja{}",
            },
        },
        config = { extra = { mult = 10 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 3, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.hand("Two Pair"),
    }
end

-- 5. Bufón Alegre
do
    SMODS.Joker {
        key = "bufon_alegre",
        loc_txt = {
            name = "Bufón Alegre",
            text = {
                "{C:chips}+#1#{} fichas si la mano",
                "jugada contiene {C:attention}Pareja{}",
            },
        },
        config = { extra = { chips = 50 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 4, y = 0 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.hand("Pair"),
    }
end

-- 6. Bufón de Cascabeles
do
    SMODS.Joker {
        key = "bufon_cascabeles",
        loc_txt = {
            name = "Bufón de Cascabeles",
            text = {
                "Ganas {C:money}$#1#{} al final",
                "de la ronda",
            },
        },
        config = { extra = { dollars = 3 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 5, y = 0 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calc_dollar_bonus = function(self, card) return card.ability.extra.dollars end,
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
                "{X:mult,C:white} X#1# {} multi en la",
                "{C:attention}última mano{} de la ronda",
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
        calculate = KAS.cond(KAS.last_hand),
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
                "{X:mult,C:white} X#1# {} multi si la mano puntuada",
                "tiene cartas de los {C:attention}4 palos{}",
            },
        },
        config = { extra = { xmult = 2.5 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas",
        pos = { x = 0, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.cond(function(card, context) return KAS.palos_distintos(context) >= 4 end),
    }
end

-- 12. Bufón Danzarín
do
    SMODS.Joker {
        key = "bufon_danzarin",
        loc_txt = {
            name = "Bufón Danzarín",
            text = {
                "{C:chips}+#1#{} fichas por cada",
                "{C:attention}descarte{} restante",
            },
        },
        config = { extra = { chips = 15 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 1, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = G.GAME.current_round.discards_left if n > 0 then return { chips = e.chips * n } end end),
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
                "Cada carta {C:attention}par{} puntuada",
                "{C:inactive}(10, 8, 6, 4, 2){} da {C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 4 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 3, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.per_card(KAS.even),
    }
end

-- 15. Bufón Verde
do
    SMODS.Joker {
        key = "bufon_verde",
        loc_txt = {
            name = "Bufón Verde",
            text = {
                "{C:mult}+#1#{} multi por cada mano jugada",
                "y {C:mult}-#1#{} multi por cada descarte",
                "{C:inactive}(Actual: {C:mult}+#2#{C:inactive} multi)",
            },
        },
        config = { extra = { gain = 1, mult = 0 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 4, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.mult } }
        end,
        calculate = function(self, card, context) local e = card.ability.extra if context.before and not context.blueprint then e.mult = e.mult + e.gain return { message = localize('k_upgrade_ex'), colour = G.C.MULT } end if context.pre_discard and not context.blueprint and e.mult > 0 then e.mult = math.max(0, e.mult - e.gain) return { message = localize { type = 'variable', key = 'a_mult_minus', vars = { e.gain } }, colour = G.C.RED } end if context.joker_main and e.mult > 0 then return { mult = e.mult } end end,
    }
end

-- 16. Bufón Estrella
do
    SMODS.Joker {
        key = "bufon_estrella",
        loc_txt = {
            name = "Bufón Estrella",
            text = {
                "Cada {C:attention}As{} puntuado da",
                "{C:chips}+#1#{} fichas y {C:mult}+#2#{} multi",
            },
        },
        config = { extra = { chips = 20, mult = 4 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 5, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips, e.mult } }
        end,
        calculate = KAS.per_card(KAS.rank(14)),
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
                "Crea una carta de {C:tarot}Tarot{}",
                "al seleccionar la {C:attention}ciega{}",
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
        calculate = KAS.create(KAS.T.blind, "Tarot", nil),
    }
end

-- 20. Arlequín
do
    SMODS.Joker {
        key = "arlequin",
        loc_txt = {
            name = "Arlequín",
            text = {
                "{C:mult}+#1#{} multi por cada",
                "{C:attention}comodín{} que tengas",
            },
        },
        config = { extra = { mult = 3 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 9, y = 1 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.dyn(function(card, context, e) return { mult = e.mult * #G.jokers.cards } end),
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
    local al_entrar, al_salir = KAS.passive({ prob_mult = 2 })
    SMODS.Joker {
        key = "conejo_suerte",
        loc_txt = {
            name = "Conejo de la Suerte",
            text = {
                "{C:attention}Duplica{} todas las",
                "{C:green}probabilidades{} del juego",
            },
        },
        config = { extra = {  } },
        rarity = 3,
        cost = 8,
        atlas = "cartas",
        pos = { x = 2, y = 2 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        add_to_deck = al_entrar,
        remove_from_deck = al_salir,
    }
end

-- 24. Rey Rana
do
    SMODS.Joker {
        key = "rey_rana",
        loc_txt = {
            name = "Rey Rana",
            text = {
                "{C:mult}+#1#{} multi si juegas",
                "{C:attention}#2#{} cartas o menos",
            },
        },
        config = { extra = { mult = 16, cards = 3 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 3, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult, e.cards } }
        end,
        calculate = KAS.cond(function(card, context, e) return #context.full_hand <= e.cards end),
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
                "Gana {C:money}$#1#{} de {C:attention}valor de venta{}",
                "al final de la ronda",
            },
        },
        config = { extra = { gain = 2 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 5, y = 2 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain } }
        end,
        calculate = function(self, card, context) if KAS.T.round_end(context) and not context.blueprint then card.ability.extra_value = (card.ability.extra_value or 0) + card.ability.extra.gain card:set_cost() return { message = localize('k_val_up'), colour = G.C.MONEY } end end,
    }
end

-- 27. Tigre
do
    SMODS.Joker {
        key = "tigre",
        loc_txt = {
            name = "Tigre",
            text = {
                "{X:mult,C:white} X#1# {} multi si la mano",
                "jugada contiene {C:attention}Escalera{}",
            },
        },
        config = { extra = { xmult = 2 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas",
        pos = { x = 6, y = 2 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult } }
        end,
        calculate = KAS.hand("Straight"),
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
    local al_entrar, al_salir = KAS.passive({ hand_size = 1 })
    SMODS.Joker {
        key = "serpiente",
        loc_txt = {
            name = "Serpiente",
            text = {
                "{C:attention}+#1#{} tamaño de mano",
            },
        },
        config = { extra = { n = 1 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 9, y = 2 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.n } }
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
                "Cada carta de {C:diamonds}Diamantes{} puntuada",
                "da {C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 3 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 3, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.per_card(KAS.suit("Diamonds")),
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
                "Gana {X:mult,C:white} X#1# {} multi cada vez",
                "que usas una carta de {C:planet}Planeta{}",
                "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
            },
        },
        config = { extra = { gain = 0.25, xmult = 1 } },
        rarity = 4,
        cost = 20,
        atlas = "cartas",
        pos = { x = 6, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.xmult } }
        end,
        calculate = KAS.scale{ field = 'xmult', on = KAS.T.consumable('Planet') },
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
                "Gana {C:mult}+#1#{} multi cada vez",
                "que usas una carta de {C:tarot}Tarot{}",
                "{C:inactive}(Actual: {C:mult}+#2#{C:inactive} multi)",
            },
        },
        config = { extra = { gain = 2, mult = 0 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 8, y = 3 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.mult } }
        end,
        calculate = KAS.scale{ field = 'mult', on = KAS.T.consumable('Tarot') },
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
                "Cada carta de {C:clubs}Tréboles{} puntuada",
                "da {C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 3 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 1, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.per_card(KAS.suit("Clubs")),
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
                "que quede en tu {C:attention}baraja{}",
            },
        },
        config = { extra = { chips = 2 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 2, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.dyn(function(card, context, e) return { chips = e.chips * #G.deck.cards } end),
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
                "Cada carta de {C:hearts}Corazones{} puntuada",
                "tiene {C:green}#1# entre #2#{} probabilidades",
                "de dar {X:mult,C:white} X#3# {} multi",
            },
        },
        config = { extra = { odds = 2, xmult = 1.5 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 6, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { KAS.prob(), e.odds, e.xmult } }
        end,
        calculate = KAS.per_card(KAS.suit("Hearts"), "kas_bufon_rubi"),
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
                "da {C:money}$#1#{}",
            },
        },
        config = { extra = { dollars = 1 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas",
        pos = { x = 7, y = 4 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calculate = KAS.per_card(KAS.suit("Diamonds")),
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
                "Reactiva la {C:attention}primera{} carta",
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
        calculate = KAS.retrigger(KAS.first),
    }
end

-- 54. Enterrador
do
    SMODS.Joker {
        key = "enterrador",
        loc_txt = {
            name = "Enterrador",
            text = {
                "Gana {X:mult,C:white} X#1# {} multi cada vez que",
                "vendes otro {C:attention}comodín{}",
                "{C:inactive}(Actual: {X:mult,C:white} X#2# {C:inactive} multi)",
            },
        },
        config = { extra = { gain = 0.25, xmult = 1 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas",
        pos = { x = 3, y = 5 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.xmult } }
        end,
        calculate = KAS.scale{ field = 'xmult', on = KAS.T.sell_other_joker },
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
                "da {C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 3 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 6, y = 5 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.per_card(KAS.suit("Hearts")),
    }
end

-- 58. Bufón Duelista
do
    SMODS.Joker {
        key = "bufon_duelista",
        loc_txt = {
            name = "Bufón Duelista",
            text = {
                "{C:mult}+#1#{} multi si la mano",
                "jugada contiene {C:attention}Pareja{}",
            },
        },
        config = { extra = { mult = 8 } },
        rarity = 1,
        cost = 3,
        atlas = "cartas",
        pos = { x = 7, y = 5 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.hand("Pair"),
    }
end

-- 59. Malabarista
do
    local al_entrar, al_salir = KAS.passive({ discards = 1 })
    SMODS.Joker {
        key = "malabarista",
        loc_txt = {
            name = "Malabarista",
            text = {
                "{C:red}+#1#{} descarte por ronda",
            },
        },
        config = { extra = { n = 1 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 8, y = 5 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.n } }
        end,
        add_to_deck = al_entrar,
        remove_from_deck = al_salir,
    }
end

-- 60. Ladrón
do
    SMODS.Joker {
        key = "ladron",
        loc_txt = {
            name = "Ladrón",
            text = {
                "Cada carta de {C:attention}figura{}",
                "puntuada da {C:money}$#1#{}",
            },
        },
        config = { extra = { dollars = 1 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 9, y = 5 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calculate = KAS.per_card(KAS.face),
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
                "pierde {C:mult}#2#{} multi al final de la ronda",
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
        calculate = KAS.scale{ field = 'mult', on = KAS.T.round_end, destroy_at = 0 },
    }
end

-- 64. Bufón Feliz
do
    SMODS.Joker {
        key = "bufon_feliz",
        loc_txt = {
            name = "Bufón Feliz",
            text = {
                "{C:chips}+#1#{} fichas si la mano",
                "jugada contiene {C:attention}Trío{}",
            },
        },
        config = { extra = { chips = 100 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 3, y = 6 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.hand("Three of a Kind"),
    }
end

-- 65. Mago de la Moneda
do
    SMODS.Joker {
        key = "mago_moneda",
        loc_txt = {
            name = "Mago de la Moneda",
            text = {
                "{C:mult}+#1#{} multi por cada",
                "{C:money}$#2#{} que tengas",
            },
        },
        config = { extra = { mult = 2, per = 5 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas",
        pos = { x = 4, y = 6 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult, e.per } }
        end,
        calculate = KAS.dyn(function(card, context, e) local n = math.floor(G.GAME.dollars / e.per) if n > 0 then return { mult = e.mult * n } end end),
    }
end

-- 66. Guitarrista
do
    SMODS.Joker {
        key = "guitarrista",
        loc_txt = {
            name = "Guitarrista",
            text = {
                "Reactiva cada {C:attention}2{}, {C:attention}3{},",
                "{C:attention}4{} o {C:attention}5{} puntuado",
            },
        },
        config = { extra = { reps = 1 } },
        rarity = 2,
        cost = 6,
        atlas = "cartas",
        pos = { x = 5, y = 6 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.retrigger(KAS.rank(2, 3, 4, 5)),
    }
end

-- 67. Bufón de los Globos
do
    SMODS.Joker {
        key = "bufon_globos",
        loc_txt = {
            name = "Bufón de los Globos",
            text = {
                "{C:mult}+#1#{} multi;",
                "{C:green}#2# entre #3#{} probabilidades de",
                "explotar al final de la ronda",
            },
        },
        config = { extra = { mult = 15, break_odds = 6 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 6, y = 6 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult, KAS.prob(), e.break_odds } }
        end,
        calculate = KAS.combine(KAS.flat(), KAS.fragile("kas_bufon_globos")),
        eternal_compat = false,
    }
end

-- 68. Bufón Sonriente
do
    SMODS.Joker {
        key = "bufon_sonriente",
        loc_txt = {
            name = "Bufón Sonriente",
            text = {
                "Cada carta de {C:attention}figura{}",
                "puntuada da {C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 5 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 7, y = 6 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.per_card(KAS.face),
    }
end

-- 69. Bola 8
do
    SMODS.Joker {
        key = "bola_ocho",
        loc_txt = {
            name = "Bola 8",
            text = {
                "Cada {C:attention}8{} puntuado tiene",
                "{C:green}#1# entre #2#{} probabilidades",
                "de crear una carta de {C:tarot}Tarot{}",
            },
        },
        config = { extra = { odds = 4 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 8, y = 6 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { KAS.prob(), e.odds } }
        end,
        calculate = function(self, card, context) if context.individual and context.cardarea == G.play and context.other_card:get_id() == 8 and pseudorandom('kas_bola_ocho') < KAS.prob() / card.ability.extra.odds then return KAS.crear('Tarot') end end,
    }
end

-- 70. Bufón Molón
do
    SMODS.Joker {
        key = "bufon_molon",
        loc_txt = {
            name = "Bufón Molón",
            text = {
                "{C:mult}+#1#{} multi si la mano",
                "jugada contiene {C:attention}Escalera{}",
            },
        },
        config = { extra = { mult = 12 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 9, y = 6 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.hand("Straight"),
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
                "Al final de la ronda ganas {C:money}$#1#{}",
                "por cada {C:attention}descarte{} restante",
            },
        },
        config = { extra = { dollars = 1 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 4, y = 7 },
        blueprint_compat = false,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.dollars } }
        end,
        calc_dollar_bonus = function(self, card) local n = G.GAME.current_round.discards_left if n > 0 then return n * card.ability.extra.dollars end end,
    }
end

-- 76. Calaverita
do
    SMODS.Joker {
        key = "calaverita",
        loc_txt = {
            name = "Calaverita",
            text = {
                "Cada carta {C:attention}impar{} puntuada",
                "{C:inactive}(A, 9, 7, 5, 3){} da {C:chips}+#1#{} fichas",
            },
        },
        config = { extra = { chips = 31 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 5, y = 7 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.chips } }
        end,
        calculate = KAS.per_card(KAS.odd),
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
                "Da entre {C:mult}+#1#{} y {C:mult}+#2#{}",
                "multi al azar",
            },
        },
        config = { extra = { min = 1, max = 20 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 1, y = 8 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.min, e.max } }
        end,
        calculate = KAS.dyn(function(card, context, e) return { mult = pseudorandom('kas_bufon_dados', e.min, e.max) } end),
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
                "Gana {C:chips}+#1#{} fichas por cada",
                "carta puntuada",
                "{C:inactive}(Actual: {C:chips}+#2#{C:inactive} fichas)",
            },
        },
        config = { extra = { gain = 2, chips = 0 } },
        rarity = 1,
        cost = 5,
        atlas = "cartas",
        pos = { x = 4, y = 8 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.gain, e.chips } }
        end,
        calculate = KAS.scale{ field = 'chips', on = function(context) return context.before and #context.scoring_hand end },
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
                "Cada {C:attention}8{} puntuado",
                "da {C:mult}+#1#{} multi",
            },
        },
        config = { extra = { mult = 8 } },
        rarity = 1,
        cost = 4,
        atlas = "cartas",
        pos = { x = 6, y = 8 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.mult } }
        end,
        calculate = KAS.per_card(KAS.rank(8)),
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
                "Reactiva todas las cartas puntuadas",
                "en la {C:attention}última mano{} de la ronda",
            },
        },
        config = { extra = { reps = 1 } },
        rarity = 3,
        cost = 8,
        atlas = "cartas",
        pos = { x = 2, y = 9 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = {  } }
        end,
        calculate = KAS.retrigger(KAS.last_hand),
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
                "{X:mult,C:white} X#1# {} multi cada {C:attention}#2#{} manos",
                "jugadas",
            },
        },
        config = { extra = { xmult = 3, every = 3, count = 0 } },
        rarity = 2,
        cost = 7,
        atlas = "cartas",
        pos = { x = 5, y = 9 },
        blueprint_compat = true,
        loc_vars = function(self, info_queue, card)
            local e = card.ability.extra
            return { vars = { e.xmult, e.every } }
        end,
        calculate = function(self, card, context) local e = card.ability.extra if context.before and not context.blueprint then e.count = e.count + 1 end if context.joker_main and e.count % e.every == 0 then return { xmult = e.xmult } end end,
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
