#include once "SimpleToggle.bas"
#include once "StringGadget.bas"
#include once "ScrollBar.bas"
#include once "ListBox.bas"
#include once "Label.bas"
#include once "ParentArrow.bas"
#include once "MessageBox.bas"

namespace sGUI

'InitGFX m u s s aufgerufen worden sein
declare function FileRequester(posx as integer,posy as integer,BtnText as string,Path as string, File as string="",FExistMode as integer=0) as string
declare sub FindContent(gad as Gadget ptr,t as string )

function FileRequester(posx as integer,posy as integer,BtnText as string,Path as string, File as string="",FExistMode as integer=0) as string
  function=""

  dim as integer scrwidth,scrheight,gfxcursorx,gfxcursory,cursorcolumn,cursorrow
  dim as integer<32> locatereturn
  screeninfo scrwidth,scrheight
  screencontrol FB.GET_PEN_POS,gfxcursorx,gfxcursory
  locatereturn=locate
  cursorcolumn = lobyte(locatereturn)
  cursorrow = hibyte(locatereturn)
  'FR stuff
  dim as string sep,originpath,entry,GoToFolder,full  
  'Fake Window GUI Abstände u. Offsets
  dim as integer Boxwidth,BoxHeight,guiwidth,guiheight,guiposx,guiposy
  dim as integer parentposx,parentposy,pathposx,pathposy
  dim as integer listposx,listposy,listboxheight
  dim as integer labelposx,labelposy,fileposx,fileposy
  dim as integer doitposx,doitposy,cancelposx,cancelposy 
  BoxWidth   =400
  BoxHeight  =400
  GetInnerMeasures(posx,posy,BoxWidth,BoxHeight,guiposx,guiposy,guiwidth,guiheight)
  guiposx +=minspace
  guiposy +=minspace
  guiwidth -=2*minspace
  guiheight -=2*minspace
  
  parentposx   =0
  pathposx     =GetFontHeight(1)+ 3*minspace
  listposx     =0
  labelposx    =0
  fileposx     =GetTextWidth(phrase_file & ":") + minspace
  cancelposx   =guiwidth - GetTextWidth(phrase_cancel) - 2*minspace
  doitposx     =cancelposx - GetTextWidth(BtnText) - 3*minspace
  
  parentposy   =0
  pathposy     =0
  listposy     =GetFontHeight(1)+ 3*minspace
  cancelposy   =guiheight-GetFontHeight - 2*minspace
  doitposy     =cancelposy
  fileposy     =cancelposy - iif(GetFontHeight>GetFontHeight(1),GetFontHeight,GetFontHeight(1))- 3*minspace
  labelposy    =fileposy
  listboxheight=labelposy-listposy-minspace
  
  'Sichern des vom Requester bedeckten Hintergrundes
  dim as FB.Image ptr gfxbackup
  gfxbackup=imagecreate(scrwidth,scrheight)
  if gfxbackup then

    get (0,0)-(scrwidth-1,scrheight-1),gfxbackup
    screenlock
      cls
      put(0,0),gfxbackup,alpha,SleepShade
    screenunlock


    'zeichne fake window
    FakeWindow( posx,posy,BoxWidth,BoxHeight,BtnText & "...",GadgetGlowColor,GadgetGlowFrameColor)
  
    'Windows Variante
    #ifdef __fb_win32__
      sep="\"
    #endif
    'Tux Variante
    #ifdef __FB_LINUX__
      sep="/"
    #endif
  
    originpath=curdir
    chdir Path
    Path=curdir
    GoToFolder=""
    entry=""
  
    dim as EventHandle ptr event=AddEventHandle
    event->guiposX=guiposx
    event->guiposY=guiposy
    dim as Gadget ptr cdparent,strpath,contlist,lblfile,doit,cancel,strfile
    cdparent=AddParentArrow (event, parentposx,parentposy)
    strpath =AddStringGadget(event, pathposx, pathposy, guiwidth - GetFontHeight(1) - 3*minspace, Path,,,1)
    contlist=AddListBox     (event, listposx, listposy, guiwidth, listboxheight,3)
    lblfile =AddLabel       (event, labelposx,labelposy, phrase_file & ":")
    strfile =AddStringGadget(event, fileposx, fileposy, guiwidth - GetTextWidth(phrase_file & ":") - minspace, File,,,1)
    doit    =AddSimpleGadget(event, doitposx,doitposy,,,BtnText)
    cancel  =AddSimpleGadget(event, cancelposx, cancelposy,,,phrase_cancel)
  
    TO_ClearText(contlist)
    FindContent(contlist,"D")
    FindContent(contlist,"F")
    UpdateGadget(contlist)
  
    GadgetOn(cdparent,cancel)
  
    do
      event->xSleep(1,0)
      if event->GADGETMESSAGE then
        select case event->GADGETMESSAGE
  
          'Pfadeingabe
          case strpath
            chdir GetString(strpath)           'Wechsel ins Directory
            Path=curdir                        'Setze aktuellen Pfad
            
            TO_ClearText(contlist)
            FindContent(contlist,"D")
            FindContent(contlist,"F")
            UpdateGadget(contlist)
  
            SetString(strpath,Path)                     'Aktualisiere die Pfadanzeige
  
          case contlist
            entry=TO_GetLineContent(contlist,GetListBoxVal(contlist))
            if entry<>"" then
              if left(entry,6)="<DIR> " then                'wenn entry ein Directory
                GoToFolder=right(entry,len(entry)-6)
                chdir GoToFolder                   'Wechsel ins Directory
                Path=curdir                        'Setze aktuellen Pfad
  
                TO_ClearText(contlist)
                FindContent(contlist,"D")
                FindContent(contlist,"F")
                UpdateGadget(contlist)
  
                SetString(strpath,Path)                     'Aktualisiere die Pfadanzeige
              else                                          'ansonsten ist entry ein Dateiname
                File=entry
                SetString(strfile,File)
              end if
            end if
  
          case cdparent
            chdir ".."                                  'Wechsel ins übergeordnete Directory
            Path=curdir                        'Setze aktuellen Pfad
            
            TO_ClearText(contlist)
            FindContent(contlist,"D")
            FindContent(contlist,"F")
            UpdateGadget(contlist)
  
            SetString(strpath,Path)                     'Aktualisiere die Pfadanzeige        
  
  				'Beenden und Rückabe eines Strings
          case strfile,doit
            File=GetString(strfile)
            if File<>"" then
              if right(Path,1)<> sep then
                full=Path & sep & File
              else
                full=Path & File
              end if
              if FExistMode then
                if fileexists(full) then
                  function=full
                  event->EXITEVENT=1
                else
                  GadgetSleep(cdparent,cancel)
                  MessageBox(posx+20,posy+100,phrase_fileaccessdenied,phrase_error,MBType_OK)
                  RestoreActivation(cdparent,cancel)
                end if
              else
                function=full
                event->EXITEVENT=1
              end if
            end if
  
          'Abbruch des FileRequesters
          case cancel
            event->EXITEVENT=1
            function=""
  
        end select
      end if
    loop until event->EXITEVENT
    DelEventHandle event
    chdir originpath
    put (0,0),gfxbackup,pset
    imagedestroy gfxbackup
  end if
  
  screencontrol FB.SET_PEN_POS,gfxcursorx,gfxcursory
  locate(cursorrow,cursorcolumn)
end function



sub FindContent(gad as Gadget ptr,t as string )
  dim as integer attr
  dim as string entryname,pre
  if ucase(t)="D" then 'bei "D" suche nach Verzeichnissen
    attr=fbDirectory or fbHidden or fbReadOnly or fbSystem
    pre="<DIR> "       '"Vorsilbe" um Verzeichnisse von Dateien unterscheiden zu können
  end if
  if ucase(t)="F" then  'bei "F" suche nach Dateien
    attr=fbNormal or fbSystem
    pre=""
  end if

  entryname=dir("*",attr)
  do
    if (len(entryname)>0) and (entryname<>".") and (entryname<>"..") then TO_AppendLine(gad,pre & entryname)
    entryname=dir
  loop while len(entryname)
end sub

end namespace
