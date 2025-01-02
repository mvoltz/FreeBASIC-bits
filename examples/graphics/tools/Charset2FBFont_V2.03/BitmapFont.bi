#include once "fbgfx.bi"
'enthält jetzt eine 64Bit Anpassung
declare function MixColor (ColorA as ulong, ColorB as ulong, Alphaweight as ubyte) as ulong
declare function CreateImage(byref img as any ptr, imgwidth as integer, imgheight as integer, col as uinteger=&H0) as integer


'->+            <-----------OffsetX
'  +----------+ <-----------AdvanceX
'     +----+    <-----------GlyphWidth
'  +--+         <-----------GlyphLeft
'  +----------+  +  +
'  |          |  |  | <-----GlyphTop
'  |  +-OO-+  |  |  +  +
'  |  | OO |  |  |     |
'  |  |    |  |  |     |
'  |  | OO |  |  |     | <---GlyphHeight
'  |  | OO |  |  |     |
'  |  | OO |  |  |     |
'  |  OOOOOO  |  |     +
'  |          |  | <---------imgheight/AdvanceY/Fontheight
'  +----------+  +

type CharDescription
  OffsetX     as integer 'Beginn der Bitmap des Zeichens innerhalb der Fontbitmap
  AdvanceX    as integer 'Breite des Zeichens "über alles", also auch mit Rand
  GlyphWidth  as integer 'Breite und ...
  GlyphHeight as integer '... Höhe des eigentlichen Zeichens ---> letztlich Größe einer bounding Box um das sichtbare Zeichen
  GlyphLeft   as integer 'Abstand dieser Box vom linken Rand der Bitmap des Zeichens
  GlyphTop    as integer 'Abstand dieser Box vom oberen Rand der Bitmap des Zeichens
end type






type BitmapFont
  #if __FB_VERSION__ >= "1.08.0"
    img           as any ptr
    imgpxldata    as any ptr
    imgrow        as ulong ptr
    imgwidth      as ulong
    imgheight     as ulong
    imgbpp        as ulong
    imgpitch      as ulong
    PlotType      as integer
    BaseLine      as integer
    monospaced    as integer
    firstchar     as integer
    lastchar      as integer
    CharSet(255)  as CharDescription
    UseBackGround as integer
    PenColor      as ulong
    BackGround    as ulong
  
  #else

    img           as any ptr
    imgpxldata    as any ptr
    imgrow        as ulong ptr
    imgwidth      as integer
    imgheight     as integer
    imgbpp        as integer
    imgpitch      as integer
    PlotType      as integer
    BaseLine      as integer
    monospaced    as integer
    firstchar     as integer
    lastchar      as integer
    CharSet(255)  as CharDescription
    UseBackGround as integer
    PenColor      as ulong
    BackGround    as ulong
  #endif
  
  declare constructor
  declare destructor
  declare function LoadFont (Filename as string) as integer
  declare function SaveFont (Filename as string) as integer
  declare function GetTextWidth(text as string, tmpmonospaced as integer=0) as integer
  declare sub Print (img as FB.Image ptr=0, posx as integer, posy as integer, text as string)
  declare sub ClearAll
end type



constructor BitmapFont
  ClearAll
end constructor



destructor BitmapFont
  ClearAll
end destructor



function BitmapFont.LoadFont (Filename as string) as integer
  function=0
  if ucase(right(filename,4))=".BMP" then
    Filename=left(Filename,(len(Filename)-4))
      ClearAll
      dim as integer ff,junk
      ff=freefile
      open Filename & ".descriptor" for input as ff
        input #ff, imgwidth
        input #ff, imgheight
        input #ff, PlotType
        input #ff, BaseLine
        input #ff, firstchar
        input #ff, lastchar

        for i as integer=firstchar to lastchar
          input #ff, junk'Daten werden nicht benötigt
          input #ff, CharSet(i).OffsetX
          input #ff, CharSet(i).AdvanceX
          input #ff, CharSet(i).GlyphWidth
          input #ff, CharSet(i).GlyphHeight
          input #ff, CharSet(i).GlyphLeft
          input #ff, CharSet(i).GlyphTop
        next i
      close ff
      CreateImage(img,imgwidth,imgheight)
      imageinfo(img,imgwidth,imgheight,imgbpp,imgpitch,imgpxldata)
      if img then
        bload (Filename & ".bmp",img)
        function=-1
      end if
  end if
end function



function BitmapFont.SaveFont (Filename as string) as integer
  function=0
  if (img<>0) and (ucase(right(Filename,4))=".BMP") then
    Filename=left(Filename,(len(Filename)-4))
    dim as integer ff
    dim as string sep
    'define the path separation
    #ifdef __fb_win32__
      sep="\"
    #endif
    'Tux Variante
    #ifdef __FB_LINUX__
      sep="/"
    #endif

    mkdir Filename

    bsave (Filename & sep & Filename & ".bmp",img)

    ff=freefile
    open Filename & sep & Filename & ".descriptor" for output as ff
      write #ff, imgwidth, imgheight, PlotType, BaseLine, firstchar, lastchar
      for i as integer=firstchar to lastchar
        write #ff, i, CharSet(i).OffsetX, CharSet(i).AdvanceX, CharSet(i).GlyphWidth, CharSet(i).GlyphHeight, CharSet(i).GlyphLeft, CharSet(i).GlyphTop
      next i
    close ff
    function=-1
  end if
end function



function BitmapFont.GetTextWidth(text as string, switchmonospaced as integer=0) as integer
  dim as integer textlen,boxwidth,achar,tmpGlyphLeft,tmpAdvanceX
  boxwidth=0
  textlen=len(text)
  
  if textlen then
    if switchmonospaced then
      
      boxwidth=textlen*monospaced
    
    else
      
      for i as integer=0 to textlen-1
        achar=text[i]

        tmpGlyphLeft=Charset(achar).GlyphLeft
        tmpAdvanceX=Charset(achar).AdvanceX

        'nur bei erstem Zeichen im Text
        if (i=0) then
          if tmpGlyphLeft<0 then      'wenn GlyphLeft negativ dann würde erstes Zeichen vor posx beginnen
            boxwidth -=tmpGlyphLeft   'vorderen "Überhang" der Breite/Boxlänge hinzufügen
          end if
        end if

        'nur bei letztem Zeichen im Text
        if i=(textlen-1) then
          if (tmpGlyphLeft + Charset(achar).GlyphWidth) > tmpAdvanceX then      'sollte Glyph über Zeichenlaufweite hinausragen
            boxwidth +=(tmpGlyphLeft + Charset(achar).GlyphWidth) - tmpAdvanceX 'hinteren "Überhang" der Breite/Boxlänge hinzufügen
          end if
        end if
        boxwidth +=tmpAdvanceX
      next i

    end if
  end if

  function=boxwidth
end function



sub BitmapFont.Print (img as FB.Image ptr=0,posx as integer, posy as integer, text as string)
  dim as integer textlen,boxwidth,achar,scanstartx,scanstarty,drawstartx,drawstarty,drawx,drawy,tmpGlyphLeft,tmpAdvanceX,tmpGlyphWidth
  dim as ubyte Alphaweight
  dim as ulong BackGround
  dim as ulong UsedColor
  dim as any ptr pxldata
  dim as integer h,w,bpp,ptch
  dim as ulong ptr row
  if img then
    imageinfo (img, w, h, bpp, ptch, pxldata)  
  else
    screeninfo w, h, , bpp, ptch
    pxldata=Screenptr
  end if
    
  textlen=len(text)
  if textlen then
    'wenn benutzt Länge Hintergrund berechnen/zeichnen
    if UseBackGround then
      boxwidth=GetTextWidth(text,monospaced)
      line img, (posx,posy)-(posx+boxwidth-1,posy+imgheight-1),BackGround,BF
    end if
  
    drawstartx=posx
    'screenlock
    for i as integer=0 to textlen-1
      achar=text[i]
      scanstartx=Charset(achar).OffsetX
      scanstarty=0
      drawstarty=posy
      
      if PlotType=1 then
        scanstartx +=Charset(achar).GlyphLeft
        scanstarty +=Charset(achar).GlyphTop
      end if
    
      if monospaced=0 then'bei proportionalen Font
        
        tmpGlyphLeft=Charset(achar).GlyphLeft
        tmpAdvanceX=Charset(achar).AdvanceX
        tmpGlyphWidth=Charset(achar).GlyphWidth
        'nur bei erstem Zeichen im Text
        if (i=0) then               
          if tmpGlyphLeft<0 then      'wenn GlyphLeft negativ dann würde erstes Zeichen vor posx beginnen
            drawstartx -=tmpGlyphLeft 'um dies zu verhindern Zeichenstart nach rechts verschieben
          end if
        end if

      else 'bei monospaced Font
        
        tmpGlyphLeft=fix((monospaced-Charset(achar).GlyphWidth)/2)
        tmpAdvanceX=monospaced
        tmpGlyphWidth=Charset(achar).GlyphWidth


        'nur bei erstem Zeichen im Text
        if (i=0) then
          if tmpGlyphLeft<0 then'wenn GlyphLeft negativ dann würde erstes Zeichen vor posx beginnen
            tmpGlyphLeft=0      'um dies zu verhindern Zeichenstart nach rechts verschieben
            'if tmpGlyphWidth>tmpAdvancex then tmpGlyphWidth=tmpAdvancex'falls Zeichen breiter, rechtsseitig "beschneiden"
          end if
        end if

        'nur bei letztem Zeichen im Text
        if i=(textlen-1) then
          if (tmpGlyphLeft + Charset(achar).GlyphWidth) > tmpAdvanceX then'sollte Glyph über Zeichenlaufweite hinausragen
          tmpGlyphWidth=tmpAdvanceX-tmpGlyphLeft'um dies zu verhindern Zeichen(nur letztes!!!) rechtsseitig "beschneiden"
          end if
        end if
        '/

      end if     
          
      for y as integer=0 to Charset(achar).GlyphHeight-1
        for x as integer=0 to tmpGlyphWidth-1
          imgrow=imgpxldata + (scanstarty + y) * imgpitch
          Alphaweight=imgrow[scanstartx + x] shr 24'Alpha aus Fontbitmap holen
          
          'Alphaweight=((Alphaweight / 255) ^ 1.33) * 255'Wichtung >1 dünner, <1 dicker
          
          if Alphaweight then
            drawx=drawstartx + tmpGlyphLeft + x
            drawy=drawstarty + Charset(achar).GlyphTop + y
            row=pxldata + drawy*ptch

            'row[drawx]=MixColor(row[drawx] and &HFFFFFF,PenColor, Alphaweight)' da scheinbar direktes Manipulieren der Bitmap nur mit screenlock/unlock sichtbar wird...                                 
            pset img,(drawx,drawy),MixColor(row[drawx] and &HFFFFFF,PenColor, Alphaweight)'... ein normales PSET
            
            'Variante Anti-Pink :/
            'BackGround=row[drawx] and &HFFFFFF
            'if BackGround=&HFF00FF then BackGround=&HFFFFFF            
            'pset img,(drawx,drawy),MixColor(BackGround,PenColor, Alphaweight)'... ein normales PSET
          end if
        next x
      next y
      drawstartx +=tmpAdvanceX
    next i
    'screenunlock
  end if
end sub



sub BitmapFont.ClearAll
  if img then imagedestroy img
  img         =0
  imgpxldata  =0
  imgrow      =0
  imgwidth    =0
  imgheight   =0
  imgbpp      =0
  imgpitch    =0
  PlotType    =0
  BaseLine    =0
  monospaced  =0
  firstchar   =0
  lastchar    =0
  for i as integer=0 to 255
    CharSet(i).OffsetX     =0
    CharSet(i).AdvanceX    =0
    CharSet(i).GlyphWidth  =0
    CharSet(i).GlyphHeight =0
    CharSet(i).GlyphLeft   =0
    CharSet(i).GlyphTop    =0
  next i
  UseBackGround         =0
  PenColor        =&HFFFFFF
  BackGround =&H000000
end sub



function LoadFBFont (Filename as string) as any ptr
  function=0
  if ucase(right(filename,4))=".BMP" then
    Filename=left(Filename,(len(Filename)-4))
    dim as integer ff,junk
    dim as integer imgwidth,imgheight,PlotType,firstchar,lastchar,AdvanceX
    dim as any ptr img,bmp,imgpxldata
    dim as ubyte ptr Header

    ff=freefile
    open Filename & ".descriptor" for input as ff
      input #ff, imgwidth
      input #ff, imgheight
      input #ff, PlotType
      input #ff, junk
      input #ff, firstchar
      input #ff, lastchar

      if PlotType=1 then
        img=imagecreate (imgwidth,imgheight+1)
        bmp=imagecreate (imgwidth,imgheight)
        if (img<>0) and (bmp<>0) then
          imageinfo(img,,,,,imgpxldata)
          bload (Filename & ".bmp",bmp)
          Header=imgpxldata'Startadresse Zeile 0 für FBFontheader
          Header[0]=0
          Header[1]=firstchar
          Header[2]=lastchar
          for i as integer=firstchar to lastchar
            input #ff, junk'Daten werden nicht benötigt
            input #ff, junk
            input #ff, AdvanceX
            input #ff, junk
            input #ff, junk
            input #ff, junk
            input #ff, junk
            Header[3 + i-firstchar]=AdvanceX
          next i
          put img,(0,1),bmp,(0,0)-(imgwidth-1,imgheight-1),pset
          imagedestroy bmp
          function=img
        end if
      end if
    close ff
  end if
end function



function MixColor (ColorA as ulong, ColorB as ulong, Alphaweight as ubyte) as ulong
  dim as ulong ColorM
  dim as ubyte ptr A,B,M

  A=cast(ubyte ptr,@ColorA)
  B=cast(ubyte ptr,@ColorB)
  M=cast(ubyte ptr,@ColorM)

  M[3]=Alphaweight
  'M[3]=255   'brewed by Haubitze
  
  for i as integer=0 to 2
    M[i]=A[i] + int((B[i]-A[i])/255 * Alphaweight)
  next i

  function=ColorM
end function



function CreateImage(byref img as any ptr, imgwidth as integer, imgheight as integer, col as uinteger=&H0) as integer
  function=0
  if img then imagedestroy img
  dim as any ptr imgtmp
  imgtmp=imagecreate(imgwidth,imgheight,col)
  if imgtmp then
    img=imgtmp
    function=-1
  end if
end function
