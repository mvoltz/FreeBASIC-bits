'******************************************************************************
'******************************************************************************
'ListObject Part2**************************************************************
'folgende Routinen Erzeugen und Löschen das gewünschte Objekt im Listobject (dies hier sind keine Memberroutinen)
'neue "listenfähige" Types hier "einpflegen"!!!

function NewNode(nt as integer) as any ptr
  dim e as any ptr
  select case nt
    case NodeType
      e=new node
    case ListObjectType
      e=new ListObject
    case EventHandleType
      e=new EventHandle
    case GadgetType
      e=new Gadget
    case TextObjectType
      e=new TextObject
    case sGUIImageType
      e=new sGUIImage
    case sGUIMenuType
      e=new Menu
    case sGUIMenuEntryType
      e=new MenuEntry    
  end select
  cast(node ptr,e)->ntype=nt
  function=e
end function


sub KillNode(e as any ptr)
  dim as integer nt
  nt=cast(node ptr,e)->ntype
  select case nt
    case NodeType
      delete cast(node ptr,e)
    case ListObjectType
      delete cast(ListObject ptr,e)      
    case EventHandleType
      delete cast(EventHandle ptr,e)
    case GadgetType
      delete cast(Gadget ptr,e)
    case TextObjectType
      delete cast(TextObject ptr,e)
    case sGUIImageType
      delete cast(sGUIImage ptr,e)
    case sGUIMenuType
      delete cast(Menu ptr,e)
    case sGUIMenuEntryType
      delete cast(MenuEntry ptr,e)      
  end select
end sub
