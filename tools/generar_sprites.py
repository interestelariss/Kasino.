"""Genera el atlas de sprites de los comodines (assets/1x y assets/2x).

Cada comodin mide 71x95 px a 1x (el tamano estandar de Balatro).
Uso: python3 tools/generar_sprites.py   (requiere Pillow)
"""
from pathlib import Path
from PIL import Image, ImageDraw

W, H = 71, 95
ROOT = Path(__file__).resolve().parent.parent

PAL = {
    "K": (30, 32, 40), "W": (245, 245, 240), "R": (220, 60, 60),
    "r": (140, 30, 40), "Y": (250, 200, 60), "y": (190, 140, 30),
    "G": (60, 170, 90), "g": (30, 100, 60), "B": (70, 130, 220),
    "b": (40, 70, 140), "O": (240, 140, 50), "D": (90, 90, 100),
    "L": (170, 170, 180), "P": (150, 90, 200), "S": (240, 200, 160),
    "N": (140, 90, 50),
}

# Iconos de 16x16 ("." = transparente)
ICONOS = {
    "tragaperras": [
        "................",
        "..KKKKKKKKKKK...",
        ".KYYYYYYYYYYYK..",
        ".KYKKKKKKKKKYK.K",
        ".KYKWWKWWKWWYKKR",
        ".KYKRRKRRKRRYK.K",
        ".KYKWRKWRKWRYK.K",
        ".KYKRWKRWKRWYK.K",
        ".KYKWWKWWKWWYKKK",
        ".KYKKKKKKKKKYK..",
        ".KYYYYYYYYYYYK..",
        ".KyyyyyyyyyyyK..",
        ".KyKKKKKKKKKyK..",
        ".KyyyyyyyyyyyK..",
        "..KKKKKKKKKKK...",
        "................",
    ],
    "crupier": [
        "................",
        ".....KKKKKK.....",
        "...KKGGGGGGKK...",
        "..KGGGGGGGGGGK..",
        ".KKKKKKKKKKKKKK.",
        "....KSSSSSSK....",
        "....KSKSSKSK....",
        "....KSSSSSSK....",
        "....KSSKKSSK....",
        ".....KSSSSK.....",
        "......KKKK......",
        "...KRRK..KRRK...",
        "...KRRRKKRRRK...",
        "...KRRK..KRRK...",
        "...KKK....KKK...",
        "................",
    ],
    "ruleta": [
        "................",
        ".....KKKKKK.....",
        "...KKRKRKRKKK...",
        "..KRKRKRKRKRKK..",
        "..KKRKNNNNKRKK..",
        ".KRKNNNNNNNNKRK.",
        ".KKRNNNYYNNNRKK.",
        ".KRKNNYWWYNNKRK.",
        ".KKRNNYWWYNNRKK.",
        ".KRKNNNYYNNNKRK.",
        "..KKRNNNNNNRKK..",
        "..KRKRNNNNKRKK..",
        "...KKRKRKRKKK...",
        ".....KKKKKK.....",
        "................",
        "................",
    ],
    "full_de_ases": [
        "................",
        "...KKKKKKKKK....",
        "...KWWWWWWWKK...",
        "...KWKWWWWWKWK..",
        "...KKWKWWWWKWK..",
        "...KWWWWKWWKWK..",
        "...KWWWKKKWKWK..",
        "...KWWKKKKKKWK..",
        "...KWKKKKKKKWK..",
        "...KWKKWKWKKWK..",
        "...KWWWWKWWKWK..",
        "...KWWWKKKWKWK..",
        "...KWWWWWWKWWK..",
        "...KKKKKKKKKWK..",
        "....KKKKKKKKKK..",
        "................",
    ],
    "la_banca": [
        "................",
        "......KKKK......",
        ".......KK.......",
        "......KyyK......",
        ".....KKKKKK.....",
        "....KNNNNNNK....",
        "...KNNNYYNNNK...",
        "..KNNNYNNNNNNK..",
        "..KNNNNYYNNNNK..",
        "..KNNNNNNYNNNK..",
        "..KNNNYYYNNNNK..",
        "..KNNNNYNNNNNK..",
        "...KNNNNNNNNK...",
        "....KKKKKKKK....",
        "................",
        "................",
    ],
    "doble_o_nada": [
        "................",
        ".KKKKKKK........",
        ".KWWWWWK........",
        ".KWKWWWK........",
        ".KWWWWWK........",
        ".KWWWKWK........",
        ".KWWWWWK........",
        ".KKKKKKK.KKKKKK.",
        ".........KRRRRK.",
        ".........KWRRWK.",
        ".........KRRRRK.",
        ".........KRWWRK.",
        ".........KRRRRK.",
        ".........KWRRWK.",
        ".........KKKKKK.",
        "................",
    ],
    "contador": [
        "................",
        "......KKKKKKK...",
        ".....KBBBBBBBK..",
        "....KKKKKKKKBK..",
        "...KWWWWWWWKBK..",
        "..KKKKKKKKWKBK..",
        "..KWWWWWWKWKBK..",
        "..KWRWWWWKWKK...",
        "..KWWWKWWKWK....",
        "..KWWKKKWKWK....",
        "..KWWWKWWKK.....",
        "..KWWWWWWK......",
        "..KWWWWRWK......",
        "..KKKKKKKK......",
        "................",
        "................",
    ],
    "as_en_la_manga": [
        "................",
        "........KKKKK...",
        ".......KWWWWK...",
        "......KWRWWWK...",
        ".....KWWWRWWK...",
        "....KWWRRRWK....",
        "KKKKKKKWWWKK....",
        "KPPPPPPKKKK.....",
        "KPLLLLLLPPK.....",
        "KPPPPPPPPPPK....",
        "KPPPPPPPSSSSK...",
        "KPLLLLLLSSSSK...",
        "KPPPPPPPSSSK....",
        "KKKKKKKKKKK.....",
        "................",
        "................",
    ],
}

# Iconos de los consumibles (atlas kasino_consumibles)
ICONOS["fusion"] = [
    "................",
    ".KKKKK....KKKKK.",
    ".KWWWK....KWWWK.",
    ".KRWWK....KWWBK.",
    ".KWWWK....KWWWK.",
    ".KWWRK....KBWWK.",
    ".KKKKK....KKKKK.",
    "...KY......YK...",
    "....KY....YK....",
    ".....KYYYYK.....",
    "....KKKKKKKK....",
    "....KWRWWBWK....",
    "....KWWYYWWK....",
    "....KWBWWRWK....",
    "....KKKKKKKK....",
    "................",
]
ICONOS["ficha"] = [
    "................",
    ".....KKKKKK.....",
    "...KKRRWWRRKK...",
    "..KRRRRWWRRRRK..",
    ".KWRRKKKKKKRRWK.",
    ".KWRKYYYYYYKRWK.",
    "KRRKYYKYYKYYKRRK",
    "KWWKYKYKYKYYKWWK",
    "KWWKYYKYKYYYKWWK",
    "KRRKYYYYYYYYKRRK",
    ".KWRKYYYYYYKRWK.",
    ".KWRRKKKKKKRRWK.",
    "..KRRRRWWRRRRK..",
    "...KKRRWWRRKK...",
    ".....KKKKKK.....",
    "................",
]
ICONOS["corona"] = [
    "................",
    "................",
    "..K....KK....K..",
    ".KYK..KYYK..KYK.",
    ".KYYK.KYYK.KYYK.",
    ".KYYYKYYYYKYYYK.",
    ".KYYYYYRRYYYYYK.",
    ".KYYYYRRRRYYYYK.",
    ".KYYYYYRRYYYYYK.",
    ".KyyyyyyyyyyyyK.",
    ".KYYBYYYYYYBYYK.",
    ".KyyyyyyyyyyyyK.",
    ".KKKKKKKKKKKKKK.",
    "................",
    "................",
    "................",
]
CONSUMIBLES = [("fusion", (150, 90, 200))]
# Paquete Casino, Mazo del Casino y cupon Mesa VIP (atlas kasino_extras, x = 2, 3, 4)
EXTRAS_ICONOS = [("ficha", (200, 60, 60)), ("ficha", (220, 170, 40)), ("corona", (220, 170, 40))]
# Cajas de las 16 cartas en assets/fuente/cartas_casino.webp (x0, y0, x1, y1)
CAJAS_CASINO = (
    [(x0, 9, x1, 340) for x0, x1 in [(64, 311), (355, 598), (645, 889), (936, 1177), (1224, 1470)]]
    + [(x0, 353, x1, 668) for x0, x1 in [(64, 311), (355, 598), (645, 889), (936, 1177), (1224, 1470)]]
    + [(x0, 678, x1, 1007) for x0, x1 in [(22, 252), (287, 512), (545, 761), (780, 1002), (1032, 1252),
                                          (1283, 1507)]]
)

# Orden en el atlas (x = columna) y color del marco de cada carta
ORDEN = [
    ("tragaperras", (200, 60, 60)),
    ("crupier", (60, 150, 90)),
    ("ruleta", (200, 60, 60)),
    ("full_de_ases", (70, 110, 200)),
    ("la_banca", (220, 170, 40)),
    ("doble_o_nada", (150, 90, 200)),
    ("contador", (70, 110, 200)),
    ("as_en_la_manga", (150, 90, 200)),
]


def carta(icono, marco):
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rounded_rectangle([0, 0, W - 1, H - 1], radius=5, fill=PAL["K"])
    d.rounded_rectangle([1, 1, W - 2, H - 2], radius=4, fill=(236, 232, 220))
    d.rounded_rectangle([3, 3, W - 4, H - 4], radius=3, outline=marco, width=2)
    # Fondo del retrato
    d.rectangle([8, 12, W - 9, H - 22], fill=(40, 48, 60))
    d.rectangle([8, 12, W - 9, H - 22], outline=PAL["K"])
    # Placa inferior
    d.rectangle([12, H - 17, W - 13, H - 10], fill=marco, outline=PAL["K"])
    # Icono escalado x3 y centrado en el retrato
    esc = 3
    ox = (W - 16 * esc) // 2
    oy = 12 + ((H - 22 - 12) - 16 * esc) // 2 + 1
    for y, fila in enumerate(ICONOS[icono]):
        for x, c in enumerate(fila):
            if c != ".":
                d.rectangle([ox + x * esc, oy + y * esc,
                             ox + x * esc + esc - 1, oy + y * esc + esc - 1],
                            fill=PAL[c])
    return img


def main():
    atlas = Image.new("RGBA", (W * len(ORDEN), H), (0, 0, 0, 0))
    for i, (nombre, marco) in enumerate(ORDEN):
        assert all(len(f) == 16 for f in ICONOS[nombre]) and len(ICONOS[nombre]) == 16, nombre
        atlas.paste(carta(nombre, marco), (i * W, 0))
    for escala in (1, 2):
        out = ROOT / "assets" / f"{escala}x" / "kasino_jokers.png"
        out.parent.mkdir(parents=True, exist_ok=True)
        atlas.resize((atlas.width * escala, atlas.height * escala),
                     Image.NEAREST).save(out)
        print("escrito", out.relative_to(ROOT))


    consumibles = Image.new("RGBA", (W * len(CONSUMIBLES), H), (0, 0, 0, 0))
    for i, (nombre, marco) in enumerate(CONSUMIBLES):
        consumibles.paste(carta(nombre, marco), (i * W, 0))
    for escala in (1, 2):
        out = ROOT / "assets" / f"{escala}x" / "kasino_consumibles.png"
        consumibles.resize((consumibles.width * escala, consumibles.height * escala),
                           Image.NEAREST).save(out)
        print("escrito", out.relative_to(ROOT))


def mejora_marcada():
    """Fondo de la Carta Marcada: carta clara con marcas rojas en las esquinas."""
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rounded_rectangle([0, 0, W - 1, H - 1], radius=5, fill=PAL["K"])
    d.rounded_rectangle([1, 1, W - 2, H - 2], radius=4, fill=(250, 244, 236))
    d.rounded_rectangle([3, 3, W - 4, H - 4], radius=3, outline=(230, 150, 150), width=1)
    for x, y in [(5, 5), (W - 10, 5), (5, H - 10), (W - 10, H - 10)]:
        d.line([x, y, x + 4, y + 4], fill=PAL["R"], width=2)
        d.line([x + 4, y, x, y + 4], fill=PAL["R"], width=2)
    return img


def mejora_trucada():
    """Fondo de la Carta Trucada: tapete verde claro con borde dorado y puntos de dado."""
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rounded_rectangle([0, 0, W - 1, H - 1], radius=5, fill=PAL["K"])
    d.rounded_rectangle([1, 1, W - 2, H - 2], radius=4, fill=(206, 234, 214))
    d.rounded_rectangle([2, 2, W - 3, H - 3], radius=4, outline=PAL["Y"], width=2)
    for x, y in [(8, 8), (W - 12, 8), (8, H - 12), (W - 12, H - 12), (W // 2 - 2, 8), (W // 2 - 2, H - 12)]:
        d.rectangle([x, y, x + 3, y + 3], fill=PAL["g"])
    return img


def ficha_ciega(escala):
    """Ficha de la ciega jefe El Crupier: 21 fotogramas de 34x34 (iguales)."""
    t = 34 * escala
    ficha = Image.new("RGBA", (t, t), (0, 0, 0, 0))
    d = ImageDraw.Draw(ficha)
    d.ellipse([1, 1, t - 2, t - 2], fill=PAL["K"])
    d.ellipse([2 * escala, 2 * escala, t - 3 * escala, t - 3 * escala], fill=(30, 110, 70))
    for i in range(8):
        import math
        a = i * math.pi / 4
        cx, cy = t / 2 + math.cos(a) * t * 0.38, t / 2 + math.sin(a) * t * 0.38
        r = 2.5 * escala
        d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=PAL["W"])
    d.ellipse([9 * escala, 9 * escala, t - 10 * escala, t - 10 * escala], fill=PAL["K"])
    # "21" en pixeles
    digitos = ["KKK.K", "..K.K", "KKK.K", "K...K", "KKK.K"]
    p = escala
    ox, oy = t // 2 - 3 * p, t // 2 - 3 * p
    for y, fila in enumerate(digitos):
        for x, c in enumerate(fila):
            if c == "K":
                d.rectangle([ox + x * 1.3 * p, oy + y * 1.3 * p, ox + (x + 1) * 1.3 * p - 1, oy + (y + 1) * 1.3 * p - 1],
                            fill=PAL["Y"])
    atlas = Image.new("RGBA", (t * 21, t), (0, 0, 0, 0))
    for i in range(21):
        atlas.paste(ficha, (i * t, 0))
    return atlas


def generar_extras():
    extras = Image.new("RGBA", (W * 5, H), (0, 0, 0, 0))
    extras.paste(mejora_marcada(), (0, 0))
    extras.paste(mejora_trucada(), (W, 0))
    for i, (nombre, marco) in enumerate(EXTRAS_ICONOS):
        extras.paste(carta(nombre, marco), ((i + 2) * W, 0))
    fuente = Image.open(ROOT / "assets" / "fuente" / "cartas_casino.webp").convert("RGB")
    for escala in (1, 2):
        out = ROOT / "assets" / f"{escala}x"
        extras.resize((extras.width * escala, extras.height * escala), Image.NEAREST).save(out / "kasino_extras.png")
        ficha_ciega(escala).save(out / "kasino_ciegas.png")
        casino = Image.new("RGBA", (W * escala * 8, H * escala * 2), (0, 0, 0, 0))
        for i, caja in enumerate(CAJAS_CASINO):
            c = fuente.crop(caja).resize((W * escala, H * escala), Image.LANCZOS).convert("RGBA")
            mascara = Image.new("L", c.size, 0)
            ImageDraw.Draw(mascara).rounded_rectangle([0, 0, c.width - 1, c.height - 1], radius=4 * escala, fill=255)
            casino.paste(c, ((i % 8) * W * escala, (i // 8) * H * escala), mascara)
        casino.save(out / "kasino_casino.png")
        print("escrito extras, ciegas y cartas casino en", out.relative_to(ROOT))


if __name__ == "__main__":
    main()
    generar_extras()
