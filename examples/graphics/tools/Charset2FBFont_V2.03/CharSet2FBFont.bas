#include "freetype2/freetype.bi"
#include "vbcompat.bi"

#include "sGUI/sGUI.bas"
#include once "sGUI/MessageBox.bas"
#include once "sGUI/StringGadget.bas"
#include once "sGUI/SimpleToggle.bas"
#include once "sGUI/FileRequester.bas"
#include once "sGUI/Label.bas"
#include once "sGUI/Arrows.bas"
#include once "sGUI/RadioCheck.bas"
#include once "sGUI/ComboBox.bas"
#include once "sGUI/ScrollBar.bas"
using sGUI

declare sub CChart(posx as integer,posy as integer, penthreshold as integer,backthreshold as integer,gamma as double, pcolor as uinteger, bcolor as uinteger)

dim as integer scrnw,scrnh
scrnw=716
scrnh=540
screenres scrnw,scrnh,32
width scrnw\8,scrnh\16
InitGFX

dim as integer unicodetable(255)

if fileexists ("CodePage.cfg") then
  
  dim as integer index,ucval,ff
  dim as string txtrow
  ff=freefile
  open "CodePage.cfg" for input as ff
    do
      line input # ff, txtrow
      if left (txtrow,1)<>"#" then
        index= val( "&H" & mid(txtrow,3,2) )
        ucval= val( "&H" & mid(txtrow,8,4) )
        unicodetable(index)=ucval
      end if
    loop until eof(ff)
  close ff

else
  
  for i as integer=0 to 255
    unicodetable(i)=i
  next i

end if

dim as FT_Library library
if (FT_Init_FreeType(@library) <> 0) then MessageBox (10,10,"FT_Init_FreeType() failed","!!!",1): End 1
dim as FT_Face face
dim as FT_Bitmap ptr FTbitmap
dim as integer FT_BitmapPitch
dim as BitmapFont ptr BMPFont=new BitmapFont
dim as integer pt,tmpheight,dpi,addwidth,contrast,FTRenderFlag,raiserange,Bthreshold,Pthreshold, gammafactor
dim as uinteger PixelColor
dim as ubyte ftoutput,bmpinput
dim as single gamma, gammastep
Bthreshold=0
Pthreshold=255
gammafactor=133
gammastep=.01
gamma=gammastep*gammafactor

BMPFont->firstchar=32
BMPFont->lastchar=127
BMPFont->imgwidth=0
BMPFont->imgheight=0
BMPFont->PlotType=1
BMPFont->PenColor=&H000000
BMPFont->Background=&HFFFFFF
pt=9
dpi=96
addwidth=1

dim as integer xo,yo,plotwinwidth,plotwinheight,cutwidth,cutheight,plotwinposx,plotwinposy,ccx,ccy
plotwinposx=21
plotwinposy=380
plotwinwidth=657
plotwinheight=70
cutwidth=0
cutheight=0
xo=0
yo=0
ccx=480
ccy=196
dim as any ptr cut=imagecreate(plotwinwidth,plotwinheight)

dim as EventHandle ptr event=AddEventHandle

dim as Gadget ptr strg_fname, smpl_open
dim as Gadget ptr strg_pt, lbl_pt
dim as Gadget ptr lbl_firstchar, lbl_lastchar, lbl_dpi, strg_firstchar, strg_lastchar, strg_dpi
dim as Gadget ptr cb_plottype, cb_propmono, lbl_addwidth, strg_addwidth

dim as Gadget ptr lbl_PenColor,lbl_background,strg_PenColor,strg_background
dim as Gadget ptr ar_gammadwn,ar_gammaup,lbl_gamma
dim as Gadget ptr ar_Pthresdwn,ar_Pthresup,lbl_Pthres
dim as Gadget ptr ar_Bthresdwn,ar_Bthresup,lbl_Bthres
dim as Gadget ptr smpl_render
dim as Gadget ptr strg_StatusText,sb_hview,sb_vview
dim as Gadget ptr smpl_save

dim as string addspacetext,monospacetext
addspacetext ="Additional Space (px):"
monospacetext="Fixed Char Width (px):"

FrameT (10, 10, scrnw-20, 155, "Font & Freetype Library Render Options")
smpl_open=AddSimpleGadget(event,565,20,110,25,"Open Font")

strg_fname=AddStringGadget(event,20,20,530)

lbl_pt=AddLabel(event,20,65,"Font Height (pt):")
strg_pt=AddStringGadget(event,170,60,50,str(pt),3,1)

lbl_dpi=AddLabel(event,20,95,"Resolution (dpi):")
strg_dpi=AddStringGadget(event,170,90,50,str(dpi),3,1)

lbl_firstchar=AddLabel(event,20,135,"ASCII Range from:")
strg_firstchar=AddStringGadget(event,170,130,50,str(BMPFont->firstchar),3,1)

lbl_lastchar=AddLabel(event,225,135,"to")
strg_lastchar=AddStringGadget(event,250,130,50,str(BMPFont->lastchar),3,1)


cb_plottype=AddCombobox(event,230,60,230,60)
TO_AppendLine(cb_plottype,"DRAW STRING compatible")
TO_AppendLine(cb_plottype,"Smallest Bitmap")
UpdateGadget(cb_plottype)
SetComboBoxVal(cb_plottype,1)

cb_propmono=AddCombobox(event,230,90,230,60)
TO_AppendLine(cb_propmono,"proportional")
TO_AppendLine(cb_propmono,"monospaced")
UpdateGadget(cb_propmono)
SetComboBoxVal(cb_propmono,1)

lbl_addwidth=AddLabel(event,475,95,addspacetext)
strg_addwidth=AddStringGadget(event,660,90,30,str(addwidth),2,1)

FrameT (10, 180, scrnw-20, 100, "Color Options")
lbl_PenColor=AddLabel(event,20,205, "Pen (hex):")
strg_PenColor=AddStringGadget(event,170,200,80,hex(BMPFont->PenColor),6,4)

lbl_background=AddLabel(event,20,235,"Background (hex):")
strg_background=AddStringGadget(event,170,230,80,hex(BMPFont->Background),6,4)

ar_Pthresdwn=AddArrow(event,280,ccy,0)
ar_Pthresup=AddArrow(event,280+16,ccy,1)
lbl_Pthres=AddLabel(event,280+40,ccy,"Pen Threshold: " & str(Pthreshold))

ar_gammadwn=AddArrow(event,280,ccy+25,0)
ar_gammaup=AddArrow(event,280+16,ccy+25,1)
lbl_gamma=AddLabel(event,280+40,ccy+25,"Gamma: " & format(gamma,"#,##0.00"))

ar_Bthresdwn=AddArrow(event,280,ccy+66-GetFontHeight,0)
ar_Bthresup=AddArrow(event,280+16,ccy+66-GetFontHeight,1)
lbl_Bthres=AddLabel(event,280+40,ccy+66-GetFontHeight,"Bgrnd. Threshold: " & str(Bthreshold))

cchart(ccx+17,ccy,Pthreshold,Bthreshold,gamma,BMPFont->PenColor,BMPFont->Background)

smpl_render=AddSimpleGadget(event,150,290,420,30,"Render")

FrameT (10, 340, scrnw-20,187, "rendered Bitmap Font in Memory")
strg_StatusText=AddStringGadget(event,22,350,530)
sb_hview=AddScrollBar (event,plotwinposx,plotwinposy+plotwinheight+1,plotwinwidth,0,BMPFont->imgwidth,xo,plotwinwidth,0)
sb_vview=AddScrollBar (event,plotwinposx+plotwinwidth+1,plotwinposy,plotwinheight,0,BMPFont->imgheight,yo,plotwinheight,1)

smpl_save=AddSimpleGadget(event,477,482,200,25,"Save Bitmap Font")

GadgetSleep(strg_fname)
GadgetOn(smpl_open)
GadgetSleep(lbl_pt,smpl_save)

dim as FilenameInfo FontName,BMPName
dim as string oldpath,fn,bn
dim as string StatusText
FontName.Path="C:\Windows\Fonts\"
#ifdef __fb_linux__
  FontName.Path="/usr/share/fonts/"
#endif

do
  event->xSleep(1)
  if event->GADGETMESSAGE then
    select case event->GADGETMESSAGE

      case smpl_open
        fn=FileRequester(100,30,"Open Font",FontName.Path,FontName.File,1)
        if fn<>"" then
          FontName.ParseFileName(fn)
          if FT_New_Face(library, FontName.PathAndFile, 0, @face) = 0 then
            SetString (strg_fname,FontName.File)
            GadgetOn(lbl_pt,smpl_render)
            if GetComboBoxVal(cb_plottype)=1 then GadgetOn(cb_propmono,strg_addwidth) else GadgetSleep(cb_propmono,strg_addwidth)
          else
            MessageBox (100,100,"File not opened","Error",1)
            SetString (strg_fname,"")
            GadgetSleep(lbl_pt,smpl_render)
          end if
        end if

      case cb_plottype
        if GetComboBoxVal(cb_plottype)=1 then GadgetOn(cb_propmono,strg_addwidth) else GadgetSleep(cb_propmono,strg_addwidth)

      case cb_propmono
        if GetComboBoxVal(cb_propmono)=1 then
          SetCaption(lbl_addwidth,addspacetext)
          SetString(strg_addwidth,str(addwidth))
        else
          SetCaption(lbl_addwidth,monospacetext)
          SetString(strg_addwidth,str(addwidth))
        end if
      
      case strg_PenColor, strg_Background
        BMPFont->PenColor=val("&H" & GetString(strg_PenColor))
        BMPFont->Background=val("&H" & GetString(strg_background))
      
      case ar_gammadwn
        gammafactor -=1
        if gammafactor<10 then gammafactor=10
        gamma=gammastep*gammafactor

      case ar_gammaup
        gammafactor +=1
        if gammafactor>300 then gammafactor=300
        gamma=gammastep*gammafactor

      case ar_Pthresdwn
        Pthreshold -=1
        if Pthreshold<=Bthreshold then Pthreshold=Bthreshold+1

      case ar_Pthresup
        Pthreshold +=1
        if Pthreshold>255 then Pthreshold=255

      case ar_Bthresdwn
        Bthreshold -=1
        if Bthreshold<0 then Bthreshold=0

      case ar_Bthresup
        Bthreshold +=1
        if Bthreshold>=Pthreshold then Bthreshold=Pthreshold-1

      case sb_hview
          xo=GetScrollbarVal(sb_hview)
          line (plotwinposx,plotwinposy)-(plotwinposx+plotwinwidth-1,plotwinposy+plotwinheight-1),BMPFont->Background,BF
          get BMPFont->img,(xo,yo)-(xo+cutwidth-1,yo+cutheight-1),cut
          put (plotwinposx,plotwinposy),cut,pset

      case sb_vview
          yo=GetScrollbarVal(sb_vview)
          line (plotwinposx,plotwinposy)-(plotwinposx+plotwinwidth-1,plotwinposy+plotwinheight-1),BMPFont->Background,BF
          get BMPFont->img,(xo,yo)-(xo+cutwidth-1,yo+cutheight-1),cut
          put (plotwinposx,plotwinposy),cut,pset

      case smpl_render
        'Daten aus GUI holen
        BMPFont->ClearAll
        BMPFont->firstchar=val(GetString(strg_firstchar))
        BMPFont->lastchar=val(GetString(strg_lastchar))
        BMPFont->PenColor=val("&H" & GetString(strg_PenColor))
        BMPFont->Background=val("&H" & GetString(strg_background))
        BMPFont->PlotType=GetComboBoxVal(cb_plottype)

        pt=val(GetString(strg_pt))
        dpi=val(GetString(strg_dpi))
        addwidth=val(GetString(strg_addwidth))
        'gamma=val(GetString(strg_gamma))
        
        'Limiter
        if BMPFont->firstchar<0 then BMPFont->firstchar=0
        if BMPFont->firstchar>255 then BMPFont->firstchar=255
        if BMPFont->lastchar<0 then BMPFont->lastchar=0
        if BMPFont->lastchar>255 then BMPFont->lastchar=255
        if BMPFont->firstchar>BMPFont->lastchar then swap BMPFont->firstchar,BMPFont->lastchar
        if pt<1 then pt=1
        if addwidth<0 then addwidth=0
        if GetComboBoxVal(cb_propmono)=2 then
         if addwidth<1 then addwidth=1
        end if

        FTRenderFlag=FT_LOAD_RENDER

        '1. alle Gr��en zu jedem Zeichen auslesen, H�he BaseLine berechnen
        if FT_Set_Char_Size( face, 0, pt*64,dpi,dpi)=0 then
          FT_BitmapPitch=face->glyph->bitmap.pitch
          for i as integer=BMPFont->firstchar to BMPFont->lastchar
            if FT_Load_Char(face, unicodetable(i), FTRenderFlag)=0 then
              BMPFont->CharSet(i).OffsetX       =BMPFont->imgwidth
              BMPFont->CharSet(i).AdvanceX      =face->glyph->advance.x shr 6
              BMPFont->CharSet(i).GlyphWidth    =face->glyph->bitmap.width
              BMPFont->CharSet(i).GlyphHeight   =face->glyph->bitmap.rows
              BMPFont->CharSet(i).GlyphLeft     =face->glyph->bitmap_left
              BMPFont->CharSet(i).GlyphTop      =face->glyph->bitmap_top
              'Baseline... eigentlich nur Suche nach gr��ter Enfernung nach oben
              if BMPFont->BaseLine < BMPFont->CharSet(i).GlyphTop then BMPFont->BaseLine = BMPFont->CharSet(i).GlyphTop

              select case  BMPFont->PlotType
                case 1'DRAW STRING
                    if GetComboBoxVal(cb_propmono)=1 then'proportional
                    if BMPFont->CharSet(i).GlyphWidth>0 then BMPFont->CharSet(i).AdvanceX = BMPFont->CharSet(i).GlyphWidth
                    BMPFont->CharSet(i).AdvanceX +=addwidth
                    BMPFont->CharSet(i).GlyphLeft=cint(addwidth/2)  'cint((BMPFont->CharSet(i).AdvanceX - BMPFont->CharSet(i).GlyphWidth)/2)
                    BMPFont->imgwidth += BMPFont->CharSet(i).AdvanceX
                  else                                   'monospaced
                    BMPFont->CharSet(i).AdvanceX =addwidth
                    if BMPFont->CharSet(i).GlyphWidth>addwidth then BMPFont->CharSet(i).GlyphWidth=addwidth
                    BMPFont->CharSet(i).GlyphLeft=cint((addwidth - BMPFont->CharSet(i).GlyphWidth)/2)
                    BMPFont->imgwidth += addwidth
                  end if
                case 2'smallest bitmap
                  BMPFont->imgwidth += BMPFont->CharSet(i).GlyphWidth
              end select
            end if
          next i

          '2.ausgehend von der nun bekannten BaseLine die Gesamth�he des Fonts ermitteln
          '.GlyphTop steht noch im Bezug zur BaseLine, Umrechnung auf "Abstand von oben"
          'damit gilt jetzt bei allen Werten das Screen/Image Koordinatensystem
          tmpheight=0
          for i as integer=BMPFont->firstchar to BMPFont->lastchar
            'GlyphTop "umrechnen"
            BMPFont->CharSet(i).GlyphTop = BMPFont->BaseLine - BMPFont->CharSet(i).GlyphTop
            'Fonth�he...
            tmpheight =BMPFont->CharSet(i).GlyphTop + BMPFont->CharSet(i).GlyphHeight
            if BMPFont->imgheight < tmpheight then BMPFont->imgheight=tmpheight
          next i

          CreateImage(BMPFont->img,BMPFont->imgwidth,BMPFont->imgheight)
          ImageInfo(BMPFont->img,BMPFont->imgwidth,BMPFont->imgheight,BMPFont->imgbpp,BMPFont->imgpitch,BMPFont->imgpxldata)

          line BMPFont->img,(0,0)-(BMPFont->imgwidth-1,BMPFont->imgheight-1),BMPFont->Background,BF

          '3. alle Zeichen ins Image plotten
          for i as integer=BMPFont->firstchar to BMPFont->lastchar
            if FT_Load_Char(face,unicodetable(i),FTRenderFlag)=0 then'flag 256 anitialias/ monochrom
              FTbitmap = @face->glyph->bitmap
              for y As integer = 0 To (FTbitmap->rows - 1)
                for x As integer = 0 To (FTbitmap->width - 1)

                  ftoutput = FTbitmap->buffer[y * FTbitmap->pitch + x]

                  'contrast
                  if Bthreshold>Pthreshold then swap Bthreshold,Pthreshold
                  raiserange=Pthreshold-Bthreshold

                  if ftoutput<=Bthreshold then bmpinput=0
                  if ftoutput>Bthreshold and ftoutput<=Pthreshold then bmpinput=(ftoutput-Bthreshold)/raiserange * 255
                  if ftoutput>Pthreshold then bmpinput=255
                  
                  bmpinput=((bmpinput / 255) ^ gamma) * 255
                  
                  PixelColor=MixColor(BMPFont->Background, BMPFont->PenColor, bmpinput)

                  select case  BMPFont->PlotType
                    case 1
                      pset BMPFont->img, (BMPFont->CharSet(i).OffsetX + BMPFont->CharSet(i).GlyphLeft + x, BMPFont->CharSet(i).GlyphTop + y),PixelColor
                    case 2
                      pset BMPFont->img, (BMPFont->CharSet(i).OffsetX + x, y),PixelColor
                  end select

                next x
              next y
            end if
          next i

          'GUI
          SetString(strg_firstchar,str(BMPFont->firstchar))
          SetString(strg_lastchar,str(BMPFont->lastchar))
          SetString(strg_addwidth,str(addwidth))
          StatusText="Font: " & FontName.FileWithoutExt & "  " & _
          "Bitmap Size: " & BMPFont->imgwidth & "x" & BMPFont->imgheight
          setstring(strg_StatusText,StatusText)
          GadgetOn(sb_hview,smpl_save)

          xo=0
          yo=0
          if BMPFont->imgwidth<plotwinwidth then cutwidth=BMPFont->imgwidth else cutwidth=plotwinwidth
          if BMPFont->imgheight<plotwinheight then cutheight=BMPFont->imgheight else cutheight=plotwinheight

          ModifyScrollBar(sb_hview,0,BMPFont->imgwidth-1,xo)
          ModifyScrollBar(sb_vview,0,BMPFont->imgheight-1,yo)

          CreateImage(cut,cutwidth,cutheight,BMPFont->Background)
          line (plotwinposx,plotwinposy)-(plotwinposx+plotwinwidth-1,plotwinposy+plotwinheight-1),BMPFont->Background,BF
          get BMPFont->img,(xo,yo)-(xo+cutwidth-1,yo+cutheight-1),cut
          put (plotwinposx,plotwinposy),cut,pset
        end if

      case smpl_save
        bn=FileRequester(100,30,"Save BMP",BMPName.Path,FontName.FileWithoutExt & ".bmp")
        if bn<>"" then
          BMPName.ParseFileName(bn)
          chdir BMPName.Path
          BMPFont->SaveFont(BMPName.File)
          StatusText &="...saved"
          setstring(strg_StatusText,StatusText)
        end if
    end select

    cchart(ccx+17,ccy,Pthreshold,Bthreshold,gamma,BMPFont->PenColor,BMPFont->Background)
    SetCaption(lbl_Pthres,"Pen Threshold: " & str(Pthreshold))
    SetCaption(lbl_gamma,"Gamma: " & format(gamma,"#,##0.00"))
    SetCaption(lbl_Bthres,"Bgrnd. Threshold: " & str(Bthreshold))
  end if

loop until event->EXITEVENT

DelEventHandle event
delete BMPFont

sub CChart(posx as integer,posy as integer, penthreshold as integer,backthreshold as integer,gamma as double, pcolor as uinteger, bcolor as uinteger)
  dim as integer raiserange,a
  penthreshold =int(penthreshold/4)
  backthreshold =int(backthreshold /4)
  raiserange=penthreshold-backthreshold
  line(posx+5,posy)-(posx+68,posy+63),&H070707,bf

  for i as integer=0 to 63
    line(posx,posy+i)-(posx+3,posy+i),mixcolor(pcolor,bcolor,255*(i/63))
  next i

  for i as integer=0 to 63 
    if i<=backthreshold then a=0
    if i>backthreshold and i<penthreshold then a=int((i-backthreshold)/raiserange * 63)
    if i>=penthreshold then a=63
    a=((a / 63) ^ gamma) * 63
    if i then
      line -(posx+5+i,posy+63-a),&HFF0000
    else
      pset (posx+5+i,posy+63-a),&HFF0000
    end if
  next i

  for i as integer=0 to 63
    line(posx+5+i,posy+65)-(posx+5+i,posy+65+3),mixcolor(&h0,&HFFFFFF,255*(i/63))
  next i  
end sub
