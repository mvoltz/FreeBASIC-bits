#include "BitmapFont.bi"
screenres 900,300,32
for x as integer = 0 to 899
  for y as integer = 0 to 299
    pset (x, y), x xor y
  next y
next x

'example 1:
'load font into a "font object" with object own plot routine
dim as BitmapFont FontA
FontA.LoadFont ("ArtDeco\ArtDeco.bmp")
FontA.PenColor=&HFF0000
FontA.Background=&HFF00ff
FontA.UseBackGround=0
FontA.Print (0,10,10,"ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789")
FontA.PenColor=&H00FFFF
FontA.monospaced=16
FontA.Print (0,10,40,"ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789 forced monospaced")

'example 2:
'load font into a FBImage and use DRAW STRING
dim as uinteger ptr fontimg'<- Image!!!
fontimg=LoadFBFont ("ArtDeco\ArtDeco.bmp")
draw string (10, 130), "ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789",&HFF0000, fontimg

imagedestroy fontimg'<- Image!!!
sleep
