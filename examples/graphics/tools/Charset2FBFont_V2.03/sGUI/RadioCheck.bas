namespace sGUI

declare function AddCheckMarkGadget (event as EventHandle ptr,PosX as integer,PosY as integer,SwtchSel as integer,Text as string="",textleft as integer=0) as Gadget ptr
declare function AddRadioButton (event as EventHandle ptr,PosX as integer,PosY as integer,SwtchSel as integer,Text as string="",Head as Gadget ptr,textleft as integer=0) as Gadget ptr
declare function RadioCheckActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawRadioCheck (gad as Gadget ptr)
declare sub UpdateRadioCheck (gad as Gadget ptr)
declare sub RCRethinkInternal(gad as Gadget ptr)

'Ctrl(0) offset x RadioButton/Checkbox
'Ctrl(1) offset y RadioButton/Checkbox
'Ctrl(2) offset x Text
'Ctrl(3) offset y Text
'Ctrl(4) Schalter Text links
'Ctrl(5) Originalposition x Backup
'Ctrl(6) Originalposition y Backup
'Ctrl(7)  wenn 1 Radiobutton
function AddCheckmarkGadget (event as EventHandle ptr,PosX as integer,PosY as integer,SwtchSel as integer, Text as string="",textleft as integer=0) as Gadget ptr
  function=0
  dim as Gadget ptr gad
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event
  	gad->sel=SwtchSel
    gad->act=0
    gad->Ctrl(4)=textleft
    gad->Ctrl(5)=PosX
    gad->Ctrl(6)=PosY
    gad->Ctrl(7)=0
    gad->caption=Text

    RCRethinkInternal(gad)

    gad->DoDraw     =@DrawRadioCheck
    gad->DoAction   =@RadioCheckActions
    gad->DoUpdate   =@UpdateRadioCheck
		function=gad
  end if
end function


function AddRadioButton (event as EventHandle ptr,PosX as integer,PosY as integer,SwtchSel as integer,Text as string="",Head as Gadget ptr,textleft as integer=0) as Gadget ptr
  function=0
  dim as Gadget ptr gad,groupfirst
  dim as node ptr n
  gad=AddCheckmarkGadget (event,PosX,PosY,SwtchSel,Text,textleft)

  if gad then
    gad->Ctrl(7)=1'CheckMark >>>> Radiobutton
    if Head=0 then
      gad->anypointer = sGUI.PointerLists->AppendNew (ListObjectType)'eine einfache (Zeiger)Liste für die Gruppe erzeugen
    else
      gad->anypointer = Head->anypointer'in einem Nichtheader Liste aus Header übernehmen
    end if

    n=cast(ListObject ptr,gad->anypointer)->AppendNew (nodeType)'in der Liste einen node als "Informationsträger" erzeugen
    n->anypointer=cast(any ptr,gad)'den Zeiger dieses Controls in den node schreiben

		function=gad
  end if
end function


function RadioCheckActions(gad as Gadget ptr,action as integer) as integer
  dim as Gadget ptr g
  dim as node ptr n
  dim as ListObject ptr lst=gad->anypointer'Adresse der "GruppenPointerliste"
  function=0
  select case action
      
      case GADGET_LMBRELEASE    'Control regulär losgelassen
          
        if gad->Ctrl(7) then
          
          n=lst->GetFirst
          do
            g=cast(Gadget ptr,n->anypointer)
            if g=gad then
              SetSelect(g,1)
            else
              SetSelect(g,0)
            end if
            n=n->next_node
          loop until n=0
          function=1
        
        else

          if GetSelect(gad) then SetSelect(gad,0) else SetSelect(gad,1)
          function=1
        
        end if

      case GADGET_MOUSEOVER   'Mouse überm Control
        gad->ctrl(13)=1
        DrawGadget(gad)

      case GADGET_MOUSENEXT   'Mouse vom Control wegbewegt
        gad->ctrl(13)=0
        DrawGadget(gad)

  end select
end function


sub DrawRadioCheck (gad as Gadget ptr)
	dim as integer GadX,GadY,RadioCheckPosx,RadioCheckPosY,TextPosX,TextPosY,GadWidth,GadHeight
  GetGlobalPosition(gad,GadX,GadY)
  GadWidth		   =gad->gadw
	GadHeight		   =gad->gadh  
  RadioCheckPosX =GadX + gad->Ctrl(0)
	RadioCheckPosY =GadY + gad->Ctrl(1)
  TextPosX       =GadX + gad->Ctrl(2)
	TextPosY       =GadY + gad->Ctrl(3)
  
  screenlock
'OFF
  gad->PutBackGround
'ON
  if gad->act then
    if gad->Ctrl(7) then'RadioButton
      'glowfx
      if gad->ctrl(13) then
        FillC RadioCheckPosX,RadioCheckPosY,GadgetGlowColor,gad->sel
      else
        FillC RadioCheckPosX,RadioCheckPosY,,gad->sel
      end if

    else'CheckMark
     'glowfx
      if gad->ctrl(13) then
        FillA RadioCheckPosX,RadioCheckPosY,16,16,GadgetGlowColor,GadgetGlowFrameColor,gad->sel
      else
        FillA RadioCheckPosX,RadioCheckPosY,16,16,,,0
      end if
      if gad->sel then Tick (RadioCheckPosX+4,RadioCheckPosY+4,GadgetTextColor)
    
    end if
    if gad->caption<>"" then drawstring (TextPosX,TextPosY,gad->caption,TextColor)
'SLEEP
    if gad->act=2 then gad->PutBackGround SleepShade
  end if
	screenunlock
end sub


sub UpdateRadioCheck (gad as Gadget ptr)
  gad->PutBackGround
  RCRethinkInternal(gad)
  gad->SaveBackGround
  DrawGadget(gad)
end sub


sub RCRethinkInternal(gad as Gadget ptr)
  if gad->caption="" then   'ohne Text
    'X Y Position Gadget
    gad->posx=gad->Ctrl(5)
    gad->posy=gad->Ctrl(6)
    'Breite u. Höhe Gadget
    gad->gadw=16
    gad->gadh=16
    'relative X Y Positionen CheckBox/RadioButton
    gad->Ctrl(0)=0
    gad->Ctrl(1)=0

  else                   'mit Text
    'neue Y Position Gadget
    gad->posy=gad->Ctrl(6)
    'Breite u. Höhe Gadget
    gad->gadw=16 + minspace + GetTextWidth(gad->caption)
    gad->gadh=GetFontHeight
    if gad->gadh<16 then gad->gadh=16
    'Y Offset CheckBox/RadioButton
    gad->Ctrl(1)=(gad->gadh - 16)/2
    'Y offset Text
    gad->Ctrl(3)=(gad->gadh-GetFontHeight)/2
    
    'Text links oder rechts?
    if gad->Ctrl(4) then' Text links
      'X Position Gadget(um Textbreite nach links verschoben)
      gad->posx= gad->Ctrl(5) - minspace - GetTextWidth(gad->caption)
      'X Offset CheckBox/RadioButton
      gad->Ctrl(0)=minspace + GetTextWidth(gad->caption)
      'X Offset Text
      gad->Ctrl(2)=0

    else 'Text rechts
      'X Position Gadget
      gad->posx=gad->Ctrl(5)
      'X Offset CheckBox/RadioButton
      gad->Ctrl(0)=0      
      'X Offset Text
      gad->Ctrl(2)=16 + minspace
    end if
  end if
end sub

end namespace
