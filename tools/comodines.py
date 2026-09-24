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


FMT = {"mult": MULT, "chips": CHIPS, "xmult": XMULT, "dollars": "{C:money}$#%d#{}"}


def rango(key, nombre, rareza, coste, ranks, etiqueta, efectos):
    """Cada carta puntuada de esos valores da los efectos (dict campo -> valor)."""
    partes = [FMT[k] % (i + 1) for i, k in enumerate(efectos)]
    return J(key, nombre, rareza, coste,
             ["Cada %s puntuado" % etiqueta, "da " + " y ".join(partes)],
             dict(efectos), list(efectos), "KAS.per_card(KAS.rank(%s))" % ", ".join(map(str, ranks)))


def retenida(key, nombre, rareza, coste, pred, etiqueta, campo, valor):
    """Cada carta que tengas en la mano (sin jugar) que cumpla pred da el efecto."""
    return J(key, nombre, rareza, coste,
             ["Cada %s que tengas" % etiqueta, "en la mano da " + FMT[campo] % 1],
             {campo: valor}, [campo], "KAS.held(%s)" % pred)


ACTUAL_X = "{C:inactive}(Actual: {X:mult,C:white} X#%d# {C:inactive} multi)"
ACTUAL_M = "{C:inactive}(Actual: {C:mult}+#%d#{C:inactive} multi)"
ACTUAL_C = "{C:inactive}(Actual: {C:chips}+#%d#{C:inactive} fichas)"

COMODINES = [
    # ---- Fila 1: bufones clasicos ----
    J("bufon_clasico", "Bufón Clásico", 1, 4,
      [MULT % 1 + " por cada comodín", "{C:blue}Común{} que tengas"], {"mult": 4}, ["mult"],
      "KAS.dyn(function(card, context, e) local n = 0 for _, j in ipairs(G.jokers.cards) do "
      "if j.config.center.rarity == 1 then n = n + 1 end end if n > 0 then return { mult = e.mult * n } end end)"),
    J("bufon_sombrio", "Bufón Sombrío", 1, 5,
      [MULT % 1 + " si todas las cartas", "puntuadas son de " + PALO["Spades"]], {"mult": 25}, ["mult"],
      "KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.suit('Spades')) "
      "== #context.scoring_hand end)"),
    J("rey_bufon", "Rey Bufón", 2, 7,
      ["Cada {C:attention}Rey{} puntuado", "da " + XMULT % 1],
      {"xmult": 1.15}, ["xmult"], "KAS.per_card(KAS.rank(13))"),
    J("bufon_violeta", "Bufón Violeta", 1, 5,
      ["Gana " + MULT % 1 + " cada vez que", "juegas una {C:attention}Doble pareja{}", ACTUAL_M % 2],
      {"gain": 2, "mult": 0}, ["gain", "mult"], "KAS.scale{ field = 'mult', on = KAS.T.hand_type('Two Pair') }"),
    J("bufon_alegre", "Bufón Alegre", 1, 4,
      ["Si la mano jugada es {C:attention}Pareja{},", "cada carta puntuada da " + CHIPS % 1],
      {"chips": 25}, ["chips"], "KAS.per_card(KAS.jugada('Pair'))"),
    J("bufon_cascabeles", "Bufón de Cascabeles", 1, 5,
      ["Al final de la ronda ganas {C:money}$#1#{}", "por cada {C:attention}mano{} jugada"], {"dollars": 1}, ["dollars"],
      extra="calc_dollar_bonus = function(self, card) local n = G.GAME.current_round.hands_played "
            "if n > 0 then return n * card.ability.extra.dollars end end", bp=False),
    J("bufon_puntiagudo", "Bufón Puntiagudo", 1, 4,
      [MULT % 1 + " por cada", "{C:attention}mano{} restante"], {"mult": 3}, ["mult"],
      "KAS.dyn(function(card, context, e) local n = G.GAME.current_round.hands_left "
      "if n > 0 then return { mult = e.mult * n } end end)"),
    J("reina_bufona", "Reina Bufona", 1, 5,
      ["Cada {C:attention}Reina{} puntuada da", MULT % 1 + " y " + CHIPS % 2],
      {"mult": 8, "chips": 20}, ["mult", "chips"], "KAS.per_card(KAS.rank(12))"),
    J("bufon_siniestro", "Bufón Siniestro", 2, 6,
      [XMULT % 1 + " si aún no has", "conseguido la {C:attention}mitad{} de la ciega"], {"xmult": 1.5}, ["xmult"],
      "KAS.cond(function() return G.GAME.chips < G.GAME.blind.chips / 2 end)"),
    J("bufon_fantasma", "Bufón Fantasma", 2, 6,
      ["Al {C:attention}venderlo{}, crea una", "carta {C:spectral}Espectral{}"],
      {}, [], 'KAS.sell_create("Spectral")', bp=False),

    # ---- Fila 2 ----
    J("arlequin_retales", "Arlequín de Retales", 2, 6,
      [MULT % 1 + " por cada {C:attention}palo{}", "distinto en la mano puntuada"], {"mult": 10}, ["mult"],
      "KAS.dyn(function(card, context, e) local n = KAS.palos_distintos(context) "
      "if n > 0 then return { mult = e.mult * n } end end)"),
    J("bufon_danzarin", "Bufón Danzarín", 1, 4,
      ["Gana " + CHIPS % 1 + " por cada carta descartada;", "se reinicia al final de la ronda", ACTUAL_C % 2],
      {"gain": 6, "chips": 0}, ["gain", "chips"],
      "KAS.scale{ field = 'chips', on = KAS.T.discard, reset = KAS.T.round_end }"),
    J("mascara_vampira", "Máscara Vampira", 2, 7,
      ["Gana " + XMULT % 1 + " por cada", "carta de {C:attention}figura{} puntuada", ACTUAL_X % 2],
      {"gain": 0.05, "xmult": 1}, ["gain", "xmult"],
      "KAS.scale{ field = 'xmult', on = function(context) return context.before "
      "and KAS.contar(context.scoring_hand, KAS.face) end }"),
    J("bufon_bicolor", "Bufón Bicolor", 2, 6,
      [XMULT % 1 + " si todas las cartas", "puntuadas son {C:attention}pares{}"], {"xmult": 1.3}, ["xmult"],
      "KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.even) == #context.scoring_hand end)"),
    J("bufon_verde", "Bufón Verde", 1, 4,
      ["Gana " + MULT % 1 + " por cada mano jugada;", "pierde la {C:attention}mitad{} al final de la ronda", ACTUAL_M % 2],
      {"gain": 2, "mult": 0}, ["gain", "mult"],
      "function(self, card, context) local e = card.ability.extra "
      "if context.before and not context.blueprint then e.mult = e.mult + e.gain "
      "return { message = localize('k_upgrade_ex'), colour = G.C.MULT } end "
      "if KAS.T.round_end(context) and not context.blueprint and e.mult > 0 then e.mult = math.floor(e.mult / 2) "
      "return { message = '-50%', colour = G.C.RED } end "
      "if context.joker_main and e.mult > 0 then return { mult = e.mult } end end"),
    J("bufon_estrella", "Bufón Estrella", 2, 6,
      [XMULT % 1 + " si la mano puntuada", "tiene {C:attention}#2#{} Ases o más"], {"xmult": 1.5, "min": 2}, ["xmult", "min"],
      "KAS.cond(function(card, context, e) return KAS.contar(context.scoring_hand, KAS.rank(14)) >= e.min end)"),
    crear("noche_estrellada", "Noche Estrellada", 2, 6,
          ["Crea una carta de {C:planet}Planeta{}", "al final de la ronda",
           "{C:inactive}(Debe haber espacio)"], "Planet", "KAS.T.round_end"),
    J("bufon_confuso", "Bufón Confuso", 1, 4,
      [PROB % (1, 2), "de dar " + MULT % 3], {"odds": 2, "mult": 20}, ["prob", "odds", "mult"],
      'KAS.chance("kas_bufon_confuso")'),
    J("caja_sorpresa", "Caja Sorpresa", 2, 6,
      ["Al seleccionar la {C:attention}ciega{}, crea una", "carta de {C:tarot}Tarot{}, {C:planet}Planeta{} o",
       "{C:spectral}Espectral{} al azar", "{C:inactive}(Debe haber espacio)"], {}, [],
      "function(self, card, context) if context.setting_blind then local r = pseudorandom('kas_caja_sorpresa') "
      "return KAS.crear(r < 0.45 and 'Tarot' or r < 0.9 and 'Planet' or 'Spectral') end end"),
    J("arlequin", "Arlequín", 2, 6,
      ["{X:mult,C:white} +X#1# {} multi por cada", "comodín a su {C:attention}izquierda{}"], {"step": 0.1}, ["step"],
      "KAS.dyn(function(card, context, e) for i, j in ipairs(G.jokers.cards) do if j == card then "
      "if i > 1 then return { xmult = 1 + e.step * (i - 1) } end return end end end)"),

    # ---- Fila 3: animales ----
    J("gato_negro", "Gato Negro", 2, 6,
      ["Cada {C:attention}7{} puntuado tiene", PROB % (1, 2), "de dar " + XMULT % 3],
      {"odds": 2, "xmult": 1.25}, ["prob", "odds", "xmult"],
      'KAS.per_card(KAS.rank(7), "kas_gato_negro")'),
    J("zorro_astuto", "Zorro Astuto", 2, 6,
      ["Ganas {C:money}$#1#{} por cada carta", "de {C:attention}figura{} descartada"],
      {"dollars": 1}, ["dollars"],
      "function(self, card, context) if context.discard and context.other_card:is_face() "
      "then KAS.dinero(card, card.ability.extra.dollars) end end", bp=False),
    J("conejo_suerte", "Conejo de la Suerte", 3, 8,
      ["Cada carta puntuada tiene", PROB % (1, 2) + " de", "{C:attention}reactivarse{}"],
      {"odds": 4, "reps": 1}, ["prob", "odds"],
      "KAS.retrigger(function(c, context, e) return pseudorandom('kas_conejo_suerte') < KAS.prob() / e.odds end)"),
    J("rey_rana", "Rey Rana", 2, 6,
      ["{X:mult,C:white} +X#1# {} multi por cada carta", "que juegues por debajo de {C:attention}5{}"],
      {"step": 0.25}, ["step"],
      "KAS.dyn(function(card, context, e) local n = 5 - #context.full_hand "
      "if n > 0 then return { xmult = 1 + e.step * n } end end)"),
    palo("pinguino", "Pingüino", 1, 4, "Clubs", "chips", 30),
    J("cuervo", "Cuervo", 1, 4,
      ["Gana {C:money}$#1#{} de {C:attention}valor de venta{} cada", "vez que juegas una {C:attention}Carta alta{}"],
      {"gain": 1}, ["gain"],
      "function(self, card, context) if context.before and not context.blueprint "
      "and context.scoring_name == 'High Card' then "
      "card.ability.extra_value = (card.ability.extra_value or 0) + card.ability.extra.gain "
      "card:set_cost() return { message = localize('k_val_up'), colour = G.C.MONEY } end end", bp=False),
    J("tigre", "Tigre", 3, 8,
      [XMULT % 1 + " si la mano contiene", "una {C:attention}Escalera{} con un {C:attention}As{}"], {"xmult": 2}, ["xmult"],
      "KAS.cond(function(card, context) return next(context.poker_hands['Straight']) ~= nil "
      "and KAS.contar(context.scoring_hand, KAS.rank(14)) > 0 end)"),
    J("lobo_solitario", "Lobo Solitario", 3, 8,
      [XMULT % 1 + " si tienes", "{C:attention}#2#{} comodines o menos"], {"xmult": 2, "max": 2}, ["xmult", "max"],
      "KAS.cond(function(card, context, e) return #G.jokers.cards <= e.max end)"),
    J("dragon", "Dragón", 3, 8,
      ["Gana " + XMULT % 1 + " por cada mano", "jugada; se reinicia al {C:attention}descartar{}", ACTUAL_X % 2],
      {"gain": 0.1, "xmult": 1}, ["gain", "xmult"],
      "KAS.scale{ field = 'xmult', on = KAS.T.hand_played, reset = KAS.T.pre_discard }"),
    J("serpiente", "Serpiente", 1, 5,
      ["{C:attention}+#1#{} tamaño de mano,", "{C:red}-#2#{} descarte por ronda"], {"n": 2, "m": 1}, ["n", "m"],
      pasivo={"hand_size": 2, "discards": -1}, bp=False),

    # ---- Fila 4: cosmos ----
    J("reloj_arena", "Reloj de Arena", 2, 7, ["{C:blue}+#1#{} mano por ronda"], {"n": 1}, ["n"],
      pasivo={"hands": 1}, bp=False),
    crear("saturno", "Saturno", 2, 6,
          ["Si la mano contiene una {C:attention}Escalera{},", "crea una carta de {C:planet}Planeta{}",
           "{C:inactive}(Debe haber espacio)"], "Planet", 'KAS.T.hand_type("Straight")'),
    J("galaxia", "Galaxia", 2, 7,
      ["{X:mult,C:white} +X#1# {} multi por cada carta", "de {C:planet}Planeta{} que tengas"],
      {"step": 0.25}, ["step"],
      "KAS.dyn(function(card, context, e) local n = 0 for _, c in ipairs(G.consumeables.cards) do "
      "if c.ability.set == 'Planet' then n = n + 1 end end "
      "if n > 0 then return { xmult = 1 + e.step * n } end end)"),
    J("estrella_polar", "Estrella Polar", 1, 5,
      ["Cada carta de " + PALO["Diamonds"] + " puntuada da", MULT % 1 + " por cada {C:money}$#2#{} que tengas"],
      {"mult": 1, "per": 10}, ["mult", "per"],
      "KAS.per_card_fn(KAS.suit('Diamonds'), function(c, context, e) local n = math.floor(G.GAME.dollars / e.per) "
      "if n > 0 then return { mult = e.mult * n } end end)"),
    J("sol_radiante", "Sol Radiante", 3, 8,
      [XMULT % 1 + " en la", "{C:attention}primera mano{} de la ronda"],
      {"xmult": 1.5}, ["xmult"], "KAS.cond(KAS.first_hand)"),
    crear("luna_menguante", "Luna Menguante", 2, 6,
          ["Crea una carta de {C:tarot}Tarot{}", "al final de la ronda",
           "{C:inactive}(Debe haber espacio)"], "Tarot", "KAS.T.round_end"),
    J("bufon_cosmico", "Bufón Cósmico", 4, 20,
      ["Crea una carta de {C:planet}Planeta{}", "cada vez que juegas una mano", "{C:inactive}(Debe haber espacio)"],
      {}, [], 'KAS.create(KAS.T.hand_played, "Planet")'),
    J("bola_cristal", "Bola de Cristal", 2, 6, ["{C:attention}+#1#{} espacio de consumible"], {"n": 1}, ["n"],
      pasivo={"consumable_slots": 1}, bp=False),
    J("sombrero_mago", "Sombrero de Mago", 1, 5,
      ["Gana " + CHIPS % 1 + " por cada consumible usado;", "se reinicia al final de la ronda", ACTUAL_C % 2],
      {"gain": 15, "chips": 0}, ["gain", "chips"],
      "KAS.scale{ field = 'chips', on = KAS.T.any_consumable, reset = KAS.T.round_end }"),
    J("demonio_fuego", "Demonio de Fuego", 3, 9,
      [XMULT % 1 + ",", "{C:red}-#2#{} descarte por ronda"], {"xmult": 2, "n": 1}, ["xmult", "n"],
      "KAS.flat()", pasivo={"discards": -1}),

    # ---- Fila 5: elementales ----
    J("bufon_hielo", "Bufón de Hielo", 1, 4,
      [CHIPS % 1 + " si no has usado", "{C:attention}descartes{} esta ronda"], {"chips": 100}, ["chips"],
      "KAS.cond(KAS.no_discards)"),
    J("bufon_venenoso", "Bufón Venenoso", 1, 5,
      [XMULT % 1 + " si la mano puntuada", "tiene {C:attention}#2#{} o más " + PALO["Clubs"]], {"xmult": 1.25, "min": 3},
      ["xmult", "min"],
      "KAS.cond(function(card, context, e) return KAS.contar(context.scoring_hand, KAS.suit('Clubs')) >= e.min end)"),
    J("bufon_piedra", "Bufón de Piedra", 1, 5,
      [CHIPS % 1 + " por cada carta", "de {C:attention}Piedra{} en tu baraja"], {"chips": 50}, ["chips"],
      "KAS.dyn(function(card, context, e) local n = KAS.contar(G.playing_cards, KAS.mejora('m_stone')) "
      "if n > 0 then return { chips = e.chips * n } end end)"),
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
      {"step": 0.15}, ["step"],
      "KAS.dyn(function(card, context, e) local n = #G.consumeables.cards "
      "if n > 0 then return { xmult = 1 + e.step * n } end end)"),
    J("bufon_rubi", "Bufón Rubí", 2, 6,
      [XMULT % 1 + " si la mano puntuada", "tiene exactamente {C:attention}un{} {C:hearts}Corazón{}"], {"xmult": 1.5}, ["xmult"],
      "KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.suit('Hearts')) == 1 end)"),
    J("bufon_diamante", "Bufón Diamante", 2, 6,
      ["Cada carta de " + PALO["Diamonds"] + " puntuada", "sube {C:money}$#1#{} su {C:attention}valor de venta{}"],
      {"gain": 1}, ["gain"],
      "function(self, card, context) if context.individual and context.cardarea == G.play and not context.blueprint "
      "and context.other_card:is_suit('Diamonds') then "
      "card.ability.extra_value = (card.ability.extra_value or 0) + card.ability.extra.gain card:set_cost() "
      "return { message = localize('k_val_up'), colour = G.C.MONEY, card = card } end end", bp=False),
    J("diablillo", "Diablillo", 2, 6,
      ["Cada {C:attention}6{} puntuado", "da " + XMULT % 1], {"xmult": 1.2}, ["xmult"],
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
      [XMULT % 1 + " si la mano", "jugada es {C:attention}Carta alta{}"], {"xmult": 1.75}, ["xmult"],
      "KAS.cond(function(card, context) return context.scoring_name == 'High Card' end)"),
    J("tahur", "Tahúr", 2, 7,
      ["Reactiva la {C:attention}última{} carta", "puntuada {C:attention}#1#{} veces más"], {"reps": 2}, ["reps"],
      "KAS.retrigger(function(c, context) return c == context.scoring_hand[#context.scoring_hand] end)"),
    J("enterrador", "Enterrador", 3, 8,
      ["Gana " + XMULT % 1 + " por cada", "carta {C:attention}destruida{}", ACTUAL_X % 2],
      {"gain": 0.1, "xmult": 1}, ["gain", "xmult"], "KAS.scale{ field = 'xmult', on = KAS.T.remove_cards }"),
    J("bufon_tesoro", "Bufón del Tesoro", 1, 5,
      ["Ganas {C:money}$#1#{} al seleccionar", "la {C:attention}ciega{}"], {"dollars": 4}, ["dollars"],
      "function(self, card, context) if context.setting_blind then "
      "KAS.dinero(card, card.ability.extra.dollars) end end"),
    J("bardo", "Bardo", 1, 4,
      ["Cada {C:attention}Rey{} o {C:attention}Reina{}", "puntuado da " + MULT % 1], {"mult": 4}, ["mult"],
      "KAS.per_card(KAS.rank(12, 13))"),
    J("bufon_enamorado", "Bufón Enamorado", 1, 5,
      ["Cada carta de " + PALO["Hearts"] + " puntuada", "da tanto {C:mult}multi{} como su valor",
       "{C:inactive}(Figuras 10, As 11)"], {}, [],
      "KAS.per_card_fn(KAS.suit('Hearts'), function(c) return { mult = KAS.valor(c) } end)"),
    J("bufon_duelista", "Bufón Duelista", 1, 4,
      ["Gana " + MULT % 1 + " por cada {C:attention}Pareja{} jugada;", "se reinicia al final de la ronda", ACTUAL_M % 2],
      {"gain": 4, "mult": 0}, ["gain", "mult"],
      "KAS.scale{ field = 'mult', on = KAS.T.hand_type('Pair'), reset = KAS.T.round_end }"),
    J("malabarista", "Malabarista", 2, 6,
      ["Si descartas exactamente", "{C:attention}#1#{} cartas, ganas {C:blue}+1{} mano"], {"cards": 5}, ["cards"],
      "function(self, card, context) if context.pre_discard and not context.blueprint "
      "and #G.hand.highlighted == card.ability.extra.cards then ease_hands_played(1) "
      "return { message = '+1', colour = G.C.BLUE } end end", bp=False),
    J("ladron", "Ladrón", 2, 6,
      ["Al vender otro {C:attention}comodín{},", "ganas su valor de venta otra vez"], {}, [],
      "function(self, card, context) if KAS.T.sell_other_joker(context, card) and not context.blueprint then "
      "KAS.dinero(card, context.card.sell_cost) end end", bp=False),

    # ---- Fila 7: el circo ----
    J("maestro_pista", "Maestro de Pista", 3, 10, ["{C:dark_edition}+#1#{} espacio de comodín"], {"n": 1}, ["n"],
      pasivo={"joker_slots": 1}, bp=False),
    J("bufon_rosa", "Bufón de la Rosa", 2, 6,
      ["Reactiva cada {C:attention}Reina{}", "puntuada {C:attention}#1#{} vez más"], {"reps": 1}, ["reps"],
      "KAS.retrigger(KAS.rank(12))"),
    J("piruleta", "Piruleta", 1, 5,
      [MULT % 1 + ",", "pierde {C:mult}#2#{} multi cada vez que descartas"], {"mult": 20, "loss": 4, "gain": -4},
      ["mult", "loss"], "KAS.scale{ field = 'mult', on = KAS.T.pre_discard, destroy_at = 0 }"),
    J("bufon_feliz", "Bufón Feliz", 2, 6,
      ["Si la mano jugada es un {C:attention}Trío{},", "reactiva todas las cartas puntuadas"], {"reps": 1}, [],
      "KAS.retrigger(KAS.jugada('Three of a Kind'))"),
    J("mago_moneda", "Mago de la Moneda", 2, 7,
      ["{X:mult,C:white} +X#1# {} multi por cada", "{C:money}$#2#{} que tengas"], {"step": 0.05, "per": 10}, ["step", "per"],
      "KAS.dyn(function(card, context, e) local n = math.floor(G.GAME.dollars / e.per) "
      "if n > 0 then return { xmult = 1 + e.step * n } end end)"),
    J("guitarrista", "Guitarrista", 2, 7,
      ["Si la mano contiene una {C:attention}Escalera{},", "reactiva todas las cartas puntuadas"], {"reps": 1}, [],
      "KAS.retrigger(KAS.jugada('Straight', 'Straight Flush'))"),
    J("bufon_globos", "Bufón de los Globos", 1, 5,
      ["Gana " + MULT % 1 + " por cada mano jugada;", PROB % (2, 3) + " de", "{C:attention}explotar{} y volver a 0",
       ACTUAL_M % 4], {"gain": 3, "odds": 6, "mult": 0}, ["gain", "prob", "odds", "mult"],
      "function(self, card, context) local e = card.ability.extra "
      "if context.before and not context.blueprint then "
      "if pseudorandom('kas_bufon_globos') < KAS.prob() / e.odds then e.mult = 0 "
      "return { message = '¡Pop!', colour = G.C.RED } end e.mult = e.mult + e.gain "
      "return { message = localize('k_upgrade_ex'), colour = G.C.MULT } end "
      "if context.joker_main and e.mult > 0 then return { mult = e.mult } end end"),
    J("bufon_sonriente", "Bufón Sonriente", 1, 5,
      ["Cada carta de {C:attention}figura{} puntuada da", MULT % 1 + " por cada figura puntuada"], {"mult": 2}, ["mult"],
      "KAS.per_card_fn(KAS.face, function(c, context, e) "
      "return { mult = e.mult * KAS.contar(context.scoring_hand, KAS.face) } end)"),
    J("bola_ocho", "Bola 8", 1, 5,
      ["Si la mano puntuada tiene un {C:attention}8{},", PROB % (1, 2) + " de crear", "una carta {C:spectral}Espectral{}"],
      {"odds": 8}, ["prob", "odds"],
      "KAS.create(function(context) return context.before and KAS.contar(context.scoring_hand, KAS.rank(8)) > 0 end, "
      "'Spectral', 'kas_bola_ocho')"),
    J("bufon_molon", "Bufón Molón", 1, 5,
      ["Gana " + MULT % 1 + " cada vez", "que juegas una {C:attention}Escalera{}", ACTUAL_M % 2],
      {"gain": 4, "mult": 0}, ["gain", "mult"], "KAS.scale{ field = 'mult', on = KAS.T.hand_type('Straight') }"),

    # ---- Fila 8 ----
    J("principe_bufon", "Príncipe Bufón", 1, 4,
      ["Cada {C:attention}J{} puntuada", "da " + MULT % 1], {"mult": 8}, ["mult"], "KAS.per_card(KAS.rank(11))"),
    J("bufon_guinador", "Bufón Guiñador", 1, 5,
      [PROB % (1, 2) + " de", "ganar {C:money}$#3#{} al jugar una mano"],
      {"odds": 3, "dollars": 3}, ["prob", "odds", "dollars"], 'KAS.chance("kas_bufon_guinador")'),
    J("bufon_punal", "Bufón del Puñal", 2, 6,
      [XMULT % 1 + " si juegas", "exactamente {C:attention}#2#{} cartas"], {"xmult": 1.25, "cards": 5}, ["xmult", "cards"],
      "KAS.cond(function(card, context, e) return #context.full_hand == e.cards end)"),
    J("bufon_azul", "Bufón Azul", 1, 4,
      [CHIPS % 1 + " por cada", "{C:attention}mano{} restante"], {"chips": 25}, ["chips"],
      "KAS.dyn(function(card, context, e) local n = G.GAME.current_round.hands_left "
      "if n > 0 then return { chips = e.chips * n } end end)"),
    J("cofre_tesoro", "Cofre del Tesoro", 1, 5,
      ["Al final de la ronda ganas {C:money}$1{} por cada", "{C:attention}#1#{} cartas que queden en tu baraja"],
      {"per": 10}, ["per"],
      extra="calc_dollar_bonus = function(self, card) local n = math.floor(#G.deck.cards / card.ability.extra.per) "
            "if n > 0 then return n end end", bp=False),
    J("calaverita", "Calaverita", 2, 6,
      [XMULT % 1 + " si todas las cartas", "puntuadas son {C:attention}impares{}"], {"xmult": 1.3}, ["xmult"],
      "KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.odd) == #context.scoring_hand end)"),
    J("bufon_relajado", "Bufón Relajado", 1, 4,
      [MULT % 1 + " por cada", "{C:attention}descarte{} restante"], {"mult": 4}, ["mult"],
      "KAS.dyn(function(card, context, e) local n = G.GAME.current_round.discards_left "
      "if n > 0 then return { mult = e.mult * n } end end)"),
    J("bufon_hippie", "Bufón Hippie", 2, 6,
      [XMULT % 1 + " si la mano puntuada", "no tiene cartas de {C:attention}figura{}"], {"xmult": 1.3}, ["xmult"],
      "KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.face) == 0 end)"),
    J("bola_magica", "Bola Mágica", 2, 6,
      ["Cada {C:attention}8{} puntuado", "da " + XMULT % 1], {"xmult": 1.2}, ["xmult"],
      "KAS.per_card(KAS.rank(8))"),
    mano("bufon_mlg", "Bufón MLG", 3, 8, "Straight Flush", "Escalera de color", "xmult", 2.5),

    # ---- Fila 9 ----
    J("bufon_barril", "Bufón del Barril", 1, 5,
      ["Gana " + CHIPS % 1 + " al final", "de cada ronda", ACTUAL_C % 2],
      {"gain": 10, "chips": 0}, ["gain", "chips"],
      "KAS.scale{ field = 'chips', on = KAS.T.round_end }"),
    J("bufon_dados", "Bufón de los Dados", 1, 5,
      ["Cada carta puntuada tira un dado", "y da entre {C:mult}+#1#{} y {C:mult}+#2#{} multi"], {"min": 1, "max": 6},
      ["min", "max"],
      "KAS.per_card_fn(KAS.any, function(c, context, e) return { mult = pseudorandom('kas_bufon_dados', e.min, e.max) } end)"),
    J("espadachin", "Espadachín", 1, 4,
      ["Cada {C:attention}10{} puntuado", "da " + MULT % 1], {"mult": 10}, ["mult"], "KAS.per_card(KAS.rank(10))"),
    J("corazon_oscuro", "Corazón Oscuro", 2, 6,
      [XMULT % 1 + " si todas las cartas", "puntuadas son de " + PALO["Hearts"]], {"xmult": 1.5}, ["xmult"],
      "KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.suit('Hearts')) "
      "== #context.scoring_hand end)"),
    J("farolero", "Farolero", 2, 6,
      [XMULT % 1 + " si quedan {C:attention}#2#{}", "cartas o menos en tu baraja"], {"xmult": 1.3, "cards": 10},
      ["xmult", "cards"], "KAS.cond(function(card, context, e) return #G.deck.cards <= e.cards end)"),
    J("mimo", "Mimo", 2, 6,
      ["Si juegas {C:attention}una sola{} carta,", "se reactiva {C:attention}#1#{} veces más"], {"reps": 2}, ["reps"],
      "KAS.retrigger(function(c, context) return #context.full_hand == 1 end)"),
    J("pulpo", "Pulpo", 1, 5,
      [XMULT % 1 + " si la mano puntuada", "tiene {C:attention}dos 8{} o más"], {"xmult": 1.3}, ["xmult"],
      "KAS.cond(function(card, context) return KAS.contar(context.scoring_hand, KAS.rank(8)) >= 2 end)"),
    crear("linterna_espectral", "Linterna Espectral", 2, 7,
          [PROB % (1, 2) + " de crear", "una carta {C:spectral}Espectral{}", "al final de la ronda"],
          "Spectral", "KAS.T.round_end", odds=4),
    J("alma_en_pena", "Alma en Pena", 3, 9,
      ["Gana " + XMULT % 1 + " al derrotar", "una {C:attention}ciega jefe{}", ACTUAL_X % 2],
      {"gain": 0.25, "xmult": 1}, ["gain", "xmult"],
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
      [PROB % (1, 2), "de dar " + XMULT % 3], {"odds": 2, "xmult": 1.5}, ["prob", "odds", "xmult"],
      'KAS.chance("kas_dos_caras")'),
    J("hipnosis", "Hipnosis", 3, 8,
      ["Si juegas la {C:attention}misma{} mano que la", "anterior, reactiva todas las", "cartas puntuadas"],
      {"reps": 1, "last": "", "repite": 0}, [],
      "function(self, card, context) local e = card.ability.extra "
      "if context.before and not context.blueprint then "
      "e.repite = (e.last == G.GAME.last_hand_played) and 1 or 0 e.last = G.GAME.last_hand_played end "
      "if context.repetition and context.cardarea == G.play and e.repite == 1 then return { repetitions = e.reps } end end"),
    J("corazon_diabolico", "Corazón Diabólico", 3, 9,
      [XMULT % 1 + ",", "{C:blue}-#2#{} mano por ronda"], {"xmult": 2, "n": 1}, ["xmult", "n"],
      "KAS.flat()", pasivo={"hands": -1}),
    crear("estrella_fugaz", "Estrella Fugaz", 2, 6,
          ["Si la mano contiene un {C:attention}Color{},", "crea una carta de {C:planet}Planeta{}",
           "{C:inactive}(Debe haber espacio)"], "Planet", 'KAS.T.hand_type("Flush")'),
    J("bufon_ajedrecista", "Bufón Ajedrecista", 2, 7,
      ["Manos {C:attention}impares{}: " + XMULT % 1, "Manos {C:attention}pares{}: " + CHIPS % 2],
      {"xmult": 1.5, "chips": 60, "count": 0}, ["xmult", "chips"],
      "function(self, card, context) local e = card.ability.extra "
      "if context.before and not context.blueprint then e.count = e.count + 1 end "
      "if context.joker_main then if e.count % 2 == 1 then return { xmult = e.xmult } end "
      "return { chips = e.chips } end end"),
    J("mascara_solar", "Máscara Solar", 3, 8,
      ["Cada carta de {C:attention}figura{}", "puntuada da " + XMULT % 1], {"xmult": 1.15}, ["xmult"],
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
