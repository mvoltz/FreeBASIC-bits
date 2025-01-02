namespace sGUI

declare function AddParentArrow (event as EventHandle ptr,PosX as integer,PosY as integer) as Gadget ptr
declare function ParentArrowActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawParentArrow (gad as Gadget ptr)

function AddParentArrow (event as EventHandle ptr,PosX as integer,PosY as integer) as Gadget ptr
  function=0
  dim as Gadget ptr gad
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event
  	gad->sel=0
    gad->act=0
    gad->posx=PosX
    gad->posy=PosY
    gad->gadw=GetFontHeight(1) + 2*minspace
    gad->gadh=GetFontHeight(1) + 2*minspace

    gad->DoDraw     =@DrawParentArrow
    gad->DoAction   =@ParentArrowActions
    gad->DoUpdate   =@DrawParentArrow

		'gad->SaveBackGround
		function=gad
  end if
end function




function ParentArrowActions(gad as Gadget ptr,action as integer) as integer
  function=0
  select case action
      
      case GADGET_LMBHIT        'Control grad frisch gedrückt
        SetSelect (gad,1)
      
      case GADGET_LMBHOLD       'Control wird gehalten, Maus über dem Control
        SetSelect (gad,1)
      
      case GADGET_LMBHOLDOFF    'Control wird gehalten, Maus neben dem Control
        SetSelect (gad,0)
      
      case GADGET_LMBRELEASE    'Control regulär losgelassen
        SetSelect (gad,0)
        function=1           'Ping!!!! Control meldet sich: bei mir ist was passiert!!!
      
      case GADGET_LMBRELEASEOFF 'Control losgelassen, dabei ist Maus neben dem Control
        SetSelect (gad,0)
      
      case GADGET_MOUSEOVER   'Mouse überm Control
        gad->ctrl(13)=1
        DrawGadget(gad)

      case GADGET_MOUSENEXT   'Mouse vom Control wegbewegt
        gad->ctrl(13)=0
        DrawGadget(gad)
  end select
end function


sub DrawParentArrow (gad as Gadget ptr)
	dim as integer GadX,GadY,GadWidth,GadHeight,ArrowPosX,ArrowPosY
  GetGlobalPosition(gad,GadX,GadY)
	GadWidth =gad->gadw
	GadHeight=gad->gadh
  ArrowPosX =GadX + int((GadWidth-7)/2)
	ArrowPosY =GadY + int((GadHeight-3)/2) 
  screenlock
'OFF
      gad->PutBackGround
    if gad->act then
'ON   unselect/select
      'FrameB PosX, PosY, GadWidth, GadHeight,,gad->sel

      'glowfx
      if gad->ctrl(13) then
        FillA GadX,GadY,GadWidth,GadHeight,GadgetGlowColor,GadgetGlowFrameColor,gad->sel
      else
        FillA GadX,GadY,GadWidth,GadHeight,,,gad->sel
      end if
      Arrow ArrowPosX,ArrowPosY - iif(gad->sel,2,0),3,2,GadgetTextColor
'SLEEP
      if gad->act=2 then gad->PutBackGround SleepShade
    end if
  screenunlock
end sub

end namespace
