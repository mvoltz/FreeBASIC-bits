#include once "SimpleToggle.bas"

namespace sGUI

'InitGFX m u s s aufgerufen worden sein
declare function MessageBox(PosX as integer,PosY as integer,MsgText as string="",TitleText as string="",MsgType as integer=1) as integer

'Konstanten für MessageBoxen
'Typen:
'MBType_OK=1
'MBType_YESNO=2
'MBType_CANCELRETRYIGNORE=3
'MBType_OKCANCEL=4
'MBType_RETRYCANCEL=5
'MBType_YESNOCANCEL=6

'Button Returnwerte
'MBButton_OK=1
'MBButton_CANCEL=2
'MBButton_RETRY=3
'MBButton_IGNORE=4
'MBButton_YES=5
'MBButton_NO=6

function MessageBox(PosX as integer,PosY as integer,MsgText as string="",TitleText as string="",MsgType as integer=1) as integer
  function=0

  dim as integer scrwidth,scrheight,gfxcursorx,gfxcursory,cursorcolumn,cursorrow
  dim as integer<32> locatereturn
  screeninfo scrwidth,scrheight
  screencontrol FB.GET_PEN_POS,gfxcursorx,gfxcursory
  locatereturn=locate
  cursorcolumn = lobyte(locatereturn)
  cursorrow = hibyte(locatereturn)

  if MsgType<1 then MsgType=1
  if MsgType>6 then MsgType=6

  dim as integer Boxwidth,BoxHeight,guiwidth,guiheight,guiposx,guiposy,textwidth,buttonswidth
  dim as integer numlines

  'Fake window Abstände u. Offsets
  BoxWidth   =0
  BoxHeight  =0

  dim as TextObject ptr t
  t=new TextObject
  if t then
    t->SetText(MsgText,"|")
    numlines=t->GetLines
    
    textwidth=0
    for i as integer=1 to numlines
      if GetTextWidth(t->GetLineContent(i))>textwidth then textwidth=GetTextWidth(t->GetLineContent(i))
    next i
    
    buttonswidth=0
    select case MsgType
      case MBType_OK
        buttonswidth=GetTextWidth(phrase_ok) + 2*minspace
      case MBType_YESNO
        buttonswidth=GetTextWidth(phrase_yes) + GetTextWidth(phrase_no) + 5*minspace
      case MBType_CANCELRETRYIGNORE
        buttonswidth=GetTextWidth(phrase_cancel) + GetTextWidth(phrase_retry) + GetTextWidth(phrase_ignore) + 8*minspace
      case MBType_OKCANCEL
        buttonswidth=GetTextWidth(phrase_ok) + GetTextWidth(phrase_cancel) + 5*minspace
      case MBType_RETRYCANCEL
        buttonswidth=GetTextWidth(phrase_retry) + GetTextWidth(phrase_cancel) + 5*minspace
      case MBType_YESNOCANCEL
        buttonswidth=GetTextWidth(phrase_yes) + GetTextWidth(phrase_no) + GetTextWidth(phrase_cancel) + 8*minspace
    end select

    guiwidth=iif(textwidth>buttonswidth,textwidth,buttonswidth)
    guiheight =(numlines+1)*GetFontHeight + 3*minspace
    
    GetOuterMeasures(guiwidth+4*minspace, guiheight+4*minspace,BoxWidth,BoxHeight)
    GetInnerMeasures(posx,posy,BoxWidth,BoxHeight,guiposx,guiposy,guiwidth,guiheight)
    guiposx +=2*minspace
    guiposy +=2*minspace
    guiwidth -=4*minspace
    guiheight -=4*minspace

    dim as integer ptr gfxbackup
    gfxbackup=imagecreate(scrwidth,scrheight)
    if gfxbackup then

      get (0,0)-(scrwidth-1,scrheight-1),gfxbackup
      screenlock
        cls
        put(0,0),gfxbackup,alpha,SleepShade
      screenunlock
      
      'zeichne fake window
      FakeWindow( posx,posy,BoxWidth,BoxHeight,TitleText,GadgetGlowColor,GadgetGlowFrameColor)
      for i as integer=1 to numlines
        drawstring (guiposx, guiposy + (i-1)*GetFontHeight,t->GetLineContent(i),TextColor)
      next i
      
      dim as EventHandle ptr event
      dim as Gadget ptr ok,yes,no,cancel,retry,ignore
      dim as integer result
      event=AddEventHandle

      select case MsgType
        case MBType_OK
          ok=AddSimpleGadget(event,guiposx + guiwidth - GetTextWidth(phrase_ok) - 2*minspace, guiposy + guiheight - GetFontheight - 2*minspace,,,phrase_ok)
          GadgetOn(ok)

        case MBType_YESNO
          yes=AddSimpleGadget(event,guiposx + guiwidth - GetTextWidth(phrase_yes) - GetTextWidth(phrase_no) - 5*minspace, guiposy + guiheight - GetFontheight - 2*minspace,,,phrase_yes)
          no=AddSimpleGadget(event,guiposx + guiwidth - GetTextWidth(phrase_no) - 2*minspace, guiposy + guiheight - GetFontheight - 2*minspace,,,phrase_no)
          GadgetOn(yes,no)

        case MBType_CANCELRETRYIGNORE
          cancel=AddSimpleGadget(event,guiposx + guiwidth - GetTextWidth(phrase_cancel) - GetTextWidth(phrase_retry) - GetTextWidth(phrase_ignore) - 8*minspace, guiposy + guiheight - GetFontheight - 2*minspace,,,phrase_cancel)
          retry=AddSimpleGadget(event,guiposx + guiwidth - GetTextWidth(phrase_retry) - GetTextWidth(phrase_ignore) - 5*minspace, guiposy + guiheight - GetFontheight - 2*minspace,,,phrase_retry)
          ignore=AddSimpleGadget(event,guiposx + guiwidth - GetTextWidth(phrase_ignore) - 2*minspace, guiposy + guiheight - GetFontheight - 2*minspace,,,phrase_ignore)
          GadgetOn(cancel,ignore)

        case MBType_OKCANCEL
          yes=AddSimpleGadget(event,guiposx + guiwidth - GetTextWidth(phrase_yes) - GetTextWidth(phrase_cancel) - 5*minspace, guiposy + guiheight - GetFontheight - 2*minspace,,,phrase_yes)
          cancel=AddSimpleGadget(event,guiposx + guiwidth - GetTextWidth(phrase_cancel) - 2*minspace, guiposy + guiheight - GetFontheight - 2*minspace,,,phrase_cancel)
          GadgetOn(yes,cancel)

        case MBType_RETRYCANCEL
          retry=AddSimpleGadget(event,guiposx + guiwidth - GetTextWidth(phrase_retry) - GetTextWidth(phrase_cancel) - 5*minspace, guiposy + guiheight - GetFontheight - 2*minspace,,,phrase_retry)
          cancel=AddSimpleGadget(event,guiposx + guiwidth - GetTextWidth(phrase_cancel) - 2*minspace, guiposy + guiheight - GetFontheight - 2*minspace,,,phrase_cancel)
          GadgetOn(retry,cancel)

        case MBType_YESNOCANCEL
          yes=AddSimpleGadget(event,guiposx + guiwidth - GetTextWidth(phrase_yes) - GetTextWidth(phrase_no) - GetTextWidth(phrase_cancel) - 8*minspace, guiposy + guiheight - GetFontheight - 2*minspace,,,phrase_yes)
          no=AddSimpleGadget(event,guiposx + guiwidth - GetTextWidth(phrase_no) - GetTextWidth(phrase_cancel) - 5*minspace, guiposy + guiheight - GetFontheight - 2*minspace,,,phrase_no)
          cancel=AddSimpleGadget(event,guiposx + guiwidth - GetTextWidth(phrase_cancel) - 2*minspace, guiposy + guiheight - GetFontheight - 2*minspace,,,phrase_cancel)
          GadgetOn(yes,cancel)
      end select

      do
        event->xSleep(1,0)
        if event->GADGETMESSAGE then
          select case event->GADGETMESSAGE
            case ok
              result=MBButton_OK
              event->EXITEVENT=1
            
            case cancel
              result=MBButton_CANCEL
              event->EXITEVENT=1
            
            case retry
              result=MBButton_RETRY
              event->EXITEVENT=1
            
            case ignore
              result=MBButton_IGNORE
              event->EXITEVENT=1
            
            case yes
              result=MBButton_YES
              event->EXITEVENT=1
            
            case no
              result=MBButton_NO
              event->EXITEVENT=1

          end select
        end if
      loop until event->EXITEVENT
      
      function=result

      DelEventHandle event

      put (0,0),gfxbackup,pset
      imagedestroy gfxbackup
    end if
    delete t
  end if

  screencontrol FB.SET_PEN_POS,gfxcursorx,gfxcursory
  locate(cursorrow,cursorcolumn)
end function

end namespace
