'Haupttype; intern im ListObject verwendet
type node extends object
  prev_node as node ptr'double linked list
  next_node as node ptr'double linked list
  ntype     as integer
  index     as integer
  'Data:
  'für den einfachsten Fall einer Liste kann man in einem node einen Zeiger hinterlegen
  anypointer as any ptr
end type



type ListObject extends node
  public:
  NumNodes     as integer'Anzahl der nodes
  private:
  first_node  as node ptr
  last_node   as node ptr  
  
  public:
  declare constructor
  declare destructor

  declare function AppendNew (nt as integer)  as any ptr 'erzeugt einen node und hängt es  a n  die liste an
  declare function PrependNew (nt as integer)  as any ptr 'erzeugt einen node und setzt es  v o r  die liste
  
  declare function GetFirst as any ptr              'liefert erstes Element als Zeiger
  declare function GetLast as any ptr               'liefert letztes Element als Zeiger
  declare function GetAddr(i as integer )as any ptr 'liefert den Zeiger des Elementes mit dem Index i
  declare function GetIndex(e as any ptr)as integer 'liefert den Index des Elementes mit der Adresse e
  
  declare sub MoveToFirst(e as any ptr)              'verschiebt ein Element an die erste Position in der Liste
  declare sub MoveToLast(e as any ptr)               'verschiebt ein Element an die letzte Position der Liste
  declare sub MoveBehind(e as any ptr, de as any ptr)'verschiebt ein Element hinter das Element de
  declare sub MoveBefore(e as any ptr, de as any ptr)'verschiebt ein Element vor das Element de  
  declare sub PrintList

  declare sub DeleteNode(e as any ptr)       'löscht Element e sowohl aus der Liste (also Freistellen) als auch das Element(Objekt) selbst
  declare sub DeleteAll                      'löscht gesamte Nodeliste und dessen Elemente(Objekte)

  private:
  declare sub Delink(n as node ptr)           'stellt einen node frei und modifiziert entsprechend die Liste, ohne es zu löschen!!!
  declare sub LinkAsFirst(n as node ptr)      'fügt ein freigestelltes node an den Listenanfang (als first_node) ein
  declare sub LinkAsLast(n as node ptr)       'hängt ein freigestelltes node ans Listenende (als last_node) an
  declare sub LinkBehindDest(n as node ptr, dest as node ptr)'setzt ein freigestelltes node hinter dest in die Liste
  declare sub LinkBeforeDest(n as node ptr, dest as node ptr)'setzt ein freigestelltes node vor dest in die Liste
  declare function CheckNode(n as node ptr) as integer       'überprüft node ob er in Liste existiert
  declare sub MakeIndex
end type



constructor ListObject
end constructor




destructor ListObject
  DeleteAll
end destructor



function ListObject.AppendNew (nt as integer) as any ptr
  dim as any ptr e
  e=NewNode(nt)
  if e then
    LinkAsLast cast(node ptr,e)
    MakeIndex
    function=e
  end if
end function



function ListObject.PrependNew (nt as integer) as any ptr
  dim as any ptr e
  e=NewNode(nt)
  if e then
    LinkAsFirst cast(node ptr,e)
    MakeIndex
    function=e
  end if
end function



function ListObject.GetFirst as any ptr
  function=first_node
end function



function ListObject.GetLast as any ptr
  function=last_node
end function



function ListObject.GetAddr(i as integer )as any ptr
  function=0
  dim as node ptr n,found
  found=0
  n=first_node
  if n then
    do
      if n->index = i  then found=n
      n=n->next_node
    loop until (n=0) or (found<>0)
    function=found
  end if
end function



function ListObject.GetIndex(e as any ptr)as integer
  function=0
  dim as node ptr n
  dim as integer found=0
  n=first_node
  if n then
    do
      if n = cast(node ptr,e)  then found=n->index
      n=n->next_node
    loop until (n=0) or (found>0)
    function=found
  end if
end function



sub ListObject.MoveToFirst(e as any ptr)
  dim as node ptr n=cast(node ptr,e)
  if CheckNode(n) then
    Delink n
    LinkAsFirst(n)
    MakeIndex
  end if
end sub



sub ListObject.MoveToLast(e as any ptr)
  dim as node ptr n=cast(node ptr,e)
  if CheckNode(n) then
    Delink n
    LinkAsLast(n)
    MakeIndex
  end if
end sub



sub ListObject.MoveBehind(e as any ptr, de as any ptr)
  dim as node ptr n=cast(node ptr,e)
  dim as node ptr dest=cast(node ptr,de)  
  if (n<>dest) and (CheckNode(n)) and (CheckNode(dest)) then
    Delink n
    LinkBehindDest(n, dest)
    MakeIndex
  end if
end sub



sub ListObject.MoveBefore(e as any ptr, de as any ptr)
  dim as node ptr n=cast(node ptr,e)
  dim as node ptr dest=cast(node ptr,de)  
  if (n<>dest) and (CheckNode(n)) and (CheckNode(dest)) then
    Delink n
    LinkBeforeDest(n, dest)
    MakeIndex
  end if
end sub



sub ListObject.PrintList
  dim as node ptr n
  n=first_node
  if (n>0) then
    do
      print "n: " & n; n->index , "pn: " & n->prev_node , "nn: " & n->next_node
      n=n->next_node
    loop until (n=0)
    print
  end if
end sub



sub ListObject.Delink(n as node ptr)
  dim as integer delinkcase
  if n then
    if (n=first_node) and (n=last_node) then delinkcase=1  'es existiert nur ein node(ist damit sowohl erstes als auch letztes), das herausgelöst wird
    if (n=first_node) and (n<>last_node) then delinkcase=2 'erste node der Liste wird herausgelöst
    if (n<>first_node) and (n<>last_node) then delinkcase=3'weder erstes noch letztes node(also mittendrin) wird herausgelöst
    if (n<>first_node) and (n=last_node) then delinkcase=4 'letztes node wird herausgelöst
    select case delinkcase
      case 1
        first_node=0
        last_node=0
      case 2
        n->next_node->prev_node=0 'im Nachfolger den Link zum Vorgänger löschen, damit wird auch innerhalb der Liste der Anfang neu definiert (zb. für Rückwärtssuche)
        first_node=n->next_node   'Nachfolger von n zum ersten node machen
      case 3
         '              +------------------+
         '              |                  |
         '      B       | C          D     |
         '   <-a c->   <-b d->    <-c n->  |
         '                  |              |
         '                  |              |  node C freistellen
         '      B           |        D     |
         '   <-a d->        |     <-b n->  |
         '        ^         |      ^       |
         '        |         |      |       |
         '        +---------+      +-------+

        n->next_node->prev_node = n->prev_node'im Nachfolger den Link zum "Vorvorgänger" setzen
        n->prev_node->next_node = n->next_node'im Vorgänger den Link zum "Nachnachfolger" setzen
      case 4
        n->prev_node->next_node=0             'im Vorgänger den Link zum Nachfolger löschen(=0), damit wird auch innerhalb der Liste das Ende neu definiert
        last_node=n->prev_node                'Vorgänger von n zum letzten node machen
    end select
    n->prev_node=0                            'alle Verlinkungen im freigestelltem node n auf 0 setzen
    n->next_node=0
  end if
end sub



sub ListObject.LinkAsFirst(n as node ptr)
  n->prev_node=0              'zur Sicherheit erst einmal alle Verlinkungen im übergebenen node auf 0 setzen
  n->next_node=0
  'Verlinken
  if first_node then          'sollte schon mindestens ein node existieren, dann...
    first_node->prev_node=n   'node n dort als Vorgänger definieren
    n->next_node=first_node   'im node n bisheriges erstes node als Nachfolger definieren
    first_node=n              'node n wird zum ersten der Liste
  else                        'sollte noch kein node existieren dann...
    first_node=n              'sowohl...
    last_node=n               ' ...als auch
  end if
end sub



sub ListObject.LinkAsLast(n as node ptr)
  n->prev_node=0              'zur Sicherheit erst einmal alle Verlinkungen im übergebenen node auf 0 setzen
  n->next_node=0
  'Verlinken
  if last_node then           'sollte schon mindestens ein node existieren, dann...
    last_node->next_node=n    'node n dort als Nachfolger definieren
    n->prev_node=last_node    'im node n bisheriges letzes node als Vorgänger definieren
    last_node=n               'node n wird zum letzten der Liste
  else                        'sollte noch kein node existieren dann...
    first_node=n              'sowohl...
    last_node=n               ' ...als auch
  end if
end sub



sub ListObject.LinkBehindDest(n as node ptr, dest as node ptr) 
  dim as node ptr nn
  if dest=last_node then
    LinkAsLast(n)  
  else
    nn=dest->next_node'Nachfolger von dest merken
  
    dest->next_node=n 'in dest node n als Nachfolger definieren
    nn->prev_node=n   'in Nachfolger von dest node n als Vorgänger definieren
  
    n->prev_node=dest 'in node n dest als Vorgänger definieren
    n->next_node=nn   'in node n Nachfolger von dest als Nachfolger definieren
  end if
end sub



sub ListObject.LinkBeforeDest(n as node ptr, dest as node ptr) 
  dim as node ptr pn
  if dest=first_node then
    LinkAsFirst(n)
  else
    pn=dest->prev_node'Vorgänger von dest merken
    
    pn->next_node=n   'in dests Vorgänger node n als Nachfolger definieren
    dest->prev_node=n 'in dest node n als Vorgänger definieren
    
    n->next_node=dest 'in node n dest als Nachfolger definieren
    n->prev_node=pn   'in node n dests ehemaligen Vorgänger als Vorgänger definieren    
  end if
end sub



function ListObject.CheckNode(n as node ptr) as integer
  function=0
  dim as node ptr nn
  dim as integer found=0
  nn=first_node
  if (nn>0) and (n>0) then
    do
      if nn=n then found=1
      nn=nn->next_node
    loop until (nn=0) or (found<>0)
    function=found
  end if
end function



sub ListObject.MakeIndex
  dim as node ptr n,nn
  n=first_node
  NumNodes=0
  if n then
    do
      NumNodes +=1        'Anzahl erhöhen,da NumNodes Bestandteil des Listobjektes enthält es die Gesamtzahl der nodes
      nn=n->next_node     'Nachfolger von n holen
      n->index=NumNodes   'Index in node schreiben
      n=nn                'Nachfolger zum akuellem node machen
    loop until n=0        'wenn keine node >>> raus!!!
  end if
end sub



sub ListObject.DeleteNode(e as any ptr)
  dim as node ptr n=cast(node ptr,e)  
  Delink n
  KillNode (e)
end sub



sub ListObject.DeleteAll
  dim as node ptr n,nn
  n=first_Node
  if n then
    do
      nn=n->next_node 'Nachfolger sichern
      'DeleteNode n        'hier würde die Liste korrigiert, nicht falsch aber nicht mehr notwendig
      KillNode (n)
      n=nn            'Nachfolger zum akuellem node machen
    loop until n=0    'wenn keine node >>> raus!!!
  end if
end sub
