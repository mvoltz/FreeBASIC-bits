namespace sGUI

declare function AddTrackBar(event as EventHandle ptr,PosX as integer,PosY as integer,TBLength as integer,Minimum as integer,Maximum as integer,ScrollValue as integer,Orientation as integer) as Gadget ptr
declare function TrackBarActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawTrackBar (gad as Gadget ptr)
declare sub AnalogSlideTrackBar(gad as Gadget ptr,knobpos as integer)
declare sub SetTrackBarVal (gad as Gadget ptr,ScrollValue as integer)
declare function GetTrackBarVal (gad as Gadget ptr) as integer

'Steuerungsvariablen TrackBar:
'Ctrl(0)  Minimalwert den Scrollwert als Rückgabewert annehmen kann
'Ctrl(1)  Maximalwert den Scrollwert als Rückgabewert annehmen kann
'Ctrl(2)  Position des Knobs in px, ergibt sich aus dem Wert in Scrollwert
'Ctrl(3)  Mausoffset beim Klicken auf den Knob
'Ctrl(4)  Schalter für Sliding-Modus
'Ctrl(5)  Schalter vertikal(1)/horizontal(0)
'Ctrl(14) alter Scrollwert um Veränderung des ->Ctrl(15) festzustellen
'Ctrl(15) Scrollwert
function AddTrackBar (event as EventHandle ptr,PosX as integer,PosY as integer,TBLength as integer,Minimum as integer,Maximum as integer,ScrollValue as integer,Orientation as integer) as Gadget ptr
  function=0
  dim as Gadget ptr gad
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    dim as integer range
  
    if Maximum<Minimum then Maximum=Minimum
  
    if ScrollValue>Maximum then ScrollValue=Maximum
    if ScrollValue<Minimum then ScrollValue=Minimum

    gad->event=event
  	gad->sel=0
    gad->act=0
    gad->posx=PosX
    gad->posy=PosY
    'gad->gadw=GadWidth 'weiter unten
    'gad->gadh=GadHeight 'weiter unten

    gad->Ctrl(0)=Minimum
    gad->Ctrl(1)=Maximum
    gad->Ctrl(5)=Orientation
    gad->Ctrl(14)=ScrollValue
    gad->Ctrl(15)=ScrollValue

    range=gad->Ctrl(1) - gad->Ctrl(0)
    if gad->Ctrl(5) then
     'vertikal
      gad->gadw=22
      gad->gadh=TBLength
      if range then gad->Ctrl(2)=(gad->Ctrl(15)-gad->Ctrl(0))/range * (gad->gadh-11)
    else
      'horizontal
      gad->gadw=TBLength
      gad->gadh=22
      if range then gad->Ctrl(2)=(gad->Ctrl(15)-gad->Ctrl(0))/range * (gad->gadw-11)
    end if

    gad->DoDraw     =@DrawTrackBar
    gad->DoAction   =@TrackBarActions
    gad->DoUpdate   =@DrawTrackBar

		'gad->SaveBackGround
		function=gad
  end if
end function


function TrackBarActions(gad as Gadget ptr,action as integer) as integer
  function=0
	dim as integer GadX,GadY
  GetGlobalPosition(gad,GadX,GadY)
 
  select case action
      
      case GADGET_LMBHIT        'Control grad frisch gedrückt
        gad->Ctrl(14)=GetTrackBarVal(gad)
        if gad->Ctrl(5) then
          'vertikal
          if MOUSEY-GadY>=gad->Ctrl(2) and _           'Knob Treffer
            MOUSEY-GadY<gad->Ctrl(2)+11 then
            gad->Ctrl(3)=(MOUSEY-GadY)-gad->Ctrl(2) 'Speichern des MouseOffsets überm Knob
            gad->Ctrl(4)=1 'SliderModus bei Hold aktivieren
            SetSelect (gad,1)
          else  'anderenfalls Knob jeweils um 1 in Richtung Mausposition verschieben, kein HOLD
            if MOUSEY < GadY + gad->Ctrl(2) then
              SetTrackBarVal(gad,GetTrackBarVal(gad)-1)
            elseif MOUSEY >= GadY+ gad->Ctrl(2) + 11 then
              SetTrackBarVal(gad,GetTrackBarVal(gad)+1)
            end if
            gad->Ctrl(4)=0
          end if
        else
          'horizontal
          if MOUSEX-GadX>=gad->Ctrl(2) and _           'Knob Treffer
            MOUSEX-GadX<gad->Ctrl(2)+11 then
            gad->Ctrl(3)=(MOUSEX-GadX)-gad->Ctrl(2) 'Speichern des MouseOffsets überm Knob
            gad->Ctrl(4)=1 'SliderModus bei Hold aktivieren
            SetSelect (gad,1)
          else  'anderenfalls Knob jeweils um 1 in Richtung Mausposition verschieben, kein HOLD
            if MOUSEX < GadX + gad->Ctrl(2) then
              SetTrackBarVal(gad,GetTrackBarVal(gad)-1)
            elseif MOUSEX >= GadX + gad->Ctrl(2) + 11 then
              SetTrackBarVal(gad,GetTrackBarVal(gad)+1)
            end if
            gad->Ctrl(4)=0
          end if
      
        end if
        if gad->Ctrl(14)<>GetTrackBarVal(gad) then function=1

      case GADGET_LMBHOLD,GADGET_LMBHOLDOFF       'Control wird gehalten, Maus über/neben dem Control
        if gad->Ctrl(4)=1 then
          gad->Ctrl(14)=GetTrackBarVal(gad)
          if gad->Ctrl(5) then  'vertikal
            AnalogSlideTrackBar(gad,MOUSEY- GadY-gad->Ctrl(3))
          else                'horizontal
            AnalogSlideTrackBar(gad,MOUSEX- GadX-gad->Ctrl(3))
          end if
          if gad->Ctrl(14)<>GetTrackBarVal(gad) then function=1
        end if

      'case GADGET_HOLDOFF    'Control wird gehalten, Maus neben dem Control

      case GADGET_LMBRELEASE,GADGET_LMBRELEASEOFF    'Control regulär losgelassen/Control losgelassen, dabei ist Maus neben dem Control
        gad->Ctrl(4)=0
        SetSelect(gad,0)
      
      case GADGET_MOUSEOVER   'Mouse überm Control
        gad->ctrl(13)=1
        DrawGadget(gad)

      case GADGET_MOUSENEXT   'Mouse vom Control wegbewegt
        gad->ctrl(13)=0
        DrawGadget(gad)

  end select
end function


sub DrawTrackBar (gad as Gadget ptr)
	dim as integer GadX,GadY,GadWidth,GadHeight,KnobPos
  GetGlobalPosition(gad,GadX,GadY)
  GadWidth		   =gad->gadw
	GadHeight		   =gad->gadh  
  KnobPos        =gad->Ctrl(2)

  screenlock
    gad->PutBackGround
    if gad->act then
'ON   unselect/select
      if gad->Ctrl(5) then'vertikal
        ClearBox GadX+9,GadY,4,GadHeight,GadgetColor
        FillA GadX+9,GadY,4,GadHeight,,,1'Knob

        'glowfx
        if gad->ctrl(13) then
          FillA GadX,GadY+KnobPos,22,11,GadgetGlowColor,GadgetGlowFrameColor,gad->sel'Knob
        else
          FillA GadX,GadY+KnobPos,22,11,,,gad->sel'Knob
        end if

      else'horizontal
        ClearBox GadX,GadY+9,GadWidth,4,GadgetColor
        FillA GadX,GadY+9,GadWidth,4,,,1'Knob
        'glowfx
        if gad->ctrl(13) then
          FillA GadX+KnobPos,GadY,11,22,GadgetGlowColor,GadgetGlowFrameColor,gad->sel'Knob
        else
          FillA GadX+KnobPos,GadY,11,22,,,gad->sel'Knob
        end if

      end if
'SLEEP
    if gad->act=2 then gad->PutBackGround SleepShade
    end if
  screenunlock
end sub


sub AnalogSlideTrackBar(gad as Gadget ptr,knobpos as integer)
	dim as integer range,TBLength
  range=gad->Ctrl(1) - gad->Ctrl(0)

  if gad->Ctrl(5) then TBLength=gad->gadh else TBLength=gad->gadw ' vert.-->TBLength=gadh  /  horiz.-->TBLength=gadw

  if knobpos<0 then knobpos=0
  if knobpos>TBLength-11 then knobpos=TBLength-11

  gad->Ctrl(2)=knobpos
  if range then gad->Ctrl(15)=gad->Ctrl(0)  +  cint(range*gad->Ctrl(2)/(TBLength-11))

  DrawGadget(gad)
end sub


sub SetTrackBarVal (gad as Gadget ptr,ScrollValue as integer)
	dim as integer range,TBLength
  range=gad->Ctrl(1) - gad->Ctrl(0)

  if gad->Ctrl(5) then TBLength=gad->gadh else TBLength=gad->gadw ' vert.-->TBLength=gadh  /  horiz.-->TBLength=gadw

  if ScrollValue>gad->Ctrl(1) then ScrollValue=gad->Ctrl(1)
  if ScrollValue<gad->Ctrl(0) then ScrollValue=gad->Ctrl(0)

  gad->Ctrl(15)=ScrollValue
  if range then gad->Ctrl(2)=(gad->Ctrl(15)-gad->Ctrl(0))/range * (TBLength-11)

  DrawGadget(gad)
end sub


function GetTrackBarVal (gad as Gadget ptr) as integer
	function=gad->Ctrl(15)
end function

end namespace
