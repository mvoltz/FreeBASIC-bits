#include "fbgfx.bi"
Using FB

Type ObjectType
  x As Single
  y As Single
  speed As Single
End Type

Dim Shared CircleM as ObjectType ''CircleM because circle is a reserved word

Screen 13,8,2,0 '' 320x200, 8-bit, 2 work pages, window mode (not fullscreen)
SetMouse 0,0,0  '' Posx, Posy, Hide

CircleM.x = 150
CircleM.y = 90
CircleM.speed = 1

Do '' start of loop

Cls ''clear screen
Circle (CircleM.x, CircleM.y), 10, 15

If MultiKey(SC_RIGHT) Then circleM.x = circleM.x + circleM.speed
If MultiKey(SC_LEFT) Then circleM.x = circleM.x - circleM.speed
If MultiKey(SC_DOWN) Then circleM.y = circleM.y + circleM.speed
If MultiKey(SC_UP) Then circleM.y = circleM.y - circleM.speed

Sleep 10, 1 '' 10 millisecond wait  FIXME
Loop Until MultiKey(SC_Q) Or MultiKey(SC_ESCAPE)

'' Loop Until Inkey$ = "Q" or Inkey$ = "q" '' this is a crude loop that we'll fix later




