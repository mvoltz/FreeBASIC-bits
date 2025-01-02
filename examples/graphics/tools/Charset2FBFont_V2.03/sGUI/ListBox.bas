#include once "ListBox_Basis.bas"
#include once "ScrollBar.bas"

namespace sGUI

declare function AddListBox (event as EventHandle ptr,PosX as integer,PosY as integer,BoxWidth as integer,BoxHeight as integer,DisplayMode as integer=0,ScrollBarMode as integer=0) as Gadget ptr
declare function ListActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawList (gad as Gadget ptr)
declare sub UpdateListBox(gad as Gadget ptr)

declare function GetListBoxVal(gad as Gadget ptr) as integer
declare sub SetListBoxVal(gad as Gadget ptr,i as integer)

'Ctrl(1) DisplayMode 0="Normale Darstellung", 1=String ist nach Label und Item zu unterscheiden, 2=MenuSelector Modus, 3 DIR Modus FileRequester
'Ctrl(2) Anzahl Zeilen, für das Wheelscrolling
'Ctrl(15) wenn 1 wird ein Ping gegeben
function AddListBox(event as EventHandle ptr,PosX as integer,PosY as integer,BoxWidth as integer,BoxHeight as integer,DisplayMode as integer=0,ScrollBarMode as integer=0) as Gadget ptr
  function=0
  dim as Gadget ptr gad,listbox
  dim as integer NumChars,NumRows
  NumChars=int((BoxWidth-6-15)/GetFixedWidth)
  NumRows=int((BoxHeight-6)/GetFontHeight(1))
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event
    gad->sel=0
    gad->act=0
    gad->posx=PosX
    gad->posy=PosY
    gad->gadw=BoxWidth
    gad->gadh=BoxHeight

    gad->Ctrl(1)=DisplayMode
    gad->Ctrl(2)=NumRows
    
    gad->subevent=AddEventHandle
    if gad->subevent then
      gad->subevent->parentevent=event
      gad->subevent->guiposX=PosX
      gad->subevent->guiposY=PosY    
    
      listbox=AddLBGadget(gad->subevent,0,0,BoxWidth-15,BoxHeight,,DisplayMode)
      AddScrollBar(gad->subevent,BoxWidth-15,0,BoxHeight,1,1,1,NumRows,1,ScrollBarMode)
    end if

    gad->TObject=listbox->TObject'Verbindung zum Textobjekt in der Listbox
    
    gad->DoDraw     =@DrawList
    gad->DoAction   =@ListActions
    gad->DoUpdate   =@UpdateListBox
    function=gad
  end if
end function


function ListActions(gad as Gadget ptr,action as integer) as integer
  function=0

  dim as Gadget ptr listbox,scrollbar
  listbox=gad->subevent->GadgetList->GetFirst
  scrollbar=cast(Gadget ptr,listbox->next_node)
 
  dim as integer enable
  select case action
    case GADGET_LMBHIT,GADGET_LMBHOLD,GADGET_LMBHOLDOFF,GADGET_LMBRELEASE,GADGET_LMBRELEASEOFF
      gad->subevent->LMBGadgetCheck
      gad->Ctrl(15)=0
      if gad->subevent->GADGETMESSAGE then
        select case gad->subevent->GADGETMESSAGE
          case listbox
            gad->Ctrl(15)=1
          case scrollbar
            VScrollLB(listbox,GetScrollBarVal(scrollbar))
            DrawGadget(listbox)
        end select
      end if        
      if gad->Ctrl(15) then function=1
    
    case GADGET_WHEELMOVE
      ModifyScrollBar(scrollbar,GetScrollBarVal( scrollbar ) + WHEEL*(gad->Ctrl(2)-1) )
      VScrollLB(listbox,GetScrollBarVal(scrollbar))
      DrawGadget(listbox)
    
    case GADGET_MOUSEOVER,GADGET_MOUSENEXT
      gad->subevent->MouseOverCheck
  end select
end function


sub DrawList (gad as Gadget ptr)
  dim as Gadget ptr listbox
  listbox=gad->subevent->GadgetList->GetFirst
  DrawGadget(listbox)
end sub


sub UpdateListBox(gad as Gadget ptr)
  dim as Gadget ptr listbox,scrollbar
  listbox=gad->subevent->GadgetList->GetFirst
  scrollbar=cast(Gadget ptr,listbox->next_node)
  listbox->Ctrl(15)=0'Selektion in LB aufheben
  ModifyScrollBar(scrollbar,1,TO_GetLines(gad),1)
  VScrollLB(listbox,1)
  DrawGadget(listbox)
end sub


function GetListBoxVal(gad as Gadget ptr) as integer
  dim as Gadget ptr listbox,scrollbar
  listbox=gad->subevent->GadgetList->GetFirst
  scrollbar=cast(Gadget ptr,listbox->next_node)

  select case gad->Ctrl(1)
    case 0,2,3
      function=listbox->Ctrl(15)
    case 1
      function=listbox->Ctrl(14)
  end select
end function


sub SetListBoxVal(gad as Gadget ptr,i as integer)
  dim as integer l,lcount,found
  dim as string lc,header
  dim as integer itemid
  dim as integer spos
  l=TO_GetLines(gad)
 
  dim as Gadget ptr listbox,scrollbar
  listbox=gad->subevent->GadgetList->GetFirst
  scrollbar=cast(Gadget ptr,listbox->next_node)

  'im DisplayMode 1 steht i für die item ID nachder in allen Zeilen des TOs gesucht wird
  'wird die Zeile gefunden

  'im DisplayMode 0 entsprich i direkt der Zeile

  if gad->Ctrl(1) then              'DisplayMode 1
    if l then
      lcount=1
      found=0
      do
        lc=TO_GetLineContent(gad,lcount)
        header=left(lc,3)
        if header="ITM" then
          itemid=val(mid(lc,5,3))
          if itemid=i then found=lcount
        end if
        lcount +=1
      loop until (lcount>l) or (found>0)
      'found ist die Zeilennummer in der i als Item ID definiert ist
      if found then
        listbox->Ctrl(14)=i
        listbox->Ctrl(15)=found
        ModifyScrollBar(scrollbar,found)
        VScrollLB(listbox,GetScrollBarVal(scrollbar))
        DrawGadget(gad)
      end if
    end if

  else                              'DisplayMode 0

    if i<1 then i=1
    if i>l then i=l
    listbox->Ctrl(15)=i
    ModifyScrollBar(scrollbar,i)
    VScrollLB( listbox , GetScrollBarVal(scrollbar) )
    DrawGadget(gad)
  end if
end sub

end namespace
