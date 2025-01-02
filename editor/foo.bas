/'
  https://www.freebasic.net/wiki/KeyPgInkey
  (mostly lower-case code means I'm experimenting)
'/

#include "fbgfx.bi"

#if __FB_LANG__ = "fb"
using FB '' use the FB namespace
#endif

#define EXTCHAR chr(255)

dim k as string
dim c as ulong

c = color()

ScreenRes 960, 540, 32
Width 960\8, 540\16
Color RGB(248, 248, 242), RGB(40, 42, 54)
Cls
print "Console colors:"
print "Foreground: " & LoWord(c)
print "Background: " & HiWord(c)


do
  k = inkey$

  select case k
    case "A" to "Z", "a" to "z": print k
    case "1" to "9": print k
    case chr$(32): print "Space"
    case chr$(27): print "Escape"
    case chr$(9): print "Tab"
    case chr$(8): print "Backspace"
    case chr$(32) to chr$(127)
      print "Printable character: " & k
    case EXTCHAR & "G": Print "Up Left / Home"
    case EXTCHAR & "H": Print "Up"
    case EXTCHAR & "I": Print "Up Right / PgUp"
    case EXTCHAR & "K": Print "Left"
    case EXTCHAR & "L": Print "Center"
    case EXTCHAR & "M": Print "Right"
    case EXTCHAR & "O": Print "Down Left / End"
    case EXTCHAR & "P": Print "Down"
    case EXTCHAR & "Q": Print "Down Right / PgDn"
    case EXTCHAR & "R": Print "Insert"
    case EXTCHAR & "S": Print "Delete"
    case EXTCHAR & "k": Print "Close window / Alt-F4"
    case EXTCHAR & Chr$(59) To EXTCHAR & Chr$(68)
      print "Function key: F" & Asc(k, 2) - 58
    case EXTCHAR & Chr$(133) To EXTCHAR & Chr$(134)
      print "Function key: F" & Asc(k, 2) - 122
    case else
      if len(k) = 2 Then
           print Using "Extended character: chr$(###, ###)"; Asc(k, 1); Asc(k, 2)
       elseif Len(k) = 1 Then
           print Using "Character chr$(###)"; Asc(k)
       end if
  end select

loop until multikey(SC_ESCAPE) and multikey(SC_RSHIFT)
