namespace sGUI

declare function AddSimpleGadget (event as EventHandle ptr,PosX as integer,PosY as integer,GadWidth as integer=0,GadHeight as integer=0,Text as string) as Gadget ptr
declare function AddToggleGadget (event as EventHandle ptr,PosX as integer,PosY as integer,GadWidth as integer=0,GadHeight as integer=0,sel as integer,Text as string) as Gadget ptr
declare function SimpleGadgetActions(gad as Gadget ptr,action as integer) as integer
declare function ToggleGadgetActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawSimpleToggle (gad as Gadget ptr)

'Ctrl(0) wenn 1 dann Toggle sonst Simple
'ctrl(13) mouse-over-control-flag
function AddSimpleGadget (event as EventHandle ptr,PosX as integer,PosY as integer,GadWidth as integer=0,GadHeight as integer=0,Text as string) as Gadget ptr
  function=0
  dim as Gadget ptr gad
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event
  	gad->sel=0
    gad->act=0
    gad->posx=PosX
    gad->posy=PosY
    if GadWidth=0 then GadWidth=GetTextWidth(Text)+2*minspace
    if GadHeight=0 then GadHeight=GetFontHeight+2*minspace
    gad->gadw=GadWidth
    gad->gadh=GadHeight

    gad->caption=Text

    gad->DoDraw     =@DrawSimpleToggle
    gad->DoAction   =@SimpleGadgetActions
    gad->DoUpdate   =@DrawSimpleToggle

		function=gad
  end if
end function


function AddToggleGadget (event as EventHandle ptr,PosX as integer,PosY as integer,GadWidth as integer=0,GadHeight as integer=0,sel as integer,Text as string) as Gadget ptr
  function=0
  dim as Gadget ptr gad
  gad=AddSimpleGadget (event,PosX,PosY,GadWidth,GadHeight,Text)
  if gad then
  	gad->sel=sel
    gad->Ctrl(0)=1
    gad->DoAction   =@ToggleGadgetActions    
		function=gad
  end if
end function




function SimpleGadgetActions(gad as Gadget ptr,action as integer) as integer
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


function ToggleGadgetActions(gad as Gadget ptr,action as integer) as integer
  function=0
  select case action
      
      case GADGET_LMBHIT        'Control grad frisch gedrückt

      case GADGET_LMBHOLD       'Control wird gehalten, Maus über dem Control

      case GADGET_LMBHOLDOFF    'Control wird gehalten, Maus neben dem Control

      case GADGET_LMBRELEASE    'Control regulär losgelassen
        if GetSelect(gad) then SetSelect(gad,0) else SetSelect(gad,1)
         function=1
      case GADGET_LMBRELEASEOFF 'Control losgelassen, dabei ist Maus neben dem Control
      
      case GADGET_MOUSEOVER   'Mouse überm Control
        gad->ctrl(13)=1
        DrawGadget(gad)

      case GADGET_MOUSENEXT   'Mouse vom Control wegbewegt
        gad->ctrl(13)=0
        DrawGadget(gad)
  end select
end function


sub DrawSimpleToggle (gad as Gadget ptr)
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
      'glowfx
      if gad->ctrl(13) then
        FillA GadX,GadY,GadWidth,GadHeight,GadgetGlowColor,GadgetGlowFrameColor,gad->sel
      else
        FillA GadX,GadY,GadWidth,GadHeight,,,gad->sel
      end if   
      if gad->sel then'unselect/select Caption
        drawstring ( TextPosX, TextPosY,gad->caption,GadgetTextColor)
        drawstring ( TextPosX+1, TextPosY,gad->caption,GadgetTextColor)
        drawstring ( TextPosX+1, TextPosY+1,gad->caption,GadgetTextColor)
        drawstring ( TextPosX, TextPosY+1,gad->caption,GadgetTextColor)

      else
        drawstring ( TextPosX   , TextPosY ,gad->caption,GadgetTextColor)
      end if   
'SLEEP
      if gad->act=2 then gad->PutBackGround SleepShade
    end if
  screenunlock
end sub

end namespace
