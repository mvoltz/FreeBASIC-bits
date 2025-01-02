#ifndef __FBTrueType_h__
#define __FBTrueType_h__

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define STB_TRUETYPE_IMPLEMENTATION
#include "stb_truetype.h"

#ifdef WIN32
 #ifdef BUILD_DLL
  #define DLL_EXPORT __declspec(dllexport)
 #else
  //#define DLL_EXPORT __declspec(dllimport)
  #define DLL_EXPORT
 #endif
#else
 #define DLL_EXPORT
#endif


#define MAX_FONTS 64


typedef struct {
  float scale;
  int   advanceHeight;
  int   ascent;
  int   descent;
  int   linegap;
} FontProps;

typedef struct {
  int  advanceWidth;
  int  kernAdvance;
  int  leftSideBearing;
  int  y;
  int  w;
  int  h;
} GlyphProps;

typedef struct {
  int image_hdr;
  int image_bpp;
  int image_w;
  int image_h;
  int image_p;
  int reserved1;
  int reserved2;
  int reserved3;
} FBGFXImage;


#ifdef __cplusplus
extern "C" {
#endif

DLL_EXPORT void FontInit(void);
DLL_EXPORT void FontDestroy(void);
//! ########
//! # Font #
//! ########
DLL_EXPORT int FontCopy(unsigned char* filedata);
DLL_EXPORT int FontLoad(const char * filename);
DLL_EXPORT void FontFree(int* fontid);

DLL_EXPORT int FontBoundingBox(int index,int *x0, int *y0, int *x1, int *y1);
DLL_EXPORT int FontPorperties(int index, int height, FontProps* props);

//! #########
//! # Glyph #
//! #########
DLL_EXPORT int GlyphIndex(int index,int codepoint);
DLL_EXPORT char GlyphHasShape(int index, int glyphindex);
DLL_EXPORT int GlyphProperties(int index, FontProps* fprops,GlyphProps* gprops,int glyphindex1,int glyphindex2);
DLL_EXPORT int GlyphBoundingBox(int index, int glyphindex,int *x0, int *y0, int *x1, int *y1);

DLL_EXPORT FBGFXImage * GlyphImageCreate(int index,FontProps* fprops,GlyphProps* gprops,int glyphindex);
DLL_EXPORT void GlyphImageDestroy(FBGFXImage** img);
#ifdef __cplusplus
}
#endif

#endif // __FBTrueType_h__
