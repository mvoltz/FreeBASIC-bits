'System Includes
#include once "fbgfx.bi"
#include once "vbcompat.bi"

namespace sGUI
#include "external\ListObject_Custom_pt1.bi"
#include "external\ListObject.bi"
#include "external\TextObject.bi"
#include "external\BitmapFont.bi"
#include "external\ColorDefinition.bi"

'Fwd Ref
type _Gadget        as Gadget
type _EventHandle   as EventHandle
type _Menu          as Menu
type _MenuEntry     as MenuEntry
type _sGUIImage     as sGUIImage
type _BitmapFont    as BitmapFont

'Konstanten für die Beschreibung des Maustastenstatus
const as integer HIT=2     'Taste grad frisch gedrückt
const as integer HOLD=3     'Taste gehalten
const as integer RELEASE=1  'Taste grad losgelassen
const as integer RELEASED=0 'Taste ist losgelassen

'Konstanten für die Beschreibung der Ereignisse von Controls
'LMB
const as integer GADGET_LMBHIT=1         'Control grad frisch gedrückt
const as integer GADGET_LMBHOLD=2        'Control wird gehalten, Maus über dem Control
const as integer GADGET_LMBHOLDOFF=3     'Control wird gehalten, Maus neben dem Control
const as integer GADGET_LMBRELEASE=4     'Control regulär losgelassen
const as integer GADGET_LMBRELEASEOFF=5  'Control losgelassen, dabei ist Maus neben dem Control
'MMB
const as integer GADGET_MMBHIT=6         'Control grad frisch gedrückt
const as integer GADGET_MMBHOLD=7        'Control wird gehalten, Maus über dem Control
const as integer GADGET_MMBHOLDOFF=8     'Control wird gehalten, Maus neben dem Control
const as integer GADGET_MMBRELEASE=9     'Control regulär losgelassen
const as integer GADGET_MMBRELEASEOFF=10  'Control losgelassen, dabei ist Maus neben dem Control
'RMB
const as integer GADGET_RMBHIT=11         'Control grad frisch gedrückt
const as integer GADGET_RMBHOLD=12        'Control wird gehalten, Maus über dem Control
const as integer GADGET_RMBHOLDOFF=13     'Control wird gehalten, Maus neben dem Control
const as integer GADGET_RMBRELEASE=14     'Control regulär losgelassen
const as integer GADGET_RMBRELEASEOFF=15  'Control losgelassen, dabei ist Maus neben dem Control
'Maus über Control(Highlighting)
const as integer GADGET_MOUSEOVER=16   'Control ist losgelassen, dabei ist Maus überm dem Control
const as integer GADGET_MOUSENEXT=17   'Control ist losgelassen, dabei ist Maus jetzt neben dem Control
'Keyboard
const as integer GADGET_KEYBOARD=18    'Control verarbeitet die Tastatureingaben
const as integer GADGET_KEYBOARDOFF=19 'Abbruch der Verarbeitung der Tastatureingaben eines Controls
'Wheel
const as integer GADGET_WHEELMOVE=20  'Rad wurde bewegt

'Konstanten für MessageBoxen
'MB Types
const as integer MBType_OK=1
const as integer MBType_YESNO=2
const as integer MBType_CANCELRETRYIGNORE=3
const as integer MBType_OKCANCEL=4
const as integer MBType_RETRYCANCEL=5
const as integer MBType_YESNOCANCEL=6
'MB Button Returnwerte
const as integer MBButton_OK=1
const as integer MBButton_CANCEL=2
const as integer MBButton_RETRY=3
const as integer MBButton_IGNORE=4
const as integer MBButton_YES=5
const as integer MBButton_NO=6

'Menü Konstanten
const as string METag_STRIPSTART="STR:"
const as string METag_ITEM="ITM:"
const as string METag_CHECKMARK="CHK:"
const as string METag_SEPARATOR="SEP:"
const as string METag_STRIPEND="END:"
'Farbkonstanten
const as uinteger black=&h000000,white=&hffffff

'Farben
dim shared as integer contrast,CustomColors,SleepShade
dim shared as uinteger TextColor,BackGroundColor,GadgetTextColor,GadgetColor,GadgetFrameColor,GadgetGlowColor,GadgetGlowFrameColor,CursorColor,GadgetDarkFillColor
dim shared as uinteger MenuColor,MenuTextColor,MenuHiliteColor,MenuGhostlyColor
'
dim shared as integer minspace,bspace

'Font
dim shared as integer fontheight
dim shared as _BitmapFont ptr FontA,FontB

'System Events
'Keyboard
dim shared as string  KEY
dim shared as integer ASCCODE
dim shared as integer EXTENDED
'Maus
dim shared as integer MOUSEMOVED'idea by Petan
dim shared as integer MOUSEX
dim shared as integer MOUSEY
dim shared as integer LMB
dim shared as integer MMB
dim shared as integer RMB
dim shared as integer WHEEL
dim shared as integer CLOSEBUTTON
'alte Vergleichswerte, in der Regel vom vorherigen Loopdurchlauf
dim shared as integer oldMOUSEX
dim shared as integer oldMOUSEY
dim shared as integer oldLMB
dim shared as integer oldMMB
dim shared as integer oldRMB
dim shared as integer oldWHEEL
dim shared as integer wheelvalue,oldwheelvalue
dim shared as integer NEWCLICKSEQUENCE

'Listen
dim shared as ListObject ptr EventHandleList,GadgetLists,ImageList,TOList,MenuList,MenuEntryLists,PointerLists

declare sub GadgetOn overload (gad as _Gadget ptr)
declare sub GadgetOn (gadblockstart as _Gadget ptr, gadblockend as _Gadget ptr)

declare sub GadgetSleep overload (gad as _Gadget ptr)
declare sub GadgetSleep (gadblockstart as _Gadget ptr, gadblockend as _Gadget ptr)

declare sub GadgetOff   overload (gad as _Gadget ptr)
declare sub GadgetOff (gadblockstart as _Gadget ptr, gadblockend as _Gadget ptr)

declare sub RestoreActivation overload (gad as _Gadget ptr)
declare sub RestoreActivation (gadblockstart as _Gadget ptr, gadblockend as _Gadget ptr)

declare sub GadOn    (gad as _Gadget ptr)
declare sub GadSleep (gad as _Gadget ptr)
declare sub GadOff   (gad as _Gadget ptr)

declare function GetSelect (gad as _Gadget ptr) as integer
declare sub SetSelect (gad as _Gadget ptr,Selection as integer)

declare sub DrawGadget(gad as _Gadget ptr)
declare function GadgetAction(gad as _Gadget ptr, action as integer) as integer
declare sub UpdateGadget(gad as _Gadget ptr)
declare sub SetCaption(gad as _Gadget ptr,Text as string)
declare sub UpdateInternalEventHandle (gad as _Gadget ptr)

declare function UImport(s as string) as string
declare function UExport(s as string) as string

declare sub GetGlobalPosition overload(event as _EventHandle ptr, byref posx as integer, byref posy as integer)
declare sub GetGlobalPosition (event as _Gadget ptr, byref posx as integer, byref posy as integer)

declare function AddImageEntry as _sGUIImage ptr
declare sub DelImageEntry(sguiimg as _sGUIImage ptr)
declare function AddEventHandle as _EventHandle ptr
declare sub DelEventHandle(event as _EventHandle ptr)
declare function AddMenu as _Menu ptr
declare sub DelMenu (m as _Menu ptr)

'sGUI Includes
#include "sGUI_SystemEvents.bas"
#include "Phrases.bi"
#include "sGUI_Font.bas"
#include "sGUI_Drawing.bas"
#include "sGUI_ImageType.bas"
#include "sGUI_GadgetType.bas"
#include "TOGadgetBindings.bas"
#include "sGUI_EventHandle.bas"
#include "sGUI_MenuType.bas"
#include "sGUI_Misc.bas"

#include "external\ListObject_Custom_pt2.bi"
end namespace


sGUI.CustomColors=0
'sGUI.contrast=96'stellt tatsächlich eine Art Kontrast-Variable dar
'           'wer will,kann gerne mal mit rumspielen, es geht nichts kaputt :)
'           'hab die 96 als angenehmsten empfunden
sGUI.SleepShade=255 * .33
sGUI.CLOSEBUTTON=0
sGUI.NEWCLICKSEQUENCE=0
sGUI.FontA=new sGUI.BitmapFont
sGUI.FontB=new sGUI.BitmapFont
sGUI.minspace=3
sGUI.bspace=3

sGUI.EventHandleList=new sGUI.ListObject
sGUI.GadgetLists=new sGUI.ListObject
sGUI.ImageList=new sGUI.ListObject
sGUI.TOList= new sGUI.ListObject
sGUI.MenuList= new sGUI.ListObject
sGUI.MenuEntryLists= new sGUI.ListObject
sGUI.PointerLists= new sGUI.ListObject

'******************************************************************************
'******************************************************************************
'allg. Destruktor**************************************************************

sub Maindestructor destructor
  if sGUI.FontA then delete sGUI.FontA
  if sGUI.FontB then delete sGUI.FontB
  if sGUI.EventHandleList then delete sGUI.EventHandleList
  if sGUI.GadgetLists then delete sGUI.GadgetLists
  if sGUI.ImageList then delete sGUI.ImageList
  if sGUI.TOList then delete sGUI.TOList
  if sGUI.MenuList then delete sGUI.MenuList
  if sGUI.MenuEntryLists then delete sGUI.MenuEntryLists
  if sGUI.PointerLists then delete sGUI.PointerLists  
  'beep' :)<--- it works!!! 
end sub
