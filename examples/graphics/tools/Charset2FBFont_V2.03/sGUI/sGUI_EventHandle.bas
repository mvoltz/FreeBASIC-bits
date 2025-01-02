type EventHandle extends node
  'Parent Handle
  parentevent as _EventHandle ptr
  
  'GUI
  guiposX     as integer
  guiposY     as integer
  
  'Gadgets
  GADGETMESSAGE as Gadget ptr'Nummer(genauer Pointer) des Gadgets, welches nen "Ping" von sich gibt
  MENUMESSAGE   as integer'ID des Menüeintrages, welcher angewählt wurde
  EXITEVENT     as integer
  GadgetList    as ListObject ptr

  private:
  'Gadget Zeugs
  refgad         as Gadget ptr 'Referenz Gadget, auf dem der Rest des Clickvorganges basiert
  actgad         as Gadget ptr
  wheelgad       as Gadget ptr

  'Maus über Gadget Handling
  mouseover      as Gadget ptr'Referenz zu einem Control über dem die Maus steht
  mousenext      as Gadget ptr'Referenz zu einem Control von dem sich die Maus weg bewegt hat

  'letzter abgearbeiteter Tastenstatus der Maus im EventHandle
  lastLMB        as integer
  lastMMB        as integer
  lastRMB        as integer

  keygad         as Gadget ptr
  
public:
  declare constructor ()
  declare destructor ()
  declare sub xSleep (eventmode as integer,XButton as integer=1)
  declare sub LMBGadgetCheck
  declare sub MMBGadgetCheck 
  declare sub RMBGadgetCheck
  declare sub WheelGadgetCheck
  declare sub MouseOverCheck
  declare sub KeyboardGadgetCheck
private:
  declare function GetGadgetPointer as Gadget ptr
end type


constructor EventHandle()
  GadgetList  = GadgetLists->AppendNew(ListObjectType)
end constructor


destructor EventHandle()
  GadgetLists->DeleteNode (GadgetList)
end destructor


'Methoden
sub EventHandle.xSleep (eventmode as integer,XButton as integer=1)
  dim as integer eventoccurred=0
  do
    'eventmode=1 mit SLEEP(1), Warten auf Ereignis
    'eventmode=0 mit SLEEP(1), kein Warten auf Ereignis -> Durchlauf
    'eventmode=-1 kein SLEEP(1), keine Warten auf Ereignis -> Durchlauf
    if eventmode>-1 then sleep 1

    eventoccurred=GetSysEvents(XButton)

    if (CLOSEBUTTON=1) and (XButton=1) then
      EXITEVENT=1
      eventoccurred=1
    end if

    MouseOverCheck
    LMBGadgetCheck
    'MMBGadgetCheck
    'RMBGadgetCheck
    KeyboardGadgetCheck
    WheelGadgetCheck
    if GADGETMESSAGE then eventoccurred=1

    if eventmode<1 then eventoccurred=1
  loop until eventoccurred
end sub


Sub EventHandle.WheelGadgetCheck
  'Gadgetaktionen für Mausrad
  if WHEEL<>0 then
    wheelgad=GetGadgetPointer
    if (wheelgad>0) then GadgetAction(wheelgad,GADGET_WHEELMOVE)
  end if
End Sub


sub EventHandle.LMBGadgetCheck
  if GadgetList->GetFirst then
    dim as integer result,action
    GADGETMESSAGE=0

    'Gadgetaktionen für linken Maustaste
    'if (lastLMB=RELEASE) and (LMB>RELEASE) then refgad=0
    select case LMB
      case HIT 'wenn Maus grad gedrückt wurde
        refgad=0           'Variablen zurücksetzen
        actgad=0
        result=0
        refgad=GetGadgetPointer
        if refgad then action=GADGET_LMBHIT

      case HOLD
        if refgad then
          actgad=GetGadgetPointer
          if actgad=refgad then action=GADGET_LMBHOLD else action=GADGET_LMBHOLDOFF
        end if

      case RELEASE
        if refgad then
          actgad=GetGadgetPointer
          if actgad=refgad then action=GADGET_LMBRELEASE else action=GADGET_LMBRELEASEOFF
        end if

      case RELEASED

    end select
    'lastLMB=LMB

    if refgad then result=GadgetAction(refgad,action)
    if (result>0) then GADGETMESSAGE=refgad

    'Daten vom Keyboard ins Control
    'einschalten
    if (keygad>0) and (refgad>0) and (refgad<>keygad) then
      GadgetAction(keygad,GADGET_KEYBOARDOFF)
      keygad=0
    end if
    if result=-1 then keygad=refgad

  end if
end sub


sub EventHandle.MouseOverCheck
  mouseover=GetGadgetPointer
  if mouseover then
    GadgetAction(mouseover,GADGET_MOUSEOVER)
    if (mouseover<>mousenext) and (mousenext>0) then GadgetAction(mousenext,GADGET_MOUSENEXT)
    mousenext=mouseover
  else
    if mousenext then GadgetAction(mousenext,GADGET_MOUSENEXT)
    mousenext=0
  end if
end sub


sub EventHandle.KeyboardGadgetCheck
  dim as integer result
  if (KEY<>"") and (keygad>0) then
    if (keygad->act=1) then result=GadgetAction(keygad,GADGET_KEYBOARD)
    if (result<>0) then GADGETMESSAGE=keygad
    if (result=-1) then
      GadgetAction(keygad,GADGET_KEYBOARDOFF)
      keygad=0
    end if
  end if
end sub



function EventHandle.GetGadgetPointer as Gadget ptr
  dim as Gadget ptr gad,over
  dim as uinteger col
  dim as integer guix,guiy,gadx,gady
  function=0  
  GetGlobalPosition(@this,guix,guiy)
  gad=GadgetList->GetFirst
  if gad then
    do
      gadx=guix + gad->posx
      gady=guiy + gad->posy
      over=0
      if gad->act=1 then'nur bei Activation=1 gibt es eine Antwort
        if  (MOUSEX>=gadx) and (MOUSEX<gadx + gad->gadw) and (MOUSEY>=gady) and (MOUSEY<gady + gad->gadh) then
          'wenn eine Maske existiert, dann ausschliessen ob die Maus-Position
					'nicht über einem Pixel mit der Farbe RGB(255,0,255) ist!
					if (gad->Mask>0) then
            col=point(MOUSEX-gadx,MOUSEY-gady,gad->Mask->img)
            if col<>&HFFFF00FF then over=gad
					else'ohne Maske
						over=gad
					end if
      	end if
			end if
      if over then function=gad
  
      gad=cast(Gadget ptr,gad->next_node)
    loop until (gad=0) or (over>0)
 
  end if
end function
