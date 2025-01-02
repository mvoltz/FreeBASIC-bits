function GetSysEvents(XButton as integer) as integer
  dim as integer eventoccurred,button
  eventoccurred=0
  button=0
  
  'CLOSEBUTTON=0
  KEY=""
  ASCCODE=-1
  EXTENDED=0

 'alte Werte vom vorhergehenden Loopdurchgang zu Vergleichszwecken sichern   
  oldMOUSEX=MOUSEX
  oldMOUSEY=MOUSEY
  oldLMB=LMB
  oldMMB=MMB
  oldRMB=RMB
  oldwheelvalue=wheelvalue
  MOUSEMOVED=0
'Maus und Tastaturereignisse sammeln
  getmouse(MOUSEX,MOUSEY,wheelvalue,button)
  KEY=inkey

  'Maustastenzustand festlegen
  if MOUSEX<0 or MOUSEY<0 then            'wenn die Maus ausserhalb des Screens ist
    'falls eine Maustaste gedrückt aus den Screen geschoben wird, wird sie über
    'RELEASE in den RELEASED Zustand versetzt
    '"kostet" also 2 Loops als Ereignis im Eventloop
    LMB=iif(LMB>RELEASE,RELEASE,RELEASED)
    MMB=iif(MMB>RELEASE,RELEASE,RELEASED)
    RMB=iif(RMB>RELEASE,RELEASE,RELEASED)
    
    wheelvalue=oldwheelvalue
  else                                    'wenn Maus im Screen und Screen hat den Fokus

    'LMB 4 Schaltzustände simulieren
    if button and 1 then
        LMB=iif(LMB<HIT,HIT,HOLD)
    else
      LMB=iif(LMB>RELEASE,RELEASE,RELEASED)
    end if
    'MMB 4 Schaltzustände simulieren
    if button and 4 then
      MMB=iif(MMB<HIT,HIT,HOLD)
    else
      MMB=iif(MMB>RELEASE,RELEASE,RELEASED)
    end if
    'RMB 4 Schaltzustände simulieren
    if button and 2 then
      RMB=iif(RMB<HIT,HIT,HOLD)
    else
      RMB=iif(RMB>RELEASE,RELEASE,RELEASED)
    end if

    'RESET der Klicksequenz bei BUTTONDOWN
    if NEWCLICKSEQUENCE then
      if button and 1 then
        LMB=HIT
        oldLMB=RELEASED
      end if

      if button and 4 then
        MMB=HIT
        oldMMB=RELEASED
      end if

      if button and 2 then
        RMB=HIT
        oldRMB=RELEASED
      end if

      NEWCLICKSEQUENCE=0
    end if

  end if

  'Ereignisse setzen---->wenn Ereignis dann eventoccurred=1
  'Event Mausposition + Mausbewegung
  if MOUSEX<>oldMOUSEX or MOUSEY<>oldMOUSEY then
    MOUSEMOVED=1
    eventoccurred=1
  end if
  'Event LMB
  if LMB<>oldLMB then eventoccurred=1
  'Event MMB
  if MMB<>oldMMB then eventoccurred=1
  'Event RMB
  if RMB<>oldRMB then eventoccurred=1

  'Ereignis Rad
    oldWHEEL=WHEEL    
    WHEEL=sgn(oldwheelvalue - wheelvalue)
    if (oldWHEEL<>WHEEL) and (WHEEL<>0) then eventoccurred=1

  'Ereignis Tastatur
  if KEY<>"" then
    if len(KEY)=2 then
      EXTENDED=asc(left(KEY,1))
      KEY=right(KEY,1)
    end if
    ASCCODE=asc(KEY)
    eventoccurred=1
  end if

  'Event CloseButton
  if (EXTENDED<>0) and (ASCCODE=107) and (XButton=1)then
      CLOSEBUTTON=1
      eventoccurred=1   
  end if

  function=eventoccurred
end function
