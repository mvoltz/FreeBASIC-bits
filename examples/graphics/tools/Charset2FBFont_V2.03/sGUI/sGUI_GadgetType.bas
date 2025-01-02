type Gadget extends node
  event       as _EventHandle ptr'Zeiger auf den EventHandle dem dieses Gadget bei Erstellung zugeordnet worden ist
  sel         as integer    'Gadget Selektion
  act         as integer    'Gadget Aktivierung
  oldact      as integer    'alte Aktivierung, für RestoreActivation
  posx        as integer    'PositionX
  posy        as integer    'PositionY
  gadw        as integer    'Gadgetbreite
  gadh        as integer    'Gadgethöhe
  caption     as string     'GadgetText / Bezeichnung
  Ctrl(15)    as integer    'Steuerungsvariablen, je nach Gadgettyp unterschiedlich oder auch gar nicht genutzt
  
  DoDraw      as sub      (gad as Gadget ptr)                                     'Platzhalter Zeichenroutine
  DoAction    as function (refgad as Gadget ptr, action as integer) as integer    'Platzhalter für Ereignis-Routine
  DoUpdate    as sub      (gad as Gadget ptr)                                     'Platzhalter Update
  
  'alle SubEvents werden in einer globalen Liste verwaltet
  subevent    as _EventHandle ptr  
  
  'alle TextObjekte werden in einer globalen Liste verwaltet
  TObject     as _TextObject ptr
  
  'alle Images werden in einer globalen Liste verwaltet
  Background  as _sGUIImage ptr
  Unselected  as _sGUIImage ptr
  Selected    as _sGUIImage ptr
  Mask        as _sGUIImage ptr

  declare constructor
  declare destructor
  declare sub MainUpdate
  declare sub SaveBackGround
  declare sub PutBackGround (shade as integer=0)
end type


constructor Gadget
end constructor


destructor Gadget
  if subevent then DelEventHandle(subevent)
end destructor


sub Gadget.MainUpdate
  UpdateInternalEventHandle(@this)
  if DoUpdate then DoUpdate(@this)
end sub



sub Gadget.SaveBackGround
	dim as integer GadX,GadY,GadWidth,GadHeight
  GetGlobalPosition(@this,GadX,GadY)
	GadWidth =gadw
	GadHeight=gadh
  dim as FB.Image ptr img=imagecreate(GadWidth,GadHeight)
  if img then
    get(GadX,GadY)-(GadX+GadWidth-1,GadY+GadHeight-1),img
    if Background then DelImageEntry(Background)'falls altes Image existiert, erstmal löschen(node löscht FB.Image via Destructor)
    Background=AddImageEntry'neuen Imageeintrag(node) an Liste anhängen, noch leer!
    Background->img=img'Image dem node zuweisen
     'Wenn ein Masken-Image existiert, dann dessen Transparenz-Farbe übertragen
		if (Mask>0) then
  		for k as integer=0 to GadHeight-1
  			for i as integer=0 to GadWidth-1
  				if point(i,k,Mask->img)=&HFFFF00FF then pset Background->img,(i,k),&HFFFF00FF
				next i
			next k
		end if
  end if
end sub


sub Gadget.PutBackGround (shade as integer=0)
	dim as integer GadX,GadY
  GetGlobalPosition(@this,GadX,GadY)
  if Background then put(GadX,GadY),Background->img,alpha,255-shade
end sub
