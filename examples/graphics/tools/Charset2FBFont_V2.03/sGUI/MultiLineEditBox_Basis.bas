namespace sGUI

declare function AddMLEBGadget (event as EventHandle ptr,x as integer,y as integer,BoxWidth as integer,BoxHeight as integer,mode as integer=1) as Gadget ptr
declare function MLEBActions(gad as Gadget ptr,action as integer) as integer
declare sub DrawMLEB(gad as Gadget ptr)
declare sub UpdMLEB (gad as Gadget ptr)

declare sub HScrollMLEB(gad as Gadget ptr,c as integer)
declare sub VScrollMLEB(gad as Gadget ptr,l as integer)
declare function TraceCursorPosition(gad as Gadget ptr) as integer
declare function TraceCursorLine(gad as Gadget ptr) as integer

'Ctrl(0)=Breite der Box in Zeichen
'Ctrl(1)=Höhe der Box in Zeilen
'Ctrl(2) Rand links
'Ctrl(3) Rand oben
'Ctrl(4)=angescrolltes Zeichen, für Horizontalscrolling, hat nichts mit der Cursoposition im TO der Box
'Ctrl(5)=angescrollte Zeile, für Vertikalscrolling, hat nichts mit der Cursorzeile im TO der Box
'Ctrl(6)= 0=Viewmodus 1=Editormodus 2=StringGadgetViewmodus 3=StringGadgetEditormodus
'Ctrl(7)= 0=GFX für StringGadget 1=GFX für mehrzeilige MLEB
function AddMLEBGadget (event as EventHandle ptr,x as integer,y as integer,BoxWidth as integer,BoxHeight as integer,mode as integer=1) as Gadget ptr
  function=0
  dim as Gadget ptr gad
  gad=event->GadgetList->AppendNew (GadgetType)
  if gad then
    gad->event=event
  	gad->sel=0
    gad->act=0
    gad->posx=x
    gad->posy=y
    gad->gadw=BoxWidth
    gad->gadh=BoxHeight
    
    gad->Ctrl(0)=int((BoxWidth-2*minspace)/GetFixedWidth)
    gad->Ctrl(1)=int((BoxHeight-2*minspace)/GetFontHeight(1))
    gad->Ctrl(2)=int( (BoxWidth  - gad->Ctrl(0)*GetFixedWidth) /2)
    gad->Ctrl(3)=minspace
    gad->Ctrl(4)=1
    gad->Ctrl(5)=1
    select case mode
      case 0
        gad->Ctrl(6)=mode
        gad->Ctrl(7)=3
      case 1
        gad->Ctrl(6)=mode
        gad->Ctrl(7)=3
      case 2
        gad->Ctrl(6)=mode-2
        gad->Ctrl(7)=0
      case 3
        gad->Ctrl(6)=mode-2
        gad->Ctrl(7)=0
    end select

    gad->DoDraw     =@DrawMLEB
    gad->DoAction   =@MLEBActions
    gad->DoUpdate   =@UpdMLEB'falls Veränderungen am TO ein Update erfordern
		
    gad->TObject=AddTextObject

		function=gad
  end if
end function


function MLEBActions(gad as Gadget ptr,action as integer) as integer
  function=0
  dim as integer GadX,GadY
  GetGlobalPosition(gad,GadX,GadY)
  dim as integer l,p,ll,lcl,oleft,otop
  dim as string lc
	oleft=gad->Ctrl(2)
	otop=gad->Ctrl(3)
  select case action

      case GADGET_LMBHIT        'Control grad frisch gedrückt
        ll=gad->TObject->GetLines
        l=-1
        p=-1
        if MOUSEY>=GadY+otop and MOUSEY<GadY + gad->gadh-otop then
          l=gad->Ctrl(5) + int((MOUSEY-GadY-otop)/GetFontHeight(1))
          if l>ll then l=ll
          lc=gad->TObject->GetLineContent(l)
          lcl=len(lc)
        end if

        if MOUSEX>=GadX+oleft and MOUSEX<GadX + gad->gadw-oleft then
          if (gad->Ctrl(6)=0) or (gad->Ctrl(6)=1) then
            p=gad->Ctrl(4) + int((MOUSEX-GadX-oleft)/GetFixedWidth)
            if p>lcl then p=lcl+1
          end if
        end if

        if (l<>-1) and (p<>-1) then
          gad->TObject->SetCursor(l,p)
          function=1
        end if
      case GADGET_LMBHOLD       'Control wird gehalten, Maus über dem Control

      case GADGET_LMBHOLDOFF    'Control wird gehalten, Maus neben dem Control

      case GADGET_LMBRELEASE    'Control regulär losgelassen

      case GADGET_LMBRELEASEOFF 'Control losgelassen, dabei ist Maus neben dem Control

      case GADGET_KEYBOARD   'Keyboardauswertung

  end select
end function


sub DrawMLEB (gad as Gadget ptr)
	dim as integer GadX,GadY,GadWidth,GadHeight
  GetGlobalPosition(gad,GadX,GadY)
	GadWidth =gad->gadw
	GadHeight=gad->gadh

	dim as integer oleft,otop,lines
  dim as integer boxc,boxl,scrollpos,scrollline,lcount,cursorline,cursorpos,cursorvisible
	dim as uinteger tcolor
  dim as TextLine ptr l
  dim as string tmpstring,cursorchar
  lines=gad->TObject->GetLines
  boxc=gad->Ctrl(0)
  boxl=gad->Ctrl(1)
	oleft=gad->Ctrl(2)
	otop=gad->Ctrl(3)
  scrollpos=gad->Ctrl(4)
  scrollline=gad->Ctrl(5)
  l=gad->TObject->GetLineAddr(scrollline)
  cursorline=gad->TObject->GetCursorLine
  cursorpos=gad->TObject->GetCursorPosition
  cursorchar=""
  cursorvisible=0
  tmpstring=gad->TObject->GetLineContent(cursorline)
  if cursorline>=scrollline and cursorline<scrollline+boxl and cursorpos>=scrollpos and cursorpos<scrollpos+boxc then
    cursorvisible=1
    if len(tmpstring)>=cursorpos then cursorchar=mid(tmpstring,cursorpos,1)
  end if

  tmpstring=""
  screenlock
  if gad->act=0 then
    gad->PutBackGround
  else
    FillE GadX,GadY,GadWidth,GadHeight,,,gad->sel,gad->Ctrl(7)

    if TO_GetLines(gad) then
      lcount=0
      do
        tmpstring=gad->TObject->GetLineContent (l)
        if scrollpos>len(tmpstring) then'Wenn der Zeichenoffset größer ist als Zeilenlänge(Horizontalscrolling)
          tmpstring=""
        else
          tmpstring=mid(tmpstring,scrollpos,boxc)
        end if
      
        select case gad->Ctrl(6)
          case 0'Textview
            if (gad->sel=1) and (cursorvisible=1) and (scrollline+lcount=cursorline) then _
              ClearBox GadX+oleft+(cursorpos-scrollpos)*GetFixedWidth,GadY+otop+lcount*GetFontHeight(1)+(GetFontHeight(1)-2),GetFixedWidth,2,&HEEEEEE
            tcolor=TextColor
  
          case 1'Cursor
            if (gad->sel=1) and (cursorvisible=1) and (scrollline+lcount=cursorline) then _
              ClearBox GadX+oleft+(cursorpos-scrollpos)*GetFixedWidth-1,GadY+otop+lcount*GetFontHeight(1),2,GetFontHeight(1),CursorColor
            tcolor=TextColor
  
        end select
        
        drawstring ( GadX+oleft, GadY+otop+lcount*GetFontHeight(1),tmpstring,tcolor,1)

        l=l->nextline
        lcount +=1
      loop until (l=0) or (lcount=boxl)'keine Zeile im TO oder der Zeilenzähler=Anzahl der zu zeigenden Zeilen(lcount startet bei 0!)
    else
      if (gad->sel=1) then _
      ClearBox GadX+oleft,GadY+otop,2,GetFontHeight(1),CursorColor
    end if
    if gad->act=2 then gad->PutBackGround SleepShade 'Shade (GadX, GadY,GadWidth, GadHeight,gad->Background->img)
  end if
  screenunlock
end sub


sub UpdMLEB (gad as Gadget ptr)
  if TO_GetLines(gad) then
    TraceCursorLine(gad)
    TraceCursorPosition(gad)
  end if
  DrawGadget(gad)                                    
end sub


sub HScrollMLEB(gad as Gadget ptr,c as integer)
  gad->Ctrl(4)=c
end sub


sub VScrollMLEB(gad as Gadget ptr,l as integer)
  gad->Ctrl(5)=l
end sub


function TraceCursorPosition(gad as Gadget ptr) as integer
  dim as integer cp=gad->TObject->GetCursorPosition
  if cp < gad->Ctrl(4) then gad->Ctrl(4)= cp
  if cp > gad->Ctrl(4) + gad->Ctrl(0)-1 then gad->Ctrl(4)= cp - gad->Ctrl(0)+1
  function=gad->Ctrl(4)
end function


function TraceCursorLine(gad as Gadget ptr) as integer
  dim as integer cl,ll,sl
  cl=gad->TObject->GetCursorLine
  ll=gad->TObject->GetLines
  sl=gad->Ctrl(5)

  if cl>=gad->Ctrl(5) and  cl<gad->Ctrl(5) + gad->Ctrl(1) then 'Cursor sichtbar

    if ll>=gad->Ctrl(5) and  ll<gad->Ctrl(5) + gad->Ctrl(1) then'wenn letzte Zeile sichtbar dann versuchen diese auf unterster Zeile im Scrollfenster zu halten
      sl= ll - gad->Ctrl(1)+1
      if sl<1 then sl=1
    end if

  else  'Cursor außerhalb des Scrollfensters dann Cursor zurückholen

    if cl < gad->Ctrl(5) then sl= cl 'vor(über) Scrollfenster
    if cl >= gad->Ctrl(5) + gad->Ctrl(1) then sl= cl - gad->Ctrl(1)+1'hinter(unter) Scrollfenster
  
  end if

  gad->Ctrl(5)=sl
  function=gad->Ctrl(5)
end function

end namespace
