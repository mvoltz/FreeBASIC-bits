#include once "MenuStrip.bas"

namespace sGUI

declare function AddMenuBar (event as EventHandle ptr, BaseMenu as Menu ptr) as Gadget ptr
declare function MenuBarActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawMenuBar (gad as Gadget ptr)
declare sub UpdateMenuBar (gad as Gadget ptr)
declare function GetMenuBarVal(gad as Gadget ptr) as integer

function AddMenuBar (event as EventHandle ptr, BaseMenu as Menu ptr) as Gadget ptr
  function=0
  dim as Gadget ptr gad
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event
  	gad->sel=0
    gad->act=0
    gad->posx=0
    gad->posy=0
    screeninfo gad->gadw

    gad->gadh=GetFontHeight(1) + 2*minspace

    gad->caption=""

    gad->DoDraw     =@DrawMenuBar
    gad->DoAction   =@MenuBarActions
    gad->DoUpdate   =@UpdateMenuBar
    dim as node ptr n
    gad->anypointer = PointerLists->AppendNew(ListObjectType)
    n=cast(ListObject ptr,gad->anypointer)->AppendNew(NodeType)'erzeugt 1. Eintrag in Liste
		n->anypointer = BaseMenu' und weist diesem in anypointer die Adresse des BaseMenue zu
    MenuFilter (BaseMenu,0,gad->anypointer)
    function=gad
  end if
end function



function MenuBarActions(gad as Gadget ptr,action as integer) as integer
  function=0
  dim n as node ptr
  dim m as Menu ptr
  dim me as MenuEntry ptr
  dim as integer PosX,PosY,result
  PosX=2*minspace
  select case action
      
      case GADGET_LMBHIT        'Control grad frisch gedrückt
        SetSelect (gad,0)
        m=cast(Node ptr, cast(ListObject ptr,gad->anypointer)->GetAddr(1) )->anypointer
        n=cast(ListObject ptr,gad->anypointer)->GetAddr(2)
        gad->Ctrl(15)=0
        do
          if n then
            me=n->anypointer
            if me->Activation then
              if (MOUSEX>=PosX-2*minspace) and (MOUSEX<PosX-2*minspace+me->entrywidth) and (MOUSEY>=0) and (MOUSEY<gad->gadh) then _
                gad->Ctrl(15)=MenuStripSelector (PosX-2*minspace,gad->gadh-1,m,me->ID)
            end if

            if gad->Ctrl(15) then
              function=1
              n=0
            else
              PosX +=me->entrywidth
              n=n->next_node
            end if

          end if
        loop until n=0

      case GADGET_LMBHOLD       'Control wird gehalten, Maus über dem Control
        SetSelect (gad,0)

      case GADGET_LMBHOLDOFF    'Control wird gehalten, Maus neben dem Control
        SetSelect (gad,0)
      
      case GADGET_LMBRELEASE    'Control regulär losgelassen
        SetSelect (gad,0)

      case GADGET_LMBRELEASEOFF 'Control losgelassen, dabei ist Maus neben dem Control
        SetSelect (gad,0)
      
      case GADGET_MOUSEOVER   'Maus überm Control
        gad->ctrl(13)=1
        DrawGadget(gad)

      case GADGET_MOUSENEXT   'Maus vom Control wegbewegt
        gad->ctrl(13)=0    
        DrawGadget(gad)
        
  end select
end function


sub DrawMenuBar (gad as Gadget ptr)
	dim as integer GadWidth,GadHeight,PosX,PosY
  dim as string selectboxtxt
	GadWidth		=gad->gadw
	GadHeight		=gad->gadh
  dim as node ptr n
  dim as MenuEntry ptr me
  PosX   =minspace*2
	PosY   =minspace
  screenlock
'OFF
    gad->PutBackGround
'ON   unselect/select
  if gad->act then
    FillA 0,0,GadWidth,GadHeight,,,0
    n=cast(ListObject ptr,gad->anypointer)->GetAddr(2)
    do
      if n then
        me=n->anypointer
          select case me->Activation
            case 0
              drawstring ( PosX, PosY,me->Text,MenuGhostlyColor)
            case 1
              'glowfx
              if gad->ctrl(13) then
                if (MOUSEX>=PosX-2*minspace) and (MOUSEX<PosX-2*minspace+me->entrywidth) then FillA PosX-2*minspace,0,me->entrywidth,GadHeight,GadgetGlowColor,GadgetGlowFrameColor,0
              end if
              drawstring ( PosX, PosY,me->Text,,TextColor)
          end select
          PosX +=me->entrywidth
        n=n->next_node
      end if

    loop until n=0
'SLEEP
    if gad->act=2 then gad->PutBackGround SleepShade
  end if
  screenunlock
end sub


sub UpdateMenuBar(gad as Gadget ptr)
  DrawGadget(gad)
end sub


function GetMenuBarVal(gad as Gadget ptr) as integer
  function=gad->Ctrl(15)
end function

end namespace