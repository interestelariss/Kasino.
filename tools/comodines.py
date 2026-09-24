"""Definicion de los 100 comodines de la hoja de sprites (assets/fuente/hoja_comodines.webp).

El orden de la lista es el orden de la hoja: fila a fila, de izquierda a derecha.
generar_comodines.py lee esta lista para crear comodines.lua y la tabla del README.

Campos:
  key, nombre, rareza (1 comun, 2 poco comun, 3 raro, 4 legendario), coste,
  texto   lineas de descripcion con el formato de Balatro; #1#, #2#... son `vars`
  cfg     valores iniciales (card.ability.extra)
  vars    claves de cfg que rellenan #1#, #2#...; "prob" es la probabilidad base
  calc    expresion Lua que construye calculate (ver kasino_lib.lua)
  extra   campos Lua adicionales (calc_dollar_bonus...)
  pasivo  modificadores de KAS.passive
  bp      compatible con Blueprint/Brainstorm
"""

MULT = "{C:mult}+#%d#{} multi"
CHIPS = "{C:chips}+#%d#{} fichas"
XMULT = "{X:mult,C:white} X#%d# {} multi"
PALO = {
    "Hearts": "{C:hearts}Corazones{}", "Diamonds": "{C:diamonds}Diamantes{}",
    "Spades": "{C:spades}Picas{}", "Clubs": "{C:clubs}Tréboles{}",
}
PROB = "{C:green}#%d# entre #%d#{} probabilidades"


def J(key, nombre, rareza, coste, texto, cfg, vars, calc=None, extra=None, pasivo=None, bp=True):
    return dict(key=key, nombre=nombre, rareza=rareza, coste=coste, texto=texto,
                cfg=cfg, vars=vars, calc=calc, extra=extra, pasivo=pasivo, bp=bp)


def palo(key, nombre, rareza, coste, suit, campo, valor):
    fmt = MULT if campo == "mult" else CHIPS
    return J(key, nombre, rareza, coste,
             ["Cada carta de %s puntuada" % PALO[suit], "da " + fmt % 1],
             {campo: valor}, [campo], 'KAS.per_card(KAS.suit("%s"))' % suit)


def mano(key, nombre, rareza, coste, hand, hand_es, campo, valor):
    fmt = {"mult": MULT, "chips": CHIPS, "xmult": XMULT}[campo]
    return J(key, nombre, rareza, coste,
             [fmt % 1 + " si la mano", "jugada contiene {C:attention}%s{}" % hand_es],
             {campo: valor}, [campo], 'KAS.hand("%s")' % hand)


def crear(key, nombre, rareza, coste, texto, set_, on, odds=None):
    cfg = {"odds": odds} if odds else {}
    vars_ = ["prob", "odds"] if odds else []
    seed = '"kas_%s"' % key if odds else "nil"
    return J(key, nombre, rareza, coste, texto, cfg, vars_,
             'KAS.create(%s, "%s", %s)' % (on, set_, seed), bp=True)


ACTUAL_X = "{C:inactive}(Actual: {X:mult,C:white} X#%d# {C:inactive} multi)"
ACTUAL_M = "{C:inactive}(Actual: {C:mult}+#%d#{C:inactive} multi)"
ACTUAL_C = "{C:inactive}(Actual: {C:chips}+#%d#{C:inactive} fichas)"

COMODINES = [
    # ---- Fila 1: bufones clasicos ----
    J("bufon_clasico", "Bufón Clásico", 1, 3, [MULT % 1], {"mult": 5}, ["mult"], "KAS.flat()"),
    palo("bufon_sombrio", "Bufón Sombrío", 1, 5, "Spades", "mult", 3),
    J("rey_bufon", "Rey Bufón", 2, 7,
      ["Cada {C:attention}Rey{} puntuado", "da " + XMULT % 1],
      {"xmult": 1.25}, ["xmult"], "KAS.per_card(KAS.rank(13))"),
    mano("bufon_violeta", "Bufón Violeta", 1, 4, "Two Pair", "Doble pareja", "mult", 10),
    mano("bufon_alegre", "Bufón Alegre", 1, 4, "Pair", "Pareja", "chips", 50),
    J("bufon_cascabeles", "Bufón de Cascabeles", 1, 5,
      ["Ganas {C:money}$#1#{} al final", "de la ronda"], {"dollars": 3}, ["dollars"],
      extra="calc_dollar_bonus = function(self, card) return card.ability.extra.dollars end", bp=False),
    J("bufon_puntiagudo", "Bufón Puntiagudo", 1, 4,
      [MULT % 1 + " por cada", "{C:attention}mano{} restante"], {"mult": 3}, ["mult"],
      "KAS.dyn(function(card, context, e) local n = G.GAME.current_round.hands_left "
      "if n > 0 then return { mult = e.mult * n } end end)"),
    J("reina_bufona", "Reina Bufona", 1, 5,
      ["Cada {C:attention}Reina{} puntuada da", MULT % 1 + " y " + CHIPS % 2],
      {"mult": 8, "chips": 20}, ["mult", "chips"], "KAS.per_card(KAS.rank(12))"),
    J("bufon_siniestro", "Bufón Siniestro", 2, 6,
      [XMULT % 1 + " en la", "{C:attention}última mano{} de la ronda"],
      {"xmult": 2}, ["xmult"], "KAS.cond(KAS.last_hand)"),
    J("bufon_fantasma", "Bufón Fantasma", 2, 6,
      ["Al {C:attention}venderlo{}, crea una", "carta {C:spectral}Espectral{}"],
      {}, [], 'KAS.sell_create("Spectral")', bp=False),

    # ---- Fila 2 ----
    J("arlequin_retales", "Arlequín de Retales", 2, 7,
      [XMULT % 1 + " si la mano puntuada", "tiene cartas de los {C:attention}4 palos{}"],
      {"xmult": 2.5}, ["xmult"],
      "KAS.cond(function(card, context) return KAS.palos_distintos(context) >= 4 end)"),
    J("bufon_danzarin", "Bufón Danzarín", 1, 4,
      [CHIPS % 1 + " por cada", "{C:attention}descarte{} restante"], {"chips": 15}, ["chips"],
      "KAS.dyn(function(card, context, e) local n = G.GAME.current_round.discards_left "
      "if n > 0 then return { chips = e.chips * n } end end)"),
    J("mascara_vampira", "Máscara Vampira", 2, 7,
      ["Gana " + XMULT % 1 + " por cada", "carta de {C:attention}figura{} puntuada", ACTUAL_X % 2],
      {"gain": 0.1, "xmult": 1}, ["gain", "xmult"],
      "KAS.scale{ field = 'xmult', on = function(context) return context.before "
      "and KAS.contar(context.scoring_hand, KAS.face) end }"),
    J("bufon_bicolor", "Bufón Bicolor", 1, 4,
      ["Cada carta {C:attention}par{} puntuada", "{C:inactive}(10, 8, 6, 4, 2){} da " + MULT % 1],
      {"mult": 4}, ["mult"], "KAS.per_card(KAS.even)"),
    J("bufon_verde", "Bufón Verde", 1, 4,
      [MULT % 1 + " por cada mano jugada", "y {C:mult}-#1#{} multi por cada descarte", ACTUAL_M % 2],
      {"gain": 1, "mult": 0}, ["gain", "mult"],
      "function(self, card, context) local e = card.ability.extra "
      "if context.before and not context.blueprint then e.mult = e.mult + e.gain "
      "return { message = localize('k_upgrade_ex'), colour = G.C.MULT } end "
      "if context.pre_discard and not context.blueprint and e.mult > 0 then "
      "e.mult = math.max(0, e.mult - e.gain) "
      "return { message = localize { type = 'variable', key = 'a_mult_minus', vars = { e.gain } }, colour = G.C.RED } end "
      "if context.joker_main and e.mult > 0 then return { mult = e.mult } end end"),
    J("bufon_estrella", "Bufón Estrella", 1, 4,
      ["Cada {C:attention}As{} puntuado da", CHIPS % 1 + " y " + MULT % 2],
      {"chips": 20, "mult": 4}, ["chips", "mult"], "KAS.per_card(KAS.rank(14))"),
    crear("noche_estrellada", "Noche Estrellada", 2, 6,
          ["Crea una carta de {C:planet}Planeta{}", "al final de la ronda",
           "{C:inactive}(Debe haber espacio)"], "Planet", "KAS.T.round_end"),
    J("bufon_confuso", "Bufón Confuso", 1, 4,
      [PROB % (1, 2), "de dar " + MULT % 3], {"odds": 2, "mult": 20}, ["prob", "odds", "mult"],
      'KAS.chance("kas_bufon_confuso")'),
    crear("caja_sorpresa", "Caja Sorpresa", 2, 6,
          ["Crea una carta de {C:tarot}Tarot{}", "al seleccionar la {C:attention}ciega{}",
           "{C:inactive}(Debe haber espacio)"], "Tarot", "KAS.T.blind"),
    J("arlequin", "Arlequín", 1, 5,
      [MULT % 1 + " por cada", "{C:attention}comodín{} que tengas"], {"mult": 3}, ["mult"],
      "KAS.dyn(function(card, context, e) return { mult = e.mult * #G.jokers.cards } end)"),

    # ---- Fila 3: animales ----
    J("gato_negro", "Gato Negro", 2, 6,
      ["Cada {C:attention}7{} puntuado tiene", PROB % (1, 2), "de dar " + XMULT % 3],
      {"odds": 2, "xmult": 1.5}, ["prob", "odds", "xmult"],
      'KAS.per_card(KAS.rank(7), "kas_gato_negro")'),
    J("zorro_astuto", "Zorro Astuto", 2, 6,
      ["Ganas {C:money}$#1#{} por cada carta", "de {C:attention}figura{} descartada"],
      {"dollars": 1}, ["dollars"],
      "function(self, card, context) if context.discard and context.other_card:is_face() "
      "then KAS.dinero(card, card.ability.extra.dollars) end end", bp=False),
    J("conejo_suerte", "Conejo de la Suerte", 3, 8,
      ["{C:attention}Duplica{} todas las", "{C:green}probabilidades{} del juego"],
      {}, [], pasivo={"prob_mult": 2}, bp=False),
    J("rey_rana", "Rey Rana", 1, 4,
      [MULT % 1 + " si juegas", "{C:attention}#2#{} cartas o menos"], {"mult": 16, "cards": 3}, ["mult", "cards"],
      "KAS.cond(function(card, context, e) return #context.full_hand <= e.cards end)"),
    palo("pinguino", "Pingüino", 1, 4, "Clubs", "chips", 30),
    J("cuervo", "Cuervo", 1, 4,
      ["Gana {C:money}$#1#{} de {C:attention}valor de venta{}", "al final de la ronda"],
      {"gain": 2}, ["gain"],
      "function(self, card, context) if KAS.T.round_end(context) and not context.blueprint then "
      "card.ability.extra_value = (card.ability.extra_value or 0) + card.ability.extra.gain "
      "card:set_cost() return { message = localize('k_val_up'), colour = G.C.MONEY } end end", bp=False),
    mano("tigre", "Tigre", 3, 8, "Straight", "Escalera", "xmult", 2),
    J("lobo_solitario", "Lobo Solitario", 3, 8,
      [XMULT % 1 + " si tienes", "{C:attention}#2#{} comodines o menos"], {"xmult": 2.5, "max": 2}, ["xmult", "max"],
      "KAS.cond(function(card, context, e) return #G.jokers.cards <= e.max end)"),
    J("dragon", "Dragón", 3, 8,
      ["Gana " + XMULT % 1 + " por cada mano", "jugada; se reinicia al {C:attention}descartar{}", ACTUAL_X % 2],
      {"gain": 0.15, "xmult": 1}, ["gain", "xmult"],
      "KAS.scale{ field = 'xmult', on = KAS.T.hand_played, reset = KAS.T.pre_discard }"),
    J("serpiente", "Serpiente", 1, 5, ["{C:attention}+#1#{} tamaño de mano"], {"n": 1}, ["n"],
      pasivo={"hand_size": 1}, bp=False),

    # ---- Fila 4: cosmos ----
    J("reloj_arena", "Reloj de Arena", 2, 7, ["{C:blue}+#1#{} mano por ronda"], {"n": 1}, ["n"],
      pasivo={"hands": 1}, bp=False),
    crear("saturno", "Saturno", 2, 6,
          ["Si la mano contiene una {C:attention}Escalera{},", "crea una carta de {C:planet}Planeta{}",
           "{C:inactive}(Debe haber espacio)"], "Planet", 'KAS.T.hand_type("Straight")'),
    J("galaxia", "Galaxia", 2, 7,
      ["{X:mult,C:white} +X#1# {} multi por cada carta", "de {C:planet}Planeta{} que tengas"],
      {"step": 0.5}, ["step"],
      "KAS.dyn(function(card, context, e) local n = 0 for _, c in ipairs(G.consumeables.cards) do "
      "if c.ability.set == 'Planet' then n = n + 1 end end "
      "if n > 0 then return { xmult = 1 + e.step * n } end end)"),
    palo("estrella_polar", "Estrella Polar", 1, 5, "Diamonds", "mult", 3),
    J("sol_radiante", "Sol Radiante", 3, 8,
      [XMULT % 1 + " en la", "{C:attention}primera mano{} de la ronda"],
      {"xmult": 2}, ["xmult"], "KAS.cond(KAS.first_hand)"),
    crear("luna_menguante", "Luna Menguante", 2, 6,
          ["Crea una carta de {C:tarot}Tarot{}", "al final de la ronda",
           "{C:inactive}(Debe haber espacio)"], "Tarot", "KAS.T.round_end"),
    J("bufon_cosmico", "Bufón Cósmico", 4, 20,
      ["Gana " + XMULT % 1 + " cada vez", "que usas una carta de {C:planet}Planeta{}", ACTUAL_X % 2],
      {"gain": 0.25, "xmult": 1}, ["gain", "xmult"],
      "KAS.scale{ field = 'xmult', on = KAS.T.consumable('Planet') }"),
    J("bola_cristal", "Bola de Cristal", 2, 6, ["{C:attention}+#1#{} espacio de consumible"], {"n": 1}, ["n"],
      pasivo={"consumable_slots": 1}, bp=False),
    J("sombrero_mago", "Sombrero de Mago", 1, 5,
      ["Gana " + MULT % 1 + " cada vez", "que usas una carta de {C:tarot}Tarot{}", ACTUAL_M % 2],
      {"gain": 2, "mult": 0}, ["gain", "mult"],
      "KAS.scale{ field = 'mult', on = KAS.T.consumable('Tarot') }"),
    J("demonio_fuego", "Demonio de Fuego", 3, 9,
      [XMULT % 1 + ",", "{C:red}-#2#{} descarte por ronda"], {"xmult": 3, "n": 1}, ["xmult", "n"],
      "KAS.flat()", pasivo={"discards": -1}),

    # ---- Fila 5: elementales ----
    J("bufon_hielo", "Bufón de Hielo", 1, 4,
      [CHIPS % 1 + " si no has usado", "{C:attention}descartes{} esta ronda"], {"chips": 100}, ["chips"],
      "KAS.cond(KAS.no_discards)"),
    palo("bufon_venenoso", "Bufón Venenoso", 1, 5, "Clubs", "mult", 3),
    J("bufon_piedra", "Bufón de Piedra", 1, 5,
      [CHIPS % 1 + " por cada carta", "que quede en tu {C:attention}baraja{}"], {"chips": 2}, ["chips"],
      "KAS.dyn(function(card, context, e) return { chips = e.chips * #G.deck.cards } end)"),
    J("bufon_fuego", "Bufón de Fuego", 1, 5,
      ["Gana " + MULT % 1 + " por cada mano", "jugada; se reinicia al final de la ronda", ACTUAL_M % 2],
      {"gain": 3, "mult": 0}, ["gain", "mult"],
      "KAS.scale{ field = 'mult', on = KAS.T.hand_played, reset = KAS.T.round_end }"),
    J("bufon_agua", "Bufón de Agua", 1, 4,
      [CHIPS % 1 + " por cada carta", "que tengas en la {C:attention}mano{}"], {"chips": 10}, ["chips"],
      "KAS.dyn(function(card, context, e) if #G.hand.cards > 0 then "
      "return { chips = e.chips * #G.hand.cards } end end)"),
    J("bufon_arcano", "Bufón Arcano", 2, 6,
      ["{X:mult,C:white} +X#1# {} multi por cada", "{C:attention}consumible{} que tengas"],
      {"step": 0.25}, ["step"],
      "KAS.dyn(function(card, context, e) local n = #G.consumeables.cards "
      "if n > 0 then return { xmult = 1 + e.step * n } end end)"),
    J("bufon_rubi", "Bufón Rubí", 2, 6,
      ["Cada carta de " + PALO["Hearts"] + " puntuada", "tiene " + PROB % (1, 2), "de dar " + XMULT % 3],
      {"odds": 2, "xmult": 1.5}, ["prob", "odds", "xmult"],
      'KAS.per_card(KAS.suit("Hearts"), "kas_bufon_rubi")'),
    J("bufon_diamante", "Bufón Diamante", 2, 7,
      ["Cada carta de " + PALO["Diamonds"] + " puntuada", "da {C:money}$#1#{}"],
      {"dollars": 1}, ["dollars"], 'KAS.per_card(KAS.suit("Diamonds"))'),
    J("diablillo", "Diablillo", 2, 6,
      ["Cada {C:attention}6{} puntuado", "da " + XMULT % 1], {"xmult": 1.5}, ["xmult"],
      "KAS.per_card(KAS.rank(6))"),
    J("bufon_calavera", "Bufón Calavera", 2, 6,
      ["Gana " + MULT % 1 + " por cada", "carta {C:attention}descartada{}", ACTUAL_M % 2],
      {"gain": 1, "mult": 0}, ["gain", "mult"],
      "KAS.scale{ field = 'mult', on = KAS.T.discard }"),

    # ---- Fila 6: personajes ----
    J("el_caballero", "El Caballero", 2, 6,
      ["Al final de la ronda ganas {C:money}$1{}", "por cada {C:money}$#1#{} que tengas",
       "{C:inactive}(Máximo {C:money}$#2#{C:inactive})"], {"per": 10, "max": 5}, ["per", "max"],
      extra="calc_dollar_bonus = function(self, card) local e = card.ability.extra "
            "local n = math.min(e.max, math.floor(G.GAME.dollars / e.per)) if n > 0 then return n end end",
      bp=False),
    J("medico_peste", "Médico de la Peste", 2, 5,
      [XMULT % 1 + " si la mano", "jugada es {C:attention}Carta alta{}"], {"xmult": 2.5}, ["xmult"],
      "KAS.cond(function(card, context) return context.scoring_name == 'High Card' end)"),
    J("tahur", "Tahúr", 2, 7,
      ["Reactiva la {C:attention}primera{} carta", "puntuada {C:attention}#1#{} veces más"], {"reps": 2}, ["reps"],
      "KAS.retrigger(KAS.first)"),
    J("enterrador", "Enterrador", 3, 8,
      ["Gana " + XMULT % 1 + " cada vez que", "vendes otro {C:attention}comodín{}", ACTUAL_X % 2],
      {"gain": 0.25, "xmult": 1}, ["gain", "xmult"],
      "KAS.scale{ field = 'xmult', on = KAS.T.sell_other_joker }"),
    J("bufon_tesoro", "Bufón del Tesoro", 1, 5,
      ["Ganas {C:money}$#1#{} al seleccionar", "la {C:attention}ciega{}"], {"dollars": 4}, ["dollars"],
      "function(self, card, context) if context.setting_blind then "
      "KAS.dinero(card, card.ability.extra.dollars) end end"),
    J("bardo", "Bardo", 1, 4,
      ["Cada {C:attention}Rey{} o {C:attention}Reina{}", "puntuado da " + MULT % 1], {"mult": 4}, ["mult"],
      "KAS.per_card(KAS.rank(12, 13))"),
    palo("bufon_enamorado", "Bufón Enamorado", 1, 5, "Hearts", "mult", 3),
    mano("bufon_duelista", "Bufón Duelista", 1, 3, "Pair", "Pareja", "mult", 8),
    J("malabarista", "Malabarista", 1, 5, ["{C:red}+#1#{} descarte por ronda"], {"n": 1}, ["n"],
      pasivo={"discards": 1}, bp=False),
    J("ladron", "Ladrón", 2, 6,
      ["Cada carta de {C:attention}figura{}", "puntuada da {C:money}$#1#{}"], {"dollars": 1}, ["dollars"],
      "KAS.per_card(KAS.face)"),

    # ---- Fila 7: el circo ----
    J("maestro_pista", "Maestro de Pista", 3, 10, ["{C:dark_edition}+#1#{} espacio de comodín"], {"n": 1}, ["n"],
      pasivo={"joker_slots": 1}, bp=False),
    J("bufon_rosa", "Bufón de la Rosa", 2, 6,
      ["Reactiva cada {C:attention}Reina{}", "puntuada {C:attention}#1#{} vez más"], {"reps": 1}, ["reps"],
      "KAS.retrigger(KAS.rank(12))"),
    J("piruleta", "Piruleta", 1, 5,
      [MULT % 1 + ",", "pierde {C:mult}#2#{} multi al final de la ronda"], {"mult": 20, "loss": 4, "gain": -4},
      ["mult", "loss"],
      "KAS.scale{ field = 'mult', on = KAS.T.round_end, destroy_at = 0 }"),
    mano("bufon_feliz", "Bufón Feliz", 1, 4, "Three of a Kind", "Trío", "chips", 100),
    J("mago_moneda", "Mago de la Moneda", 2, 7,
      [MULT % 1 + " por cada", "{C:money}$#2#{} que tengas"], {"mult": 2, "per": 5}, ["mult", "per"],
      "KAS.dyn(function(card, context, e) local n = math.floor(G.GAME.dollars / e.per) "
      "if n > 0 then return { mult = e.mult * n } end end)"),
    J("guitarrista", "Guitarrista", 2, 6,
      ["Reactiva cada {C:attention}2{}, {C:attention}3{},", "{C:attention}4{} o {C:attention}5{} puntuado"],
      {"reps": 1}, [], "KAS.retrigger(KAS.rank(2, 3, 4, 5))"),
    J("bufon_globos", "Bufón de los Globos", 1, 5,
      [MULT % 1 + ";", PROB % (2, 3) + " de", "explotar al final de la ronda"],
      {"mult": 15, "break_odds": 6}, ["mult", "prob", "break_odds"],
      'KAS.combine(KAS.flat(), KAS.fragile("kas_bufon_globos"))', extra="eternal_compat = false"),
    J("bufon_sonriente", "Bufón Sonriente", 1, 4,
      ["Cada carta de {C:attention}figura{}", "puntuada da " + MULT % 1], {"mult": 5}, ["mult"],
      "KAS.per_card(KAS.face)"),
    J("bola_ocho", "Bola 8", 1, 5,
      ["Cada {C:attention}8{} puntuado tiene", PROB % (1, 2), "de crear una carta de {C:tarot}Tarot{}"],
      {"odds": 4}, ["prob", "odds"],
      "function(self, card, context) if context.individual and context.cardarea == G.play "
      "and context.other_card:get_id() == 8 "
      "and pseudorandom('kas_bola_ocho') < KAS.prob() / card.ability.extra.odds then "
      "return KAS.crear('Tarot') end end"),
    mano("bufon_molon", "Bufón Molón", 1, 4, "Straight", "Escalera", "mult", 12),

    # ---- Fila 8 ----
    J("principe_bufon", "Príncipe Bufón", 1, 4,
      ["Cada {C:attention}J{} puntuada", "da " + MULT % 1], {"mult": 8}, ["mult"], "KAS.per_card(KAS.rank(11))"),
    J("bufon_guinador", "Bufón Guiñador", 1, 5,
      [PROB % (1, 2) + " de", "ganar {C:money}$#3#{} al jugar una mano"],
      {"odds": 3, "dollars": 3}, ["prob", "odds", "dollars"], 'KAS.chance("kas_bufon_guinador")'),
    J("bufon_punal", "Bufón del Puñal", 2, 6,
      [XMULT % 1 + " si juegas", "exactamente {C:attention}#2#{} cartas"], {"xmult": 1.5, "cards": 5}, ["xmult", "cards"],
      "KAS.cond(function(card, context, e) return #context.full_hand == e.cards end)"),
    J("bufon_azul", "Bufón Azul", 1, 4,
      [CHIPS % 1 + " por cada", "{C:attention}mano{} restante"], {"chips": 25}, ["chips"],
      "KAS.dyn(function(card, context, e) local n = G.GAME.current_round.hands_left "
      "if n > 0 then return { chips = e.chips * n } end end)"),
    J("cofre_tesoro", "Cofre del Tesoro", 1, 5,
      ["Al final de la ronda ganas {C:money}$#1#{}", "por cada {C:attention}descarte{} restante"],
      {"dollars": 1}, ["dollars"],
      extra="calc_dollar_bonus = function(self, card) local n = G.GAME.current_round.discards_left "
            "if n > 0 then return n * card.ability.extra.dollars end end", bp=False),
    J("calaverita", "Calaverita", 1, 4,
      ["Cada carta {C:attention}impar{} puntuada", "{C:inactive}(A, 9, 7, 5, 3){} da " + CHIPS % 1],
      {"chips": 31}, ["chips"], "KAS.per_card(KAS.odd)"),
    J("bufon_relajado", "Bufón Relajado", 1, 4,
      [MULT % 1 + " por cada", "{C:attention}descarte{} restante"], {"mult": 4}, ["mult"],
      "KAS.dyn(function(card, context, e) local n = G.GAME.current_round.discards_left "
      "if n > 0 then return { mult = e.mult * n } end end)"),
    J("bufon_hippie", "Bufón Hippie", 2, 6,
      [XMULT % 1 + " si la mano puntuada", "no tiene cartas de {C:attention}figura{}"], {"xmult": 1.5}, ["xmult"],
      "KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.face) == 0 end)"),
    J("bola_magica", "Bola Mágica", 2, 6,
      ["Cada {C:attention}8{} puntuado", "da " + XMULT % 1], {"xmult": 1.5}, ["xmult"],
      "KAS.per_card(KAS.rank(8))"),
    mano("bufon_mlg", "Bufón MLG", 3, 8, "Straight Flush", "Escalera de color", "xmult", 4),

    # ---- Fila 9 ----
    J("bufon_barril", "Bufón del Barril", 1, 5,
      ["Gana " + CHIPS % 1 + " al final", "de cada ronda", ACTUAL_C % 2],
      {"gain": 10, "chips": 0}, ["gain", "chips"],
      "KAS.scale{ field = 'chips', on = KAS.T.round_end }"),
    J("bufon_dados", "Bufón de los Dados", 1, 4,
      ["Da entre {C:mult}+#1#{} y {C:mult}+#2#{}", "multi al azar"], {"min": 1, "max": 20}, ["min", "max"],
      "KAS.dyn(function(card, context, e) return { mult = pseudorandom('kas_bufon_dados', e.min, e.max) } end)"),
    J("espadachin", "Espadachín", 1, 4,
      ["Cada {C:attention}10{} puntuado", "da " + MULT % 1], {"mult": 10}, ["mult"], "KAS.per_card(KAS.rank(10))"),
    J("corazon_oscuro", "Corazón Oscuro", 2, 6,
      [XMULT % 1 + " si todas las cartas", "puntuadas son de " + PALO["Hearts"]], {"xmult": 2}, ["xmult"],
      "KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.suit('Hearts')) "
      "== #context.scoring_hand end)"),
    J("farolero", "Farolero", 1, 5,
      ["Gana " + CHIPS % 1 + " por cada", "carta puntuada", ACTUAL_C % 2],
      {"gain": 2, "chips": 0}, ["gain", "chips"],
      "KAS.scale{ field = 'chips', on = function(context) return context.before and #context.scoring_hand end }"),
    J("mimo", "Mimo", 2, 6,
      ["Si juegas {C:attention}una sola{} carta,", "se reactiva {C:attention}#1#{} veces más"], {"reps": 2}, ["reps"],
      "KAS.retrigger(function(c, context) return #context.full_hand == 1 end)"),
    J("pulpo", "Pulpo", 1, 4,
      ["Cada {C:attention}8{} puntuado", "da " + MULT % 1], {"mult": 8}, ["mult"], "KAS.per_card(KAS.rank(8))"),
    crear("linterna_espectral", "Linterna Espectral", 2, 7,
          [PROB % (1, 2) + " de crear", "una carta {C:spectral}Espectral{}", "al final de la ronda"],
          "Spectral", "KAS.T.round_end", odds=4),
    J("alma_en_pena", "Alma en Pena", 3, 9,
      ["Gana " + XMULT % 1 + " al derrotar", "una {C:attention}ciega jefe{}", ACTUAL_X % 2],
      {"gain": 0.5, "xmult": 1}, ["gain", "xmult"],
      "KAS.scale{ field = 'xmult', on = KAS.T.boss }"),
    J("pocion", "Poción", 1, 3,
      ["Al {C:attention}venderla{}, crea una", "carta de {C:tarot}Tarot{}"], {}, [],
      'KAS.sell_create("Tarot")', bp=False),

    # ---- Fila 10: misticos ----
    J("ojo_omnisciente", "Ojo Omnisciente", 4, 20,
      ["Gana " + XMULT % 1 + " si juegas una mano", "{C:attention}distinta{} a la anterior;",
       "se reinicia si la repites", ACTUAL_X % 2],
      {"gain": 0.5, "xmult": 1, "last": ""}, ["gain", "xmult"],
      "function(self, card, context) local e = card.ability.extra "
      "if context.before and not context.blueprint then local distinta = context.scoring_name ~= e.last "
      "e.last = context.scoring_name if distinta then e.xmult = e.xmult + e.gain "
      "return { message = localize('k_upgrade_ex'), colour = G.C.FILTER } elseif e.xmult > 1 then e.xmult = 1 "
      "return { message = localize('k_reset'), colour = G.C.RED } end end "
      "if context.joker_main and e.xmult > 1 then return { xmult = e.xmult } end end"),
    J("dos_caras", "Dos Caras", 2, 6,
      [PROB % (1, 2), "de dar " + XMULT % 3], {"odds": 2, "xmult": 2}, ["prob", "odds", "xmult"],
      'KAS.chance("kas_dos_caras")'),
    J("hipnosis", "Hipnosis", 3, 8,
      ["Reactiva todas las cartas puntuadas", "en la {C:attention}última mano{} de la ronda"],
      {"reps": 1}, [], "KAS.retrigger(KAS.last_hand)"),
    J("corazon_diabolico", "Corazón Diabólico", 3, 9,
      [XMULT % 1 + ",", "{C:blue}-#2#{} mano por ronda"], {"xmult": 3, "n": 1}, ["xmult", "n"],
      "KAS.flat()", pasivo={"hands": -1}),
    crear("estrella_fugaz", "Estrella Fugaz", 2, 6,
          ["Si la mano contiene un {C:attention}Color{},", "crea una carta de {C:planet}Planeta{}",
           "{C:inactive}(Debe haber espacio)"], "Planet", 'KAS.T.hand_type("Flush")'),
    J("bufon_ajedrecista", "Bufón Ajedrecista", 2, 7,
      [XMULT % 1 + " cada {C:attention}#2#{} manos", "jugadas"], {"xmult": 3, "every": 3, "count": 0},
      ["xmult", "every"],
      "function(self, card, context) local e = card.ability.extra "
      "if context.before and not context.blueprint then e.count = e.count + 1 end "
      "if context.joker_main and e.count % e.every == 0 then return { xmult = e.xmult } end end"),
    J("mascara_solar", "Máscara Solar", 3, 8,
      ["Cada carta de {C:attention}figura{}", "puntuada da " + XMULT % 1], {"xmult": 1.25}, ["xmult"],
      "KAS.per_card(KAS.face)"),
    J("bufon_mundo", "Bufón del Mundo", 4, 20,
      ["Reactiva {C:attention}todas{} las", "cartas puntuadas"], {"reps": 1}, [],
      "KAS.retrigger(KAS.any)"),
    J("corona_cosmica", "Corona Cósmica", 4, 20,
      ["Gana " + XMULT % 1 + " al derrotar", "una {C:attention}ciega jefe{}", ACTUAL_X % 2],
      {"gain": 1, "xmult": 1}, ["gain", "xmult"],
      "KAS.scale{ field = 'xmult', on = KAS.T.boss }"),
    J("bufon_arcoiris", "Bufón Arcoíris", 4, 20,
      [XMULT % 1 + " por cada {C:attention}palo{}", "distinto en la mano puntuada"], {"xmult": 1.5}, ["xmult"],
      "KAS.dyn(function(card, context, e) local n = KAS.palos_distintos(context) "
      "if n > 0 then return { xmult = e.xmult ^ n } end end)"),
]

assert len(COMODINES) == 100, len(COMODINES)
assert len({c["key"] for c in COMODINES}) == 100
