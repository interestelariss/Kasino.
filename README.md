# Kasino — mod de Balatro

Añade **225 comodines** con arte pixel:

- **217 comodines** sacados de las tres hojas de sprites de `assets/fuente/`
  (100 + 65 + 52). Sus especificaciones (efecto, rareza y coste) están en
  **[COMODINES.md](COMODINES.md)**.
- **8 comodines de casino**, en la tabla de abajo.

## Comodines de casino

| Comodín | Rareza | Efecto |
|---|---|---|
| Tragaperras | Poco común | 1 entre 4 probabilidades de dar X3 multi |
| Crupier | Común | Cada 7 jugado da +7 multi al puntuar |
| Ruleta | Común | Corazones/Diamantes: +3 multi · Picas/Tréboles: +20 fichas |
| Full de Ases | Poco común | Gana X0.25 multi cada vez que juegas un Full |
| La Banca | Poco común | $2 al final de la ronda; +$1 por cada ciega jefe derrotada |
| Doble o Nada | Poco común | X2.5 multi, 1 entre 4 de destruirse al final de la ronda |
| Contador de Cartas | Común | +2 multi por carta descartada esta ronda (se reinicia) |
| As en la Manga | Poco común | Reactiva cada As jugado |

## Instalación

1. Instala [Lovely Injector](https://github.com/ethangreen-dev/lovely-injector) y
   [Steamodded](https://github.com/Steamodded/smods) (1.0.0 o superior).
2. Copia esta carpeta entera (con `main.lua`, `kasino_lib.lua`, `comodines.lua`, `Kasino.json` y `assets/`) en la carpeta de mods:
   - Windows: `%AppData%\Balatro\Mods\Kasino`
   - macOS: `~/Library/Application Support/Balatro/Mods/Kasino`
   - Linux (Proton): `~/.local/share/Steam/steamapps/compatdata/2379780/pfx/drive_c/users/steamuser/AppData/Roaming/Balatro/Mods/Kasino`
3. Abre Balatro. En el menú **Mods** debería aparecer *Kasino*.

## Editar los comodines de las hojas

Los efectos, rarezas y costes están en `tools/comodines.py` (hoja 1),
`tools/comodines_hoja2.py` y `tools/comodines_hoja3.py`. Después de cambiarlos, ejecuta:

```
pip install pillow
python3 tools/generar_comodines.py
```

Esto regenera `comodines.lua`, los atlas `assets/*/kasino_cartas*.png` y `COMODINES.md`.

## Editar los sprites de casino

Los iconos están definidos como mapas de píxeles en `tools/generar_sprites.py`.
Tras cambiarlos, regenera el atlas con:

```
pip install pillow
python3 tools/generar_sprites.py
```
