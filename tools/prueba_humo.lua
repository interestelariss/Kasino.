--- Prueba de humo del mod con un Balatro/Steamodded simulado (no sustituye a probarlo en el juego).
-- Carga el mod, ejecuta cada comodin en los contextos habituales y comprueba
-- la logica de fusion y de Doble o Nada.
-- Uso, desde la raiz del repo: lua5.1 tools/prueba_humo.lua

local fallos = 0
local function comprobar(cond, msg)
    if not cond then
        fallos = fallos + 1
        print("FALLO: " .. msg)
    end
end

---------------------------------------------------------------- simulacion
function HEX() return {} end
local jokers, consumibles, creados = {}, {}, {}
SMODS = {
    Atlas = function() end,
    Rarity = function() end,
    Joker = function(t) jokers[#jokers + 1] = t end,
    Consumable = function(t) consumibles[t.key] = t end,
    load_file = function(p) return loadfile(p) end,
    add_card = function(t) creados[#creados + 1] = t return { juice_up = function() end } end,
    calculate_context = function() end,
}

local function carta(id, suit, face)
    return {
        get_id = function() return id end,
        is_suit = function(_, s) return s == suit end,
        is_face = function() return face end,
        base = { nominal = math.min(id, 10) }, ability = {}, config = { center = "c_base" }, T = { x = id },
        set_seal = function(self, s) self.seal = s end,
        set_ability = function(self, c) self.config.center = c end,
        juice_up = function() end, start_dissolve = function(self) self.disuelta = true end,
    }
end

local function comodin(rareza)
    return {
        config = { center = { rarity = rareza } }, ability = { set = 'Joker' },
        start_dissolve = function(self) self.disuelto = true end,
    }
end

local mano = { carta(13, 'Hearts', true), carta(13, 'Spades', true), carta(8, 'Clubs', false),
    carta(7, 'Diamonds', false), carta(14, 'Hearts', false) }

G = {
    GAME = {
        probabilities = { normal = 1 }, dollars = 23, consumeable_buffer = 0,
        current_round = { hands_left = 2, hands_played = 0, discards_left = 2, discards_used = 0 },
        blind = { boss = true, chips = 300 }, chips = 100, last_hand_played = 'Pair', round = 3,
        hands = { Pair = { level = 2 }, Flush = { level = 1 } },
        consumeable_usage_total = { planet = 2, tarot = 1, all = 3 },
        round_resets = { hands = 4, discards = 3 },
    },
    playing_cards = mano,
    jokers = { cards = { comodin(1), comodin(3) }, config = { card_limit = 5 }, unhighlight_all = function() end,
        remove_card = function() end },
    consumeables = { cards = {}, config = { card_limit = 2 } },
    deck = { cards = { 1, 2, 3 } },
    hand = { cards = { mano[1], mano[2] }, highlighted = { 1, 2, 3, 4, 5 }, change_size = function() end,
        unhighlight_all = function() end },
    play = {},
    -- Los eventos se ejecutan en el momento para poder comprobar su efecto
    E_MANAGER = { add_event = function(_, ev) if ev.func then ev.func() end end },
    C = setmetatable({ SECONDARY_SET = {}, UI = {} }, { __index = function() return {} end }),
    UIT = { C = 1, R = 2, T = 3, B = 4, ROOT = 0 },
    FUNCS = {}, UIDEF = { use_and_sell_buttons = function() return { nodes = { { nodes = {} } } } end },
    P_CENTERS = { c_base = "c_base" }, P_CENTER_POOLS = { Enhanced = { "m_bonus", "m_mult" } },
    STATES = { SELECTING_HAND = 1 }, STATE = 1,
}
for _, j in ipairs(G.jokers.cards) do j.area = G.jokers end

function localize() return "x" end
function pseudorandom(_, a, b) if a then return a end return 0.1 end
function pseudoseed() return 0 end
function pseudorandom_element(t) return t[1] end
function Event(t) return t end
function ease_dollars() end function ease_discard() end function ease_hands_played() end
function card_eval_status_text() end function play_sound() end
function update_hand_text() end function attention_text() end
function mod_mult(x) return x end
function create_UIBox_buttons() return { nodes = { {}, {} } } end

dofile("main.lua")

---------------------------------------------------------------- comodines
local contextos = {
    { joker_main = true, full_hand = mano, scoring_hand = mano, scoring_name = 'Pair',
        poker_hands = setmetatable({}, { __index = function() return { 1 } end }) },
    { before = true, full_hand = mano, scoring_hand = mano, scoring_name = 'Flush',
        poker_hands = setmetatable({}, { __index = function() return { 1 } end }) },
    { individual = true, cardarea = G.play, other_card = mano[1], scoring_hand = mano, full_hand = mano },
    { repetition = true, cardarea = G.play, other_card = mano[1], scoring_hand = mano, full_hand = mano },
    { discard = true, other_card = mano[1] }, { pre_discard = true },
    { remove_playing_cards = true, removed = { 1, 2 } },
    { end_of_round = true, main_eval = true }, { setting_blind = true }, { selling_self = true },
    { using_consumeable = true, consumeable = { ability = { set = 'Planet' } } },
    { using_consumeable = true, consumeable = { ability = { set = 'Tarot' } } },
    { individual = true, cardarea = G.hand, other_card = mano[2] },
    { selling_card = true, card = { ability = { set = 'Joker' }, sell_cost = 3 } },
}
local function copia(t) local r = {} for k, v in pairs(t) do r[k] = v end return r end
for _, j in ipairs(jokers) do
    local card = { ability = { extra = copia(j.config.extra) }, T = {}, states = { drag = {} },
        children = { center = { pinch = {} } }, juice_up = function() end, set_cost = function() end,
        remove = function() end }
    local ok, err = pcall(function()
        j.loc_vars(j, {}, card)
        for _, ctx in ipairs(contextos) do if j.calculate then j.calculate(j, card, ctx) end end
        if j.add_to_deck then j.add_to_deck(j, card); j.remove_from_deck(j, card) end
        if j.calc_dollar_bonus then j.calc_dollar_bonus(j, card) end
    end)
    comprobar(ok, "comodin " .. j.key .. ": " .. tostring(err))
end
print(("%d comodines cargados y ejecutados"):format(#jokers))

---------------------------------------------------------------- fusion de comodines
local c1, c2, c3 = comodin(1), comodin(1), comodin(2)
G.jokers.cards = { c1, c2, c3 }
for _, j in ipairs(G.jokers.cards) do j.area = G.jokers end
comprobar(KAS.pareja_fusion(c1) == c2, "dos comunes seguidos se pueden fusionar")
comprobar(KAS.pareja_fusion(c2) == nil, "comun + poco comun no se fusionan")
comprobar(KAS.pareja_fusion(c3) == nil, "el ultimo comodin no tiene pareja")
c2.ability.eternal = true
comprobar(KAS.pareja_fusion(c1) == nil, "un comodin eterno no se fusiona")
c2.ability.eternal = nil
local boton = { config = { ref_table = c1 } }
G.FUNCS.kas_puede_fusionar(boton)
comprobar(boton.config.button == 'kas_fusionar', "el boton se activa con pareja valida")
G.FUNCS.kas_fusionar(boton)
comprobar(c1.disuelto and c2.disuelto and not c3.disuelto, "se destruyen los dos fusionados")
comprobar(creados[#creados].rarity == "Uncommon", "dos comunes dan un poco comun")
local l1, l2 = comodin("kas_legendario"), comodin("kas_legendario")
G.jokers.cards = { l1, l2 }
for _, j in ipairs(G.jokers.cards) do j.area = G.jokers end
comprobar(KAS.pareja_fusion(l1) == nil, "los legendarios no se fusionan")
local ui = G.UIDEF.use_and_sell_buttons(l1)
comprobar(#ui.nodes[1].nodes == 1, "se anade el boton FUSIONAR a los comodines")

---------------------------------------------------------------- carta La Fusion
local fusion = consumibles.fusion
local a, b = carta(9, 'Hearts', false), carta(9, 'Spades', false)
a.T.x, b.T.x = 1, 2
b.seal = 'Red'
G.hand.highlighted = { b, a }
comprobar(fusion.can_use(fusion, {}), "La Fusion se puede usar con dos cartas del mismo valor")
fusion.use(fusion, { juice_up = function() end })
comprobar(a.ability.perma_bonus == 9, "la carta resultante suma las fichas de la otra")
comprobar(a.seal == 'Red', "hereda el sello")
comprobar(a.config.center == "m_bonus", "gana una mejora")
comprobar(b.disuelta, "la otra carta desaparece")
G.hand.highlighted = { carta(9, 'Hearts', false), carta(10, 'Hearts', false) }
comprobar(not fusion.can_use(fusion, {}), "no se puede con valores distintos")

---------------------------------------------------------------- Doble o Nada
local apostar = { config = {} }
G.GAME.current_round.hands_left = 2
G.FUNCS.kas_puede_apostar(apostar)
comprobar(apostar.config.button == nil, "no se puede apostar si no es la ultima mano")
G.GAME.current_round.hands_left = 1
G.FUNCS.kas_puede_apostar(apostar)
comprobar(apostar.config.button == 'kas_apostar', "se puede apostar en la ultima mano")
G.FUNCS.kas_apostar(apostar)
comprobar(G.GAME.kas_apuesta == true, "apostar activa la apuesta")
mult = 10
pseudorandom = function() return 0.2 end
SMODS.calculate_context({ final_scoring_step = true })
comprobar(mult == 20, "si sale doble, el multi se duplica")
comprobar(not G.GAME.kas_apuesta, "la apuesta se gasta al puntuar")
G.GAME.kas_apuesta, mult = true, 10
pseudorandom = function() return 0.8 end
SMODS.calculate_context({ final_scoring_step = true })
comprobar(mult == 0, "si sale nada, la mano puntua 0")
mult = 10
SMODS.calculate_context({ final_scoring_step = true })
comprobar(mult == 10, "sin apuesta no cambia nada")
G.GAME.kas_apuesta = true
SMODS.calculate_context({ setting_blind = true })
comprobar(not G.GAME.kas_apuesta, "la apuesta se reinicia al empezar una ciega")
local botones = create_UIBox_buttons()
comprobar(#botones.nodes == 3, "se anade el boton APOSTAR")

if fallos > 0 then
    print(fallos .. " comprobaciones fallidas")
    os.exit(1)
end
print("Todo OK")
