"""Genera comodines.lua, el atlas kasino_cartas.png y COMODINES.md.

Uso: python3 tools/generar_comodines.py   (requiere Pillow)
"""
import re
from pathlib import Path

from PIL import Image, ImageDraw

from comodines import COMODINES

ROOT = Path(__file__).resolve().parent.parent
HOJA = ROOT / "assets" / "fuente" / "hoja_comodines.webp"
W, H = 71, 95
COLS, FILAS = 10, 10
RAREZAS = {1: "Común", 2: "Poco común", 3: "Raro", 4: "Legendario"}


# ---------------------------------------------------------------- sprites

def rachas(perfil, umbral):
    out, ini = [], None
    for i, v in enumerate(perfil):
        if v > umbral and ini is None:
            ini = i
        elif v <= umbral and ini is not None:
            out.append((ini, i - 1))
            ini = None
    if ini is not None:
        out.append((ini, len(perfil) - 1))
    return out


def es_carta(p):
    return sum(p) / 3 > 150


def recortar_cartas(img):
    """Localiza cada carta de la hoja (cartas claras sobre fondo oscuro)."""
    px = img.load()
    ancho, alto = img.size
    cols = [sum(es_carta(px[x, y]) for y in range(0, alto, 2)) / (alto / 2) for x in range(ancho)]
    filas = [sum(es_carta(px[x, y]) for x in range(0, ancho, 2)) / (ancho / 2) for y in range(alto)]
    xs, ys = rachas(cols, 0.15), rachas(filas, 0.15)
    assert len(xs) >= COLS and len(ys) >= FILAS, (len(xs), len(ys))
    cajas = []
    for (y0, y1) in ys[:FILAS]:
        for (x0, x1) in xs[:COLS]:
            cajas.append((x0, y0, x1 + 1, y1 + 1))
    return cajas


def sprite(img, caja, escala):
    w, h = W * escala, H * escala
    carta = img.crop(caja)
    # Escala uniforme hasta cubrir el hueco y recorta el sobrante centrado
    f = max(w / carta.width, h / carta.height)
    carta = carta.resize((round(carta.width * f), round(carta.height * f)), Image.LANCZOS)
    x = (carta.width - w) // 2
    y = (carta.height - h) // 2
    carta = carta.crop((x, y, x + w, y + h)).convert("RGBA")
    # Esquinas redondeadas y borde oscuro como las cartas de Balatro
    mascara = Image.new("L", (w, h), 0)
    ImageDraw.Draw(mascara).rounded_rectangle([0, 0, w - 1, h - 1], radius=5 * escala, fill=255)
    fondo = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    fondo.paste(carta, (0, 0), mascara)
    ImageDraw.Draw(fondo).rounded_rectangle([0, 0, w - 1, h - 1], radius=5 * escala,
                                            outline=(30, 32, 40, 255), width=escala)
    return fondo


def generar_atlas():
    img = Image.open(HOJA).convert("RGB")
    cajas = recortar_cartas(img)
    for escala in (1, 2):
        atlas = Image.new("RGBA", (W * escala * COLS, H * escala * FILAS), (0, 0, 0, 0))
        for i, caja in enumerate(cajas):
            atlas.paste(sprite(img, caja, escala), ((i % COLS) * W * escala, (i // COLS) * H * escala))
        out = ROOT / "assets" / f"{escala}x" / "kasino_cartas.png"
        atlas.save(out)
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
           "--- Los 100 comodines de la hoja de sprites (atlas kasino_cartas).", ""]
    for i, c in enumerate(COMODINES):
        cfg = ", ".join("%s = %s" % (k, lua_valor(v)) for k, v in c["cfg"].items())
        out.append("-- %d. %s" % (i + 1, c["nombre"]))
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
        out.append("        rarity = %d," % c["rareza"])
        out.append("        cost = %d," % c["coste"])
        out.append('        atlas = "cartas",')
        out.append("        pos = { x = %d, y = %d }," % (i % COLS, i // COLS))
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
    (ROOT / "comodines.lua").write_text("\n".join(out), encoding="utf-8")
    print("escrito comodines.lua")


# ---------------------------------------------------------------- docs

def texto_plano(c):
    valores = [1 if v == "prob" else c["cfg"][v] for v in c["vars"]]
    lineas = []
    for linea in c["texto"]:
        linea = re.sub(r"#(\d+)#", lambda m: str(valores[int(m.group(1)) - 1]), linea)
        linea = re.sub(r"\{[^}]*\}", "", linea)
        lineas.append(re.sub(r"\s+", " ", linea).strip())
    return " ".join(lineas).replace(" )", ")")


def generar_docs():
    filas = ["# Especificaciones de los 100 comodines", "",
             "Generado por `tools/generar_comodines.py`. La posición indica fila y columna",
             "en la hoja de sprites (`assets/fuente/hoja_comodines.webp`).", ""]
    resumen = {r: 0 for r in RAREZAS}
    for c in COMODINES:
        resumen[c["rareza"]] += 1
    filas.append("**Rarezas:** " + " · ".join("%s: %d" % (RAREZAS[r], n) for r, n in resumen.items()))
    filas += ["", "| # | Pos. | Comodín | Rareza | Coste | Efecto | Blueprint |",
              "|---|---|---|---|---|---|---|"]
    for i, c in enumerate(COMODINES):
        filas.append("| %d | F%d·C%d | **%s** | %s | $%d | %s | %s |" % (
            i + 1, i // COLS + 1, i % COLS + 1, c["nombre"], RAREZAS[c["rareza"]],
            c["coste"], texto_plano(c), "Sí" if c["bp"] else "No"))
    (ROOT / "COMODINES.md").write_text("\n".join(filas) + "\n", encoding="utf-8")
    print("escrito COMODINES.md")


if __name__ == "__main__":
    generar_atlas()
    generar_lua()
    generar_docs()
