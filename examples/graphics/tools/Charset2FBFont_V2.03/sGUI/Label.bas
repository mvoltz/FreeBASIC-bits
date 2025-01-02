namespace sGUI

declare function AddLabel (event as EventHandle ptr,PosX as integer,PosY as integer,Text as string,TextColor as integer=TextColor) as Gadget ptr
declare function LabelActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawLabel (gad as Gadget ptr)
declare sub UpdateLabel (gad as Gadget ptr)

declare sub SetLabelColor (gad as Gadget ptr,TextColor as integer)

'Ctrl(0) Farbe des Textes
function AddLabel (event as EventHandle ptr,PosX as integer,PosY as integer,Text as string,TextColor as integer=TextColor) as Gadget ptr
  function=0
  dim as Gadget ptr gad
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event

  	gad->sel=0
    gad->act=0
    gad->posx=PosX
    gad->posy=PosY
    gad->gadw=GetTextWidth(Text)
    gad->gadh=GetFontHeight

    gad->caption=Text

    gad->Ctrl(0)=TextColor

    gad->DoDraw     =@DrawLabel
    gad->DoAction   =@LabelActions
    gad->DoUpdate   =@UpdateLabel

		function=gad
  end if
end function


function LabelActions(gad as Gadget ptr,action as integer) as integer
  function=0
  select case action

      case GADGET_LMBHIT

      case GADGET_LMBHOLD

      case GADGET_LMBHOLDOFF

      case GADGET_LMBRELEASE
        function=1
      
      case GADGET_LMBRELEASEOFF

  end select
end function


sub DrawLabel (gad as Gadget ptr)
	dim as integer GadX,GadY
  GetGlobalPosition(gad,GadX,GadY)

  screenlock
  gad->PutBackGround
	if gad->act then
    put(GadX,GadY),gad->Background->img,pset
    drawstring ( GadX, GadY,gad->caption,gad->Ctrl(0))
    if gad->act=2 then gad->PutBackGround SleepShade
  end if
  screenunlock
end sub


sub UpdateLabel (gad as Gadget ptr)
  gad->PutBackGround          
  gad->gadw=GetTextWidth(gad->caption)
  gad->SaveBackGround                                 
  DrawGadget(gad)                             
end sub


sub SetLabelColor (gad as Gadget ptr,TextColor as integer)
  gad->Ctrl(0)=TextColor
  UpdateGadget(gad)
end sub

end namespace
