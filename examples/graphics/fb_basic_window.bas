'' https://www.freebasic.net/wiki/KeyPgDrawString

Const w=800, h=450
dim x as Integer, y as Integer, s as String

ScreenRes w, h, 24, , , 60  '' set resolution, color depth, refresh rate (requesting 60)

s = "FreeBASIC basic window"
x = (w - Len(s) * 8) \ 2 '' the default font is 8px per character
y = (h - 1 * 8) \ 2

Draw String (x, y), s

Sleep 

