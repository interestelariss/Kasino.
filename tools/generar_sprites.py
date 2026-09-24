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


if __name__ == "__main__":
    main()
