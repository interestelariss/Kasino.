--- Kasino: menu de fusiones.
-- Se abre con Ctrl + F durante una partida, o desde Opciones -> FUSIONES.
-- Muestra las reglas de fusion, con que otros comodines tuyos puede fusionarse
-- cada uno (y que parejas estan ya listas) y que cartas de tu mano se pueden
-- juntar con la carta de Tarot La Fusion.

local NOMBRES_RAREZA = { [1] = "Común", [2] = "Poco común", [3] = "Raro", [4] = "Legendario",
    kas_legendario = "Legendario" }

-- Nombre de la rareza que sale al fusionar (claves de KAS.SIGUIENTE_RAREZA)
local NOMBRES_DESTINO = { Uncommon = "Poco común", Rare = "Raro", kas_legendario = "Legendario" }

local NOMBRES_VALOR = { [11] = "J", [12] = "Q", [13] = "K", [14] = "A" }

local function nombre_comodin(j)
    local ok, nombre = pcall(localize, { type = 'name_text', set = 'Joker', key = j.config.center.key })
    if ok and type(nombre) == 'string' and nombre ~= 'ERROR' then return nombre end
    return j.config.center.name or j.config.center.key
end

-- Datos del menu: una entrada por comodin y los valores repetidos de la mano
function KAS.info_fusiones()
    local comodines = {}
    local lista = G.jokers and G.jokers.cards or {}
    for i, j in ipairs(lista) do
        local rareza = j.config.center.rarity
        local info = {
            nombre = nombre_comodin(j),
            rareza = NOMBRES_RAREZA[rareza] or tostring(rareza),
            fusionable = KAS.SIGUIENTE_RAREZA[rareza] ~= nil and not j.ability.eternal,
            con = {},
            lista = KAS.pareja_fusion(j) ~= nil,
        }
        if info.fusionable then
            info.da = NOMBRES_DESTINO[KAS.SIGUIENTE_RAREZA[rareza]]
            for k, otro in ipairs(lista) do
                if k ~= i and otro.config.center.rarity == rareza and not otro.ability.eternal then
                    info.con[#info.con + 1] = nombre_comodin(otro)
                end
            end
        end
        comodines[#comodines + 1] = info
    end

    local repetidos = {}
    if G.hand and G.hand.cards then
        local cuenta = {}
        for _, c in ipairs(G.hand.cards) do
            local id = c:get_id()
            if id and id > 0 then cuenta[id] = (cuenta[id] or 0) + 1 end
        end
        for id = 2, 14 do
            if (cuenta[id] or 0) >= 2 then
                repetidos[#repetidos + 1] = (NOMBRES_VALOR[id] or tostring(id)) .. " ×" .. cuenta[id]
            end
        end
    end
    return comodines, repetidos
end

---------------------------------------------------------------------------
-- Interfaz
---------------------------------------------------------------------------

local function linea(t, escala, color)
    return { n = G.UIT.R, config = { align = "cm", padding = 0.03 }, nodes = {
        { n = G.UIT.T, config = { text = t, scale = escala or 0.35, colour = color or G.C.UI.TEXT_LIGHT } },
    } }
end

local function caja(titulo, nodos)
    table.insert(nodos, 1, linea(titulo, 0.45, G.C.GOLD))
    return { n = G.UIT.R, config = { align = "cm", padding = 0.12, r = 0.1, colour = G.C.BLACK, minw = 9 },
        nodes = nodos }
end

function KAS.fusiones_ui()
    local comodines, repetidos = KAS.info_fusiones()

    local reglas = caja("REGLAS", {
        linea("2 Comunes  →  1 Poco común"),
        linea("2 Poco comunes  →  1 Raro"),
        linea("2 Raros  →  1 Legendario de Kasino"),
        linea("Los Legendarios y los comodines Eternos no se fusionan", 0.3, G.C.UI.TEXT_INACTIVE),
        linea("Pon los dos juntos y pulsa FUSIONAR en el de la izquierda", 0.3, G.C.UI.TEXT_INACTIVE),
    })

    local filas = {}
    if #comodines == 0 then
        filas[1] = linea("No tienes comodines", 0.35, G.C.UI.TEXT_INACTIVE)
    end
    for _, c in ipairs(comodines) do
        local texto, color
        if not c.fusionable then
            texto, color = c.nombre .. " (" .. c.rareza .. "): no se puede fusionar", G.C.UI.TEXT_INACTIVE
        elseif #c.con == 0 then
            texto, color = c.nombre .. " (" .. c.rareza .. "): sin pareja", G.C.UI.TEXT_INACTIVE
        else
            texto = c.nombre .. " (" .. c.rareza .. ") + " .. table.concat(c.con, " / ") .. "  →  " .. c.da
            color = c.lista and G.C.GREEN or G.C.UI.TEXT_LIGHT
            if c.lista then texto = texto .. "   ¡LISTA!" end
        end
        filas[#filas + 1] = linea(texto, 0.32, color)
    end
    local tuyos = caja("TUS COMODINES", filas)

    local mano = caja("LA FUSIÓN (cartas del mismo valor en tu mano)", {
        #repetidos > 0 and linea(table.concat(repetidos, "    "), 0.35, G.C.GREEN)
            or linea("No tienes cartas repetidas en la mano", 0.35, G.C.UI.TEXT_INACTIVE),
    })

    return create_UIBox_generic_options({
        contents = {
            linea("FUSIONES", 0.7, G.C.PURPLE),
            reglas,
            tuyos,
            mano,
            linea("En verde: parejas listas para fusionar ahora mismo", 0.3, G.C.UI.TEXT_INACTIVE),
        },
    })
end

local function en_partida()
    return G.STAGE == G.STAGES.RUN and G.GAME and G.jokers
end

function KAS.abrir_fusiones()
    if not en_partida() then return end
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu({ definition = KAS.fusiones_ui() })
end

G.FUNCS.kas_fusiones_abrir = function(e) KAS.abrir_fusiones() end

-- Atajo de teclado: Ctrl + F
SMODS.Keybind {
    key = "fusiones",
    key_pressed = "f",
    held_keys = { "lctrl" },
    action = function(self) KAS.abrir_fusiones() end,
}

-- Boton FUSIONES en el menu de Opciones (solo durante una partida)
local opciones_original = create_UIBox_options
function create_UIBox_options(...)
    local t = opciones_original(...)
    if en_partida() then
        local padre, pos = KAS.buscar_nodo(t, function(n)
            return n.nodes and n.nodes[1] and n.nodes[1].config and n.nodes[1].config.button == 'your_collection'
        end)
        if padre then
            table.insert(padre.nodes, pos + 1, UIBox_button({
                label = { "FUSIONES" }, button = 'kas_fusiones_abrir', minw = 5, colour = G.C.PURPLE,
            }))
        end
    end
    return t
end
