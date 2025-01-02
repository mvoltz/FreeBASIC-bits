namespace sGUI

declare function AddDragBar (event as EventHandle ptr,PosX as integer,PosY as integer,GadWidth as integer=0,Text as string) as Gadget ptr
declare function DragBarActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawDragBar (gad as Gadget ptr)
declare sub UpdateDragBar (gad as Gadget ptr)

'Ctrl(0) x Abstand Maus <-> linke obere Ecke
'Ctrl(1) y Abstand Maus <-> linke obere Ecke
'Ctrl(2) screeninfo
'Ctrl(3) screeninfo
function AddDragBar (event as EventHandle ptr,PosX as integer,PosY as integer,GadWidth as integer=0,Text as string) as Gadget ptr
  function=0
  dim as Gadget ptr gad
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event
  	gad->sel=0
    gad->act=0
    if GadWidth=0 then GadWidth=GetTextWidth(Text)+2*minspace
    gad->gadw=GadWidth
    gad->gadh=GetFontHeight+2*minspace
    gad->posx=0
    gad->posy=0
    gad->caption=Text
    event->guiposX=PosX
    event->guiposY=PosY
    gad->DoDraw     =@DrawDragBar
    gad->DoAction   =@DragBarActions
    gad->DoUpdate   =@DrawDragBar

		function=gad
  end if
end function


function DragBarActions(gad as Gadget ptr,action as integer) as integer
  function=0
	dim as integer GadX,GadY
  GetGlobalPosition(gad,GadX,GadY)

  select case action     
    case GADGET_LMBHIT        'Control grad frisch gedrückt
      gad->Ctrl(0)=MOUSEX - GadX
      gad->Ctrl(1)=MOUSEY - Gady
      screeninfo gad->Ctrl(2),gad->Ctrl(3)
    case GADGET_LMBHOLD,GADGET_LMBHOLDOFF
      cls
      gad->event->guiposX=MOUSEX - gad->Ctrl(0)
      gad->event->guiposY=MOUSEY - gad->Ctrl(1)
      if gad->event->guiposX<0 then gad->event->guiposX=0
      if gad->event->guiposY<0 then gad->event->guiposY=0
      if gad->event->guiposX+gad->gadw>=gad->Ctrl(2) then gad->event->guiposX=gad->Ctrl(2)-gad->gadw-1
      if gad->event->guiposY+gad->gadh>=gad->Ctrl(3) then gad->event->guiposY=gad->Ctrl(3)-gad->gadh-1
        DrawDragBar (gad)
  end select
end function

sub DrawDragBar (gad as Gadget ptr)
	dim as integer GadX,GadY,GadWidth,GadHeight,TextPosX,TextPosY
  GetGlobalPosition(gad,GadX,GadY)
	GadWidth =gad->gadw
	GadHeight=gad->gadh
  TextPosX =GadX + int((GadWidth-GetTextWidth(gad->caption))/2)
	TextPosY =GadY + int((GadHeight-GetFontHeight)/2)
  screenlock
'OFF 
    gad->PutBackGround
'ON   unselect/select
  if gad->act then
      FillA GadX,GadY,GadWidth,GadHeight,GadgetGlowColor,GadgetGlowFrameColor,0
      drawstring (TextPosX,TextPosY,gad->caption,GadgetTextColor)
'SLEEP
      if gad->act=2 then gad->PutBackGround SleepShade
    end if
  screenunlock
end sub

sub UpdateDragBar (gad as Gadget ptr)

end sub

end namespace
