type sGUIImage extends node
  img       as FB.Image ptr
  declare destructor
end type

destructor sGUIImage
  if img then imagedestroy img
end destructor

'******************************************************************************
'******************************************************************************
'******************************************************************************

