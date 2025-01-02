namespace sGUI

declare function AddStrip (m as _Menu ptr, text as string="", activation as integer=1) as integer
declare function AddItem (m as _Menu ptr, text as string, activation as integer=1) as integer
declare function AddCheckMark (m as _Menu ptr, text as string="", activation as integer=1, selection as integer=1) as integer
declare function AddSeparator (m as _Menu ptr) as integer
declare function StripEnd (m as _Menu ptr) as integer

declare sub ModifyEntryActivation (m as _Menu ptr, entryID as integer, newact as integer)
declare sub ModifyEntrySelection  (m as _Menu ptr, entryID as integer, newsel as integer)
declare sub ModifyEntryText (m as _Menu ptr, entryID as integer, newText as string)

declare sub ClearMenu (m as _Menu ptr)

declare sub MenuFilter (BaseMenu as Menu ptr, StartID as integer=1, byref DisplayList as ListObject ptr)


function AddStrip (m as Menu ptr, text as string="", activation as integer=1) as integer
  function = m->AddEntry (METag_STRIPSTART,activation,,text)
end function


function AddItem (m as Menu ptr, text as string, activation as integer=1) as integer
  function=m->AddEntry (METag_ITEM,activation,,text)
end function


function AddCheckMark (m as Menu ptr, text as string="", activation as integer=1, selection as integer=1) as integer
  function=m->AddEntry (METag_CHECKMARK,activation,selection,text)
end function


function AddSeparator (m as Menu ptr) as integer
  function=m->AddEntry (METag_SEPARATOR,0,0)
end function


function StripEnd (m as Menu ptr) as integer
  function=m->AddEntry(METag_STRIPEND)
end function


sub ModifyEntryActivation (m as Menu ptr, entryID as integer, newact as integer)
  m->ModifyActivation (entryID, newact)
end sub


sub ModifyEntrySelection (m as Menu ptr, entryID as integer, newsel as integer)
  m->ModifySelection (entryID, newsel)
end sub


sub ModifyEntryText (m as Menu ptr, entryID as integer, newText as string)
  m->ModifyText (entryID, newText)
end sub


sub MenuFilter (BaseMenu as Menu ptr, StartID as integer=1, byref DisplayList as ListObject ptr)
  dim as MenuEntry ptr me
  dim as node ptr nn
  dim as integer BaseLevel,MenuLevel,IDcount,exitloop
  dim as integer numentriesBaseMenu,ParseLevelZero
  
  ParseLevelZero=iif(StartID=0,1,0)
  
  numentriesBaseMenu=BaseMenu->GetEntries
  
  IDCount=iif(StartID=0,1,StartID)
  do
    me=BaseMenu->EntryList->GetAddr(IDCount)
    
    if IDCount=StartID then
      if me->tag=METag_STRIPSTART then
        BaseLevel=me->Level
        if ParseLevelZero=1 then
          MenuLevel=BaseLevel
        else
          MenuLevel=BaseLevel+1
        end if
      else
        exitloop=1
      end if
    end if
    
    'falls ein Menüeintrag des Basemenüs dem Menülevel entspricht
    'einen neuen Node in der DisplayList erzeugen und diesen
    'Menüeintrag dort hinterlegen (in ->anypointer)
    if (me->Level=MenuLevel) and (me->Tag<>METag_STRIPEND) and (exitloop=0) then
      nn=DisplayList->Appendnew(NodeType)
      nn->anypointer=me
    end if
    
    if ParseLevelZero=0 then
      if (me->Level=BaseLevel) and (me->Tag=METag_STRIPEND) then exitloop=1'wenn ENDTAG erreicht, raus aus Loop    
    end if
    
    IDCount +=1
  loop until (IDCount>numentriesBaseMenu) or (exitloop=1)
end sub

end namespace