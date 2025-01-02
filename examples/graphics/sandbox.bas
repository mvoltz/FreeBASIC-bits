'' the comment numbers show when I did something in the code

'' 1. ref: https://www.freebasic.net/wiki/KeyPgAddGfx

ScreenRes 800, 450, 16 '' 2. open a window

Const As Integer r = 32  '' 3. circle sprite

'' 9. randomize function ref: https://www.freebasic.net/wiki/KeyPgRnd
Function rnd_range (first as Integer, last as Integer) As Integer
    Function = Rnd * (last - first) + first
End Function

Dim c As Any Ptr = ImageCreate(r * 2 + 1, r * 2 + 1, 0)

'' 8. experimenting with random colors
Circle c, (r, r), r, RGB(rnd_range(100, 255), 255, rnd_range(0,255)), , , 1, f


'' 4. what is going on here?
'' 7. I think this is how we're making 3 circles and each is 'adding' values for a saturated appearance...

Put (146 - r, 108 - r), c, add,  64
Put (174 - r, 108 - r), c, add, 128
Put (160 - r,  84 - r), c, add, 192

'' 5. kill it
ImageDestroy c

'' 6. but wait...
Sleep 

