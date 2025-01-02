#include once "MultiLineEditBox_Basis.bas"
#include once "ScrollBar.bas"

namespace sGUI

declare function AddMultiLineEditBox (event as EventHandle ptr,PosX as integer,PosY as integer,BoxWidth as integer,BoxHeight as integer,DisplayMode as integer=1) as Gadget ptr
declare function MultiLineEditActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawMultiLineEdit (gad as Gadget ptr)

declare sub MultiLineEditSubHandle(gad as Gadget ptr)
declare sub UpdateMLEB(gad as Gadget ptr)

'Ctrl(4)  0=Viewmodus 1=Editormodus
function AddMultiLineEditBox(event as EventHandle ptr,PosX as integer,PosY as integer,BoxWidth as integer,BoxHeight as integer,DisplayMode as integer=1) as Gadget ptr
  function=0
  dim as Gadget ptr gad,editbox
  dim as integer NumChars,NumRows
  NumChars=int((BoxWidth-6-15)/GetFixedWidth)
  NumRows=int((BoxHeight-6-15)/GetFontHeight(1))
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event
  	gad->sel=0
    gad->act=0
    gad->posx=PosX
    gad->posy=PosY
    gad->gadw=BoxWidth
    gad->gadh=BoxHeight
    
    gad->Ctrl(4)=DisplayMode
    
    gad->subevent=AddEventHandle
		if gad->subevent then
      gad->subevent->parentevent=event
      gad->subevent->guiposX=PosX
      gad->subevent->guiposY=PosY
      
      editbox=AddMLEBGadget(gad->subevent,0,0,BoxWidth-15,BoxHeight-15,DisplayMode)
    	AddScrollBar(gad->subevent,BoxWidth-15,0,BoxHeight-15,1,1,1,NumRows,1)
    	AddScrollBar(gad->subevent,0,BoxHeight-15,BoxWidth-15,1,1,1,NumChars,0)
		end if

    gad->TObject=editbox->TObject'Verbindung zum Textobjekt erzeugen

    gad->DoDraw     =@DrawMultiLineEdit
    gad->DoAction   =@MultiLineEditActions
    gad->DoUpdate   =@UpdateMLEB

		function=gad
  end if
end function



function MultiLineEditActions(gad as Gadget ptr,action as integer) as integer
  function=0
  
  dim as Gadget ptr editbox,vscrollbar,hscrollbar
  editbox=gad->subevent->GadgetList->GetFirst
  vscrollbar=cast(Gadget ptr,editbox->next_node) 
  hscrollbar=cast(Gadget ptr,vscrollbar->next_node)
  
  dim as integer enable
  select case action

      case GADGET_LMBHIT
        MultiLineEditSubHandle(gad)
        SetSelect(editbox,1)
        function=-1

      case GADGET_LMBHOLD,GADGET_LMBHOLDOFF,GADGET_LMBRELEASE,GADGET_LMBRELEASEOFF
        MultiLineEditSubHandle(gad)

      case GADGET_KEYBOARD   'Keyboardauswertung
        'ob eine Taste gedrückt wurde ist schon in GadgetControl überprüft worden
        'wenn man bis hierher gelangt ist, wurde definitiv etwas gedrückt
        if  EXTENDED then
          'Cursorbewegung mit Pfeiltasten
          if ASCCODE=75 then TO_CursorLeft(gad)
          if ASCCODE=77 then TO_CursorRight(gad)
          if ASCCODE=72 then TO_CursorUp(gad)
          if ASCCODE=80 then TO_CursorDown(gad)
          'added by MilkFreeze, modified by Muttonhead :D
          if ASCCODE=71 then TO_CursorKeyPos1(gad)
          if ASCCODE=79 then TO_CursorKeyEnd(gad)
          ModifyScrollBar(hscrollbar,TraceCursorPosition(editbox))
          ModifyScrollBar(vscrollbar,TraceCursorLine(editbox))
          DrawGadget(editbox)
          'DEL Windows
          #ifdef __fb_win32__
            if ASCCODE=83 then
              TO_KeyDelete(gad)
              ModifyScrollBar(vscrollbar,1,TO_GetLines(gad),TraceCursorLine(editbox))
              ModifyScrollBar(hscrollbar,TraceCursorPosition(editbox))
              DrawGadget(editbox)
            end if
          #endif

        else

          'BACKSPACE
          if ASCCODE=8 then
            TO_KeyBackspace(gad)
            ModifyScrollBar(vscrollbar,1,TO_GetLines(gad),TraceCursorLine(editbox))
            ModifyScrollBar(hscrollbar,TraceCursorPosition(editbox))
            DrawGadget(editbox)
          end if

          'DEL Linux
          #ifdef __fb_linux__
            if ASCCODE=127 then
              TO_KeyDelete(gad)
              ModifyScrollBar(vscrollbar,1,TO_GetLines(gad),TraceCursorLine(editbox))
              ModifyScrollBar(hscrollbar,TraceCursorPosition(editbox))
              DrawGadget(editbox)
            end if
          #endif

          'Return
          if ASCCODE=13 then
            TO_KeyReturn(gad)
            ModifyScrollBar(vscrollbar,1,TO_GetLines(gad),TraceCursorLine(editbox))
            ModifyScrollBar(hscrollbar,TraceCursorPosition(editbox))
            DrawGadget(editbox)
          end if

          'Zeicheneingabe
          enable=0

          'Linux chr(127) (Delete) ausschließen
          #ifdef __fb_linux__
            if ASCCODE>=32 and ASCCODE<>127 then enable=1
          #endif

          'Windows
          #ifdef __fb_win32__
            if ASCCODE>=32 then enable=1
          #endif

          if gad->Ctrl(4)<>1 then enable=0

          if enable then
            TO_KeyAddChar(gad,KEY)
            ModifyScrollBar(vscrollbar,1,TO_GetLines(gad),TraceCursorLine(editbox))
            ModifyScrollBar(hscrollbar,1,TO_GetLongestLine(gad)+1,TraceCursorPosition(editbox))
            DrawGadget(editbox)
          end if
        end if

      case GADGET_KEYBOARDOFF'Abbruch Keyboardauswertung
        SetSelect(editbox,0)
        function=-1
      
      case GADGET_WHEELMOVE
        ModifyScrollBar(vscrollbar,GetScrollBarVal( vscrollbar ) + WHEEL*3 )'3ZeilenScroll Rad
        VScrollMLEB(editbox,GetScrollBarVal(vscrollbar))
        DrawGadget(editbox)
      
      case GADGET_MOUSEOVER,GADGET_MOUSENEXT
        gad->subevent->MouseOverCheck
  end select
end function



sub DrawMultiLineEdit (gad as Gadget ptr)
  dim as Gadget ptr editbox,vscrollbar,hscrollbar
  editbox=gad->subevent->GadgetList->GetFirst
  vscrollbar=cast(Gadget ptr,editbox->next_node) 
  hscrollbar=cast(Gadget ptr,vscrollbar->next_node)
  
  DrawGadget(editbox)
  DrawGadget(vscrollbar)  
  DrawGadget(hscrollbar)  
end sub



sub MultiLineEditSubHandle(gad as Gadget ptr)
  dim as Gadget ptr editbox,vscrollbar,hscrollbar
  editbox=gad->subevent->GadgetList->GetFirst
  vscrollbar=cast(Gadget ptr,editbox->next_node) 
  hscrollbar=cast(Gadget ptr,vscrollbar->next_node)

  gad->subevent->LMBGadgetCheck
  if gad->subevent->GADGETMESSAGE then
    select case gad->subevent->GADGETMESSAGE
      case editbox
        ModifyScrollBar(vscrollbar,1,TO_GetLines(gad),TraceCursorLine(editbox))
        ModifyScrollBar(hscrollbar,TraceCursorPosition(editbox))
      case vscrollbar
        VScrollMLEB(editbox,GetScrollBarVal(vscrollbar))
      case hscrollbar
        HScrollMLEB(editbox,GetScrollBarVal(hscrollbar))
    end select
    DrawGadget(editbox)
  end if
end sub



sub UpdateMLEB(gad as Gadget ptr)
  dim as Gadget ptr editbox,vscrollbar,hscrollbar
  editbox=gad->subevent->GadgetList->GetFirst
  vscrollbar=cast(Gadget ptr,editbox->next_node) 
  hscrollbar=cast(Gadget ptr,vscrollbar->next_node)

  dim as integer cp,cl
  cp=TO_GetCursorPosition(gad)
  cl=TO_GetCursorLine(gad)
  ModifyScrollBar(vscrollbar,1,TO_GetLines(gad),cl)
  ModifyScrollBar(hscrollbar,1,TO_GetLongestLine(gad)+1,cp)
  VScrollMLEB(editbox,GetScrollBarVal(vscrollbar))
  HScrollMLEB(editbox,GetScrollBarVal(hscrollbar))
  UpdateGadget(editbox)
end sub

end namespace
