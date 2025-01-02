'#include once "file.bi"'ohne sGUI bitte aktivieren
type _TextObject as TextObject

'UDT f�r Beschreibung einer Zeile
type TextLine
  text      as string       'enth�lt die Zeile
  index     as integer      'Zeilennummer
  prevline  as TextLine ptr 'Zeiger auf vorhergehende Zeile, 0 wenn 1.Zeile
  nextline  as TextLine ptr 'Zeiger auf nachfolgende Zeile, 0 wenn letzte Zeile
  BaseTO    as _TextObject ptr'das Mutterschiff, damit jede Zeile Auskunft geben kann wo sie hingeh�rt
end type



'UDT f�r Beschreibung einer eindeutigen Textposition, f�r Cursor,Clipboardmarker
type TextMark
  tline     as TextLine ptr
  position  as integer
end type



'"Objekt" zur Verwaltung und Editieren eines mehrzeiligen Textes
type TextObject extends node'extends node' auskommentieren
  private:
    cursor     as TextMark        'Hmmm ;)

    firstline  as TextLine ptr    'Zeiger auf erste Zeile
    lastline   as TextLine ptr    'Zeiger auf letzte Zeile
    longestline as integer        'eine Art Schleppzeiger f�r die bisher l�ngste Zeile, die zur Laufzeit editiert/geladen wurde
                                  'ob diese tats�chlich noch existiert ist nicht gegeben, diese Info ist mehr als Highscore zu verstehen ;)
                                  'kann in der �bergeordneten GUI f�r die Konfiguration des horizontalen Scrollbalkens verwendet werden

'kommt vielleicht sp�ter mal: ein internes Clipboard
'    clipstart     as TextMark
'    clipend       as TextMark
'    clipfirstline as TextLine ptr
'    cliplastline  as TextLine ptr
  public:
    declare constructor
    declare destructor
    'Editierfunktionen
    declare sub KeyAddChar(c as string)
    declare sub KeyBackspace
    declare sub KeyDelete
    declare sub KeyReturn
    'Cursorsteuerung
    declare sub CursorUp
    declare sub CursorDown
    declare sub CursorLeft
    declare sub CursorRight
    declare sub CursorKeyPos1'added by MilkFreeze, modified by Muttonhead :)
    declare sub CursorKeyEnd'added by MilkFreeze, modified by Muttonhead :)
    declare sub SetCursor overload(l as integer,p as integer)
    declare sub SetCursor (l as Textline ptr,p as integer)
    'Info
    declare function GetCursorLine as integer
    declare function GetCursorPosition as integer
    declare function GetLines as integer
    declare function GetLineAddr(i as integer) as TextLine ptr
    declare function GetLineIndex(l as TextLine ptr) as integer
    declare function GetLongestLine  as integer
    'Input/Output
      'Laden aus Datei/String
    declare sub LoadText (filename as string,linebreak as string=chr(13,10))
    declare sub SetText (s as string,linebreak as string=chr(13,10))
      'Ausgabe/Speichern als Datei/String
    declare sub SaveText (filename as string, linebreak as string=chr(13,10))
    declare function GetText (linebreak as string=chr(13,10)) as string
      'Abfrage Zeileninhalt
    declare function GetLineContent overload(i as integer) as string
    declare function GetLineContent (l as TextLine ptr) as string
      '(Er)-Setzen des Zeileninhaltes einer bestimmten Zeile
    declare sub SetLineContent overload(i as integer,t as string)
    declare sub SetLineContent (l as TextLine ptr,t as string)
      'Zeile an vorhandenen Text anh�ngen
    declare sub AppendLine (t as string="")
      'Text komplett l�schen
    declare sub ClearText

      'nur f�r Testzwecke des TOs
    declare sub printout
  private:
    'Speicherverwaltung & Zeilenlogik
    declare function CreateBlankLine as TextLine ptr    'erzeugt eine nicht verlinkte Zeile (NEW "gewrappt")
    declare function AppendBlankLine as TextLine ptr    'H�ngt ein Leerzeile am Ende des Textes an/ Erzeugt Startzeile
    declare function InsertBlankLine(prev as TextLine ptr) as TextLine ptr'F�gt eine Zeile zwischen 2 anderen
    declare sub DeleteAllLines (l as TextLine ptr)      'L�scht alle Zeilen ab/einschlie�lich �bergebene(r) Zeile
    'interne Statistik
    declare sub MakeIndex'Versieht alle Zeilen mit einer Zeilennummer
end type



constructor TextObject
  /'
  AppendBlankLine 'bei Erstellung eines TOs ist mindestens eine Zeile notwendig, wird hiermit erledigt
  longestline=0
  cursor.tline=lastline
  cursor.position=len(lastline->text)+1
  '/
  cursor.tline=0
  cursor.position=1
  firstline=0
  lastline=0
end constructor



destructor TextObject
  DeleteAllLines firstline
  'DeleteAllLines clipboard
end destructor


'Editierfunktionen*************************************************************
sub TextObject.KeyAddChar(c as string)
  'sollte noch keine Zeile existieren, erste Erzeugen und Cursor setzen
  if firstline=0 then
    AppendBlankLine
    longestline=0
    cursor.tline=lastline
    cursor.position=len(lastline->text)+1
    makeindex
  end if

  dim as integer ll
  cursor.tline->text= left(cursor.tline->text,cursor.position-1) & c & right(cursor.tline->text,len(cursor.tline->text)-cursor.position+1)
  cursor.position +=1
  ll=len(cursor.tline->text)
  if ll>longestline then longestline=ll
end sub



sub TextObject.KeyBackspace
  if firstline=0 then exit sub

  dim as TextLine ptr prev,nxt
  dim as string textbuffer
  if cursor.position=1 then        'bei Backspace von erster Position in der Zeile erfolgt (wenn m�glich) ein L�schen der Zeile

    if cursor.tline<>firstline then'Zeile 1 Position 1 kein BACKSPACE m�glich
      prev=cursor.tline->prevline  'vorherige Zeile holen
      nxt=cursor.tline->nextline   'nachfolgende Zeile holen(kann bei letzter Zeile auch 0 sein)

      if cursor.tline=lastline then'sollte es sich um die letzte Zeile handeln
        lastline=prev              'dann ist das entsprechend im TO zu �ndern
        prev->nextline=0           'prev hat nun keinen Nachfolger mehr
      else                         'ansonsten Verkn�pfung zwischen Vorg�nger und Nachfolger der zu L�schenden herstellen
        prev->nextline = nxt
        nxt->prevline = prev
      end if
      'damit ist die zu l�schende Zeile (Cursorzeile) freigestellt

      textbuffer=cursor.tline->text'eventuell vorhandenen Text der zu l�schenden Zeile merken
      cursor.tline->text=""        'Inhalt l�schen(eigentlich nicht n�tig)
      delete cursor.tline          'Zeile entg�ltig l�schen

      'Cursor hinter den Text der Vorherigen setzen
      cursor.position=len(prev->text)+1
      cursor.tline=prev

      'eventuell vorhandenen Text aus gel�schter Zeile anf�gen
      prev->text = prev->text & textbuffer

      makeindex
    end if

  else 'ansonsten "normales" In-Line-BACKSPACE

    cursor.tline->text=left(cursor.tline->text,cursor.position-2)  & _
      right(cursor.tline->text,len(cursor.tline->text)-cursor.position+1)
    cursor.position -=1

  end if
end sub



sub TextObject.KeyDelete
  if firstline=0 then exit sub

  dim as TextLine ptr nxt,nnxt
  dim as string textbuffer

  if cursor.position>len(cursor.tline->text) then 'wenn Cursor hinter einer Zeile erfolgt (wenn m�glich) ein L�schen der folgenden Zeile
    if cursor.tline<>lastline then                'hinter letzter Zeile kein DELETE m�glich
      nxt=cursor.tline->nextline                  'n�chste Zeile holen(die gel�scht wird)
      nnxt=nxt->nextline                          '�bern�chste Zeile holen(kann auch 0 sein)

      if nxt=lastline then      'sollte N�chste die letzte Zeile sein
        lastline=cursor.tline   'dann ist das entsprechend im TO zu �ndern
        cursor.tline->nextline=0'aktuelle Cursorzeile hat nun keinen Nachfolger mehr
      else                      'ansonsten Verkn�pfung zwischen Cursorzeile und Nachfolger der zu L�schenden herstellen
        cursor.tline->nextline = nnxt
        nnxt->prevline = cursor.tline
      end if
      'damit ist die zu l�schende Zeile (nxt) freigestellt

      textbuffer=nxt->text'eventuell vorhandenen Text der zu l�schenden Zeile merken
      nxt->text=""        'Inhalt l�schen(eigentlich nicht n�tig)
      delete nxt          'Zeile entg�ltig l�schen

      'eventuell vorhandenen Text aus gel�schter Zeile anf�gen
      cursor.tline->text = cursor.tline->text & textbuffer

      MakeIndex
    end if
  else'ansonsten "normales" In-Line-DELETE
    cursor.tline->text=left(cursor.tline->text,cursor.position-1) & _
      right(cursor.tline->text,len(cursor.tline->text)-cursor.position)
  end if
end sub



sub TextObject.KeyReturn
  'sollte noch keine Zeile existieren, erste Erzeugen und Cursor setzen
  if firstline=0 then
    AppendBlankLine
    longestline=0
    cursor.tline=lastline
    cursor.position=len(lastline->text)+1
  end if

  'In der Regel wird durch Return eine neue Zeile ge�ffnet.
  dim as TextLine ptr ntr
  dim as string textbuffer

  'String der Zeile in Abh�ngigkeit von der Cursorposition splitten
  '1.Fall
  'Cursor ist hinter dem String, also Len(Zeile)+1. Der String bleibt vollst�ndig in der alten Zeile und
  'es wird eine neue leere Zeile erzeugt.Der Cursor ist in der neuen Zeile an Position 1
  if cursor.position>len(cursor.tline->text) then textbuffer=""
  '2.Fall
  'Cursor ist im Bereich Position >1 bis Len(Zeile). String bleibt bis zur Position Cursor-1 in der alten
  'Zeile, ab dem Cursor wandert der Rest des Strings in die neue Zeile. Der Cursor ist in der neuen
  'Zeile an Position 1
  if cursor.position>1 and cursor.position<=len(cursor.tline->text) then
    textbuffer=right(cursor.tline->text , (len(cursor.tline->text)-cursor.position+1) )'Zeilentext ab Cursor sichern
    cursor.tline->text=left(cursor.tline->text , cursor.position-1)                    'Zeilentext der Cursorzeile verk�rzen
  end if
  '3.Fall
  'Cursor ist an Position 1. Der gesamte String geht in die neue Zeile und die alte Zeile wird leer.
  'Der Cursor ist in der neuen Zeile an Position 1
  if cursor.position=1 then
    textbuffer=cursor.tline->text 'Zeileninhalt merken
    cursor.tline->text=""         'Inhalt von CursorZeile l�schen
  end if

  'neue Zeile erzeugen
    if cursor.tline=lastline then    'wenn die Zeile ans Textende angef�gt wird dann...
    AppendBlankLine                  'Zeile anh�ngen
    lastline->text=textbuffer        'gegebenfalls Text hineinkopieren
    cursor.tline=lastline            'Cursor in die letzte Zeile an Position 1 setzen
    cursor.position=1
  else                               'wenn die Zeile mittendrin eingef�gt wird dann...
    ntr=InsertBlankLine(cursor.tline)
    ntr->text=textbuffer             'gegebenfalls Text hineinkopieren
    cursor.tline=ntr                 'Cursor in die neue Zeile an Position 1 setzen
    cursor.position=1
    MakeIndex
  end if

end sub



'Cursorsteuerung***************************************************************
sub TextObject.SetCursor (l as integer,p as integer)
  if firstline=0 then exit sub

  cursor.tline=GetLineAddr(l)
  if p<0 then p=1
  if p>len(cursor.tline->text)+1 then p=len(cursor.tline->text)+1
  cursor.position=p
end sub



sub TextObject.SetCursor (l as Textline ptr,p as integer)
  if firstline=0 then exit sub

  cursor.tline=l
  if p<0 then p=1
  if p>len(cursor.tline->text)+1 then p=len(cursor.tline->text)+1
  cursor.position=p
end sub



sub TextObject.CursorUp
  if firstline=0 then exit sub

  'nicht �ber die erste Zeile hinaus
  if cursor.tline<>firstline then
    cursor.tline=cursor.tline->prevline'damit sind wir schon in der vorhergehenden Zeile!!!
    'Falls Zeile k�rzer ist als aktuelle Cursorposition mu� entsprechend angepa�t werden
    'Cursor wird dann hinter der Zeile positioniert
    if len(cursor.tline->text)+1 < cursor.position then cursor.position=len(cursor.tline->text)+1
  end if
end sub



sub TextObject.CursorDown
  if firstline=0 then exit sub

  'nicht �ber die letzte Zeile hinaus
  if cursor.tline<>lastline then
    cursor.tline=cursor.tline->nextline'damit sind wir schon in der nachfolgenden Zeile!!!
    'Falls Zeile k�rzer ist als aktuelle Cursorposition mu� entsprechend angepa�t werden
    'Cursor wird dann hinter der Zeile positioniert
    if len(cursor.tline->text)+1 < cursor.position then cursor.position=len(cursor.tline->text)+1
  end if
end sub



sub TextObject.CursorLeft
  if firstline=0 then exit sub

  cursor.position -=1                          'Cursorposition um 1 verringern
  if cursor.position<1 then                    'ist diese dann 0, was nicht sein darf, dann...
    if cursor.tline<>firstline then            'befinden wir uns nich nicht in der ersten Zeile
      cursor.tline=cursor.tline->prevline      'dann vorhergehende Zeile zur CursorZeile machen
      cursor.position=len(cursor.tline->text)+1'Cursor ans Ende dieser Zeile setzen
    else                                       'sind wir doch schon in der ersten Zeile
      cursor.position=1                        'dann Position 1 setzen, weiter gehts ja nicht
    end if
  end if
end sub



sub TextObject.CursorRight
  if firstline=0 then exit sub

  cursor.position +=1                              'Cursorposition um 1 erh�hen
  if cursor.position>len(cursor.tline->text)+1 then'ist diese dann mehr als eine Position hinter dem Text, was nicht sein darf, dann...
    if cursor.tline<>lastline then                 'wir befinden uns nich nicht in der letzten Zeile
      cursor.tline=cursor.tline->nextline          'dann n�chste Zeile zur CursorZeile machen
      cursor.position=1                            'Cursor an den Anfang dieser Zeile setzen
    else                                           'sind wir doch schon in der letzten Zeile
      cursor.position=len(cursor.tline->text)+1    'dann auf eine Position hinter Text setzen, weiter gehts ja nicht
    end if
  end if
end sub


'added by MilkFreeze, modified by Muttonhead :)
Sub TextObject.CursorKeyPos1
  if firstline=0 then exit sub

	cursor.position=1
End Sub


'added by MilkFreeze, modified by Muttonhead :)
Sub TextObject.CursorKeyEnd
  if firstline=0 then exit sub

	cursor.position=len(cursor.tline->text)+1
End Sub



'Info**************************************************************************
function TextObject.GetCursorLine as integer
  if firstline=0 then function=0 else function=GetLineIndex(cursor.tline)
end function



function TextObject.GetCursorPosition as integer
  function=cursor.position
end function



'liefert die Zeilenzahl des Textes
function TextObject.GetLines as integer
  if lastline then function=lastline->index else function=0
end function



'liefert die Adresse einer Zeile auf Basis des Index
function TextObject.GetLineAddr(i as integer) as TextLine ptr
  if firstline=0 then
    function=0
  else
    dim as TextLine ptr l,found
    l=firstline
    found=0
    do
      if l->index=i then found=l
      l=l->nextline
    loop until (found<>0) or (l=0)
    function=found
  end if
end function



'liefert die Zeilennummer(Index) einer Zeile auf Basis der Adresse
function TextObject.GetLineIndex(l as TextLine ptr) as integer
  if firstline=0 then
    function=0
  else
    function=l->index
  end if
end function



function TextObject.GetLongestLine  as integer
  function=longestline
end function



'Input/Output******************************************************************
sub TextObject.LoadText (filename as string,linebreak as string=chr(13,10))
  dim as integer ff
  dim as string fulltext=""

  'if fileexists(filename) then
    ff=freefile
    open filename for binary as ff
      if lof(ff) then fulltext=space(lof(ff))
      get #ff, ,fulltext
    close ff
   SetText (fulltext,linebreak)
    fulltext=""
  'end if
  'SetCursor(1,1)
end sub



sub TextObject.SetText (s as string,linebreak as string=chr(13,10))
  dim as integer searchstart,tabsize,numspaces,tabpos,newtabpos
	dim as integer llb,ls,ll,linestart,lineend

	'Tabulator Expander
	tabsize=2
	searchstart=1
	do
    tabpos = instr(searchstart,s,chr(9))
    if tabpos>0 then
    	newtabpos=int((tabpos+tabsize-1)/tabsize)*tabsize + 1
    	numspaces=newtabpos-tabpos
			s=left(s, tabpos-1) & space(numspaces) & mid(s, tabpos+1)
		end if
		searchstart=tabpos
  loop until tabpos=0

	'Line Split
  llb=len(linebreak)
  ls=len(s)
  linestart=1

  DeleteAllLines firstline
  longestline=0

  do
    lineend = instr(linestart,s,linebreak)
    if lineend=0 then lineend=ls+1
    AppendBlankLine
    lastline->text=mid(s,linestart,lineend-linestart)
    ll=len(lastline->text)
    if ll>longestline then longestline=ll
    linestart=lineend+llb
  loop until lineend>ls

  SetCursor(1,1)
  MakeIndex
end sub



sub TextObject.SaveText (filename as string, linebreak as string=chr(13,10))
  if firstline=0 then exit sub

  dim as integer ff=freefile
  dim as TextLine ptr l
  open filename for output as ff
    l=firstline
    do
      print #ff, l->text;
      if l<>lastline then print #ff,linebreak;
      l=l->nextline
    loop until l=0
  close ff
end sub



function TextObject.GetText (linebreak as string=chr(13,10)) as string
  if firstline=0 then
    function=""
  else
    dim as TextLine ptr l
    dim as string s
    s=""
    l=firstline
    do
      s =s & l->text
      if l<>lastline then s =s & linebreak
      l=l->nextline
    loop until l=0
    function=s
  end if
end function



function TextObject.GetLineContent (i as integer) as string
  if firstline=0 then function="" else function=GetLineAddr(i)->text
end function



function TextObject.GetLineContent (l as TextLine ptr) as string
  function=l->text
end function



sub TextObject.SetLineContent (i as integer,t as string)
  dim as integer ll
  dim as TextLine ptr l
  l= GetLineAddr(i)
  l->text=t
  ll=len(l->text)
  if ll>longestline then longestline=ll
end sub



sub TextObject.SetLineContent (l as TextLine ptr,t as string)
  dim  as integer ll
  l->text=t
  ll=len(l->text)
  if ll>longestline then longestline=ll
  SetCursor (l,1)
end sub



sub TextObject.AppendLine (t as string="")
  dim as integer ll
  AppendBlankLine
  lastline->text=t
  ll=len(lastline->text)
  if ll>longestline then longestline=ll
  SetCursor (lastline,1)
end sub



sub TextObject.ClearText
  DeleteAllLines firstline
  'longestline=0
  'AppendBlankLine
  'cursor.tline=lastline
  'cursor.position=1
end sub



'dient nur zu Testzwecken!!!!
sub TextObject.printout
  dim as TextLine ptr l
  dim as integer rc=0
  if firstline then
    screenlock
    cls
    l=firstline
    do
      draw string(0,rc*16),l->text
      l=l->nextline
      rc +=1
    loop until l=0
    draw string((cursor.position-1)*8,(GetLineIndex(cursor.tline)-1)*16+1),"_"
    screenunlock
  end if
end sub



'Speicherverwaltung & Zeilenlogik**********************************************
function TextObject.CreateBlankLine as TextLine ptr
  function=0
  dim tmptr as TextLine ptr
  tmptr=new TextLine
  if tmptr then
    tmptr->text=""     'neue Zeile ist leer
    tmptr->index=0     'keine Indexnummer
    tmptr->nextline=0  'kein Vorg�nger
    tmptr->nextline=0  'kein Nachfolger
    tmptr->BaseTO=@this'Adresse des TO zu dem diese Zeile geh�rt
    function=tmptr
  end if
end function



function TextObject.AppendBlankLine as TextLine ptr
  function=0
  dim tmptr as TextLine ptr
  tmptr=CreateBlankLine
  if tmptr then
    'Verlinken

    if lastline=0 then   'wenn die erste Zeile erzeugt wird
      tmptr->prevline=0  'keinen Vorg�nger
      tmptr->nextline=0  'keinen Nachfolger
      tmptr->index=1     'da erste bekommt sie auch den Index 1
      firstline=tmptr    'Zeile als erste im TO definieren
      lastline=tmptr     'Zeile als letzte im TO definieren... ist also beides!!!
    else                 'Anh�ngen an vorhandene Zeilen
      tmptr->prevline=lastline'Vorg�nger in neuer Zeile verlinken
      tmptr->nextline=0  'keinen Nachfolger
      tmptr->index=lastline->index + 1'Index um eins h�her als Vorg�nger
      lastline->nextline=tmptr'neue Zeile im Vorg�nger verlinken
      lastline=tmptr     'neue Zeile im TO als Letzte eintragen
    end if
    function=tmptr
  end if
end function



function TextObject.InsertBlankLine(prev as TextLine ptr) as TextLine ptr
  function=0
  dim as TextLine ptr nxt,newtr
  nxt=prev->nextline           'Nachfolger merken
  newtr=CreateBlankLine
    if newtr then
    'Verlinken
    '(nach hinten)
    prev->nextline=newtr       'neue Zeile in prev als Nachfolger eintragen
    newtr->prevline=prev       'prev in neuer Zeile als Vorg�nger eintragen

    '(nach vorn)
    newtr->nextline=nxt        'Nachfolger in neue Zeile als Nachfolger...
    nxt->prevline=newtr        'neue Zeile als (neuer) Vorg�nger des Nachfolgers... *hust*                                                  '�hhmm jahhh... die letzten 2 Kommentare lesen sich sehr bl�d, ist aber so... XD !!!
    function=newtr
  end if
end function



sub TextObject.DeleteAllLines (byval l as TextLine ptr)
  dim as TextLine ptr nl

  if l=firstline then
    firstline=0
    lastline=0
    longestline=0
    cursor.tline=0
    cursor.position=1
  end if

'  if l=clipfirstline then
'    clipfirstline=0
'    cliplastline=0
'  end if

  if l then          'wenn Zeile vorhanden(l>0), dann...
    do
      nl=l->nextline 'Hole aus der Zeile den Zeiger der n�chsten Zeile (ist 0 wenn keine n�chste Zeile existiert)
      delete l       'L�sche aktuelle Zeile
      l=nl           'Erkl�re n�chste Zeile zur aktuellen,kann dabei auch zu 0 werden
    loop until l=0   'wenn keine Zeile da dann raus aus Loop
  end if
end sub



'interne Statistik*************************************************************
sub TextObject.MakeIndex
  dim as TextLine ptr l,nl
  dim as integer counter=0
  l=firstline        'Hole erste Zeile
  do
    counter +=1
    l->index=counter 'Schreibe Zeilennummer in Zeile
    l=l->nextline    'Hole aus der Zeile den Zeiger der n�chsten Zeile
  loop until l=0     'wenn keine Zeile da dann raus aus Loop
end sub