'mit Sicherheit nicht die schnellste Umsetzung :)

'basierend auf Eternal Pains Code:
'http://www.freebasic-portal.de/code-beispiele/grafik-und-fonts/hsv-rgb-162.html
'und
'http://de.wikipedia.org/wiki/HSV-Farbraum

type ColorDefinition
  private:
  RGBValue      as uinteger
  'Zeiger auf die einzelnen Farbkomponenten in der Variable RGBValue
  RedComponentPtr    as ubyte ptr
  GreenComponentPtr  as ubyte ptr
  BlueComponentPtr   as ubyte ptr
  AlphaComponentPtr  as ubyte ptr

  Hue           as single'Farbwert/Farbwinkel: 0 - 360 grd
  Saturation    as single'Sättigung/Weißwert: 0 - 100 %
  Value         as single'Dunkelwert/Schwarzwert: 0 - 100 %

  public:
  declare constructor
  
  declare sub AllToZero
  
  declare sub SetRGB (rgbv as uinteger)
  declare sub SetRed (c as ubyte)
  declare sub SetGreen (c as ubyte)
  declare sub SetBlue (c as ubyte)
  declare sub SetAlpha (c as ubyte)

  declare sub SetHSV (h as single, s as single, v as single)
  declare sub SetHue (h as single)
  declare sub SetSaturation (s as single)
  declare sub SetValue (v as single)
  declare sub ShiftHue (h as single)
  declare sub ShiftSaturation (s as single)
  declare sub ShiftValue (v as single)


  declare function GetRGB as uinteger
  declare function GetRed as ubyte
  declare function GetGreen as ubyte
  declare function GetBlue as ubyte
  declare function GetAlpha as ubyte

  declare function GetHue as single
  declare function GetSaturation as single
  declare function GetValue as single

  private:
  declare sub CalcHSV
  declare sub CalcRGB
end type



constructor ColorDefinition
  AllToZero
  BlueComponentPtr=cast(ubyte ptr,@RGBValue)
  GreenComponentPtr=cast(ubyte ptr,@RGBValue)+1
  RedComponentPtr=cast(ubyte ptr,@RGBValue)+2
  AlphaComponentPtr=cast(ubyte ptr,@RGBValue)+3
end constructor



sub ColorDefinition.AllToZero
  RGBValue=0
  Hue=0
  Saturation=0
  Value=0
end sub



sub ColorDefinition.SetRGB (rgbv as uinteger)
  RGBValue=rgbv
  CalcHSV
end sub



sub ColorDefinition.SetRed (c as ubyte)
  *RedComponentPtr=c
  CalcHSV
end sub



sub ColorDefinition.SetGreen (c as ubyte)
  *GreenComponentPtr=c
  CalcHSV
end sub



sub ColorDefinition.SetBlue (c as ubyte)
  *BlueComponentPtr=c
  CalcHSV
end sub



sub ColorDefinition.SetAlpha (c as ubyte)
  *AlphaComponentPtr=c
  'CalcHSV
end sub



sub ColorDefinition.SetHSV (h as single, s as single, v as single)
  Hue=h
  Saturation=s
  Value=v
  if Hue>=360 then Hue=0
  if Hue<=0 then Hue=0
  if Saturation>100 then Saturation=100
  if Saturation<0 then Saturation=0
  if Value>100 then Value=100
  if Value<0 then Value=0
  CalcRGB
end sub



sub ColorDefinition.SetHue (h as single)
  Hue=h
  if Hue>=360 then Hue=0
  if Hue<=0 then Hue=0
  CalcRGB
end sub



sub ColorDefinition.SetSaturation (s as single)
  Saturation=s
  if Saturation>100 then Saturation=100
  if Saturation<0 then Saturation=0
  CalcRGB
end sub



sub ColorDefinition.SetValue (v as single)
  Value=v
  if Value>100 then Value=100
  if Value<0 then Value=0
  CalcRGB
end sub



sub ColorDefinition.ShiftHue (h as single)
  Hue +=h
  if Hue>=360 then Hue=0
  if Hue<=0 then Hue=0
  CalcRGB
end sub



sub ColorDefinition.ShiftSaturation (s as single)
  Saturation +=s
  if Saturation>100 then Saturation=100
  if Saturation<0 then Saturation=0
  CalcRGB
end sub



sub ColorDefinition.ShiftValue (v as single)
  Value +=v
  if Value>100 then Value=100
  if Value<0 then Value=0
  CalcRGB
end sub



function ColorDefinition.GetRGB as uinteger
  function=RGBValue
end function



function ColorDefinition.GetRed as ubyte
  function=*RedComponentPtr
end function



function ColorDefinition.GetGreen as ubyte
  function=*GreenComponentPtr
end function



function ColorDefinition.GetBlue as ubyte
  function=*BlueComponentPtr
end function



function ColorDefinition.GetAlpha as ubyte
  function=*AlphaComponentPtr
end function



function ColorDefinition.GetHue as single
  function=Hue
end function



function ColorDefinition.GetSaturation as single
  function=Saturation
end function



function ColorDefinition.GetValue as single
  function=Value
end function



sub ColorDefinition.CalcHSV
  dim as ubyte RGB_Max,RGB_Min,RGB_Range

  'Maximal- und Minimalwerte ermitteln
  RGB_Max=0
  RGB_Min=255
  if *RedComponentPtr<RGB_Min then RGB_Min=*RedComponentPtr
  if *GreenComponentPtr<RGB_Min then RGB_Min=*GreenComponentPtr
  if *BlueComponentPtr<RGB_Min then RGB_Min=*BlueComponentPtr

  if *RedComponentPtr>RGB_Max then RGB_Max=*RedComponentPtr
  if *GreenComponentPtr>RGB_Max then RGB_Max=*GreenComponentPtr
  if *BlueComponentPtr>RGB_Max then RGB_Max=*BlueComponentPtr

  RGB_Range=RGB_Max-RGB_Min
  'Grundfarbe in Grad ermitteln
  if RGB_Range then'keine Grauwerte
    select case RGB_Max
      case *RedComponentPtr                                 'Maximalwert:rot
        Hue=60 * (0 + (*GreenComponentPtr-*BlueComponentPtr) / RGB_Range)
      case *GreenComponentPtr                                 'Maximalwert:grün
        Hue=60 * (2 + (*BlueComponentPtr-*RedComponentPtr) / RGB_Range)
      case *BlueComponentPtr                                 'Maximalwert:blau
        Hue=60 * (4 + (*RedComponentPtr-*GreenComponentPtr) / RGB_Range)
    end select
    if Hue<0 then Hue +=360

  else'Grauwerte
    Hue=0
  end if

  if RGB_Max then Saturation=100 * RGB_range/RGB_Max else Saturation=0

  Value=100 *RGB_Max/255
end sub



sub ColorDefinition.CalcRGB
  'diese Routine lässt die Alphakomponente unberührt!!!

  dim as integer Huecase
  'Grundfarbe ermitteln
  Huecase=int(Hue/60)+1
  select case Huecase
    case 1                        'grün steigend
      *RedComponentPtr=255
      *GreenComponentPtr=255 * Hue/60
      *BlueComponentPtr=0
    case 2                        'rot fallend
      *RedComponentPtr=255 - (255 * (Hue-60) / 60)
      *GreenComponentPtr=255
      *BlueComponentPtr=0
    case 3                        'blau steigend
      *RedComponentPtr=0
      *GreenComponentPtr=255
      *BlueComponentPtr=255 * (Hue-120)/60
    case 4                        'grün fallend
      *RedComponentPtr=0
      *GreenComponentPtr=255 - (255 * (Hue-180)/60)
      *BlueComponentPtr=255
    case 5                        'rot steigend
      *RedComponentPtr=255 * (Hue-240)/60
      *GreenComponentPtr=0
      *BlueComponentPtr=255
    case 6                        'blau fallend
      *RedComponentPtr=255
      *GreenComponentPtr=0
      *BlueComponentPtr=255 - (255 * (Hue-300)/60)
  end select
  '                          s Sättigung                            und        v Helligkeit berechnen
  *RedComponentPtr=(255 - (255-*RedComponentPtr)*Saturation/100)     *         Value/100
  *GreenComponentPtr=(255 - (255-*GreenComponentPtr)*Saturation/100) *         Value/100
  *BlueComponentPtr=(255 - (255-*BlueComponentPtr)*Saturation/100)   *         Value/100
end sub
