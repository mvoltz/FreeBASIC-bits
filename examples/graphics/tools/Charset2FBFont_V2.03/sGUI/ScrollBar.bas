#include once "Arrows.bas"
#include once "ScrollBar_Basis.bas"

namespace sGUI

declare function AddScrollBar(event as EventHandle ptr,PosX as integer,PosY as integer,SBLength as integer,Minimum as integer,Maximum as integer,ScrollValue as integer,PageSize as integer,Orientation as integer,DisplayMode as integer=0) as Gadget ptr
declare function ScrollBarActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawScrollBar (gad as Gadget ptr)

declare sub ModifyScrollBar overload(gad as Gadget ptr,ScrollValue as integer)
declare sub ModifyScrollBar (gad as Gadget ptr,Minimum as integer,Maximum as integer)
declare sub ModifyScrollBar (gad as Gadget ptr,Minimum as integer,Maximum as integer,ScrollValue as integer,PageSize as integer=0)
declare sub SetScrollBarVal (gad as Gadget ptr,ScrollValue as integer)
declare sub SetScrollBarLimits(gad as Gadget ptr,Minimum as integer,Maximum as integer)

declare function GetScrollBarVal (gad as Gadget ptr) as integer


'Ctrl(0) "Ablage" des Scrollwertes aus ->gad(0)(dem eigentlichen Scrollbar) im SubHandle
'Ctrl(1) Vergleichswert zu Ctrl(0) bei Unterschied gibt es nen Ping
function AddScrollBar(event as EventHandle ptr,PosX as integer,PosY as integer,SBLength as integer,Minimum as integer,Maximum as integer,ScrollValue as integer,PageSize as integer,Orientation as integer,DisplayMode as integer=0) as Gadget ptr
  function=0
  dim as Gadget ptr gad
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event
  	gad->sel=0
    gad->act=0
    gad->posx=PosX
    gad->posy=PosY
    gad->gadw=SBLength
    gad->gadh=15
    if Orientation then swap gad->gadw,gad->gadh'Breite und Höhe tauschen wenn vertikal
    gad->Ctrl(0)=ScrollValue
	
    gad->subevent=AddEventHandle
		if gad->subevent then
    
      gad->subevent->parentevent=event
      gad->subevent->guiposX=PosX
      gad->subevent->guiposY=PosY

      if Orientation then       'wenn vertikal
        if (DisplayMode=1) or (SBLength-32 < 10) then
          AddSB(gad->subevent,0,0,gad->gadh,Minimum,Maximum,ScrollValue,PageSize,1)
        else
          AddSB(gad->subevent,0,16,gad->gadh-32,Minimum,Maximum,ScrollValue,PageSize,1)
          AddArrow(gad->subevent, 0, 0, 2)
          AddArrow(gad->subevent, 0, gad->gadh-16, 3)
        end if
      else                      'wenn horizontal
        if (DisplayMode=1) or (SBLength-32 < 10) then
          AddSB(gad->subevent,0,0,gad->gadw,Minimum,Maximum,ScrollValue,PageSize,0)
        else
          AddSB(gad->subevent,16,0,gad->gadw-32,Minimum,Maximum,ScrollValue,PageSize,0)
          AddArrow(gad->subevent, 0, 0, 0)
          AddArrow(gad->subevent, gad->gadw-16, 0, 1)
        end if
      end if
    end if

    gad->DoDraw     =@DrawScrollBar
    gad->DoAction   =@ScrollBarActions
    gad->DoUpdate   =@DrawScrollBar

		''gad->SaveBackGround
		function=gad
  end if
end function



function ScrollBarActions(gad as Gadget ptr,action as integer) as integer
  function=0
  
  dim as Gadget ptr knobcontainer,arrowdecr,arrowincr
  knobcontainer=gad->subevent->GadgetList->GetFirst'Container existiert in jedem Fall  
  arrowdecr=cast(Gadget ptr,knobcontainer->next_node)'kann 0 sein dann sind kein Arrows erzeugt worden
  if arrowdecr then arrowincr=cast(Gadget ptr,arrowdecr->next_node) 
  
  select case action
    case GADGET_LMBHIT,GADGET_LMBHOLD,GADGET_LMBHOLDOFF,GADGET_LMBRELEASE,GADGET_LMBRELEASEOFF
       gad->Ctrl(1)=gad->Ctrl(0)
        gad->subevent->LMBGadgetCheck
        if gad->subevent->GADGETMESSAGE then

        	gad->Ctrl(0)=GetSBVal(knobcontainer)'egal welches der 3 Controls angeklickt wurde, Scrollbar auslesen
      
          select case gad->subevent->GADGETMESSAGE
            case knobcontainer
      			  'seltsam, beim Bewegen des Scrollbars muß garnichts passieren :D
            case arrowdecr
              gad->Ctrl(0) -=1
              SetSBVal(knobcontainer,gad->Ctrl(0))
              gad->Ctrl(0)=GetSBVal(knobcontainer)

            case arrowincr
              gad->Ctrl(0) +=1
              SetSBVal(knobcontainer,gad->Ctrl(0))
              gad->Ctrl(0)=GetSBVal(knobcontainer)
           end select
        end if
        if gad->ctrl(1)<>gad->Ctrl(0) then
          DrawGadget(knobcontainer)
          function=1
        end if
    case GADGET_MOUSEOVER,GADGET_MOUSENEXT
      gad->subevent->MouseOverCheck
  end select
end function



sub DrawScrollBar (gad as Gadget ptr)
  dim as Gadget ptr knobcontainer,arrowdecr,arrowincr
  knobcontainer=gad->subevent->GadgetList->GetFirst
  arrowdecr=cast(Gadget ptr,knobcontainer->next_node)
  DrawGadget(knobcontainer)
  'falls keine Arrows erzeugt wurden
  if arrowdecr then
    arrowincr=cast(Gadget ptr,arrowdecr->next_node)  
    DrawGadget(arrowdecr)
    DrawGadget(arrowincr)
  end if
end sub



sub SetScrollBarVal (gad as Gadget ptr,ScrollValue as integer)
  dim as Gadget ptr knobcontainer
  knobcontainer=gad->subevent->GadgetList->GetFirst
  SetSBVal (knobcontainer,ScrollValue)
  gad->Ctrl(0)=GetScrollBarVal (gad)
  DrawGadget(knobcontainer)
end sub



sub SetScrollBarLimits(gad as Gadget ptr,Minimum as integer,Maximum as integer)
  dim as Gadget ptr knobcontainer
  knobcontainer=gad->subevent->GadgetList->GetFirst
  SetSBLimits(knobcontainer,Minimum,Maximum)
  DrawGadget(knobcontainer)
end sub



sub ModifyScrollBar (gad as Gadget ptr,ScrollValue as integer)
  dim as Gadget ptr knobcontainer
  knobcontainer=gad->subevent->GadgetList->GetFirst
  SetSBVal (knobcontainer,ScrollValue)
  gad->Ctrl(0)=GetScrollBarVal (gad)
  DrawGadget(knobcontainer)
end sub



sub ModifyScrollBar (gad as Gadget ptr,Minimum as integer,Maximum as integer)
  dim as Gadget ptr knobcontainer
  knobcontainer=gad->subevent->GadgetList->GetFirst
  SetSBLimits(knobcontainer,Minimum,Maximum)
  DrawGadget(knobcontainer)
end sub



sub ModifyScrollBar (gad as Gadget ptr,Minimum as integer,Maximum as integer,ScrollValue as integer,PageSize as integer=0)
  dim as Gadget ptr knobcontainer
  knobcontainer=gad->subevent->GadgetList->GetFirst
  SetSBLimits(knobcontainer,Minimum,Maximum)
  SetSBVal (knobcontainer,ScrollValue)
  gad->Ctrl(0)=GetScrollBarVal (gad)
  DrawGadget(knobcontainer)
end sub



function GetScrollBarVal (gad as Gadget ptr) as integer
  dim as Gadget ptr knobcontainer
  knobcontainer=gad->subevent->GadgetList->GetFirst
  function=GetSBVal(knobcontainer)
end function

end namespace
