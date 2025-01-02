#include once "MiniSelector.bas"

namespace sGUI

declare function AddComboBox(event as EventHandle ptr,PosX as integer,PosY as integer,BoxWidth as integer,BoxHeight as integer) as Gadget ptr
declare function ComboBoxActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawComboBox (gad as Gadget ptr)
declare sub SetComboBoxVal(gad as Gadget ptr,i as integer)
declare function GetComboBoxVal(gad as Gadget ptr) as integer


'Ctrl(0) Breite TextBox / offset x PullDwn
'Ctrl(4) Anzahl Zeichen in Textbox
'Ctrl(5) Breite MiniSelector in px
'Ctrl(6) Höhe MiniSelector in px
'Ctrl(14) Vergleichsreferenz zu Ctrl(15)
'Ctrl(15) selektierter Eintrag
function AddComboBox(event as EventHandle ptr,PosX as integer,PosY as integer,BoxWidth as integer,BoxHeight as integer) as Gadget ptr
  function=0
  dim as Gadget ptr gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event
  	gad->sel=0
    gad->act=0
    gad->posx=PosX
    gad->posy=PosY
    gad->gadw=BoxWidth
    gad->gadh=GetFontHeight(1) + 2*minspace
    gad->Ctrl(0)=BoxWidth-15
    gad->Ctrl(4)=int((BoxWidth-2*minspace-15)/GetFixedWidth)    
    gad->Ctrl(5)=BoxWidth
    gad->Ctrl(6)=BoxHeight

    gad->TObject=AddTextObject

    gad->DoDraw     =@DrawComboBox
    gad->DoAction   =@ComboBoxActions
    gad->DoUpdate   =@DrawComboBox

		function=gad
  end if
end function


function ComboBoxActions(gad as Gadget ptr,action as integer) as integer
  function=0
  
  dim as integer result
  select case action
    case GADGET_LMBRELEASE
      gad->Ctrl(14)=gad->Ctrl(15)
      result=MiniSelector(gad->posx,gad->posy + GetFontHeight(1) + 2*minspace ,gad->Ctrl(5) ,gad->Ctrl(6) ,gad->TObject,gad->Ctrl(15))
      if result then
        gad->Ctrl(15)=result
        if gad->Ctrl(14)<>gad->Ctrl(15) then
          UpdateGadget(gad)
          function=1
        end if  
      end if
    
      case GADGET_MOUSEOVER
        gad->ctrl(13)=1
        DrawGadget(gad)

      case GADGET_MOUSENEXT
        gad->ctrl(13)=0
        DrawGadget(gad)
  end select
end function


sub DrawComboBox (gad as Gadget ptr)
	dim as integer GadX,GadY,PullDwnPosx,PullDwnPosY,PullDwnWidth,TextPosX,TextPosY,TextBoxWidth,GadWidth,GadHeight,o
  GetGlobalPosition(gad,GadX,GadY)
  PullDwnPosX    =GadX + gad->Ctrl(0)
  PullDwnWidth   =15 
  TextPosX       =GadX + minspace
	TextPosY       =GadY + minspace
  TextBoxWidth   =gad->Ctrl(0)
  GadWidth		   =gad->gadw
	GadHeight		   =gad->gadh
  screenlock
'OFF
  gad->PutBackGround
'ON   unselect/select
  if gad->act then
    'glowfx
    if gad->ctrl(13) then
      FillE GadX,GadY,TextBoxWidth,GadHeight,white,GadgetGlowFrameColor,0,1
      FillA PullDwnPosX,GadY,PullDwnWidth,GadHeight,GadgetGlowColor,GadgetGlowFrameColor,0
    else
      FillE GadX,GadY,TextBoxWidth,GadHeight,white,,0,1    
      FillA PullDwnPosX,GadY,PullDwnWidth,GadHeight,,,0
    end if
    if gad->Ctrl(15) then drawstring (TextPosX,TextPosY,left (TO_GetLineContent(gad,gad->Ctrl(15)), gad->Ctrl(4)),TextColor,1)    
    Arrow PullDwnPosX+4,GadY+(GadHeight/2-2),3,3,GadgetTextColor
'SLEEP
    if gad->act=2 then gad->PutBackGround SleepShade
  end if
	screenunlock
end sub


sub SetComboBoxVal(gad as Gadget ptr,i as integer)
  dim as integer l
  l=TO_GetLines(gad)
  if i<0 then i=0
  if i>l then i=l
  gad->Ctrl(15)=i
  DrawGadget(gad)
end sub


function GetComboBoxVal(gad as Gadget ptr) as integer
  function=gad->Ctrl(15)
end function

end namespace
