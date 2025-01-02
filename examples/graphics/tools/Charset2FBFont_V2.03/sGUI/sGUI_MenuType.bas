type MenuEntry extends node
  tag        as string
  level      as integer
  ID         as integer  
  text       as string  
  activation as integer
  selection  as integer
  posx       as integer    
  posy       as integer    
  entrywidth     as integer
  entryheight   as integer  
end type


type Menu extends node
  public:
  EntryList  as ListObject ptr
  private:
  MenuLevel  as integer

  public:
  declare constructor ()
  declare destructor ()
  declare function AddEntry(entrytag as string, activation as integer=1,selection as integer=1,text as string="") as integer
  declare function GetMenuLevel as integer
  declare sub ModifyActivation (entryID as integer, newact as integer)
  declare sub ModifySelection  (entryID as integer, newsel as integer)
  declare sub ModifyText       (entryID as integer, newText as string)
  declare function GetEntries as integer
  declare sub ClearMenu

  private:
  declare sub IncrMenuLevel
  declare sub DecrMenuLevel
end type


constructor Menu()
  EntryList= MenuEntryLists->AppendNew(ListObjectType)
  MenuLevel=0
end constructor


destructor Menu()
  MenuEntryLists->DeleteNode(EntryList)
end destructor


function Menu.AddEntry(entrytag as string, activation as integer=1,selection as integer=1,text as string="") as integer
  function=0
  dim as MenuEntry ptr me
  me=EntryList->AppendNew (sGUIMenuEntryType) 
  if me then
  
    if entrytag=METag_STRIPEND then DecrMenuLevel 
    'damit befindet sich ein STRIPEND Eintrag selbst wieder eine Ebene unterhalb der 
    'eingeschlossenen Einträge, passend zu seinem Pendant STRIPSTART weiter oben in der Liste  
  
    me->tag        =entrytag
    me->level      =MenuLevel
    me->ID         =EntryList->GetIndex(me)  
    me->text       =text  
    me->activation =activation
    me->selection  =selection
    me->posx       =0    
    me->posy       =0   
    me->entrywidth =GetTextWidth(text,0) + 4*minspace
    me->entryheight=0
    
    if entrytag=METag_STRIPSTART then IncrMenuLevel
    'damit befindet sich ein STRIPSTART Eintrag selbst noch in der Ursprungsebene, folgende Einträge
    'dann eine Ebene höher
    
    function=EntryList->GetIndex(me)
  end if
end function


function Menu.GetMenuLevel as integer
  function=MenuLevel
end function


sub Menu.ModifyActivation (entryID as integer, newact as integer)
  dim as MenuEntry ptr me
  me=EntryList->GetAddr(entryID)
  if me->tag<>METag_SEPARATOR then me->activation=newact
end sub


sub Menu.ModifySelection (entryID as integer, newsel as integer)
  dim as MenuEntry ptr me
  me=EntryList->GetAddr(entryID)
  if me->tag<>METag_SEPARATOR then me->selection=newsel
end sub


sub Menu.ModifyText (entryID as integer, newText as string)
  dim as MenuEntry ptr me
  me=EntryList->GetAddr(entryID)
  me->text=newtext 
end sub


function Menu.GetEntries as integer
  function=EntryList->NumNodes
end function


sub Menu.ClearMenu
  delete EntryList
  dim newentrylist as ListObject ptr
  newentrylist=new ListObject 
  EntryList=newentrylist
  MenuLevel=0
end sub


sub Menu.IncrMenuLevel
  MenuLevel +=1
end sub


sub Menu.DecrMenuLevel
  MenuLevel -=1
end sub
