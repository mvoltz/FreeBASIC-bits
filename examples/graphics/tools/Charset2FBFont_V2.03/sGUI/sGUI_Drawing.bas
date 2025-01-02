'******************************************************************************
'******************************************************************************
'GFX***************************************************************************

declare sub InitGFX (clearscreen as integer=1)

declare function ShiftRGB (col as uinteger,shift as integer) as uinteger
declare sub ClearBox (PosX as integer,PosY as integer,BoxWidth as integer,BoxHeight as integer,col as uinteger=BackGroundColor)

declare sub FrameT (PosX as integer, PosY as integer, BoxWidth as integer, BoxHeight as integer, txt as string="")
declare sub FillA (PosX as integer,PosY as integer,BoxWidth as integer,BoxHeight as integer,fill as uinteger=GadgetColor,frame as uinteger=GadgetFrameColor,switch as integer)
declare sub FillC (PosX as integer,PosY as integer,col as uinteger=GadgetColor,switch as integer)
declare sub FillE (PosX as integer,PosY as integer,BoxWidth as integer,BoxHeight as integer,fill as uinteger=white,frame as uinteger=GadgetFrameColor,switch as integer,mode as integer)

declare sub FakeWindow (PosX as integer,PosY as integer,BoxWidth as integer,Boxheight as integer,Text as string="",fill as uinteger=GadgetColor,frame as uinteger=GadgetFrameColor)
declare sub GetInnerMeasures (BoxPosX as integer,BoxPosY as integer,Boxwidth as integer,Boxheight as integer,byref GuiPosX as integer,byref GuiPosY as integer,byref Guiwidth as integer,byref Guiheight as integer)
declare sub GetOuterMeasures (GuiWidth as integer,GuiHeight as integer,byref Boxwidth as integer,byref Boxheight as integer)

declare sub Tick (PosX as integer,PosY as integer, col as uinteger)
declare sub Dot (PosX as integer,PosY as integer, col as uinteger)
declare sub Arrow (PosX as integer,PosY as integer,size as integer,d as integer,col as uinteger)

declare sub Separator (PosX as integer,PosY as integer,swidth as integer)



sub InitGFX (clearscreen as integer=1)
	dim as ColorDefinition c
	if CustomColors=0 then
    BackGroundColor	    =&HF0F0F0
    TextColor				     =black
    GadgetColor			    =&HEAEAEA
    GadgetFrameColor    =&HACACAC
    GadgetGlowColor	    =&HE4F0FC
    GadgetGlowFrameColor=&H3399FF
    GadgetTextColor	    =black
    c.SetRGB(BackGroundColor)
    c.ShiftValue(-10)    
    GadgetDarkFillColor	=c.GetRGB
    CursorColor			    =&H337FFF
    MenuColor       =BackGroundColor
    MenuTextColor   =black
    MenuHiliteColor =GadgetColor
    c.SetRGB(MenuColor)
    c.ShiftValue(-20)
    MenuGhostlyColor=c.GetRGB
  end if

  if clearscreen then
    color TextColor,BackGroundColor
    cls
  end if
end sub


'******************************************************************************
'******************************************************************************
'******************************************************************************
'es folgen alle Grafikelemente und Farbroutinen, die in irgend einer Weise in den Gadgets benutzt werden (können)
'also eine Art Grafik-Baukasten



'erhöht/verringert die RGB Werte einer Farbe um den Wert shift
'eine einfache Additions/Subtraktionsvariante
function ShiftRGB (col as uinteger,shift as integer) as uinteger
  dim as integer red,green,blue
  'RGB Splitting
  'mal wieder Volta
  'siehe http://forum.qbasic.at/viewtopic.php?t=4274&highlight=rgb
  red  =((col shr 16) and &HFF)+shift
	green=((col shr 8) and &HFF )+shift
	blue =(col and &HFF         )+shift
	if red<0 then red=0
  if green<0 then green=0
  if blue<0 then blue=0
	if red>255 then red=255
  if green>255 then green=255
  if blue>255 then blue=255
  function=rgb(red,green,blue)
end function



'von allen Gadgets als Reinigungsdienst benutzt
sub ClearBox (PosX as integer,PosY as integer,BoxWidth as integer,BoxHeight as integer,col as uinteger=BackGroundColor)
	line (PosX,PosY)-(PosX+BoxWidth-1,PosY+BoxHeight-1),col,BF
end sub



'Rahmen(hintergrundbezogen) in zwei Schaltzuständen, ungefüllt
'SimpleGadget,ToggleGadget,CheckmarkGadget
sub FrameB (PosX as integer, PosY as integer, BoxWidth as integer, BoxHeight as integer,col as uinteger=BackGroundColor,switch as integer)
	dim as ColorDefinition topleft,bottomright,ptopleft,pmiddle,pbottomright
  topleft.SetRGB(col)
  bottomright.SetRGB(col)
  ptopleft.SetRGB(col)
  pmiddle.SetRGB(col)
  pbottomright.SetRGB(col)

  'Farben für Hintergrundfase setzen
  if switch then
    topleft.ShiftValue(-50)
    bottomright.ShiftValue(50)
  else
    topleft.ShiftValue(-50)
    bottomright=topleft
	end if

  pset (PosX,PosY),ptopleft.GetRGB
  pset (PosX+BoxWidth-1,PosY),pmiddle.GetRGB
  pset (PosX+BoxWidth-1,PosY+BoxHeight-1),pmiddle.GetRGB
  pset (PosX,PosY+BoxHeight-1),pbottomright.GetRGB

  line (PosX+1,PosY)-(PosX+BoxWidth-2,PosY),topleft.GetRGB
  line (PosX+BoxWidth-1,PosY+1)-(PosX+BoxWidth-1,PosY+BoxHeight-2),bottomright.GetRGB
  line (PosX+BoxWidth-2,PosY+BoxHeight-1)-(PosX+1,PosY+BoxHeight-1),bottomright.GetRGB
  line (PosX,PosY+BoxHeight-2)-(PosX,PosY+1),topleft.GetRGB
end sub



'Rahmen (hintergrundbezogen) mit Text, gefüllt, für Gliederung der Oberfläche
sub FrameT (PosX as integer, PosY as integer, BoxWidth as integer, BoxHeight as integer, txt as string="")
  dim as integer foheight,txtwidth
  foheight=GetFontHeight
  txtwidth=GetTextWidth(txt)

  dim as ColorDefinition lite,dark
  lite.SetRGB(BackgroundColor)
  dark.SetRGB(BackgroundColor)
  if lite.GetSaturation then 'wenn Sättigung>0 ist es eine Farbe
    lite.ShiftSaturation(-50)
    dark.ShiftSaturation(50)
  else                      'Wenn Sättigung=0 Grauwert
    lite.ShiftValue(-50)
    dark.ShiftValue(50)
  end if

	line (PosX+1,PosY+1)-(PosX+BoxWidth-1,PosY+BoxHeight-1),lite.GetRGB,b
  line (PosX,PosY)-(PosX+BoxWidth-2,PosY+BoxHeight-2),dark.GetRGB,b
  line (PosX+2,PosY+2)-(PosX+BoxWidth-3,PosY+BoxHeight-3),BackGroundColor,bf 'Löschen des Frameinneren

	if txtwidth then
    line(PosX+2*minspace,PosY-foheight/2)-(PosX+2*minspace+txtwidth,PosY-foheight/2 + foheight),BackGroundColor,bf
    DrawString(PosX+2*minspace,PosY-foheight/2,txt)
  end if
end sub



'gefüllte farbige Box in zwei Schaltzuständen
'SimpleGadget,ToggleGadget,CheckmarkGadget
Sub FillA (PosX as integer,PosY as integer,BoxWidth as integer,BoxHeight as integer,fill as uinteger=GadgetColor,frame as uinteger=GadgetFrameColor,switch as integer)
	dim as ColorDefinition frm,fll
  frm.SetRGB(frame)
  fll.SetRGB(fill)
  if switch then
  	frm.Shiftvalue(-20)
    fll.Shiftvalue(-20)
	end if
	line(PosX,PosY)-(PosX+BoxWidth-1,PosY+BoxHeight-1),frm.GetRGB,b
	line(PosX+1,PosY+1)-(PosX+BoxWidth-2,PosY+BoxHeight-2),fll.GetRGB,bf
end sub



'Radiobutton Frame 16x16
Sub FillC (PosX as integer,PosY as integer,col as uinteger=GadgetColor,switch as integer)
	dim as ColorDefinition frm,fll
  frm.SetRGB(col)
  fll.SetRGB(col)
  if fll.GetSaturation then 'wenn Sättigung>0 ist es eine Farbe, modifiziere Sättigung
    frm.ShiftSaturation(50)
  else                      'Wenn Sättigung=0 Grauwert, modifiziere Schwarzwert
    frm.ShiftValue(-25)
  end if
  if switch then
  	frm.Shiftvalue(-20)
    fll.Shiftvalue(-20)
	end if

  line(PosX+5,PosY)-(PosX+10,PosY),frm.GetRGB
    line(PosX+10,PosY)-(PosX+13,PosY+2),frm.GetRGB
    line(PosX+13,PosY+2)-(PosX+15,PosY+5),frm.GetRGB
  line(PosX+15,PosY+5)-(PosX+15,PosY+10),frm.GetRGB
    line(PosX+15,PosY+10)-(PosX+13,PosY+13),frm.GetRGB
    line(PosX+13,PosY+13)-(PosX+10,PosY+15),frm.GetRGB
  line(PosX+10,PosY+15)-(PosX+5,PosY+15),frm.GetRGB
    line(PosX+5,PosY+15)-(PosX+2,PosY+13),frm.GetRGB
    line(PosX+2,PosY+13)-(PosX,PosY+10),frm.GetRGB
  line(PosX,PosY+10)-(PosX,PosY+5),frm.GetRGB  
    line(PosX,PosY+5)-(PosX+2,PosY+2),frm.GetRGB
    line(PosX+2,PosY+2)-(PosX+5,PosY),frm.GetRGB    
  paint(PosX+7,PosY+7),white,frm.GetRGB
    
    if fll.GetSaturation then 'wenn Sättigung>0 ist es eine Farbe
      fll.ShiftSaturation(50)
    else                      'Wenn Sättigung=0 Grauwert
      fll.ShiftValue(-50)
    end if
  if switch then Dot (PosX+4,PosY +4,fll.GetRGB)
end sub


Sub FillE (PosX as integer,PosY as integer,BoxWidth as integer,BoxHeight as integer,fill as uinteger=white,frame as uinteger=GadgetFrameColor,switch as integer,mode as integer)
	dim as ColorDefinition frm,fll
  frm.SetRGB(frame)
  fll.SetRGB(fill)
  if switch then
  	frm.Shiftvalue(-10)
    'fll.Shiftvalue(-.5)
	end if

  select case mode
    case 0
      line(PosX,PosY)-(PosX+BoxWidth-1,PosY+BoxHeight-1),frm.GetRGB,b
      line (PosX+1,PosY+1)-(PosX+BoxWidth-2,PosY+BoxHeight-2),fll.GetRGB,BF
    case 1'rechts ohne Umrandung
      line(PosX,PosY)-(PosX+BoxWidth-1,PosY+BoxHeight-1),frm.GetRGB,b
      line (PosX+1,PosY+1)-(PosX+BoxWidth-1,PosY+BoxHeight-2),fll.GetRGB,BF
    case 3'Rechts u. unten ohne Umrandung
      line(PosX,PosY)-(PosX+BoxWidth-1,PosY+BoxHeight-1),frm.GetRGB,b
      line (PosX+1,PosY+1)-(PosX+BoxWidth-1,PosY+BoxHeight-1),fll.GetRGB,BF
  End Select
end sub



sub FakeWindow (PosX as integer,PosY as integer,BoxWidth as integer,BoxHeight as integer,Text as string="",fill as uinteger=GadgetColor,frame as uinteger=GadgetFrameColor)
  FillA PosX,PosY,BoxWidth,BoxHeight,fill,frame,0
  FillA PosX + bspace + 1, PosY + GetFontHeight + 2*bspace + 1, BoxWidth - 2*bspace - 2, BoxHeight - (GetFontHeight+2*bspace) - bspace - 2, BackGroundColor,frame,0
  drawstring (PosX+int((BoxWidth-GetTextWidth(Text))/2), PosY+bspace, Text, TextColor)
end sub



sub GetInnerMeasures (BoxPosX as integer,BoxPosY as integer,Boxwidth as integer,Boxheight as integer,byref GuiPosX as integer,byref GuiPosY as integer,byref Guiwidth as integer,byref Guiheight as integer)
  GuiPosX  =BoxPosX + bspace + 2
  GuiPosY  =BoxPosY + GetFontHeight + 2*bspace + 2
  Guiwidth =Boxwidth - (2*bspace + 4)
  Guiheight=Boxheight -(GetFontHeight + 2*bspace + bspace + 4)
end sub



sub GetOuterMeasures (GuiWidth as integer,GuiHeight as integer,byref Boxwidth as integer,byref Boxheight as integer)
  Boxwidth =GuiWidth +  2*bspace + 4
  Boxheight=GuiHeight +  GetFontHeight + 2*bspace + bspace + 4
end sub



'farbiges Symbol
'"Häkchen" für CheckMarkGadget 8x9 px
sub Tick (PosX as integer,PosY as integer, col as uinteger)
  line(PosX+1,PosY+4)-(PosX+4,PosY+7),col
  line(PosX,PosY+4)-(PosX+3,PosY+7),col

  line(PosX+4,PosY+7)-(PosX+7,PosY),col
  line(PosX+3,PosY+7)-(PosX+6,PosY),col
end sub



'farbiges Symbol
'RadiobuttonDot  8x8 px
sub Dot (PosX as integer,PosY as integer, col as uinteger)
	dim as ColorDefinition frm,fll
  frm.SetRGB(col)
  fll.SetRGB(col)
  
  if fll.GetSaturation then 'wenn Sättigung>0 ist es eine Farbe
    frm.ShiftSaturation(33)
  else                      'Wenn Sättigung=0 Grauwert
    frm.ShiftValue(-33)
  end if

  line(PosX+2,PosY)-(PosX+5,PosY),frm.GetRGB
    pset(PosX+6,PosY+1),frm.GetRGB
  line(PosX+7,PosY+2)-(PosX+7,PosY+5),frm.GetRGB
    pset(PosX+6,PosY+6),frm.GetRGB
  line(PosX+5,PosY+7)-(PosX+2,PosY+7),frm.GetRGB
    pset(PosX+1,PosY+6),frm.GetRGB
  line(PosX,PosY+5)-(PosX,PosY+2),frm.GetRGB
    pset(PosX+1,PosY+1),frm.GetRGB
  paint(PosX+3,PosY+3),fll.GetRGB,frm.GetRGB
end sub



'farbiges Symbol
'Pfeil
sub Arrow (PosX as integer,PosY as integer,size as integer,d as integer,col as uinteger)
  for i as integer=0 to 2
    select case d
      case 0'l
        line(PosX+size+i,PosY)-(PosX+i,PosY+size),col
        line                -(PosX+size+i,PosY+2*size),col
      case 1'r
        line(PosX+i,PosY)-(PosX+size+i,PosY+size),col
        line                -(PosX+i,PosY+2*size),col
      case 2'up
        line(PosX,PosY+size+i)-(PosX+size,PosY+i),col
        line                -(PosX+2*size,PosY+size+i),col
      case 3'dwn
        line(PosX,PosY+i)-(PosX+size,PosY+size+i),col
        line                -(PosX+2*size,PosY+i),col
    end select
  next
end sub



sub Separator (PosX as integer,PosY as integer,swidth as integer)
  line(PosX,PosY)-(PosX+swidth-1,PosY),ShiftRGB(BackGroundColor,-contrast)
  line(PosX,PosY+1)-(PosX+swidth-1,PosY+1),ShiftRGB(BackGroundColor,contrast)
end sub
