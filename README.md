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

#### Menú de fusiones
Durante una partida, pulsa **Ctrl + F** o ve a **Opciones → FUSIONES**. Muestra:

- Las reglas de fusión.
- Tus comodines, uno por línea, con los otros comodines tuyos con los que puede
  fusionarse y qué rareza saldría. En **verde** salen las parejas que ya están
  juntas y se pueden fusionar ahora mismo.
- Las cartas de tu mano que tienen el mismo valor, para usar La Fusión.

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

### Cartas Casino
Un tipo de consumible nuevo, como el Tarot, con los dioses egipcios de
`assets/fuente/cartas_casino.webp`. Salen en la tienda y en el **Paquete del Nilo**.

| Carta | Efecto |
|---|---|
| Thoth | Sube 1 nivel tu mano de póker más jugada |
| Osiris | Revive el último comodín que vendiste |
| Isis | Convierte hasta 2 cartas seleccionadas en Cartas Marcadas |
| Hermes Trismegisto | Convierte hasta 2 cartas seleccionadas en Cartas Trucadas |
| Ra (Atum) | Todas las cartas de tu mano ganan +10 fichas permanentes |
| Anubis | Destruye 1 carta seleccionada y ganas $ igual a la mitad de su valor |
| Set (Seth) | Cambia a un valor aleatorio hasta 3 cartas seleccionadas |
| Shu | Roba 3 cartas extra (durante una ronda) |
| Tefnut | +1 mano en esta ronda |
| Horus | Da la edición Laminada a un comodín aleatorio sin edición |
| Neftis | Crea una carta Espectral |
| Seshat | $2 por cada tipo de mano de póker jugada en la partida (máx. $20) |
| Ma'at | 1 entre 2 de ganar $10; si no, pierdes $5 |
| Nut | Sube 2 niveles una mano de póker aleatoria |
| Geb | Hasta 3 cartas seleccionadas ganan +20 fichas permanentes |
| Iah (Jonsu) | Recuperas todos los descartes usados en esta ronda |

### Mejoras de carta
- **Carta Marcada**: +10 fichas y ganas $1 al puntuar.
- **Carta Trucada**: al puntuar, 1 entre 2 de X2 multi; si no, X0.75 multi.

### Tragaperras en la tienda
Botón **TRAGAPERRAS** debajo de "Volver a tirar". Cuesta $2 por tirada:

| Resultado | Premio |
|---|---|
| 7 · 7 · 7 | $20 |
| $ · $ · $ | $10 |
| BUFÓN ×3 | Un comodín aleatorio ($8 si no tienes hueco) |
| CEREZA ×3 | $6 |
| Dos iguales (que no sean calaveras) | $2 |

### Ciega jefe: El Crupier
Si las cartas jugadas suman más de 21 (figuras 10, As 11 o 1), la mano no puntúa.

### Paquetes
- **Paquete Casino** ($6): elige 1 de 3 comodines de Kasino.
- **Paquete del Nilo** ($4): elige 1 de 3 cartas Casino para usar al momento.

### Mazo del Casino
Puedes apostar Doble o Nada en todas las manos. −1 mano por ronda y $6 extra al empezar.

### Cupón: Mesa VIP ($10)
Doble o Nada y Ma'at ganan el 60 % de las veces, y la tragaperras cuesta $1.

### Desafíos
- **Todo o Nada**: todas las manos se juegan a Doble o Nada. Empiezas con Doble o Nada eterno.
- **Noche en el Casino**: empiezas con $0, Tragaperras, Crupier, Ruleta, La Banca y la Mesa VIP.
  Todas las ciegas jefe son El Crupier.
- **El Faraón**: la tienda solo vende cartas Casino como consumibles. Empiezas con Thoth,
  Ra y Nut, y 3 huecos de consumible.

### Panel de admin
Para probar el mod. Durante una partida, pulsa **Ctrl + K** o ve a
**Opciones → ADMIN KASINO**. Desde el panel puedes:

- Darte o quitarte dinero (−$100, −$10, −$1, +$1, +$10, +$100).
- Darte +1 mano, +1 descarte o +1 hueco de comodín, y quitar todos tus comodines.
- Abrir la colección en **modo admin** (Comodines, Tarot, Planetas, Espectrales,
  otros consumibles como las cartas Casino, y Cupones). Mientras estás en ese modo,
  **pulsar cualquier carta te la da**, sea del juego base o del mod. Los cupones se activan.

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
2. Copia esta carpeta entera (con todos los `.lua`, `Kasino.json` y `assets/`) en la carpeta de mods:
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
comodines y cartas Casino y comprueba la fusión, el Doble o Nada, la tragaperras,
la ciega jefe, las mejoras, los paquetes, el mazo y los desafíos. No sustituye a probarlo en el juego.

```
lua5.1 tools/prueba_humo.lua
```
