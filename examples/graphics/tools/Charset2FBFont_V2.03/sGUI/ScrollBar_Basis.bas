namespace sGUI

declare function AddSB(event as EventHandle ptr,PosX as integer,PosY as integer,l as integer,Minimum as integer,Maximum as integer,ScrollValue as integer,PageSize as integer,Orientation as integer) as Gadget ptr
declare function SBActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawSB (gad as Gadget ptr)

declare sub SlideSB(gad as Gadget ptr,knobpos as integer)
declare sub SetSBVal (gad as Gadget ptr,ScrollValue as integer)
declare function GetSBVal (gad as Gadget ptr) as integer
declare sub SetSBLimits(gad as Gadget ptr,Minimum as integer,Maximum as integer,PageSize as integer=0)
declare sub rethinkinternal(gad as Gadget ptr, Minimum as integer, Maximum as integer, ScrollValue as integer, PageSize as integer)

'Steuerungsvariablen SB:
'Ctrl(0)  Minimalwert den value als Rückgabewert annehmen kann
'Ctrl(1)  Maximalwert den value als Rückgabewert annehmen kann
'Ctrl(2)  Position des Knobs in px, ergibt sich aus dem Wert in value und range
'Ctrl(3)  Mausoffset beim Klicken auf den Knob
'Ctrl(4)  Schalter für Sliding-Modus
'Ctrl(5)  Schalter vertikal(1)/horizontal(0)
'Ctrl(6)  KnobSize
'Ctrl(7)  PageSize
'Ctrl(14) alter Regelwert
'Ctrl(15) Regelwert
function AddSB(event as EventHandle ptr,PosX as integer,PosY as integer,l as integer,Minimum as integer,Maximum as integer,ScrollValue as integer,PageSize as integer,Orientation as integer) as Gadget ptr
  function=0
  dim as Gadget ptr gad
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event
  	gad->sel=0
    gad->act=0
    gad->posx=PosX
    gad->posy=PosY
    
    gad->Ctrl(5)=Orientation
    if gad->Ctrl(5) then
     'vertikal
      gad->gadw=15
      gad->gadh=l
    else
      'horizontal
      gad->gadw=l
      gad->gadh=15
    end if
    rethinkinternal(gad,Minimum,Maximum,ScrollValue,PageSize)
    gad->DoDraw     =@DrawSB
    gad->DoAction   =@SBActions
    gad->DoUpdate   =@DrawSB

		'gad->SaveBackGround
		function=gad
  end if
end function



function SBActions(gad as Gadget ptr,action as integer) as integer
  function=0
  'relative Mausposition zum Control berechnen, mit Fallunterscheidung h/v
	dim as integer GadX,GadY,GadMousePos
  GetGlobalPosition(gad,GadX,GadY)
  if gad->Ctrl(5) then
    GadMousePos=MOUSEY - GadY
  else
    GadMousePos=MOUSEX - GadX
  end if

  select case action

      case GADGET_LMBHIT        'Control grad frisch gedrückt

        if ( GadMousePos >= gad->Ctrl(2) ) and ( GadMousePos < gad->Ctrl(2) + gad->Ctrl(6) ) then 'Fall Knobtreffer

            gad->Ctrl(3)=GadMousePos  - gad->Ctrl(2) 'Speichern des MouseOffsets überm Knob
            gad->Ctrl(4)=1 'SliderModus für Hold aktivieren
            SetSelect (gad,1)
            DrawGadget(gad)

        else                                                                        'Fall im Container aber neben Knob

          if GadMousePos < gad->Ctrl(2) then                     'falls Maus im Container vor Knob dann...
            SetSBVal(gad , GetSBVal(gad) - gad->Ctrl(7) ) 'Page zurück
          elseif GadMousePos >= gad->Ctrl(2) +  gad->Ctrl(6) then'falls Maus im Container hinter Knob dann...
            SetSBVal(gad , GetSBVal(gad) + gad->Ctrl(7) ) 'Page vor
          end if
          gad->Ctrl(4)=0                                  'da kein Knobtreffer wird für HOLD der SLIDINGMODUS nicht aktiviert
          DrawGadget(gad)

        end if
        function=1

      case GADGET_LMBHOLD,GADGET_LMBHOLDOFF       'Control wird gehalten, Maus über/neben dem Control
        if gad->Ctrl(4)=1 then
          gad->Ctrl(14)=GetSBVal(gad)
          
          SlideSB(gad,GadMousePos - gad->Ctrl(3))'Übergabe einer Sliderposition in Abhängigkeit von Maus

          if gad->Ctrl(14)<>GetSBVal(gad) then
            SetSelect (gad,1)
            function=1
          end if
        end if

      case GADGET_LMBRELEASE,GADGET_LMBRELEASEOFF    'Control losgelassen
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



sub DrawSB (gad as Gadget ptr)
	dim as integer GadX,GadY,KnobPos,KnobSize,GadWidth,GadHeight
  GetGlobalPosition(gad,GadX,GadY)
  GadWidth		   =gad->gadw
	GadHeight		   =gad->gadh
  KnobPos        =gad->Ctrl(2)
  KnobSize       =gad->Ctrl(6)
  screenlock
	if gad->act=0 then
'OFF
    gad->PutBackGround
  else
'ON
		ClearBox GadX,GadY,GadWidth,GadHeight,GadgetDarkFillColor
    if gad->Ctrl(5) then'vertikal

      'glowfx
      if gad->ctrl(13) then
        FillA GadX,GadY+KnobPos,GadWidth,KnobSize,GadgetGlowColor,GadgetGlowFrameColor,gad->sel
      else
        FillA GadX,GadY+KnobPos,GadWidth,KnobSize,,,0
      end if
    
    
    else'horizontal
     
      'glowfx
      if gad->ctrl(13) then
        FillA GadX+KnobPos,GadY,KnobSize,GadHeight,GadgetGlowColor,GadgetGlowFrameColor,gad->sel
      else
        FillA GadX+KnobPos,GadY,KnobSize,GadHeight,,,0
      end if

    end if
'SLEEP
    if gad->act=2 then gad->PutBackGround SleepShade
  end if
  screenunlock
end sub



sub SlideSB(gad as Gadget ptr,knobpos as integer)
  dim as integer clength, cres, vmaxp, vrange
  dim as single cratio

  'Containerlänge ermitteln, Werte entsprechend vertikal/horizontal aus Control holen
  if gad->Ctrl(5) then clength=gad->gadh else clength=gad->gadw
  'Auflösung Slider, Gesamtzahl der Sliderpositionen
  cres=clength - gad->Ctrl(6)

  'Knob Position Limiter
  if knobpos<0 then knobpos=0
  if knobpos>clength - gad->Ctrl(6) then knobpos=clength - gad->Ctrl(6)
  'Prozentwert der aktuellen Knobposition
  cratio=knobpos / (clength - gad->Ctrl(6))

  if knobpos<>gad->Ctrl(2) then 'wenn eine Knobbewegung erfolgt, dann
    'größter anzuscrollender Maximalwert
    vmaxp=gad->Ctrl(1) - gad->Ctrl(7) + 1
    'Gesamtzahl aller Scrollwerte
    vrange=vmaxp - gad->Ctrl(0)

    gad->Ctrl(15)= gad->Ctrl(0) + vrange * cratio'minimalwert +  gesamtzahl * Prozent Knob

    gad->Ctrl(2)=knobpos
  end if
  DrawGadget(gad)
end sub



sub SetSBVal (gad as Gadget ptr,ScrollValue as integer)
  'es wird nur der Scrollwert gesetzt, alle anderen Parameter werden aus Gadget geholt
  rethinkinternal(gad, gad->Ctrl(0), gad->Ctrl(1), ScrollValue, gad->Ctrl(7))
end sub



function GetSBVal (gad as Gadget ptr) as integer
	function=gad->Ctrl(15)
end function



sub SetSBLimits(gad as Gadget ptr,Minimum as integer,Maximum as integer,PageSize as integer=0)
  if PageSize=0 then PageSize=gad->Ctrl(7)
  rethinkinternal(gad, Minimum, Maximum, Minimum, PageSize)
end sub



sub rethinkinternal(gad as Gadget ptr, Minimum as integer, Maximum as integer, ScrollValue as integer, PageSize as integer)
  /'
  rethinkinternal faßt erstmal alle Parameter als "außenstehend" auf, und müssen - obwohl möglicherweise Bestandteil
  des Controls - erstmal als Parameter übergeben werden. Überraschenderweise weit weniger Rechnerei
  als gedacht. Erst zum Schluß werden die neu berechneten Werte ins Zielcontrol übertragen
  '/

  dim as single pageratio,vratio
  dim as integer clength,knobsize,vmaxp,knobposmax,knobpos

  '**********Scrollwert Berechnung/Überprüfung
  'falls notwendig, tauschen
  if Minimum>Maximum then swap Minimum,Maximum

  'Verhältnis Pagegröße / Gesamtzahl der Elemente
  pageratio=PageSize / (Maximum-Minimum+1)
  if pageratio>1 then pageratio=1'der Fall tritt auf wenn weniger Elemente da sind als Pagegröße, dann kein Scrollen möglich

  'größter anzuscrollender Maximalwert, wenn Pagegröße=1 entspricht dieser gleich Maximum, anderenfalls entsprechend der Page kleiner
  vmaxp= Maximum - PageSize + 1

  'Scrollwert Begrenzung berechnen falls ScrollValue über beide Ziele hinaus will
  if pageratio=1 then           'sollte Anzahl Elemente <= Pagegröße sein (kein Scrollen möglich), dann..
    ScrollValue=Minimum                      'muß der Scrollwert immer auf Anfang stehen, dem Minimalwert
  else                          'sollten mehr Elemente da sein, also Anzahl Elemente>Pagegröße, dann...
    if ScrollValue<Minimum then ScrollValue=Minimum       'ScrollValue darf nicht kleiner als Minimalwert sein
    if ScrollValue>vmaxp then ScrollValue=vmaxp     'ScrollValue darf nicht größer als der mögliche anscrollbarer Maximalwert(abhängig von Pagegröße) sein
  end if

  'den Scrollwert in einen Prozentwert (bzw Wert zwischen 0 bis 1) umrechnen Minimum=0%, vmaxp=100%
  vratio= (ScrollValue-Minimum) / (vmaxp-Minimum)

  '**********Darstellung
  'Containerlänge ermitteln, Werte entsprechend vertikal/horizontal aus Control holen
  if gad->Ctrl(5) then clength=gad->gadh else clength=gad->gadw

  'hiermit ist die Größe des Knobs proportional zum Verhältnis von Pagesize/Anzahl Elemente
  'jedoch niemals größer als der Container(da pageratio<=1 siehe oben) bzw. nie kleiner als 10
  knobsize=int(clength * pageratio)
  if knobsize<10 then knobsize=10

  'Position(Abstand) von oben/links des Knobs entsprechend ScrollValue(genauer vratio) berechnen
  if pageratio=1 then             'wenn Knob den Container ausfüllt dann
    knobposmax=0                  'kein Scrollen möglich
    knobpos=0                     'und Position ist immer 0
  else                            'ist Knob kleiner als Container
    knobposmax=clength-knobsize   'größte Scrollposition des Knobs berechnen
    knobpos=int(knobposmax*vratio)'und auf dessen Basis eigentliche Position berechnen
  end if

  'Zurückschreiben ins Control
  gad->Ctrl(0)=Minimum       'Ctrl(0)  Minimalwert den value als Rückgabewert annehmen kann
  gad->Ctrl(1)=Maximum       'Ctrl(1)  Maximalwert den value als Rückgabewert annehmen kann
  gad->Ctrl(2)=knobpos    'Ctrl(2)  Position des Knobs in px
  gad->Ctrl(6)=knobsize   'Ctrl(6)  KnobSize
  gad->Ctrl(7)=PageSize        'Ctrl(7)  PageSize
  gad->Ctrl(15)=ScrollValue         'Ctrl(15) Regelwert
end sub

end namespace