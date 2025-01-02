'' https://www.freebasic.net/wiki/KeyPgDrawString

dim as Integer w=800, h=450
dim x as Integer, y as Integer, s as String
dim font_ As Any Ptr = ImageCreate()
ScreenRes w, h, 24, , , 60  '' set resolution, color depth, refresh rate (requesting 60)

Width w\8, h\16 '' Change font size

s = "FreeBASIC basic window"
x = (w - Len(s) * 8) \ 2 '' the default font is 8px per character
y = (h - 1 * 16) \ 2

Draw String (x, y), s, , LiberationMono-Regular.bmp 

Sleep 

