namespace sGUI

declare function AddMStripBox (event as EventHandle ptr,PosX as integer,PosY as integer,EntryList as ListObject ptr=0) as Gadget ptr
declare function MSActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawMStrip(gad as Gadget ptr)
declare sub UpdateMStrip(gad as Gadget ptr)
declare function GetMStripVal(gad as Gadget ptr) as integer
declare sub GetStripBoxSize(l as ListObject ptr, byref BoxWidth as integer, byref BoxHeight as integer)

'Ctrl(0) Breite der Box in Zeichen ???
'Ctrl(1) Höhe der Box in Zeilen ???
'Ctrl(2) Rand links
'Ctrl(3) Rand oben
'Ctrl(15) Returngröße: MenuEntry ID
function AddMStripBox (event as EventHandle ptr,PosX as integer,PosY as integer,EntryList as ListObject ptr=0) as Gadget ptr
  function=0
  dim as Gadget ptr gad
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event
  	gad->sel=0
    gad->act=0
    gad->posx=PosX
    gad->posy=PosY

    gad->Ctrl(0)=0
    gad->Ctrl(1)=0
    gad->Ctrl(2)=minspace
    gad->Ctrl(3)=minspace
    gad->gadw=0
    gad->gadh=0
    GetStripBoxSize EntryList,gad->gadw,gad->gadh


    gad->Ctrl(4)=1
    gad->Ctrl(15)=0

    gad->DoDraw     =@DrawMStrip
    gad->DoAction   =@MSActions
    gad->DoUpdate   =@UpdateMStrip

    gad->anypointer=EntryList

    'gad->SaveBackGround
		function=gad
  end if
end function


function MSActions(gad as Gadget ptr,action as integer) as integer
  function=0
  dim as integer oleft,otop,selectedRow,maxRows
  dim as ListObject ptr lst
  oleft=gad->Ctrl(2)
	otop=gad->Ctrl(3)
  selectedRow=0
  lst=gad->anypointer
  maxRows=lst->NumNodes'Anzahl der nodes=Anzahl der sichtbaren (gefilterten) Menüeinträge des Strips
  select case action

      case GADGET_LMBHIT        'Control grad frisch gedrückt
        SetSelect (gad,1)

        selectedRow=0
        if maxRows then'wenn Einträge vorhanden
          if MOUSEY>=gad->posy+otop and MOUSEY<gad->posy + gad->gadh-otop then
            selectedRow=int((MOUSEY-gad->posy-otop)/GetFontHeight)+1
            if selectedRow>maxRows then selectedRow=maxRows
          end if
        end if

        if selectedRow>0 then'sollte gültig eine Zeile angeklickt worden sein
          gad->Ctrl(15)=selectedRow
          DrawGadget(gad)
          function=1
        end if

      case GADGET_LMBHOLD       'Control wird gehalten, Maus über dem Control
        SetSelect (gad,1)
      case GADGET_LMBHOLDOFF    'Control wird gehalten, Maus neben dem Control
        SetSelect (gad,0)
      case GADGET_LMBRELEASE    'Control regulär losgelassen
        SetSelect (gad,0)
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


sub DrawMStrip (gad as Gadget ptr)
	dim as integer PosX,PosY,GadWidth,GadHeight,oleft,otop,fheight,count,gtwidth
  dim as node ptr n
  dim as MenuEntry ptr me

  PosX   =gad->posx
	PosY   =gad->posy
	GadWidth=gad->gadw
	GadHeight=gad->gadh
  oleft=gad->Ctrl(2)
  otop=gad->Ctrl(3)
  fheight=GetFontHeight
  gtwidth=GetTextWidth(">")
  screenlock
'OFF
  gad->PutBackGround
'ON
  if gad->act then
    FillE PosX,PosY,GadWidth,GadHeight,,,gad->sel,0

  n=cast(ListObject ptr,gad->anypointer)->GetFirst
  do
    if n then
      count=n->index-1
      me=n->anypointer
      if me->Activation then
        if (MOUSEY>=PosY+otop+count*fheight) and  (MOUSEY<PosY+otop+(count+1)*fheight) then
          FillA PosX+2,PosY+otop+count*fheight,GadWidth-4,fheight,GadgetGlowColor,GadgetGlowFrameColor,0
        end if
      end if

     select case me->Tag
        case METag_ITEM
          select case me->Activation
            case 0
              drawstring ( PosX +oleft+8+minspace, PosY+otop+count*fheight,me->Text,MenuGhostlyColor)
            case 1
              drawstring ( PosX +oleft+8+minspace, PosY+otop+count*fheight,me->Text,TextColor)
          end select

        case METag_STRIPSTART
          select case me->Activation
            case 0
              drawstring ( PosX +oleft+8+minspace, PosY+otop+count*fheight,me->Text,MenuGhostlyColor)
              drawstring ( PosX + gadwidth - gtwidth - minspace, PosY+otop+count*fheight,">",MenuGhostlyColor)
            case 1
              drawstring ( PosX +oleft+8+minspace, PosY+otop+count*fheight,me->Text,,TextColor)
              drawstring ( PosX + gadwidth - gtwidth - minspace, PosY+otop+count*fheight,">",,TextColor)
          end select

        case METag_CHECKMARK
          if me->activation then

            if me->Selection then
              Tick (PosX+oleft,PosY+otop+count*fheight+(fheight-8)/2,TextColor)
              drawstring ( PosX+oleft+8+minspace, PosY+otop+count*fheight,me->Text,TextColor)
            else
              drawstring ( PosX +oleft+8+minspace, PosY+otop+count*fheight,me->Text,TextColor)
            end if

          else

            if me->Selection then
              Tick (PosX+oleft,PosY+otop+count*fheight+(fheight-8)/2,MenuGhostlyColor)
              drawstring ( PosX +oleft+8+minspace, PosY+otop+count*fheight,me->Text,MenuGhostlyColor)
            else
              drawstring ( PosX +oleft+8+minspace, PosY+otop+count*fheight,me->Text,MenuGhostlyColor)
            end if

          end if

        case METag_SEPARATOR
          FillA PosX+2*minspace,PosY+otop+count*fheight + (fheight-3)/2,GadWidth-4*minspace,3,,,0
      end select

    end if
    n=n->next_node
  loop until n=0

    if gad->act=2 then gad->PutBackGround SleepShade
  end if
  screenunlock
end sub


sub UpdateMStrip(gad as Gadget ptr)
  GadgetOff(gad)
  dim as ListObject ptr EntryList=gad->anypointer
  GetStripBoxSize EntryList,gad->gadw,gad->gadh
  'gad->SaveBackGround
  RestoreActivation(gad)
end sub


function GetMStripVal(gad as Gadget ptr) as integer
  function=gad->Ctrl(15)
end function


sub GetStripBoxSize(l as ListObject ptr, byref BoxWidth as integer, byref BoxHeight as integer)
  dim as integer numlines
  dim as string tmpstring
  dim as node ptr n
  dim as MenuEntry ptr me
  BoxHeight=0

  n=l->GetFirst
  do
    if n then
      me=n->anypointer
      tmpstring=me->text & " >"
      if BoxWidth<GetTextWidth(tmpstring) then BoxWidth=GetTextWidth(tmpstring)
      BoxHeight +=GetFontHeight
    end if
    n=n->next_node
  loop until n=0
  BoxWidth +=(3*minspace + 8)
  BoxHeight +=2*minspace
end sub

end namespace
