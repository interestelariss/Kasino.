--- Kasino: panel de admin para probar el mod.
-- Se abre con Ctrl + K durante una partida, o desde Opciones -> ADMIN KASINO.
-- Permite darse o quitarse dinero, manos, descartes y huecos de comodin, y abrir
-- la coleccion en "modo admin": al pulsar cualquier carta de la coleccion
-- (comodines del juego base y del mod, Tarot, Planetas, Espectrales, Casino,
-- cupones...) te la da.

KAS.admin = { activo = false }

local function en_partida()
    return G.STAGE == G.STAGES.RUN and G.GAME and G.jokers
end

local function aviso(texto, color)
    attention_text({
        text = texto, scale = 0.7, hold = 1.2, major = G.ROOM_ATTACH, align = 'cm',
        offset = { x = 0, y = -3.5 }, backdrop_colour = color or G.C.BLACK, silent = true,
    })
end

-- Da la carta de la coleccion correspondiente a `centro`
function KAS.admin_dar(centro)
    if not en_partida() then return false end
    if centro.set == 'Voucher' then
        if not G.GAME.used_vouchers[centro.key] then
            G.GAME.used_vouchers[centro.key] = true
            Card.apply_to_run(nil, centro)
        end
    elseif centro.set == 'Joker' or centro.consumeable then
        SMODS.add_card({ key = centro.key })
    else
        aviso("No se puede dar", G.C.RED)
        return false
    end
    play_sound('card1')
    return true
end

-- En modo admin, pulsar una carta de la coleccion te la da
local click_original = Card.click
function Card:click()
    if KAS.admin.activo and en_partida() and self.area and self.area.config and self.area.config.collection
        and self.config and self.config.center then
        if KAS.admin_dar(self.config.center) then self:juice_up(0.3, 0.3) end
        return
    end
    return click_original(self)
end

-- Al cerrar el menu se sale del modo admin
local salir_original = G.FUNCS.exit_overlay_menu
G.FUNCS.exit_overlay_menu = function(...)
    KAS.admin.activo = false
    return salir_original(...)
end

---------------------------------------------------------------------------
-- Acciones de los botones
---------------------------------------------------------------------------

G.FUNCS.kas_admin_dinero = function(e)
    ease_dollars(e.config.ref_table.n)
end

G.FUNCS.kas_admin_manos = function(e)
    ease_hands_played(1)
end

G.FUNCS.kas_admin_descartes = function(e)
    ease_discard(1)
end

G.FUNCS.kas_admin_hueco = function(e)
    G.jokers.config.card_limit = G.jokers.config.card_limit + 1
end

G.FUNCS.kas_admin_vaciar = function(e)
    for _, j in ipairs(G.jokers.cards) do j:start_dissolve() end
end

-- Abre una pagina de la coleccion en modo admin
G.FUNCS.kas_admin_coleccion = function(e)
    KAS.admin.activo = true
    G.FUNCS[e.config.ref_table.pagina](e)
    KAS.admin.activo = true
end

---------------------------------------------------------------------------
-- Interfaz
---------------------------------------------------------------------------

local function boton(texto, funcion, datos, color, ancho)
    return UIBox_button({
        label = { texto }, button = funcion, ref_table = datos or {}, colour = color or G.C.RED,
        minw = ancho or 1.5, minh = 0.6, scale = 0.4,
    })
end

local function fila(nodos)
    return { n = G.UIT.R, config = { align = "cm", padding = 0.08 }, nodes = nodos }
end

local function columna(nodo)
    return { n = G.UIT.C, config = { align = "cm", padding = 0.04 }, nodes = { nodo } }
end

local function texto(t, escala, color)
    return { n = G.UIT.R, config = { align = "cm", padding = 0.05 }, nodes = {
        { n = G.UIT.T, config = { text = t, scale = escala or 0.4, colour = color or G.C.UI.TEXT_LIGHT } },
    } }
end

-- Paginas de la coleccion que se pueden abrir desde el panel
KAS.PAGINAS_ADMIN = {
    { "Comodines", "your_collection_jokers" },
    { "Tarot", "your_collection_tarots" },
    { "Planetas", "your_collection_planets" },
    { "Espectrales", "your_collection_spectrals" },
    { "Otros consumibles", "your_collection_consumables" },
    { "Cupones", "your_collection_vouchers" },
}

function KAS.admin_ui()
    local dinero, coleccion = {}, {}
    for _, n in ipairs({ -100, -10, -1, 1, 10, 100 }) do
        dinero[#dinero + 1] = columna(boton((n > 0 and "+$" or "-$") .. math.abs(n), 'kas_admin_dinero', { n = n },
            n > 0 and G.C.GREEN or G.C.RED, 1.1))
    end
    for _, p in ipairs(KAS.PAGINAS_ADMIN) do
        if G.FUNCS[p[2]] then
            coleccion[#coleccion + 1] = columna(boton(p[1], 'kas_admin_coleccion', { pagina = p[2] }, G.C.PURPLE, 2.2))
        end
    end
    local coleccion_1, coleccion_2 = {}, {}
    for i, c in ipairs(coleccion) do
        if i <= 3 then coleccion_1[#coleccion_1 + 1] = c else coleccion_2[#coleccion_2 + 1] = c end
    end
    return create_UIBox_generic_options({
        contents = {
            texto("PANEL DE ADMIN", 0.7, G.C.GOLD),
            { n = G.UIT.R, config = { align = "cm", padding = 0.05 }, nodes = {
                { n = G.UIT.T, config = { text = "Dinero: $", scale = 0.45, colour = G.C.MONEY } },
                { n = G.UIT.T, config = { ref_table = G.GAME, ref_value = 'dollars', scale = 0.45, colour = G.C.MONEY } },
            } },
            fila(dinero),
            fila({
                columna(boton("+1 mano", 'kas_admin_manos', nil, G.C.BLUE, 2.2)),
                columna(boton("+1 descarte", 'kas_admin_descartes', nil, G.C.RED, 2.2)),
                columna(boton("+1 hueco comodín", 'kas_admin_hueco', nil, G.C.ORANGE, 2.2)),
            }),
            fila({ columna(boton("Quitar todos los comodines", 'kas_admin_vaciar', nil, G.C.BLACK, 4)) }),
            texto("Dar cartas: abre la colección y pulsa una carta", 0.35),
            fila(coleccion_1),
            fila(coleccion_2),
        },
    })
end

function KAS.abrir_admin()
    if not en_partida() then return end
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu({ definition = KAS.admin_ui() })
end

G.FUNCS.kas_admin_abrir = function(e) KAS.abrir_admin() end

-- Atajo de teclado: Ctrl + K
SMODS.Keybind {
    key = "admin",
    key_pressed = "k",
    held_keys = { "lctrl" },
    action = function(self) KAS.abrir_admin() end,
}

-- Boton ADMIN KASINO en el menu de Opciones (solo durante una partida)
local opciones_original = create_UIBox_options
function create_UIBox_options(...)
    local t = opciones_original(...)
    if en_partida() then
        local padre, pos = KAS.buscar_nodo(t, function(n)
            return n.nodes and n.nodes[1] and n.nodes[1].config and n.nodes[1].config.button == 'your_collection'
        end)
        if padre then
            table.insert(padre.nodes, pos + 1, UIBox_button({
                label = { "ADMIN KASINO" }, button = 'kas_admin_abrir', minw = 5, colour = G.C.GOLD,
            }))
        end
    end
    return t
end
