"""Genera comodines.lua, los atlas assets/*/kasino_cartas*.png y COMODINES.md.

Uso: python3 tools/generar_comodines.py   (requiere Pillow)
"""
import re
from pathlib import Path

from PIL import Image, ImageDraw, ImageEnhance, ImageFilter

import comodines
import comodines_hoja2
import comodines_hoja3

ROOT = Path(__file__).resolve().parent.parent
W, H = 71, 95

# modo "claro": cartas claras sobre fondo oscuro; "oscuro": cartas de cualquier
# color separadas por un fondo casi negro.
HOJAS = [
    dict(fuente="hoja_comodines.webp", atlas="cartas", png="kasino_cartas.png",
         cols=10, filas=10, modo="claro", comodines=comodines.COMODINES),
    dict(fuente="hoja_comodines_2.webp", atlas="cartas2", png="kasino_cartas_2.png",
         cols=13, filas=5, modo="oscuro", comodines=comodines_hoja2.COMODINES),
    dict(fuente="hoja_comodines_3.webp", atlas="cartas3", png="kasino_cartas_3.png",
         cols=13, filas=4, modo="oscuro", comodines=comodines_hoja3.COMODINES),
]
RAREZAS = {1: "Común", 2: "Poco común", 3: "Raro", 4: "Legendario"}


# ---------------------------------------------------------------- sprites

def rachas(perfil, umbral, hueco=0):
    out, ini = [], None
    for i, v in enumerate(perfil):
        if v > umbral and ini is None:
            ini = i
        elif v <= umbral and ini is not None:
            out.append((ini, i - 1))
            ini = None
    if ini is not None:
        out.append((ini, len(perfil) - 1))
    # Une tramos separados por huecos pequenos (detalles oscuros dentro de una carta)
    unidos = [list(out[0])]
    for a, b in out[1:]:
        if a - unidos[-1][1] <= hueco:
            unidos[-1][1] = b
        else:
            unidos.append([a, b])
    return unidos


def recortar_cartas(img, hoja):
    """Localiza cada carta de la hoja a partir de los perfiles de filas y columnas."""
    px = img.load()
    ancho, alto = img.size
    if hoja["modo"] == "claro":
        es_carta, umbral, hueco = (lambda p: sum(p) / 3 > 150), 0.15, 0
    else:
        es_carta, umbral, hueco = (lambda p: sum(p) / 3 >= 45), 0.2, 6
    cols = [sum(es_carta(px[x, y]) for y in range(0, alto, 2)) / (alto / 2) for x in range(ancho)]
    filas = [sum(es_carta(px[x, y]) for x in range(0, ancho, 2)) / (ancho / 2) for y in range(alto)]
    xs, ys = rachas(cols, umbral, hueco), rachas(filas, umbral, hueco)
    assert len(xs) >= hoja["cols"] and len(ys) >= hoja["filas"], (hoja["fuente"], len(xs), len(ys))
    cajas = []
    for (y0, y1) in ys[:hoja["filas"]]:
        for (x0, x1) in xs[:hoja["cols"]]:
            cajas.append((x0, y0, x1 + 1, y1 + 1))
    return cajas


def sprite(img, caja):
    """Carta a 1x (71x95) como pixel art limpio.

    Las hojas son imagenes pequenas; ampliarlas con suavizado las emborrona.
    Se reduce a 1x con un poco de nitidez y el 2x se obtiene duplicando
    pixeles (NEAREST), igual que los sprites del juego base.
    """
    carta = img.crop(caja)
    # Escala uniforme hasta cubrir el hueco y recorta el sobrante centrado
    f = max(W / carta.width, H / carta.height)
    carta = carta.resize((round(carta.width * f), round(carta.height * f)), Image.LANCZOS)
    x = (carta.width - W) // 2
    y = (carta.height - H) // 2
    carta = carta.crop((x, y, x + W, y + H))
    carta = carta.filter(ImageFilter.UnsharpMask(radius=1, percent=80, threshold=2))
    carta = ImageEnhance.Contrast(carta).enhance(1.08)
    carta = ImageEnhance.Color(carta).enhance(1.12)
    carta = carta.convert("RGBA")
    # Esquinas redondeadas y borde oscuro como las cartas de Balatro
    mascara = Image.new("L", (W, H), 0)
    ImageDraw.Draw(mascara).rounded_rectangle([0, 0, W - 1, H - 1], radius=5, fill=255)
    fondo = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    fondo.paste(carta, (0, 0), mascara)
    ImageDraw.Draw(fondo).rounded_rectangle([0, 0, W - 1, H - 1], radius=5, outline=(30, 32, 40, 255), width=1)
    return fondo


def generar_atlas(hoja):
    img = Image.open(ROOT / "assets" / "fuente" / hoja["fuente"]).convert("RGB")
    cajas = recortar_cartas(img, hoja)
    cols, filas = hoja["cols"], hoja["filas"]
    atlas = Image.new("RGBA", (W * cols, H * filas), (0, 0, 0, 0))
    for i, caja in enumerate(cajas):
        atlas.paste(sprite(img, caja), ((i % cols) * W, (i // cols) * H))
    for escala in (1, 2):
        out = ROOT / "assets" / f"{escala}x" / hoja["png"]
        atlas.resize((atlas.width * escala, atlas.height * escala), Image.NEAREST).save(out)
        print("escrito", out.relative_to(ROOT))


# ---------------------------------------------------------------- lua

def lua_valor(v):
    if isinstance(v, str):
        return '"%s"' % v
    return repr(v)


def lua_str(s):
    return '"%s"' % s.replace("\\", "\\\\").replace('"', '\\"')


def lua_var(v):
    return "KAS.prob()" if v == "prob" else "e.%s" % v


def generar_lua():
    out = ["--- GENERADO por tools/generar_comodines.py: no editar a mano.",
           "--- Comodines de las hojas de sprites de assets/fuente.", ""]
    for hoja in HOJAS:
        out.append('SMODS.Atlas { key = "%s", path = "%s", px = %d, py = %d }' % (hoja["atlas"], hoja["png"], W, H))
    out.append("")
    n = 0
    for hoja in HOJAS:
        out += generar_lua_hoja(hoja, n)
        n += len(hoja["comodines"])
    (ROOT / "comodines.lua").write_text("\n".join(out), encoding="utf-8")
    print("escrito comodines.lua")


def generar_lua_hoja(hoja, inicio):
    out = []
    cols = hoja["cols"]
    for i, c in enumerate(hoja["comodines"]):
        cfg = ", ".join("%s = %s" % (k, lua_valor(v)) for k, v in c["cfg"].items())
        out.append("-- %d. %s" % (inicio + i + 1, c["nombre"]))
        out.append("do")
        if c["pasivo"]:
            args = ", ".join("%s = %s" % (k, v) for k, v in c["pasivo"].items())
            out.append("    local al_entrar, al_salir = KAS.passive({ %s })" % args)
        out.append("    SMODS.Joker {")
        out.append('        key = "%s",' % c["key"])
        out.append("        loc_txt = {")
        out.append("            name = %s," % lua_str(c["nombre"]))
        out.append("            text = {")
        for linea in c["texto"]:
            out.append("                %s," % lua_str(linea))
        out.append("            },")
        out.append("        },")
        out.append("        config = { extra = { %s } }," % cfg)
        # Los legendarios usan la rareza propia kas_legendario (ver main.lua)
        rareza = '"kas_legendario"' if c["rareza"] == 4 else str(c["rareza"])
        out.append("        rarity = %s," % rareza)
        out.append("        cost = %d," % c["coste"])
        out.append('        atlas = "%s",' % hoja["atlas"])
        out.append("        pos = { x = %d, y = %d }," % (i % cols, i // cols))
        out.append("        blueprint_compat = %s," % ("true" if c["bp"] else "false"))
        out.append("        loc_vars = function(self, info_queue, card)")
        out.append("            local e = card.ability.extra")
        out.append("            return { vars = { %s } }" % ", ".join(lua_var(v) for v in c["vars"]))
        out.append("        end,")
        if c["calc"]:
            out.append("        calculate = %s," % c["calc"])
        if c["pasivo"]:
            out.append("        add_to_deck = al_entrar,")
            out.append("        remove_from_deck = al_salir,")
        if c["extra"]:
            out.append("        %s," % c["extra"])
        out.append("    }")
        out.append("end")
        out.append("")
    return out


# ---------------------------------------------------------------- docs

def texto_plano(c):
    valores = [1 if v == "prob" else c["cfg"][v] for v in c["vars"]]
    lineas = []
    for linea in c["texto"]:
        linea = re.sub(r"#(\d+)#", lambda m: str(valores[int(m.group(1)) - 1]), linea)
        linea = re.sub(r"\{[^}]*\}", "", linea)
        lineas.append(re.sub(r"\s+", " ", linea).strip())
    return " ".join(lineas).replace(" )", ")")


def resumen_rarezas(lista):
    cuenta = {r: 0 for r in RAREZAS}
    for c in lista:
        cuenta[c["rareza"]] += 1
    return " · ".join("%s: %d" % (RAREZAS[r], n) for r, n in cuenta.items())


def generar_docs():
    todos = [c for hoja in HOJAS for c in hoja["comodines"]]
    filas = ["# Especificaciones de los %d comodines" % len(todos), "",
             "Generado por `tools/generar_comodines.py`. La posición indica fila y columna",
             "en su hoja de sprites (`assets/fuente/`).", "",
             "**Rarezas en total:** " + resumen_rarezas(todos)]
    n = 0
    for h, hoja in enumerate(HOJAS, 1):
        cols = hoja["cols"]
        filas += ["", "## Hoja %d · `%s`" % (h, hoja["fuente"]), "",
                  "%d comodines. %s" % (len(hoja["comodines"]), resumen_rarezas(hoja["comodines"])), "",
                  "| # | Pos. | Comodín | Rareza | Coste | Efecto | Blueprint |",
                  "|---|---|---|---|---|---|---|"]
        for i, c in enumerate(hoja["comodines"]):
            n += 1
            filas.append("| %d | F%d·C%d | **%s** | %s | $%d | %s | %s |" % (
                n, i // cols + 1, i % cols + 1, c["nombre"], RAREZAS[c["rareza"]],
                c["coste"], texto_plano(c), "Sí" if c["bp"] else "No"))
    (ROOT / "COMODINES.md").write_text("\n".join(filas) + "\n", encoding="utf-8")
    print("escrito COMODINES.md")


def comprobar():
    todos = [c for hoja in HOJAS for c in hoja["comodines"]]
    claves = [c["key"] for c in todos]
    repetidas = {k for k in claves if claves.count(k) > 1}
    assert not repetidas, "claves repetidas: %s" % repetidas
    for hoja in HOJAS:
        assert len(hoja["comodines"]) == hoja["cols"] * hoja["filas"], hoja["fuente"]


if __name__ == "__main__":
    comprobar()
    for hoja in HOJAS:
        generar_atlas(hoja)
    generar_lua()
    generar_docs()
