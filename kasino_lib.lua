--- Kasino: piezas reutilizables para definir comodines con poco codigo.
-- Cada constructor devuelve una funcion calculate(self, card, context).
-- Los valores se leen siempre de card.ability.extra (llamado "e").

KAS = {}

function KAS.prob()
    return (G.GAME and G.GAME.probabilities.normal) or 1
end

local function suerte(seed, odds)
    return pseudorandom(seed) < KAS.prob() / odds
end

-- Efecto estandar de puntuacion a partir de los campos de config
local function efecto(e)
    return {
        chips = e.chips,
        mult = e.mult,
        xmult = e.xmult,
        dollars = e.dollars,
    }
end

-- Animacion de destruccion (igual que Gros Michel)
function KAS.destruir(card)
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

-- Crea un consumible ("Tarot", "Planet" o "Spectral") si hay hueco
function KAS.crear(set)
    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.add_card({ set = set, key_append = 'kas' })
                G.GAME.consumeable_buffer = 0
                return true
            end,
        }))
        return { message = localize('k_plus_' .. string.lower(set)), colour = G.C.SECONDARY_SET[set] }
    end
end

function KAS.dinero(card, n)
    ease_dollars(n)
    card_eval_status_text(card, 'dollars', n)
end

---------------------------------------------------------------------------
-- Condiciones sobre cartas: function(carta, context, e) -> bool
---------------------------------------------------------------------------

function KAS.suit(...)
    local palos = { ... }
    return function(c)
        for _, s in ipairs(palos) do
            if c:is_suit(s) then return true end
        end
        return false
    end
end

function KAS.rank(...)
    local ids = {}
    for _, id in ipairs({ ... }) do ids[id] = true end
    return function(c) return ids[c:get_id()] == true end
end

function KAS.face(c) return c:is_face() end

function KAS.even(c)
    local id = c:get_id()
    return id >= 2 and id <= 10 and id % 2 == 0
end

function KAS.odd(c)
    local id = c:get_id()
    return id == 14 or (id >= 3 and id <= 9 and id % 2 == 1)
end

function KAS.first(c, context) return c == context.scoring_hand[1] end

function KAS.any() return true end

---------------------------------------------------------------------------
-- Condiciones de mano: function(card, context, e) -> bool
---------------------------------------------------------------------------

function KAS.first_hand() return G.GAME.current_round.hands_played == 0 end

function KAS.last_hand() return G.GAME.current_round.hands_left == 0 end

function KAS.no_discards() return G.GAME.current_round.discards_used == 0 end

function KAS.palos_distintos(context)
    local vistos, n = {}, 0
    for _, c in ipairs(context.scoring_hand) do
        for _, s in ipairs({ 'Hearts', 'Diamonds', 'Spades', 'Clubs' }) do
            if not vistos[s] and c:is_suit(s, true) then
                vistos[s] = true
                n = n + 1
                break
            end
        end
    end
    return n
end

function KAS.contar(lista, pred, context)
    local n = 0
    for _, c in ipairs(lista) do
        if pred(c, context) then n = n + 1 end
    end
    return n
end

---------------------------------------------------------------------------
-- Disparadores (para comodines que escalan o crean cartas)
---------------------------------------------------------------------------

KAS.T = {}

function KAS.T.hand_played(context) return context.before end

function KAS.T.hand_type(nombre)
    return function(context)
        return context.before and next(context.poker_hands[nombre]) ~= nil
    end
end

function KAS.T.discard(context) return context.discard end

function KAS.T.pre_discard(context) return context.pre_discard end

function KAS.T.round_end(context) return context.end_of_round and context.main_eval end

function KAS.T.boss(context)
    return context.end_of_round and context.main_eval and G.GAME.blind.boss
end

function KAS.T.blind(context) return context.setting_blind end

function KAS.T.consumable(set)
    return function(context)
        return context.using_consumeable and context.consumeable.ability.set == set
    end
end

function KAS.T.sell_other_joker(context, card)
    return context.selling_card and context.card ~= card and context.card.ability.set == 'Joker'
end

---------------------------------------------------------------------------
-- Constructores de calculate
---------------------------------------------------------------------------

-- Siempre da su efecto
function KAS.flat()
    return function(self, card, context)
        if context.joker_main then return efecto(card.ability.extra) end
    end
end

-- Efecto por cada carta puntuada que cumpla pred (opcionalmente con probabilidad e.odds)
function KAS.per_card(pred, seed)
    return function(self, card, context)
        local e = card.ability.extra
        if context.individual and context.cardarea == G.play and pred(context.other_card, context, e)
            and (not e.odds or suerte(seed, e.odds)) then
            return efecto(e)
        end
    end
end

-- Efecto si la mano jugada contiene la jugada indicada
function KAS.hand(nombre)
    return function(self, card, context)
        if context.joker_main and next(context.poker_hands[nombre]) then
            return efecto(card.ability.extra)
        end
    end
end

-- Efecto si se cumple cond(card, context, e)
function KAS.cond(cond)
    return function(self, card, context)
        if context.joker_main and cond(card, context, card.ability.extra) then
            return efecto(card.ability.extra)
        end
    end
end

-- Efecto calculado: fn(card, context, e) devuelve la tabla de efecto o nil
function KAS.dyn(fn)
    return function(self, card, context)
        if context.joker_main then return fn(card, context, card.ability.extra) end
    end
end

-- 1 entre e.odds de dar su efecto
function KAS.chance(seed)
    return function(self, card, context)
        if context.joker_main and suerte(seed, card.ability.extra.odds) then
            return efecto(card.ability.extra)
        end
    end
end

-- Reactiva e.reps veces las cartas puntuadas que cumplan pred
function KAS.retrigger(pred)
    return function(self, card, context)
        local e = card.ability.extra
        if context.repetition and context.cardarea == G.play and pred(context.other_card, context, e) then
            return { repetitions = e.reps }
        end
    end
end

-- Comodin que escala: o.on(context, card, e) -> true o numero de veces.
-- o.field es el campo que crece e.gain; o.reset lo devuelve a o.base.
-- o.destroy_at: se destruye si el valor baja a ese numero o menos.
function KAS.scale(o)
    local base = o.base or (o.field == 'xmult' and 1 or 0)
    return function(self, card, context)
        local e = card.ability.extra
        if not context.blueprint then
            local n = o.on(context, card, e)
            if n then
                n = (n == true) and 1 or n
                if n > 0 then
                    e[o.field] = e[o.field] + e.gain * n
                    if o.destroy_at and e[o.field] <= o.destroy_at then
                        KAS.destruir(card)
                        return { message = localize('k_eaten_ex'), colour = G.C.RED }
                    end
                    if e.gain < 0 then
                        return { message = localize { type = 'variable', key = 'a_mult_minus', vars = { -e.gain } }, colour = G.C.RED }
                    end
                    return { message = localize('k_upgrade_ex'), colour = G.C.FILTER }
                end
            end
            if o.reset and o.reset(context, card, e) and e[o.field] ~= base then
                e[o.field] = base
                return { message = localize('k_reset'), colour = G.C.RED }
            end
        end
        if context.joker_main and e[o.field] ~= base then
            return { [o.field] = e[o.field] }
        end
    end
end

-- Crea un consumible cuando ocurre on(context, card, e); con e.odds es aleatorio
function KAS.create(on, set, seed)
    return function(self, card, context)
        local e = card.ability.extra
        if on(context, card, e) and (not e.odds or suerte(seed, e.odds)) then
            return KAS.crear(set)
        end
    end
end

-- 1 entre e.break_odds de destruirse al final de la ronda
function KAS.fragile(seed)
    return function(self, card, context)
        if KAS.T.round_end(context) and not context.blueprint then
            if suerte(seed, card.ability.extra.break_odds) then
                KAS.destruir(card)
                return { message = localize('k_extinct_ex'), colour = G.C.RED }
            end
            return { message = localize('k_safe_ex') }
        end
    end
end

-- Al venderlo crea un consumible
function KAS.sell_create(set)
    return function(self, card, context)
        if context.selling_self and not context.blueprint then
            return KAS.crear(set)
        end
    end
end

-- Ejecuta varios calculate y devuelve el primer resultado
function KAS.combine(...)
    local fns = { ... }
    return function(self, card, context)
        for _, f in ipairs(fns) do
            local r = f(self, card, context)
            if r then return r end
        end
    end
end

-- Modificadores pasivos mientras el comodin este en juego
function KAS.passive(o)
    local function aplicar(signo)
        if o.hand_size then G.hand:change_size(o.hand_size * signo) end
        if o.discards then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + o.discards * signo
            ease_discard(o.discards * signo)
        end
        if o.hands then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + o.hands * signo
            ease_hands_played(o.hands * signo)
        end
        if o.joker_slots then G.jokers.config.card_limit = G.jokers.config.card_limit + o.joker_slots * signo end
        if o.consumable_slots then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + o.consumable_slots * signo
        end
        if o.prob_mult then
            for k, v in pairs(G.GAME.probabilities) do
                G.GAME.probabilities[k] = signo > 0 and v * o.prob_mult or v / o.prob_mult
            end
        end
    end
    return function(self, card, from_debuff) aplicar(1) end,
        function(self, card, from_debuff) aplicar(-1) end
end
