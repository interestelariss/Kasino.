--- Kasino: mejoras de carta, ciega jefe, paquetes, mazo, cupon, desafios y tragaperras.
-- Sprites: assets/*/kasino_extras.png (x = 0 marcada, 1 trucada, 2 paquete, 3 mazo, 4 cupon)
--          assets/*/kasino_ciegas.png (ficha animada de la ciega, 21 fotogramas)

SMODS.Atlas { key = "extras", path = "kasino_extras.png", px = 71, py = 95 }
SMODS.Atlas {
    key = "ciegas", path = "kasino_ciegas.png", px = 34, py = 34,
    atlas_table = "ANIMATION_ATLAS", frames = 21,
}

---------------------------------------------------------------------------
-- Mejoras de carta
---------------------------------------------------------------------------

SMODS.Enhancement {
    key = "marcada",
    loc_txt = { name = "Carta Marcada", text = { "{C:chips}+#1#{} fichas", "Ganas {C:money}$#2#{} al puntuar" } },
    atlas = "extras", pos = { x = 0, y = 0 },
    config = { bonus = 10, p_dollars = 1 },
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.bonus, self.config.p_dollars } }
    end,
}

SMODS.Enhancement {
    key = "trucada",
    loc_txt = {
        name = "Carta Trucada",
        text = { "Al puntuar: {C:green}#1# entre #2#{} de", "dar {X:mult,C:white} X#3# {} multi;", "si no, {X:mult,C:white} X#4# {} multi" },
    },
    atlas = "extras", pos = { x = 1, y = 0 },
    config = { extra = { odds = 2, gana = 2, pierde = 0.75 } },
    loc_vars = function(self, info_queue, card)
        local e = self.config.extra
        return { vars = { KAS.prob(), e.odds, e.gana, e.pierde } }
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local e = self.config.extra
            if pseudorandom('kas_trucada') < KAS.prob() / e.odds then
                return { xmult = e.gana }
            end
            return { xmult = e.pierde }
        end
    end,
}

---------------------------------------------------------------------------
-- Ciega jefe: El Crupier (blackjack)
---------------------------------------------------------------------------

-- Suma de blackjack: figuras 10, Ases 11 o 1 (lo que convenga para no pasarse)
function KAS.suma_blackjack(cartas)
    local suma, ases = 0, 0
    for _, c in ipairs(cartas) do
        local id = c:get_id()
        if id == 14 then
            suma, ases = suma + 11, ases + 1
        elseif id > 10 then
            suma = suma + 10
        elseif id > 0 then
            suma = suma + id
        end
    end
    while suma > 21 and ases > 0 do
        suma, ases = suma - 10, ases - 1
    end
    return suma
end

SMODS.Blind {
    key = "crupier",
    loc_txt = { name = "El Crupier", text = { "Si las cartas jugadas suman", "más de 21, la mano no puntúa" } },
    atlas = "ciegas", pos = { x = 0, y = 0 },
    dollars = 5, mult = 2,
    boss = { min = 1, max = 10 },
    boss_colour = HEX("1E6E46"),
    debuff_hand = function(self, cards, hand, handname, check)
        return KAS.suma_blackjack(cards) > 21
    end,
}

---------------------------------------------------------------------------
-- Paquetes
---------------------------------------------------------------------------

local RAREZAS_PAQUETE = { { 0.70, 1 }, { 0.95, 2 }, { 0.99, 3 }, { 1.00, "kas_legendario" } }

-- Un comodin de Kasino aleatorio que no tengas ya
function KAS.comodin_kasino_aleatorio(semilla)
    local r = pseudorandom(semilla)
    local rareza
    for _, par in ipairs(RAREZAS_PAQUETE) do
        if r <= par[1] then rareza = par[2] break end
    end
    local opciones = {}
    for clave, centro in pairs(G.P_CENTERS) do
        if centro.set == 'Joker' and clave:sub(1, 6) == 'j_kas_' and centro.rarity == rareza
            and not next(SMODS.find_card(clave)) then
            opciones[#opciones + 1] = clave
        end
    end
    table.sort(opciones)
    if #opciones == 0 then return nil end
    return pseudorandom_element(opciones, pseudoseed(semilla .. '_clave'))
end

SMODS.Booster {
    key = "casino",
    loc_txt = {
        name = "Paquete Casino",
        group_name = "Paquete Casino",
        text = { "Elige {C:attention}#1#{} de hasta", "{C:attention}#2#{} comodines de {C:gold}Kasino{}" },
    },
    atlas = "extras", pos = { x = 2, y = 0 },
    config = { extra = 3, choose = 1 },
    cost = 6, weight = 0.6,
    kind = "Buffoon",
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,
    ease_background_colour = function(self)
        ease_background_colour({ new_colour = HEX("1E6E46"), special_colour = HEX("D4A017"), contrast = 2 })
    end,
    create_card = function(self, card, i)
        local clave = KAS.comodin_kasino_aleatorio('kas_paquete_casino')
        if clave then
            return { key = clave, area = G.pack_cards, skip_materialize = true, key_append = 'kas_paquete' }
        end
        return { set = 'Joker', area = G.pack_cards, skip_materialize = true, key_append = 'kas_paquete' }
    end,
}

SMODS.Booster {
    key = "nilo",
    loc_txt = {
        name = "Paquete del Nilo",
        group_name = "Paquete del Nilo",
        text = { "Elige {C:attention}#1#{} de hasta", "{C:attention}#2#{} cartas {C:gold}Casino{}", "para usar al momento" },
    },
    atlas = "casino", pos = { x = 5, y = 1 },
    config = { extra = 3, choose = 1 },
    cost = 4, weight = 0.6,
    kind = "Arcana",
    draw_hand = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,
    ease_background_colour = function(self)
        ease_background_colour({ new_colour = HEX("2B2410"), special_colour = HEX("D4A017"), contrast = 2 })
    end,
    create_card = function(self, card, i)
        return { set = 'Casino', area = G.pack_cards, skip_materialize = true, soulable = false, key_append = 'kas_nilo' }
    end,
}

---------------------------------------------------------------------------
-- Mazo del Casino
---------------------------------------------------------------------------

SMODS.Back {
    key = "casino",
    loc_txt = {
        name = "Mazo del Casino",
        text = {
            "Puedes apostar {C:attention}Doble o Nada{}",
            "en {C:attention}todas{} las manos",
            "{C:blue}-1{} mano por ronda",
            "Empiezas con {C:money}$#1#{} extra",
        },
    },
    atlas = "extras", pos = { x = 3, y = 0 },
    config = { hands = -1, dollars = 6 },
    loc_vars = function(self) return { vars = { self.config.dollars } } end,
    apply = function(self, back)
        G.GAME.modifiers.kas_apuesta_siempre = true
    end,
}

---------------------------------------------------------------------------
-- Cupon Mesa VIP
---------------------------------------------------------------------------

SMODS.Voucher {
    key = "mesa_vip",
    loc_txt = {
        name = "Mesa VIP",
        text = {
            "{C:attention}Doble o Nada{} y {C:attention}Ma'at{} ganan",
            "el {C:green}60%{} de las veces",
            "La {C:attention}Tragaperras{} cuesta {C:money}$1{}",
        },
    },
    atlas = "extras", pos = { x = 4, y = 0 },
    cost = 10,
}

function KAS.vip()
    return G.GAME.used_vouchers and G.GAME.used_vouchers.v_kas_mesa_vip
end

-- Probabilidad de ganar las apuestas de 50 %
function KAS.prob_apuesta()
    return KAS.vip() and 0.6 or 0.5
end

---------------------------------------------------------------------------
-- Tragaperras en la tienda
---------------------------------------------------------------------------

KAS.SIMBOLOS = { "7", "$", "BUFÓN", "CEREZA", "CALAVERA" }
KAS.ui.tragaperras = "$2"

function KAS.coste_tragaperras()
    return KAS.vip() and 1 or 2
end

-- Premio de una tirada: devuelve dinero y si toca un comodin
function KAS.premio_tragaperras(a, b, c)
    if a == b and b == c then
        if a == "7" then return 20 end
        if a == "$" then return 10 end
        if a == "BUFÓN" then return 0, true end
        if a == "CEREZA" then return 6 end
        return 0
    end
    if (a == b and a ~= "CALAVERA") or (b == c and b ~= "CALAVERA") or (a == c and a ~= "CALAVERA") then
        return 2
    end
    return 0
end

G.FUNCS.kas_puede_girar = function(e)
    local coste = KAS.coste_tragaperras()
    KAS.ui.tragaperras = "$" .. coste
    if not KAS.girando and G.GAME.dollars - G.GAME.bankrupt_at >= coste then
        e.config.colour = G.C.RED
        e.config.button = 'kas_girar'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.kas_girar = function(e)
    KAS.girando = true
    ease_dollars(-KAS.coste_tragaperras())
    local tirada = {}
    for i = 1, 3 do tirada[i] = pseudorandom_element(KAS.SIMBOLOS, pseudoseed('kas_tragaperras' .. i)) end
    local dinero, comodin = KAS.premio_tragaperras(tirada[1], tirada[2], tirada[3])
    if comodin and #G.jokers.cards >= G.jokers.config.card_limit then
        comodin, dinero = false, 8
    end
    play_sound('coin3')
    G.E_MANAGER:add_event(Event({
        trigger = 'after', delay = 0.2,
        func = function()
            attention_text({
                text = table.concat(tirada, " | "), scale = 0.7, hold = 2, major = G.shop,
                align = 'tm', offset = { x = 0, y = -1.2 }, backdrop_colour = G.C.BLACK, silent = true,
            })
            return true
        end,
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after', delay = 1.2,
        func = function()
            local texto, color = "Nada...", G.C.RED
            if comodin then
                SMODS.add_card({ set = 'Joker', key_append = 'kas_tragaperras' })
                texto, color = "¡COMODÍN!", G.C.PURPLE
            elseif dinero > 0 then
                ease_dollars(dinero)
                texto, color = "¡$" .. dinero .. "!", G.C.MONEY
            end
            play_sound(dinero >= 10 and 'multhit2' or 'coin1')
            attention_text({
                text = texto, scale = 1, hold = 1.5, major = G.shop, align = 'tm',
                offset = { x = 0, y = -0.2 }, backdrop_colour = color, silent = true,
            })
            KAS.girando = false
            return true
        end,
    }))
end

-- Busca en un arbol de UI el nodo que cumple pred; devuelve su padre y su posicion
function KAS.buscar_nodo(nodo, pred)
    for i, hijo in ipairs(nodo.nodes or {}) do
        if pred(hijo) then return nodo, i end
        local padre, pos = KAS.buscar_nodo(hijo, pred)
        if padre then return padre, pos end
    end
end

local function boton_tragaperras()
    return {
        n = G.UIT.R,
        config = {
            align = "cm", minw = 2.8, minh = 1.1, r = 0.15, colour = G.C.RED, hover = true, shadow = true,
            button = 'kas_girar', func = 'kas_puede_girar',
        },
        nodes = {
            { n = G.UIT.R, config = { align = "cm", padding = 0.03 }, nodes = {
                { n = G.UIT.T, config = { text = "TRAGAPERRAS", scale = 0.4, colour = G.C.WHITE, shadow = true } },
            } },
            { n = G.UIT.R, config = { align = "cm" }, nodes = {
                { n = G.UIT.T, config = { ref_table = KAS.ui, ref_value = 'tragaperras', scale = 0.55,
                    colour = G.C.WHITE, shadow = true } },
            } },
        },
    }
end

-- Anade el boton TRAGAPERRAS debajo del de volver a tirar la tienda
local tienda_original = G.UIDEF.shop
function G.UIDEF.shop()
    local t = tienda_original()
    local padre, pos = KAS.buscar_nodo(t, function(n) return n.config and n.config.button == 'reroll_shop' end)
    if padre then table.insert(padre.nodes, pos + 1, boton_tragaperras()) end
    return t
end

---------------------------------------------------------------------------
-- Desafios
---------------------------------------------------------------------------

SMODS.Challenge {
    key = "todo_o_nada",
    loc_txt = { name = "Todo o Nada" },
    rules = { custom = { { id = "kas_todo_o_nada" } }, modifiers = {} },
    jokers = { { id = "j_kas_doble_o_nada", eternal = true } },
    consumeables = {}, vouchers = {},
    deck = { type = "Challenge Deck" },
    restrictions = { banned_cards = {}, banned_tags = {}, banned_other = {} },
}

SMODS.Challenge {
    key = "noche_casino",
    loc_txt = { name = "Noche en el Casino" },
    rules = {
        custom = { { id = "kas_crupier_siempre" } },
        modifiers = { { id = "dollars", value = 0 } },
    },
    jokers = {
        { id = "j_kas_tragaperras" }, { id = "j_kas_crupier" }, { id = "j_kas_ruleta" }, { id = "j_kas_la_banca" },
    },
    consumeables = {},
    vouchers = { { id = "v_kas_mesa_vip" } },
    deck = { type = "Challenge Deck" },
    restrictions = { banned_cards = {}, banned_tags = {}, banned_other = {} },
}

SMODS.Challenge {
    key = "faraon",
    loc_txt = { name = "El Faraón" },
    rules = { custom = { { id = "kas_solo_nilo" } }, modifiers = { { id = "consumable_slots", value = 3 } } },
    jokers = {},
    consumeables = { { id = "c_kas_thoth" }, { id = "c_kas_ra" }, { id = "c_kas_nut" } },
    vouchers = {},
    deck = { type = "Challenge Deck" },
    restrictions = { banned_cards = {}, banned_tags = {}, banned_other = {} },
}

-- Texto de las reglas especiales de los desafios
SMODS.current_mod.process_loc_text = function()
    G.localization.misc.v_text.ch_c_kas_todo_o_nada = { "Todas las manos se juegan a {C:attention}Doble o Nada{}" }
    G.localization.misc.v_text.ch_c_kas_crupier_siempre = { "Todas las ciegas jefe son {C:attention}El Crupier{}" }
    G.localization.misc.v_text.ch_c_kas_solo_nilo = { "La tienda solo vende cartas {C:gold}Casino{} como consumibles" }
end

-- Noche en el Casino: todas las ciegas jefe son El Crupier
local nuevo_jefe_original = get_new_boss
function get_new_boss(...)
    if G.GAME.modifiers.kas_crupier_siempre then return 'bl_kas_crupier' end
    return nuevo_jefe_original(...)
end

-- El Faraon: la tienda no vende Tarot ni Planetas, solo cartas Casino
local empezar_partida_original = Game.start_run
function Game:start_run(args)
    empezar_partida_original(self, args)
    if self.GAME.modifiers.kas_solo_nilo then
        self.GAME.tarot_rate = 0
        self.GAME.planet_rate = 0
        self.GAME.casino_rate = 8
    end
end
