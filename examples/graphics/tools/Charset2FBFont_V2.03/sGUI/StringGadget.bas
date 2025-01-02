#include once "MultiLineEditBox_Basis.bas"

namespace sGUI

declare function AddStringGadget(event as EventHandle ptr,PosX as integer,PosY as integer,BoxWidth as integer,Text as string="",MaxChars as integer=0 ,CharLimitation as integer=0,ShowEnd as integer=0,Focus as integer=0) as Gadget ptr
declare function StringGadgetActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawStringGadget (gad as Gadget ptr)

declare sub StringGadgetSubHandle(gad as Gadget ptr)
declare sub UpdateStringGadgetBox(gad as Gadget ptr)

declare function GetString (gad as Gadget ptr) as string
declare sub SetString (gad as Gadget ptr,Text as string)
declare sub ScrollToAnEnd (gad as Gadget ptr)

'Ctrl(0) Zeichenbegrenzung 0=String,1=integer,2=Fließkomma,3=binär,4=hexadezimal,5=IP
'Ctrl(1) Schalter "Zeige Stringende"
'Ctrl(2) Focus
'Ctrl(3) maximale Anzahl der Zeichen im String
function AddStringGadget(event as EventHandle ptr,PosX as integer,PosY as integer,BoxWidth as integer,Text as string="",MaxChars as integer=0 ,CharLimitation as integer=0,ShowEnd as integer=0,Focus as integer=0) as Gadget ptr
  function=0
  dim as Gadget ptr gad,editbox
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event
    gad->sel=0
    gad->act=0
    gad->posx=PosX
    gad->posy=PosY
    gad->gadw=BoxWidth
    gad->gadh=GetFontHeight(1) + 2*minspace

    gad->Ctrl(0)=CharLimitation
    gad->Ctrl(1)=ShowEnd
    gad->Ctrl(2)=Focus
    gad->Ctrl(3)=MaxChars
    
    gad->subevent=AddEventHandle
    if gad->subevent then
      gad->subevent->parentevent=event
      gad->subevent->guiposX=PosX
      gad->subevent->guiposY=PosY
    
      editbox=AddMLEBGadget(gad->subevent,0,0,BoxWidth,gad->gadh,3)
    end if

    gad->DoDraw     =@DrawStringGadget
    gad->DoAction   =@StringGadgetActions
    gad->DoUpdate   =@DrawStringGadget

    gad->TObject=editbox->TObject'Verbindung zum Textobjekt erzeugen

    if Text<>"" then
      TO_AppendLine(gad,Text)
      UpdateGadget(editbox)
    end if
    ScrollToAnEnd(gad)
		function=gad
  end if
end function



function StringGadgetActions(gad as Gadget ptr,action as integer) as integer
  function=0

  dim as Gadget ptr editbox
  editbox=gad->subevent->GadgetList->GetFirst

  dim as integer enable
  select case action

      case GADGET_LMBHIT
        StringGadgetSubHandle(gad)
        SetSelect(editbox,1)
        function=-1

      case GADGET_LMBHOLD,GADGET_LMBHOLDOFF,GADGET_LMBRELEASE,GADGET_LMBRELEASEOFF
        StringGadgetSubHandle(gad)

      case GADGET_KEYBOARD   'Keyboardauswertung
        'ob eine Taste gedrückt wurde, ist schon in GadgetControl überprüft worden
        'wenn man bis hierher gelangt ist, wurde etwas gedrückt
        if  EXTENDED then
          'Cursorbewegung mit Pfeiltasten
          if ASCCODE=75 then TO_CursorLeft(gad)
          if ASCCODE=77 then TO_CursorRight(gad)
          'added by MilkFreeze, modified by Muttonhead :D
          if ASCCODE=71 then TO_CursorKeyPos1(gad)
          if ASCCODE=79 then TO_CursorKeyEnd(gad)
          TraceCursorPosition(editbox)
          DrawGadget(editbox)
          'DEL Windows
          #ifdef __fb_win32__
            if ASCCODE=83 then
              TO_KeyDelete(gad)
              TraceCursorPosition(editbox)
              DrawGadget(editbox)
            end if
          #endif

        else

          'BACKSPACE
          if ASCCODE=8 then
            TO_KeyBackspace(gad)
            TraceCursorPosition(editbox)
            DrawGadget(editbox)
          end if

          'DEL Linux
          #ifdef __fb_linux__
            if ASCCODE=127 then
              TO_KeyDelete(gad)
              TraceCursorPosition(editbox)
              DrawGadget(editbox)
            end if
          #endif

          'Return
          if ASCCODE=13 then
            ScrollToAnEnd(gad)
            if gad->Ctrl(2) then function=-2 else function=-1'bei Focus bleibt das Control aktiv(return -2), ansonsten Ausstieg mit -1
          end if

          'Zeicheneingabe
          enable=0

          'Beschränkungen bei der Zeicheneingabe
          select case gad->Ctrl(0)
            case 0'String
             'Linux chr(127) (Delete) ausschließen
              #ifdef __fb_linux__
                if ASCCODE>=32 and ASCCODE<>127 then enable=1
              #endif

              'Windows
              #ifdef __fb_win32__
                if ASCCODE>=32 then enable=1
              #endif

            case 1'Ganze Zahlen
              if ASCCODE>47 and ASCCODE<58 then enable=1


            case 2'Fließkomma
              if ASCCODE>47 and ASCCODE<58 then enable=1
              if ASCCODE=46 and instr(TO_GetLineContent(gad,1),".")=0 then enable=1 'wenn . gedrückt und noch kein . im String ist


            case 3'binär
              if ASCCODE>47 and ASCCODE<50 then enable=1

            case 4'hexadezimal
              if ASCCODE>47 and ASCCODE<58 then enable=1
              if ASCCODE>64 and ASCCODE<71 then enable=1
              if ASCCODE>96 and ASCCODE<103 then enable=1

            case 5'IPAdressen  ;)
              if ASCCODE>47 and ASCCODE<58 then enable=1
              if ASCCODE>64 and ASCCODE<71 then enable=1
              if ASCCODE>96 and ASCCODE<103 then enable=1
              if ASCCODE=46 then enable=1
          end select

          'Längenbegrenzung
          if (gad->Ctrl(3)>0) and (len(TO_GetLineContent(gad,1))>=gad->Ctrl(3)) then enable=0
          
          'generelles Minus Override, es fehlt etwas an Eleganz :/
          if (ASCCODE=45) and (TO_GetCursorPosition(gad)=1) and (instr(TO_GetLineContent(gad,1),"-")=0) then enable=1 'wenn - gedrückt und noch kein - im String ist

          if enable then
            TO_KeyAddChar(gad,KEY)
            TraceCursorPosition(editbox)
            DrawGadget(editbox)
          end if
        end if

      case GADGET_KEYBOARDOFF'Abbruch Keyboardauswertung
        ScrollToAnEnd(gad)
        SetSelect(editbox,0)

        function=0

  end select
end function



sub DrawStringGadget (gad as Gadget ptr)
  dim as Gadget ptr editbox
  editbox=gad->subevent->GadgetList->GetFirst
  
  DrawGadget(editbox)
end sub



sub StringGadgetSubHandle(gad as Gadget ptr)
  dim as Gadget ptr editbox
  editbox=gad->subevent->GadgetList->GetFirst

  gad->subevent->LMBGadgetCheck
  if gad->subevent->GADGETMESSAGE then
    select case gad->subevent->GADGETMESSAGE
      case editbox
        TraceCursorPosition(editbox)
    end select
    DrawGadget(editbox)
  end if
end sub



function GetString (gad as Gadget ptr) as string
  function=TO_GetLineContent(gad,1)
end function



sub SetString (gad as Gadget ptr,Text as string)
  dim as Gadget ptr editbox
  editbox=gad->subevent->GadgetList->GetFirst

  if TO_GetLines(gad)=0 then
    TO_AppendLine(gad,Text)
  else
    TO_SetLineContent(gad,1,Text)
  end if
  
  UpdateGadget(editbox)
  ScrollToAnEnd(gad)
  DrawGadget(editbox)
end sub



sub ScrollToAnEnd (gad as Gadget ptr)
  dim as Gadget ptr editbox
  editbox=gad->subevent->GadgetList->GetFirst

  if gad->Ctrl(1)=1 then
    HScrollMLEB(editbox,1)'erst Scrollfenster (virtuell) ganz nach links schieben
    TO_CursorKeyEnd(gad)
    'dadurch ist immer das Ende des Textes im StringGadget zu sehen
    'Da nun das "Cursorverfolgen" von links(Textanfang) erfolgt
  else
    TO_CursorKeyPos1(gad)
  end if
  TraceCursorPosition(editbox)
end sub

end namespace
