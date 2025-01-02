namespace sGUI

declare function AddBMPSimpleGadget (event as EventHandle ptr,PosX as integer,PosY as integer,fn_unselected as string,fn_selected as string="",fn_mask as string="") as Gadget ptr
declare function BMPSGActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawBMPSimpleGadget (gad as Gadget ptr)

function AddBMPSimpleGadget (event as EventHandle ptr,PosX as integer,PosY as integer,fn_unselected as string,fn_selected as string="",fn_mask as string="") as Gadget ptr
  function=0
  dim as Gadget ptr gad
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    dim as integer<32> GadWidth,GadHeight,ff=freefile
    open  fn_unselected for binary as #ff
      get #ff, 19, GadWidth
      get #ff, 23, GadHeight
    close #ff
    gad->event=event
  	gad->sel=0
    gad->act=0
    gad->posx=PosX
    gad->posy=PosY
    gad->gadw=GadWidth
    gad->gadh=GadHeight

    gad->DoDraw     =@DrawBMPSimpleGadget
    gad->DoAction   =@BMPSGActions
    gad->DoUpdate   =@DrawBMPSimpleGadget
    
    gad->Unselected=AddImageEntry
    gad->Unselected->img=imagecreate(GadWidth,GadHeight)
    bload fn_unselected,gad->Unselected->img

    if fn_selected>"" then
      gad->Selected=AddImageEntry
      gad->Selected->img=imagecreate(GadWidth,GadHeight)
      bload fn_selected,gad->Selected->img
    end if
    
    if fn_mask>"" then
      gad->Mask=AddImageEntry
      gad->Mask->img=imagecreate(GadWidth,GadHeight)
      bload fn_mask,gad->Mask->img
    end if

    function=gad
  end if
end function


function BMPSGActions(gad as Gadget ptr,action as integer) as integer
  function=0
  select case action
      
      case GADGET_LMBHIT
        SetSelect (gad,1)
      
      case GADGET_LMBHOLD
        SetSelect (gad,1)
      
      case GADGET_LMBHOLDOFF
        SetSelect (gad,0)
      
      case GADGET_LMBRELEASE
        SetSelect (gad,0)
        function=1
      
      case GADGET_LMBRELEASEOFF
        SetSelect (gad,0)
  end select
end function



sub DrawBMPSimpleGadget (gad as Gadget ptr)
	dim as integer GadX,GadY,GadWidth,GadHeight
  GetGlobalPosition(gad,GadX,GadY)
	GadWidth =gad->gadw
	GadHeight=gad->gadh
  
  screenlock
	if gad->act=0 then 
    put(GadX,GadY),gad->Background->img,trans
  else
		put(GadX,GadY),gad->Background->img,trans
		if (gad->sel=1) and (gad->Selected>0) then
		  put(GadX,GadY),gad->Selected->img,trans
		else
			put(GadX,GadY),gad->Unselected->img,trans
  	end if
    if gad->act=2 then put(GadX,GadY),gad->Background->img,alpha,SleepShade
	end if
  screenunlock
end sub

end namespace
