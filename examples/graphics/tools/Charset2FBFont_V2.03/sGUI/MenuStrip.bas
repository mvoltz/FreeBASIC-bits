#include once "MenuList.bas"
#include once "MenuStripBox.bas"

namespace sGUI

declare function MenuStripSelector (posx as integer,posy as integer, BaseMenu as Menu ptr, StartID as integer=1, prevBoxWidth as integer=0,subdir as integer=1) as integer

function MenuStripSelector (posx as integer,posy as integer, BaseMenu as Menu ptr, StartID as integer=1, prevBoxWidth as integer=0,subdir as integer=1) as integer
  function=0
  
  dim as ListObject ptr DisplayList=PointerLists->AppendNew(ListObjectType)'für die Darstellung aufbereitete Einträge der aktuellen Menüebene 
  dim as integer BaseLevel,MenuLevel,result

  dim as integer Boxwidth,BoxHeight
  MenuFilter (BaseMenu, StartID, DisplayList)

  BoxWidth=0
  BoxHeight=0
  GetStripBoxSize DisplayList,BoxWidth,BoxHeight

  dim as integer scrw,scrh
  screeninfo scrw,scrh

  if prevBoxWidth>0 then
    if posx-BoxWidth+minspace <=0 then subdir=1
    if posx+BoxWidth-minspace+prevBoxWidth >= scrw then subdir=-1

    if subdir>0 then posx=posx+prevBoxWidth-minspace
    if subdir<0 then posx=posx-BoxWidth+minspace
  else
    if posx<0 then posx=0
    if (posx+BoxWidth)>= scrw then posx=scrw-BoxWidth-1
  end if

  if posy<0 then posy=0
  if (posy+BoxHeight)>= scrh then posy=scrh-BoxHeight-1
  
  dim as FB.Image ptr gfxbackup
  gfxbackup=imagecreate(BoxWidth,BoxHeight)
  
  if gfxbackup then
    get (posx,posy)-(posx+BoxWidth-1,posy+BoxHeight-1),gfxbackup
    clearbox (posx,posy,BoxWidth,BoxHeight,&HFF0000)
    dim as EventHandle ptr event=AddEventHandle

    dim as Gadget ptr strip=AddMStripBox(event,posx,posy,DisplayList)
  
    GadgetOn(strip)
    do
      event->xSleep(1,1)
      if event->GADGETMESSAGE then
        select case event->GADGETMESSAGE
          case strip
            dim as integer selectedRow=GetMStripVal(strip)
            dim as node ptr n=DisplayList->GetAddr(selectedRow)'selektierte Zeile -> node Adresse
            dim as MenuEntry ptr me=n->anypointer  'node->anypointer => Adresse des tatsächlichen Menüeintrages  
            
            select case me->Tag
              case METag_ITEM
                if me->Activation then
                  function=me->ID
                  event->EXITEVENT=1
                end if

              case METag_CHECKMARK
                if me->Activation then
                  dim as integer me_Selection=iif(me->Selection=1,0,1)
                  ModifyEntrySelection (BaseMenu,me->ID,me_Selection)
                  function=me->ID
                  event->EXITEVENT=1
                end if

              case METag_STRIPSTART
                if me->Activation then 
                  result=MenuStripSelector (posx,posy+(selectedRow-1)*GetFontHeight+minspace,BaseMenu,me->ID,BoxWidth,subdir)
                  
                  if result then
                    function=result
                    event->EXITEVENT=1
                  else
                    
                    if (MOUSEX<posx) or (MOUSEX>posx+BoxWidth-1) or (MOUSEY<posy) or (MOUSEY>posy+BoxHeight-1) then
                      function=0
                      event->EXITEVENT=1
                    end if
                  end if
                
                end if

            end select
        end select
        
      else
        
        if (LMB=HIT) or (RMB=HIT) then
          if (MOUSEX<posx) or (MOUSEX>posx+BoxWidth-1) or (MOUSEY<posy) or (MOUSEY>posy+BoxHeight-1) then
            function=0
            event->EXITEVENT=1
          end if
        end if
      
      end if
    loop until event->EXITEVENT

    put (posx,posy),gfxbackup,pset
    DelEventHandle(event)
    imagedestroy gfxbackup
  end if
  
  NEWCLICKSEQUENCE=1
  PointerLists->DeleteNode(DisplayList)'die Displayliste kann dann wieder gelöscht werden
  'Die eigntliche MenüListe existiert nach wie vor in BaseMenu
end function

end namespace
