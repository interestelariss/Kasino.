# Kasino — mod de Balatro

Añade **225 comodines** con arte pixel:

- **217 comodines** sacados de las tres hojas de sprites de `assets/fuente/`
  (100 + 65 + 52). Sus especificaciones (efecto, rareza y coste) están en
  **[COMODINES.md](COMODINES.md)**.
- **8 comodines de casino**, en la tabla de abajo.

## Comodines de casino

| Comodín | Rareza | Efecto |
|---|---|---|
| Tragaperras | Poco común | 1 entre 4 probabilidades de dar X2 multi |
| Crupier | Común | Cada 7 jugado da +7 multi al puntuar |
| Ruleta | Común | Corazones/Diamantes: +3 multi · Picas/Tréboles: +20 fichas |
| Full de Ases | Poco común | Gana X0.15 multi cada vez que juegas un Full |
| La Banca | Poco común | Al final de la ronda, $1 por cada comodín que tengas |
| Doble o Nada | Poco común | X1.5 multi; al final de la ronda, a cara o cruz gana o pierde X0.25 (se destruye en X1) |
| Contador de Cartas | Común | +2 multi por carta descartada esta ronda (se reinicia) |
| As en la Manga | Poco común | Reactiva cada As jugado |

## Mecánicas nuevas

### Fusión de comodines
Cada comodín tiene un botón **FUSIONAR** debajo del de vender. Se activa cuando el
comodín de su **derecha** es de la misma rareza: los dos desaparecen y aparece un
comodín aleatorio de la rareza siguiente.

| Fusionas | Obtienes |
|---|---|
| 2 Comunes | 1 Poco común |
| 2 Poco comunes | 1 Raro |
| 2 Raros | 1 Legendario de Kasino |

Los legendarios y los comodines eternos no se pueden fusionar.

### La Fusión (carta de Tarot)
Selecciona **2 cartas del mismo valor** y úsala: la de la izquierda absorbe a la
otra. Suma sus fichas, hereda su sello y, si no tenía mejora, gana una al azar.
Sale en la tienda y en los paquetes arcanos como cualquier Tarot.

### Doble o Nada
En la **última mano** de cada ronda se ilumina el botón **DOBLE O NADA** junto a
Jugar y Descartar. Si lo pulsas antes de jugar la mano, al puntuarla se lanza una
moneda (50 %):

- **¡DOBLE!**: la puntuación de esa mano se multiplica por 2.
- **¡NADA!**: la mano puntúa 0.

Puedes volver a pulsarlo para cancelar la apuesta antes de jugar.

## Probabilidades en la tienda

Con los pesos del juego (tienda sin cupones: comodín 20, Tarot 4, Planeta 4) y
contando los comodines del juego base que comparten rareza:

| Rareza | Peso de la rareza | Comodines Kasino | Algún Kasino por hueco | Uno concreto por hueco |
|---|---|---|---|---|
| Común | 69.3 % | 103 de 164 | 30.8 % | 0.31 % |
| Poco común | 24.8 % | 101 de 165 | 10.6 % | 0.11 % |
| Raro | 5.0 % | 20 de 40 | 1.8 % | 0.09 % |
| Legendario | 1.0 % | 9 de 9 | 0.7 % | 0.08 % |

En el juego base los legendarios solo salen con la carta espectral El Alma. Los de
Kasino usan una rareza propia (`kas_legendario`, peso 0.01) para salir también en
la tienda y en los paquetes de bufón; a cambio, El Alma no los genera.

## Instalación

1. Instala [Lovely Injector](https://github.com/ethangreen-dev/lovely-injector) y
   [Steamodded](https://github.com/Steamodded/smods) (1.0.0 o superior).
2. Copia esta carpeta entera (con `main.lua`, `kasino_lib.lua`, `kasino_features.lua`, `comodines.lua`, `Kasino.json` y `assets/`) en la carpeta de mods:
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

## Prueba de humo

`tools/prueba_humo.lua` carga el mod con un Balatro simulado, ejecuta todos los
comodines y comprueba la fusión y el Doble o Nada. No sustituye a probarlo en el juego.

```
lua5.1 tools/prueba_humo.lua
```
