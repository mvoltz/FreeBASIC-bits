declare function TO_KeyAddChar(gad as _Gadget ptr,c as string)as integer
declare function TO_KeyBackspace(gad as _Gadget ptr)as integer
declare function TO_KeyDelete(gad as _Gadget ptr)as integer
declare function TO_KeyReturn(gad as _Gadget ptr)as integer

declare function TO_SetCursor overload(gad as _Gadget ptr,l as integer,p as integer)as integer
declare function TO_SetCursor(gad as _Gadget ptr,l as Textline ptr,p as integer)as integer
declare function TO_CursorUp(gad as _Gadget ptr)as integer
declare function TO_CursorDown(gad as _Gadget ptr)as integer
declare function TO_CursorLeft(gad as _Gadget ptr)as integer
declare function TO_CursorRight(gad as _Gadget ptr)as integer
'added by MilkFreeze, modified by Muttonhead :)
declare function TO_CursorKeyPos1(gad as _Gadget ptr)as integer
declare function TO_CursorKeyEnd(gad as _Gadget ptr)as integer

declare function TO_GetCursorLine(gad as _Gadget ptr) as integer
declare function TO_GetCursorPosition(gad as _Gadget ptr) as integer
declare function TO_GetLines (gad as _Gadget ptr) as integer
declare function TO_GetLineAddr(gad as _Gadget ptr,i as integer) as TextLine ptr
declare function TO_GetLineIndex(gad as _Gadget ptr,r as TextLine ptr) as integer
declare function TO_GetLongestLine(gad as _Gadget ptr) as integer

declare function TO_LoadText (gad as _Gadget ptr,s as string,linebreak as string=chr(13,10)) as integer
declare function TO_SetText (gad as _Gadget ptr,s as string,linebreak as string=chr(13,10)) as integer

declare function TO_SaveText (gad as _Gadget ptr,filename as string, linebreak as string=chr(13,10))as integer
declare function TO_GetText (gad as _Gadget ptr,linebreak as string=chr(13,10)) as string
declare function TO_GetLineContent overload(gad as _Gadget ptr,i as integer) as string
declare function TO_GetLineContent (gad as _Gadget ptr,l as TextLine ptr) as string
declare function TO_SetLineContent overload(gad as _Gadget ptr,i as integer,t as string)as integer
declare function TO_SetLineContent (gad as _Gadget ptr,l as TextLine ptr,t as string)as integer
declare function TO_AppendLine (gad as _Gadget ptr,t as string) as integer
declare function TO_ClearText (gad as _Gadget ptr) as integer



function TO_KeyAddChar(gad as _Gadget ptr,c as string)as integer
  function=0  
  if gad->TObject then
    gad->TObject->KeyAddChar(c)
    function=1
  end if
end function



function TO_KeyBackspace(gad as _Gadget ptr)as integer
  function=0
  if gad->TObject then
    gad->TObject->KeyBackspace
    function=1
  end if
end function


function TO_KeyDelete(gad as _Gadget ptr)as integer
  function=0
  if gad->TObject then
    gad->TObject->KeyDelete
    function=1
  end if
end function



function TO_KeyReturn(gad as _Gadget ptr)as integer
  function=0
  if gad->TObject then
    gad->TObject->KeyReturn
    function=1
  end if
end function



function TO_SetCursor overload(gad as _Gadget ptr,l as integer,p as integer)as integer
  function=0
  if gad->TObject then
    gad->TObject->SetCursor(l,p)
    function=1
  end if
end function



function TO_SetCursor(gad as _Gadget ptr,l as Textline ptr,p as integer)as integer
  function=0
  if gad->TObject then
    gad->TObject->SetCursor(l,p)
    function=1
  end if
end function



function TO_CursorUp(gad as _Gadget ptr)as integer
  function=0
  if gad->TObject then
    gad->TObject->CursorUp
    function=1
  end if
end function



function TO_CursorDown(gad as _Gadget ptr)as integer
  function=0
  if gad->TObject then
    gad->TObject->CursorDown
    function=1
  end if
end function



function TO_CursorLeft(gad as _Gadget ptr)as integer
  function=0
  if gad->TObject then
    gad->TObject->CursorLeft
    function=1
  end if
end function



function TO_CursorRight(gad as _Gadget ptr)as integer
  function=0
  if gad->TObject then
    gad->TObject->CursorRight
    function=1
  end if
end function



function TO_CursorKeyPos1(gad as _Gadget ptr)as integer
  function=0
  if gad->TObject then
    gad->TObject->CursorKeyPos1
    function=1
  end if
end function



function TO_CursorKeyEnd(gad as _Gadget ptr)as integer
  function=0
  if gad->TObject then
    gad->TObject->CursorKeyEnd
    function=1
  end if
end function



function TO_GetCursorLine(gad as _Gadget ptr) as integer
  function=0
  if gad->TObject then function=gad->TObject->GetCursorLine
end function



function TO_GetCursorPosition(gad as _Gadget ptr) as integer
  function=0
  if gad->TObject then function=gad->TObject->GetCursorPosition
end function



function TO_GetLines (gad as _Gadget ptr) as integer
  function=0
  if gad->TObject then function=gad->TObject->GetLines
end function



function TO_GetLineAddr(gad as _Gadget ptr,i as integer) as TextLine ptr
  function=0
  if gad->TObject then function=gad->TObject->GetLineAddr(i)
end function



function TO_GetLineIndex(gad as _Gadget ptr,l as TextLine ptr) as integer
  function=0
  if gad->TObject then function=gad->TObject->GetLineIndex(l)
end function



function TO_GetLongestLine(gad as _Gadget ptr) as integer
  function=0
  if gad->TObject then function=gad->TObject->GetLongestLine
end function



function TO_LoadText(gad as _Gadget ptr,filename as string,linebreak as string=chr(13,10)) as integer
  function=0
  if gad->TObject then
    gad->TObject->LoadText(filename,linebreak)
    function=1
  end if
end function



function TO_SetText(gad as _Gadget ptr,s as string,linebreak as string=chr(13,10)) as integer
  function=0
  if gad->TObject then
    gad->TObject->SetText (s,linebreak)
    function=1
  end if
end function



function TO_SaveText (gad as _Gadget ptr,filename as string, linebreak as string=chr(13,10)) as integer
  function=0
  if gad->TObject then
    gad->TObject->SaveText (filename, linebreak)
    function=1
  end if
end function



function TO_GetText (gad as _Gadget ptr,linebreak as string=chr(13,10)) as string
  function=""
  if gad->TObject then function=gad->TObject->GetText(linebreak)
end function



function TO_GetLineContent (gad as _Gadget ptr,i as integer) as string
  function=""
  if gad->TObject then function=gad->TObject->GetLineContent (i)
end function



function TO_GetLineContent (gad as _Gadget ptr,l as TextLine ptr) as string
  function=""
  if gad->TObject then function=gad->TObject->GetLineContent (l)
end function



function TO_SetLineContent (gad as _Gadget ptr,i as integer,t as string)as integer
  function=0
  if gad->TObject then
    gad->TObject->SetLineContent(i,t)
    function=1
  end if
end function



function TO_SetLineContent (gad as _Gadget ptr,l as TextLine ptr,t as string)as integer
  function=0
  if gad->TObject then
    gad->TObject->SetLineContent(l,t)
    function=1
  end if
end function



function TO_AppendLine (gad as _Gadget ptr,t as string) as integer
  function=0
  if gad->TObject then
    gad->TObject->AppendLine (t)
    function=1
  end if
end function


function TO_ClearText(gad as _Gadget ptr)as integer
  function=0
  if gad->TObject then
    gad->TObject->ClearText
    function=1
  end if
end function
