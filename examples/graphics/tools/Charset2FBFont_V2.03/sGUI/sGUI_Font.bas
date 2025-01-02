declare function GetSysFontHeight as integer
declare function GetTextWidth(txt as string, mode as integer=0) as integer
declare function GetFontHeight(mode as integer=0) as integer
declare sub DrawString(xpos as integer,ypos as integer,txt as string,PenColor as uinteger=&H000000,mode as integer=0)
declare sub LoadProportionalFont(filename as string)
declare sub LoadFixedFont(filename as string)
declare sub SetFixedWidth(w as integer)
declare function GetFixedWidth as integer

'nach einer Idee von Volta
'ermittelt die benutzte Fonthöhe und gibt sie zurück
'siehe http://forum.qbasic.at/viewtopic.php?t=6065&highlight=fonth%F6he
function GetSysFontHeight as integer
  #if __FB_VERSION__ >= "1.08.0"
    dim as ulong h,fheight
  #else
    dim as integer h,fheight
  #endif
  screeninfo ,h
  select case  h\hiword(width)
    case is < 8
      fheight=0
    case 8 to 13
      fheight=8
    case 14, 15
      fheight=14
    case is > 15
      fheight=16
  end select
  function=fheight
end function



function GetFontHeight(mode as integer=0) as integer
  if mode then'mode 1 Monospacefont für MLEB und Stringgadget
    if FontB->img then function=FontB->imgheight else function=GetSysFontHeight
  else'mode 0 Proportionalfont
    if FontA->img then function=FontA->imgheight else function=GetSysFontHeight
  end if
end function



function GetTextWidth(txt as string, mode as integer=0) as integer
  if mode then'mode 1 Monospacefont für MLEB und Stringgadget
    if FontB->img then function=FontB->GetTextWidth(txt,1) else function=8*len(txt)
  else'mode 0 Proportionalfont
    if FontA->img then function=FontA->GetTextWidth(txt) else function=8*len(txt)
  end if
end function



sub DrawString(xpos as integer,ypos as integer,txt as string,PenColor as uinteger=&H000000,mode as integer=0)
  if mode then'mode 1 Monospacefont für MLEB und Stringgadget
    if FontB->img then
      FontB->PenColor=PenColor
      FontB->Print (0,xpos,ypos,txt)
    else 
      draw string (xpos,ypos),txt,Pencolor
    end if
  else'mode 0 Proportionalfont
    if FontA->img then
      FontA->PenColor=PenColor
      FontA->Print (0,xpos,ypos,txt)
    else 
      draw string (xpos,ypos),txt,Pencolor
    end if
  end if
end sub



sub LoadProportionalFont(filename as string)
  FontA->LoadFont(filename)
end sub



sub LoadFixedFont(filename as string)
  FontB->LoadFont(filename)
  FontB->monospaced= FontB->CharSet(32).AdvanceX'Space als feste Breite verwenden
end sub



sub SetFixedWidth(w as integer)
  FontB->monospaced= w
end sub



function GetFixedWidth as integer
  if FontB->img then
    function=FontB->monospaced
  else
    function=8
  end if
end function