'******************************************************************************
'******************************************************************************
'******************************************************************************
'Hängt einen Eintrag an die EventListe
function AddEventHandle as EventHandle ptr
  function=EventHandleList->AppendNew (EventHandleType)
end function

'Löscht den betreffenden Eintrag aus der EventListe
sub DelEventHandle(event as EventHandle ptr)
  EventHandleList->DeleteNode (event)
end sub

'Hängt einen Eintrag an die TOListe
function AddTextObject as TextObject ptr
  function=TOList->AppendNew (TextObjectType)
end function

'Löscht den betreffenden Eintrag aus der TOListe
sub DelTextObject(t as TextObject ptr)
  TOList->DeleteNode (t)
end sub

'Hängt einen Einrag an die Imageliste,"leer" ohne ein existierndes reales Image
function AddImageEntry as sGUIImage ptr
  function=ImageList->AppendNew (sGUIImageType)
end function

'Löscht den betreffenden Eintrag aus der Imageliste. Ein "darin befindliches" reales
'Image wird via Destructor gelöscht (siehe sGUI_ImageType.bas)
sub DelImageEntry(sguiimg as sGUIImage ptr)
  ImageList->DeleteNode(sguiimg)
end sub


function AddMenu as Menu ptr
  function=MenuList->AppendNew(sGUIMenuType)
end function

sub DelMenu (m as _Menu ptr)

end sub

'**************************************************************************************************
'**************************************************************************************************
'Aktivierung***************************************************************************************

sub GadgetOn (gad as Gadget ptr)
  GadOn (gad)
end sub


sub GadgetSleep (gad as Gadget ptr)
  GadSleep (gad)
end sub


sub GadgetOff (gad as Gadget ptr)
  GadOff (gad)
end sub


sub GadgetOn (gadblockstart as Gadget ptr, gadblockend as Gadget ptr)
  dim as Gadget ptr gad
  dim as integer exitloop=0
  gad=gadblockstart
  do
    GadOn (gad)
    if gad=gadblockend then exitloop=1
    gad=cast(Gadget ptr,gad->next_node)
  loop until (gad=0) or (exitloop=1)
end sub


sub GadgetSleep (gadblockstart as Gadget ptr, gadblockend as Gadget ptr)
  dim as Gadget ptr gad
  dim as integer exitloop=0
  gad=gadblockstart
  do
    GadSleep (gad)
    if gad=gadblockend then exitloop=1
    gad=cast(Gadget ptr,gad->next_node)
  loop until (gad=0) or (exitloop=1)
end sub


sub GadgetOff (gadblockstart as Gadget ptr, gadblockend as Gadget ptr)
  dim as Gadget ptr gad
  dim as integer exitloop=0
  gad=gadblockstart
  do
    GadOff (gad)
    if gad=gadblockend then exitloop=1
    gad=cast(Gadget ptr,gad->next_node)
  loop until (gad=0) or (exitloop=1)
end sub


sub RestoreActivation (gad as Gadget ptr)
  dim oa as integer=gad->oldact
  select case oa
    case 0
      GadOff (gad)
    case 1
      GadOn (gad)
    case 2
      GadSleep (gad)
  end select
end sub


sub RestoreActivation (gadblockstart as Gadget ptr, gadblockend as Gadget ptr)
  dim as Gadget ptr gad
  dim as integer oa
  dim as integer exitloop=0
  gad=gadblockstart
  do
    oa=gad->oldact
    select case oa
      case 0
        GadOff (gad)
      case 1
        GadOn (gad)
      case 2
        GadSleep (gad)
    end select
    if gad=gadblockend then exitloop=1
    gad=cast(Gadget ptr,gad->next_node)
  loop until (gad=0) or (exitloop=1)
end sub


'Dies waren bisher die "echten" Befehle
'sind jetzt zu Gunsten einer überladenen Variante oben gekapselt worden
sub GadOn (gad as Gadget ptr)
  if gad->Background=0 then gad->SaveBackGround
  gad->oldact=gad->act'alten Zustand merken
  gad->act=1
  gad->DoDraw (gad)

'wenn SubEvent vorhanden(rekursiv)
	if gad->subevent then
    dim as Gadget ptr g,ng  
    g=gad->subevent->GadgetList->GetFirst
    if g then
      do
        GadOn(g)
        g=cast(Gadget ptr,g->next_node)
      loop until g=0
    end if
	end if
end sub


sub GadSleep (gad as Gadget ptr)
  if gad->Background=0 then gad->SaveBackGround
  gad->oldact=gad->act'alten Zustand merken
  gad->act=2
  gad->DoDraw (gad)
  
	'wenn SubEvent vorhanden(rekursiv)
	if gad->subevent then
    dim as Gadget ptr g,ng  
    g=gad->subevent->GadgetList->GetFirst
    if g then
      do
        GadSleep(g)
        g=cast(Gadget ptr,g->next_node)
      loop until g=0
    end if
	end if
end sub


sub GadOff (gad as Gadget ptr)
  gad->oldact=gad->act'alten Zustand merken
  gad->act=0  
  gad->DoDraw (gad)

	'wenn SubEvent vorhanden(rekursiv)
	if gad->subevent then
    dim as Gadget ptr g,ng  
    g=gad->subevent->GadgetList->GetFirst
    if g then
      do
        GadOff(g)
        g=cast(Gadget ptr,g->next_node)
      loop until g=0
    end if
	end if
end sub


'**************************************************************************************************
'**************************************************************************************************
'Selektion*****************************************************************************************
function GetSelect (gad as Gadget ptr) as integer
  function=gad->sel
end function


sub SetSelect (gad as Gadget ptr,Selection as integer)
  gad->sel=selection
  gad->DoDraw (gad)
end sub


'**************************************************************************************************
'**************************************************************************************************
'Draw/Action/Update********************************************************************************
sub DrawGadget(gad as _Gadget ptr)
  gad->DoDraw (gad)
end sub


function GadgetAction(gad as Gadget ptr, action as integer) as integer
  function=gad->DoAction(gad,action)
end function


sub UpdateGadget(gad as _Gadget ptr)
  'gad->DoUpdate(gad)
  gad->MainUpdate
end sub


sub SetCaption(gad as _Gadget ptr,Text as string)
  gad->caption=Text
  UpdateGadget(gad)
end sub

'**************************************************************************************************
'**************************************************************************************************
'**************************************************************************************************
sub UpdateInternalEventHandle (gad as _Gadget ptr)
	if gad->subevent then
    gad->subevent->parentevent=gad->event
    gad->subevent->guiposX=gad->PosX
    gad->subevent->guiposY=gad->PosY
  end if
end sub


'******************************************************************************
'******************************************************************************
'Umlaute***********************************************************************

function UImport(s as string) as string
  function=""
  dim as string tmps
  dim as integer i,tmpasc
  if len(s) then
    tmps=s
    for i=1 to len(s)
      tmpasc=asc(mid(tmps,i,1))
      if tmpasc=228 then tmpasc=132 'ae
      if tmpasc=246 then tmpasc=148 'oe
      if tmpasc=252 then tmpasc=129 'ue

      if tmpasc=196 then tmpasc=142 'AE
      if tmpasc=214 then tmpasc=153 'OE
      if tmpasc=220 then tmpasc=154 'UE

      if tmpasc=223 then tmpasc=225 '"Eszett" zu "Beta"???

      mid(tmps,i,1)=chr(tmpasc)
    next i
    function=tmps
  end if
end function


function UExport(s as string) as string
  function=""
  dim as string tmps
  dim as integer i,tmpasc
  if len(s) then
    tmps=s
    for i=1 to len(tmps)
      tmpasc=asc(mid(tmps,i,1))
      if tmpasc=132 then tmpasc=228 'ae
      if tmpasc=148 then tmpasc=246 'oe
      if tmpasc=129 then tmpasc=252 'ue

      if tmpasc=142 then tmpasc=196 'AE
      if tmpasc=153 then tmpasc=214 'OE
      if tmpasc=154 then tmpasc=220 'UE

      if tmpasc=225 then tmpasc=223 '"Beta" zu "Eszett"???

      mid(tmps,i,1)=chr(tmpasc)
    next i
    function=tmps
  end if
end function


'******************************************************************************
'******************************************************************************
'Stringparser******************************************************************
'Setzt einen gültigen Dateinamen, wie vom FileRequester geliefert, vorraus!!!
'd.h. Dateiname muß sowohl die Pfadinformation als auch einen Dateinamen enthalten.
'Erweiterung optional

type FileNameInfo
  public:
  PathAndFile     as string
  Path            as string
  File            as string
  FileWithoutExt  as string
  Ext             as string

  public:
  declare constructor
  declare sub ParseFileName(filename as string)
end type


constructor FileNameInfo
  PathAndFile   =""
  Path          =""
  File          =""
  FileWithoutExt=""
  Ext           =""
end constructor


sub FileNameInfo.ParseFileName(filename as string)
  PathAndFile   =""
  Path          =""
  File          =""
  FileWithoutExt=""
  Ext           =""
  if filename<>"" then
    dim as string sep
    'define the path separation
    #ifdef __fb_win32__
      sep="\"
    #endif
    'Tux Variante
    #ifdef __FB_LINUX__
      sep="/"
    #endif

    dim as integer length,posext,posfile
    posext=0
    posfile=0
    PathAndFile=filename
    length=len(PathAndFile)
    posfile=instrrev(PathAndFile,sep)
    File=right(PathAndFile,length - posfile)
    Path=left(PathAndFile,posfile)
    posext=instrrev(File,".")
    if posext then
      FileWithoutExt=left(File,posext - 1)
      Ext=right(File,len(File) - posext + 1)
    end if
  end if
end sub


sub GetGlobalPosition(event as EventHandle ptr, byref posx as integer, byref posy as integer)
  if event->parentevent then 
    GetGlobalPosition(event->parentevent,posx,posy)'rekursiv zum "root event" hangeln
    posx +=event->guiposX
    posy +=event->guiposY    
  else'wenn kein parent mehr existiert, dann sind wir im "root event"
    posx =event->guiposX
    posy =event->guiposY  
  end if
end sub


sub GetGlobalPosition(gad as Gadget ptr, byref posx as integer, byref posy as integer)
  GetGlobalPosition(gad->event,posx,posy)
  posx    +=gad->posx
	posy    +=gad->posy
end sub
