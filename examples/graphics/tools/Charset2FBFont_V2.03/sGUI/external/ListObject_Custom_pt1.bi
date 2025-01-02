declare function NewNode(nt as integer) as any ptr
declare sub KillNode(e as any ptr)

'allen UDTs, denen das node type vererbt und damit "listenfähig" gemacht wurden, werden jetzt Typkonstanten zugeordnet
'über diese wird das entsprechende Objekt erzeugt, und kann auch wieder richtig entfernt werden.
const as integer NodeType=0
const as integer ListObjectType=1
const as integer EventHandleType=2
const as integer GadgetType=3
const as integer TextObjectType=4
const as integer sGUIImageType=5
const as integer sGUIMenuType=6
const as integer sGUIMenuEntryType=7
