namespace sGUI

declare function AddArrow (event as EventHandle ptr,PosX as integer,PosY as integer,DirArrow as integer) as Gadget ptr
declare function AddSmallArrow (event as EventHandle ptr,PosX as integer,PosY as integer,DirArrow as integer) as Gadget ptr
declare function ArrowActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawArrow (gad as Gadget ptr)
declare sub DrawSmallArrow (gad as Gadget ptr)

'Steuerungsvariablen:
'Ctrl(0) enthält einen Richtungsmarker 0=links,1=rechts,2=hoch,3=runter
'Ctrl(1) wird für die Zeitverzögerung des Triggerns benötigt
function AddArrow (event as EventHandle ptr,PosX as integer,PosY as integer,DirArrow as integer) as Gadget ptr
  function=0
  dim as Gadget ptr gad
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event
  	gad->sel=0
    gad->act=0
    gad->posx=PosX
    gad->posy=PosY
    if DirArrow=0 or DirArrow=1 then
      gad->gadw=16
      gad->gadh=15
    end if
    if DirArrow=2 or DirArrow=3 then
      gad->gadw=15
      gad->gadh=16
    end if

    gad->Ctrl(0)=DirArrow

    gad->DoDraw     =@DrawArrow
    gad->DoAction   =@ArrowActions
    gad->DoUpdate   =@DrawArrow

		function=gad
  end if
end function


function AddSmallArrow (event as EventHandle ptr,PosX as integer,PosY as integer,DirArrow as integer) as Gadget ptr
  function=0
  dim as Gadget ptr gad
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event
  	gad->sel=0
    gad->act=0
    gad->posx=PosX
    gad->posy=PosY
    if DirArrow=0 or DirArrow=1 then
      gad->gadw=10
      gad->gadh=9
    end if
    if DirArrow=2 or DirArrow=3 then
      gad->gadw=9
      gad->gadh=10
    end if

    gad->Ctrl(0)=DirArrow

    gad->DoDraw     =@DrawSmallArrow
    gad->DoAction   =@ArrowActions

		function=gad
  end if
end function


function ArrowActions(gad as Gadget ptr,action as integer) as integer
  function=0
  static as single tt

  select case action

      case GADGET_LMBHIT
        SetSelect (gad,1)
        function=1
      
      case GADGET_LMBHOLD
        if gad->Ctrl(1)=2 and timer >= tt+.05 then
          tt=timer
          function=1
        end if

        if gad->Ctrl(1)=1 and timer >= tt+.8 then
          tt=timer
          gad->Ctrl(1)=2
          function=1
        end if

        if gad->Ctrl(1)=0 then
          tt=timer
          gad->Ctrl(1)=1
        end if

      case GADGET_LMBRELEASE,GADGET_LMBRELEASEOFF
        gad->Ctrl(1)=0
        SetSelect (gad,0)
      
      case GADGET_MOUSEOVER
        gad->ctrl(13)=1
        DrawGadget(gad)

      case GADGET_MOUSENEXT
        gad->ctrl(13)=0
        DrawGadget(gad)

  end select
end function


sub DrawArrow (gad as Gadget ptr)
	dim as integer GadX,GadY,GadWidth,GadHeight,DirArrow,o
  GetGlobalPosition(gad,GadX,GadY)
	GadWidth =gad->gadw
	GadHeight=gad->gadh
  DirArrow =gad->Ctrl(0)
  screenlock
    if gad->act=0 then
'OFF
      gad->PutBackGround
    else
'ON
      'glowfx
      if gad->ctrl(13) then
        FillA GadX,GadY,GadWidth,GadHeight,GadgetGlowColor,GadgetGlowFrameColor,gad->sel
      else
        FillA GadX,GadY,GadWidth,GadHeight,,,gad->sel
      end if
      
      if gad->sel then o=1 else o=0
      if DirArrow=0 then Arrow GadX+5-o,GadY+3,4,DirArrow,GadgetTextColor
      if DirArrow=1 then Arrow GadX+5+o,GadY+3,4,DirArrow,GadgetTextColor
      if DirArrow=2 then Arrow GadX+3,GadY+5-o,4,DirArrow,GadgetTextColor
      if DirArrow=3 then Arrow GadX+3,GadY+5+o,4,DirArrow,GadgetTextColor
'SLEEP
      if gad->act=2 then gad->PutBackGround SleepShade
    end if
  screenunlock
end sub


sub DrawSmallArrow (gad as Gadget ptr)
	dim as integer GadX,GadY,GadWidth,GadHeight,DirArrow,o
  GetGlobalPosition(gad,GadX,GadY)
	GadWidth =gad->gadw
	GadHeight=gad->gadh
  DirArrow =gad->Ctrl(0)
  screenlock
    if gad->act=0 then
'OFF
      gad->PutBackGround
    else
'ON
      'glowfx
      if gad->ctrl(13) then
        FillA GadX,GadY,GadWidth,GadHeight,GadgetGlowColor,GadgetGlowFrameColor,gad->sel
      else
        FillA GadX,GadY,GadWidth,GadHeight,,,gad->sel
      end if

      if gad->sel then o=1 else o=0
      if DirArrow=0 then Arrow GadX+3-o,GadY+2,2,DirArrow,GadgetTextColor
      if DirArrow=1 then Arrow GadX+3+o,GadY+2,2,DirArrow,GadgetTextColor
      if DirArrow=2 then Arrow GadX+2,GadY+3-o,2,DirArrow,GadgetTextColor
      if DirArrow=3 then Arrow GadX+2,GadY+3+o,2,DirArrow,GadgetTextColor
'SLEEP
      if gad->act=2 then gad->PutBackGround SleepShade
    end if
  screenunlock  
end sub

end namespace
