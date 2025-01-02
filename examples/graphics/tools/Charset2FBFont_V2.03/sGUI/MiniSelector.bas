#include once "ListBox.bas"

namespace sGUI

declare function MiniSelector(PosX as integer,PosY as integer,BoxWidth as integer, BoxHeight as integer, TOAddr as textobject ptr=0, EntrySelected as integer=0,DisplayMode as integer=0) as integer

function MiniSelector(posx as integer,posy as integer,BoxWidth as integer, BoxHeight as integer, TOAddr as textobject ptr=0, EntrySelected as integer=0,DisplayMode as integer=0) as integer
  function=0

   #if __FB_VERSION__ >= "1.08.0"
    dim as ulong ScreenHeight
  #else
    dim as integer ScreenHeight
  #endif 
  
  screeninfo ,ScreenHeight
  if (posy+BoxHeight) >= ScreenHeight then posy=ScreenHeight-BoxHeight-1
  dim as FB.Image ptr gfxbackup
  gfxbackup=imagecreate(BoxWidth,BoxHeight)
  if gfxbackup then
    get (posx,posy)-(posx+BoxWidth-1,posy+BoxHeight-1),gfxbackup
    clearbox (posx,posy,BoxWidth,BoxHeight,&H0)


    dim as EventHandle ptr event=AddEventHandle
    dim as Gadget ptr list=AddListBox (event,posx,posy,BoxWidth,BoxHeight,DisplayMode,0)
    GadgetOn(list)

    dim as integer tlines=TOAddr->GetLines
    if tlines then
      for i as integer=1 to tlines
        TO_AppendLine(list , TOAddr->GetLineContent(i) )
      next i
      UpdateGadget(list)
    end if
    SetListBoxVal(list,EntrySelected)

    do
      event->xSleep(1,1)
      if event->GADGETMESSAGE then

        select case event->GADGETMESSAGE
          case list
          function=GetListBoxVal(list)
          event->EXITEVENT=1
        end select

      else

        'if LMB=HOLD then
        if LMB=RELEASE then
          if (MOUSEX<posx) or (MOUSEX>posx+BoxWidth-1) or (MOUSEY<posy) or (MOUSEY>posy+BoxHeight-1) then
            function=0
            event->EXITEVENT=1
          end if
        end if

      end if
    loop until event->EXITEVENT
    DelEventHandle event

    put (posx,posy),gfxbackup,pset
    imagedestroy gfxbackup
  end if
end function

end namespace
