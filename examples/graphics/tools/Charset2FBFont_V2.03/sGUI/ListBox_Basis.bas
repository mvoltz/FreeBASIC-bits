namespace sGUI

declare function AddLBGadget (event as EventHandle ptr,PosX as integer,PosY as integer,BoxWidth as integer=1,BoxHeight as integer=1,InitialTO as TextObject ptr=0,DisplayMode as integer=0) as Gadget ptr
declare function LBActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawLB(gad as Gadget ptr)
declare function GetLBVal(gad as Gadget ptr) as integer
declare sub VScrollLB(gad as Gadget ptr,l as integer)

'Ctrl(0)=Breite der Box in Zeichen
'Ctrl(1)=Höhe der Box in Zeilen
'Ctrl(2) Rand links
'Ctrl(3) Rand oben
'Ctrl(4)=angescrollte Zeile, für Vertikalscrolling, oberste sichtbare Zeile in der Box
'Ctrl(5) DisplayMode 0="Normale Darstellung", 1=String ist nach Label und Item zu unterscheiden, 3 DIR Modus FileRequester
'                     >>>>>>> 2=MenuSelector Modus entfällt!!!!!!!!!
'Ctrl(14) Regel/Returngröße: im DisplayMode 1 Item ID
'Ctrl(15)= Regel/Returngröße: im DisplayMode 0 angeklickte Zeile
function AddLBGadget (event as EventHandle ptr,PosX as integer,PosY as integer,BoxWidth as integer=1,BoxHeight as integer=1,InitialTO as TextObject ptr=0,DisplayMode as integer=0) as Gadget ptr
  function=0
  dim as Gadget ptr gad
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event
  	gad->sel=0
    gad->act=0
    gad->posx=PosX
    gad->posy=PosY

    gad->Ctrl(0)=int((BoxWidth-2*minspace)/GetFixedWidth)
    gad->Ctrl(1)=int((BoxHeight-2*minspace)/GetFontHeight(1))
    gad->Ctrl(2)=int( (BoxWidth  - gad->Ctrl(0)*GetFixedWidth) /2)
    gad->Ctrl(3)=int( (BoxHeight - gad->Ctrl(1)*GetFontHeight(1)) /2)
    gad->gadw=BoxWidth
    gad->gadh=BoxHeight

    gad->Ctrl(4)=1
    gad->Ctrl(5)=DisplayMode
    gad->Ctrl(14)=0
    gad->Ctrl(15)=0

    gad->DoDraw     =@DrawLB
    gad->DoAction   =@LBActions
    gad->DoUpdate   =@DrawLB

    if InitialTO then
      gad->TObject=InitialTO
      gad->anypointer=InitialTO
    else
      gad->TObject=AddTextObject
      gad->anypointer=AddTextObject
    end if

		function=gad
  end if
end function


function LBActions(gad as Gadget ptr,action as integer) as integer
  function=0
  dim as integer l,ll,lcl,oleft,otop
  dim as string lc,header,itemid
	dim as integer GadX,GadY,GadMousePos
  GetGlobalPosition(gad,GadX,GadY)
	oleft          =gad->Ctrl(2)
	otop           =gad->Ctrl(3)

  select case action

      case GADGET_LMBHIT        'Control grad frisch gedrückt
        SetSelect (gad,1)

        ll=TO_GetLines(gad)
        l=0
        if ll then'wenn Zeilen im TO
          if MOUSEY>=GadY+otop and MOUSEY<GadY + gad->gadh-otop then
            l=gad->Ctrl(4) + int((MOUSEY-GadY-otop)/GetFontHeight(1))
            if l>ll then l=ll
          end if
        end if
        if l>0 then'sollte gültig eine Zeile angeklickt worden sein
          select case gad->Ctrl(5)

            case 0,3
              gad->Ctrl(15)=l
              DrawGadget(gad)
              function=1

            case 1
              lc=TO_GetLineContent(gad,l)
              header=left(lc,3)
              if header="ITM" then
                itemid=mid(lc,5,3)
                gad->Ctrl(14)=val(itemid)
                gad->Ctrl(15)=l
                DrawGadget(gad)
                function=1
              end if
          end select
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



sub DrawLB (gad as Gadget ptr)
	dim as integer GadX,GadY,GadWidth,GadHeight
	dim as integer oleft,otop,NumRows,fheight
  dim as integer boxc,boxl,scrollline,lcount,selline,act,sel
	dim as uinteger tcolor
  dim as TextLine ptr l
  dim as string tmpstring,cursorchar,typestring
  
  GetGlobalPosition(gad,GadX,GadY)
	GadWidth =gad->gadw
	GadHeight=gad->gadh
  NumRows=TO_GetLines(gad)
  boxc=gad->Ctrl(0)
  boxl=gad->Ctrl(1)
	oleft=gad->Ctrl(2)
	otop=gad->Ctrl(3)
  scrollline=gad->Ctrl(4)
  l=TO_GetLineAddr(gad,scrollline)
  selline=gad->Ctrl(15) 
  tmpstring=""

  screenlock
'OFF
  gad->PutBackGround
'ON
  if gad->act then

    fheight=GetFontHeight(1)
    FillE GadX,GadY,GadWidth,GadHeight,,,gad->sel,1

    if NumRows then
      lcount=0
      do
        tmpstring=TO_GetLineContent(gad,l)

        select case gad->Ctrl(5)

          case 0
            tmpstring=left(tmpstring,boxc)
            if (scrollline+lcount=selline) then FillA GadX+2,GadY+otop+lcount*fheight,GadWidth-3,fheight,GadgetGlowColor,GadgetGlowFrameColor,0
            drawstring ( GadX+oleft, GadY+otop+lcount*fheight ,tmpstring,textcolor,1)
            lcount +=1

          case 1
            if left(tmpstring,3)="LBL" then
              tmpstring=left(right(tmpstring,len(tmpstring)-4),boxc)
              FillA GadX+2,GadY+otop+lcount*fheight,GadWidth-3,fheight,&H333333,GadgetFrameColor,0
              tcolor=&HEE5500
            end if

            if left(tmpstring,3)="ITM" then
              tmpstring=left(space(2) & right(tmpstring,len(tmpstring)-8),boxc)
              if (scrollline+lcount=selline) then
                tcolor=TextColor
                FillA GadX+2,GadY+otop+lcount*fheight,GadWidth-3,fheight,GadgetGlowColor,GadgetGlowFrameColor,0
              else
                tcolor=TextColor
              end if
            end if
            drawstring ( GadX+oleft, GadY+otop+lcount*fheight,tmpstring,tcolor,1)
            lcount +=1

          case 3
            if left(tmpstring,5)="<DIR>" then
              tcolor=&HEE0011
            else
              tcolor=TextColor
            end if
            if (MOUSEY>=GadY+otop+lcount*fheight) and  (MOUSEY<GadY+otop+(lcount+1)*fheight) then FillA GadX+2,GadY+otop+lcount*fheight,GadWidth-3,fheight,GadgetGlowColor,GadgetGlowColor,0
            if (scrollline+lcount=selline) then FillA GadX+2,GadY+otop+lcount*fheight,GadWidth-3,fheight,GadgetGlowColor,GadgetGlowFrameColor,0            
            tmpstring=left(tmpstring,boxc)
            drawstring ( GadX+oleft, GadY+otop+lcount*fheight,tmpstring,tcolor,1)
            lcount +=1

         end select
        l=l->nextline
      loop until (l=0) or (lcount=boxl)'keine Zeile im TO oder der Zeilenzähler=Anzahl der zu zeigenden Zeilen(lcount startet bei 0!)
    end if
'SLEEP
    if gad->act=2 then gad->PutBackGround SleepShade
  end if
  screenunlock
end sub



sub VScrollLB(gad as Gadget ptr,l as integer)
  gad->Ctrl(4)=l
end sub


function GetLBVal(gad as Gadget ptr) as integer
  select case gad->Ctrl(5)
    case 0,3
      function=gad->Ctrl(15)
    case 1
      function=gad->Ctrl(14)
  end select
end function

end namespace
