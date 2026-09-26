--- Prueba de humo del mod con un Balatro/Steamodded simulado (no sustituye a probarlo en el juego).
-- Carga el mod, ejecuta cada comodin en los contextos habituales y comprueba
-- la logica de fusion, Doble o Nada, cartas Casino, mejoras, ciega jefe y tragaperras.
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
local jokers, consumibles, creados, registrados = {}, {}, {}, {}
local function registrar(tipo) return function(t) registrados[tipo .. ":" .. t.key] = t end end
SMODS = {
    Atlas = function() end,
    Rarity = function() end,
    ConsumableType = registrar("tipo"), Enhancement = registrar("mejora"), Blind = registrar("ciega"),
    Booster = registrar("paquete"), Back = registrar("mazo"), Voucher = registrar("cupon"),
    Challenge = registrar("desafio"),
    current_mod = {},
    Keybind = registrar("atajo"),
    find_card = function() return {} end,
    change_base = function(c, _, valor) c.nuevo_valor = valor end,
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
        hands = {
            Pair = { level = 2, played = 3, visible = true, chips = 10, mult = 2 },
            Flush = { level = 1, played = 0, visible = true, chips = 35, mult = 4 },
        },
        bankrupt_at = 0, used_vouchers = {}, modifiers = {},
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
    FUNCS = { draw_from_deck_to_hand = function(n) G.robadas = n end },
    UIDEF = {
        use_and_sell_buttons = function() return { nodes = { { nodes = {} } } } end,
        shop = function() return { nodes = { { nodes = { { config = { button = 'reroll_shop' } } } } } } end,
    },
    P_CENTERS = { c_base = "c_base", m_kas_marcada = "m_kas_marcada", m_kas_trucada = "m_kas_trucada",
        j_kas_crupier = { set = 'Joker', rarity = 1 }, e_foil = {} }, P_CENTER_POOLS = { Enhanced = { "m_bonus", "m_mult" } },
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
function level_up_hand(_, mano, _, n) G.GAME.hands[mano].level = G.GAME.hands[mano].level + (n or 1) end
Game = { start_run = function(self) self.GAME = G.GAME end }
function get_new_boss() return 'bl_original' end
Card = { click = function(self) self.clic_normal = true end, apply_to_run = function(_, c) G.aplicado = c.key end }
function UIBox_button(t) return { n = 2, nodes = { { n = 1, config = { button = t.button, ref_table = t.ref_table } } } } end
function create_UIBox_generic_options(t) return { nodes = t.contents } end
function create_UIBox_options() return { nodes = { UIBox_button({ button = 'your_collection' }) } } end
G.STAGES, G.STAGE, G.SETTINGS = { RUN = 2 }, 2, {}
G.FUNCS.overlay_menu = function(t) G.menu = t.definition end
G.FUNCS.exit_overlay_menu = function() G.menu = nil end
G.FUNCS.your_collection_jokers = function() G.pagina = 'jokers' end
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

---------------------------------------------------------------- cartas Casino
local nombres = { "thoth", "osiris", "isis", "hermes", "ra", "anubis", "set", "shu", "tefnut", "horus",
    "neftis", "seshat", "maat", "nut", "geb", "iah" }
comprobar(registrados["tipo:Casino"] ~= nil, "existe el tipo de consumible Casino")
local vistos = {}
for _, n in ipairs(nombres) do
    local c = consumibles[n]
    comprobar(c ~= nil and c.set == "Casino", "carta Casino " .. n)
    if c then
        comprobar(not vistos[c.pos.x .. "," .. c.pos.y], "sprite repetido en " .. n)
        vistos[c.pos.x .. "," .. c.pos.y] = true
    end
end
local function usar(nombre, seleccion)
    local c = consumibles[nombre]
    local card = { ability = copia(c.config or {}), juice_up = function() end }
    if c.config and c.config.extra then card.ability.extra = copia(c.config.extra) end
    G.hand.highlighted = seleccion or {}
    if c.loc_vars then c.loc_vars(c, {}, card) end
    local ok, puede = pcall(c.can_use, c, card)
    comprobar(ok, "can_use de " .. nombre .. ": " .. tostring(puede))
    if ok and puede then
        local ok2, err = pcall(c.use, c, card)
        comprobar(ok2, "use de " .. nombre .. ": " .. tostring(err))
    end
    return puede
end
G.hand.cards = { carta(5, 'Hearts', false), carta(6, 'Clubs', false) }
G.jokers.cards = { comodin(1) }
G.jokers.cards[1].set_edition = function(self, e) self.edition = e end
for _, n in ipairs(nombres) do usar(n, { carta(9, 'Hearts', false) }) end
comprobar(G.GAME.hands.Pair.level == 3, "Thoth sube la mano mas jugada")
local marcada = carta(4, 'Spades', false)
usar("isis", { marcada })
comprobar(marcada.config.center == "m_kas_marcada", "Isis convierte en Carta Marcada")
comprobar(G.robadas == 3, "Shu roba 3 cartas")
comprobar(G.jokers.cards[1].edition and G.jokers.cards[1].edition.foil, "Horus da edicion Laminada")
comprobar(not usar("osiris"), "Osiris no se puede usar sin haber vendido un comodin")
SMODS.calculate_context({ selling_card = true, card = { ability = { set = 'Joker' }, config = { center = { key = 'j_kas_crupier' } } } })
comprobar(usar("osiris") and creados[#creados].key == 'j_kas_crupier', "Osiris revive el ultimo comodin vendido")

---------------------------------------------------------------- mejoras
local trucada = registrados["mejora:trucada"]
pseudorandom = function() return 0.1 end
comprobar(trucada.calculate(trucada, {}, { main_scoring = true, cardarea = G.play }).xmult == 2, "Carta Trucada gana")
pseudorandom = function() return 0.9 end
comprobar(trucada.calculate(trucada, {}, { main_scoring = true, cardarea = G.play }).xmult == 0.75, "Carta Trucada pierde")
comprobar(registrados["mejora:marcada"].config.p_dollars == 1, "Carta Marcada da dinero")

---------------------------------------------------------------- El Crupier
local function ids(...) local t = {} for _, id in ipairs({ ... }) do t[#t + 1] = carta(id, 'Hearts', id > 10 and id < 14) end return t end
comprobar(KAS.suma_blackjack(ids(14, 13)) == 21, "As + Rey = 21")
comprobar(KAS.suma_blackjack(ids(14, 14, 9)) == 21, "As + As + 9 = 21")
comprobar(KAS.suma_blackjack(ids(13, 12, 5)) == 25, "Rey + Reina + 5 = 25")
local crupier = registrados["ciega:crupier"]
comprobar(crupier.debuff_hand(crupier, ids(13, 12, 5)) == true, "El Crupier anula una mano que se pasa de 21")
comprobar(crupier.debuff_hand(crupier, ids(10, 5, 6)) == false, "El Crupier deja puntuar 21 justos")
G.GAME.modifiers.kas_crupier_siempre = true
comprobar(get_new_boss() == 'bl_kas_crupier', "en Noche en el Casino todos los jefes son El Crupier")
G.GAME.modifiers.kas_crupier_siempre = nil
comprobar(get_new_boss() == 'bl_original', "sin el desafio el jefe es el normal")

---------------------------------------------------------------- tragaperras
comprobar(KAS.premio_tragaperras("7", "7", "7") == 20, "tres 7 dan $20")
comprobar(select(2, KAS.premio_tragaperras("BUFÓN", "BUFÓN", "BUFÓN")) == true, "tres bufones dan un comodin")
comprobar(KAS.premio_tragaperras("CEREZA", "7", "CEREZA") == 2, "una pareja devuelve $2")
comprobar(KAS.premio_tragaperras("CALAVERA", "CALAVERA", "7") == 0, "dos calaveras no dan nada")
comprobar(KAS.premio_tragaperras("7", "$", "CEREZA") == 0, "sin coincidencias no hay premio")
local tienda = G.UIDEF.shop()
comprobar(#tienda.nodes[1].nodes == 2 and tienda.nodes[1].nodes[2].config.button == 'kas_girar',
    "el boton TRAGAPERRAS se anade junto a volver a tirar")
comprobar(tienda.nodes[1].nodes[1].config.minh == 1, "el boton de volver a tirar se compacta")
local gastado = 0
ease_dollars = function(n) gastado = gastado + n end
G.shop = {}
pseudorandom_element = function(t) return t[1] end
local boton_slot = { config = {} }
G.FUNCS.kas_puede_girar(boton_slot)
comprobar(boton_slot.config.button == 'kas_girar', "se puede girar con dinero suficiente")
G.FUNCS.kas_girar(boton_slot)
comprobar(gastado == -2 + 20, "girar cuesta $2 y tres 7 pagan $20")
G.GAME.used_vouchers.v_kas_mesa_vip = true
comprobar(KAS.coste_tragaperras() == 1 and KAS.prob_apuesta() == 0.6, "Mesa VIP abarata y mejora las apuestas")
G.GAME.used_vouchers.v_kas_mesa_vip = nil

---------------------------------------------------------------- paquetes, mazo, desafios
for _, k in ipairs({ "paquete:casino", "paquete:nilo", "mazo:casino", "cupon:mesa_vip",
    "desafio:todo_o_nada", "desafio:noche_casino", "desafio:faraon" }) do
    comprobar(registrados[k] ~= nil, "registrado " .. k)
end
G.P_CENTERS.j_kas_crupier.rarity = 1
pseudorandom = function() return 0.1 end
comprobar(registrados["paquete:casino"].create_card(registrados["paquete:casino"], {}, 1).key == 'j_kas_crupier',
    "el Paquete Casino da comodines de Kasino")
local mazo = registrados["mazo:casino"]
mazo.apply(mazo, {})
G.GAME.current_round.hands_left = 3
comprobar(KAS.es_ultima_mano(), "con el Mazo del Casino se puede apostar en cualquier mano")
G.GAME.modifiers.kas_apuesta_siempre = nil
G.GAME.modifiers.kas_todo_o_nada = true
mult = 10
SMODS.calculate_context({ final_scoring_step = true })
comprobar(mult ~= 10, "en Todo o Nada todas las manos se apuestan")
G.GAME.modifiers.kas_todo_o_nada = nil
G.GAME.modifiers.kas_solo_nilo = true
Game.start_run(G)
comprobar(G.GAME.tarot_rate == 0 and G.GAME.casino_rate == 8, "El Faraon solo vende cartas Casino")
G.localization = { misc = { v_text = {} } }
SMODS.current_mod.process_loc_text()
comprobar(G.localization.misc.v_text.ch_c_kas_todo_o_nada ~= nil, "texto de las reglas de los desafios")

---------------------------------------------------------------- panel de admin
comprobar(registrados["atajo:admin"] ~= nil, "atajo Ctrl + K registrado")
registrados["atajo:admin"].action()
comprobar(G.menu ~= nil, "Ctrl + K abre el panel de admin")
local dinero = 0
ease_dollars = function(n) dinero = dinero + n end
G.FUNCS.kas_admin_dinero({ config = { ref_table = { n = 10 } } })
G.FUNCS.kas_admin_dinero({ config = { ref_table = { n = -100 } } })
comprobar(dinero == -90, "el panel da y quita dinero")
local huecos = G.jokers.config.card_limit
G.FUNCS.kas_admin_hueco({})
comprobar(G.jokers.config.card_limit == huecos + 1, "el panel da huecos de comodin")
G.FUNCS.kas_admin_coleccion({ config = { ref_table = { pagina = 'your_collection_jokers' } } })
comprobar(G.pagina == 'jokers' and KAS.admin.activo, "abre la coleccion en modo admin")
local n_creados = #creados
local en_coleccion = { area = { config = { collection = true } }, config = { center = { key = 'j_joker', set = 'Joker' } },
    juice_up = function() end }
Card.click(en_coleccion)
comprobar(#creados == n_creados + 1 and creados[#creados].key == 'j_joker', "pulsar un comodin de la coleccion te lo da")
Card.click({ area = { config = { collection = true } }, config = { center = { key = 'c_fool', set = 'Tarot', consumeable = true } },
    juice_up = function() end })
comprobar(creados[#creados].key == 'c_fool', "pulsar un Tarot de la coleccion te lo da")
G.GAME.used_vouchers = {}
Card.click({ area = { config = { collection = true } }, config = { center = { key = 'v_overstock_norm', set = 'Voucher' } },
    juice_up = function() end })
comprobar(G.aplicado == 'v_overstock_norm' and G.GAME.used_vouchers.v_overstock_norm, "pulsar un cupon lo activa")
G.FUNCS.exit_overlay_menu()
comprobar(not KAS.admin.activo, "al cerrar el menu se sale del modo admin")
local normal = { area = { config = { collection = true } }, config = { center = { key = 'j_joker', set = 'Joker' } } }
Card.click(normal)
comprobar(normal.clic_normal, "fuera del modo admin la coleccion funciona normal")
local opciones = create_UIBox_options()
comprobar(#opciones.nodes == 2 and opciones.nodes[2].nodes[1].config.button == 'kas_admin_abrir',
    "boton ADMIN KASINO en Opciones")
G.STAGE = 1
comprobar(#create_UIBox_options().nodes == 1, "fuera de una partida no sale el boton de admin")

if fallos > 0 then
    print(fallos .. " comprobaciones fallidas")
    os.exit(1)
end
print("Todo OK")
