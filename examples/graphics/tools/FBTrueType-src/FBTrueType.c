#include "FBTrueType.h"

#ifdef __cplusplus
extern "C" {
#endif

const int FONT_MAGIC = 0xC0FFEE;

#define FONT_NOT_LOADED    (-1)
#define FONT_NOT_SUPPORTED (-2)
#define NO_FREE_FONTID     (-3)
#define WRONG_FONTID       (-4)
#define WRONG_VALUE        (-5)
#define GLYPH_NOT_FOUND    (-6)

struct fbfont_tag {
  int            magic;
  int            allocated;
  unsigned char* filedata;
  stbtt_fontinfo fontinfo;
};

typedef struct fbfont_tag fbfont;

fbfont fbfonts[MAX_FONTS];

DLL_EXPORT void FontDestroy(){
  int i;
  for (i=0;i<MAX_FONTS;i++){
    if (fbfonts[i].magic==FONT_MAGIC) {
      if (fbfonts[i].filedata){
        if (fbfonts[i].allocated){
          free(fbfonts[i].filedata);
          fbfonts[i].allocated=0;
        }
        fbfonts[i].filedata=NULL;
      }
    }
  }
}

DLL_EXPORT void FontInit(){
  int i;
  FontDestroy();
  for (i=0;i<MAX_FONTS;i++){
    memset(&fbfonts[i],0,sizeof(fbfont));
    fbfonts[i].magic=FONT_MAGIC;
  }
}

int FontAlloc(void) {
  int i,index=NO_FREE_FONTID;
  for (i=0;i<MAX_FONTS;i++){
    if (fbfonts[i].magic!=FONT_MAGIC){
      memset(&fbfonts[i],0,sizeof(fbfont));
      fbfonts[i].magic=FONT_MAGIC;
      index=i;
      break;
    }
    else if (!fbfonts[i].filedata){
      index=i;
      break;
    }
  }
  return index;
}

DLL_EXPORT int FontCopy(unsigned char* filedata){
  if (!filedata)
    return FONT_NOT_LOADED;
  stbtt_fontinfo fontinfo;
  if (stbtt_InitFont(&fontinfo, filedata, 0)<1) {
    return FONT_NOT_SUPPORTED;
  }
  int index=FontAlloc();
  if (index<0) {
    return NO_FREE_FONTID;
  }
  fbfonts[index].allocated=0;
  fbfonts[index].filedata=filedata;
  fbfonts[index].fontinfo=fontinfo;
  return index;
}

//! ########
//! # Font #
//! ########
DLL_EXPORT int FontLoad(const char * filename){
  size_t filesize;
  unsigned char* filedata;
  FILE* hFile = fopen(filename, "rb");
  if (!hFile)
    return FONT_NOT_LOADED;

  fseek(hFile, 0, SEEK_END);
  filesize = ftell(hFile);
  fseek(hFile, 0, SEEK_SET);
  if (filesize<1024){
    fclose(hFile);
    return FONT_NOT_SUPPORTED;
  }
  filedata = malloc(filesize);
  fread(filedata, filesize, 1, hFile);
  fclose(hFile);
  stbtt_fontinfo fontinfo;
  if (stbtt_InitFont(&fontinfo, filedata, 0)<1) {
    free(filedata);
    return FONT_NOT_SUPPORTED;
  }
  int index=FontAlloc();
  if (index<0) {
    free(filedata);
    return NO_FREE_FONTID;
  }
  fbfonts[index].allocated=1;
  fbfonts[index].filedata=filedata;
  fbfonts[index].fontinfo=fontinfo;
  return index;
}


int IsFontIndex(int index){
  if (index<0 || index>=MAX_FONTS)
    return 0;
  if (fbfonts[index].magic!=FONT_MAGIC)
    return 0;
  if (fbfonts[index].filedata==NULL)
    return 0;
  return 1;
}

DLL_EXPORT void FontFree(int* index){
  if (index==NULL)
    return;
  if (IsFontIndex(*index)) {
    if (fbfonts[*index].allocated) {
      free(fbfonts[*index].filedata);
      fbfonts[*index].allocated=0;
    }
    fbfonts[*index].filedata=NULL;
  }
  *index=WRONG_FONTID;
}

DLL_EXPORT int FontBoundingBox(int index,int *x0, int *y0, int *x1, int *y1){
 if (!IsFontIndex(index))
    return WRONG_FONTID;
  if (x0==NULL)
    return WRONG_VALUE;
  if (y0==NULL)
    return WRONG_VALUE;
  if (x1==NULL)
    return WRONG_VALUE;
  if (x1==NULL)
    return WRONG_VALUE; 
  stbtt_GetFontBoundingBox(&fbfonts[index].fontinfo, x0,y0,x1,y1);
  return 0;
}

DLL_EXPORT int FontPorperties(int index,int height,FontProps* fprops) {
  if (!IsFontIndex(index))
    return WRONG_FONTID;
  if (fprops==NULL)
    return WRONG_VALUE;
  if (height<1)
    return WRONG_VALUE;
  fprops->scale = stbtt_ScaleForPixelHeight(&fbfonts[index].fontinfo, height);
  stbtt_GetFontVMetrics(&fbfonts[index].fontinfo, &fprops->ascent, &fprops->descent, &fprops->linegap);
  fprops->ascent *= fprops->scale;
  fprops->descent*= fprops->scale;
  fprops->linegap*= fprops->scale;
  fprops->advanceHeight = fprops->ascent - fprops->descent + fprops->linegap;
  return 0;
}

//! #########
//! # Glyph #
//! #########
DLL_EXPORT int GlyphIndex(int index,int codepoint) {
  if (!IsFontIndex(index))
    return WRONG_FONTID;
  if (codepoint<0)
    return WRONG_VALUE;
  int gindex = stbtt_FindGlyphIndex(&fbfonts[index].fontinfo,codepoint);
  if (gindex==0)
    return GLYPH_NOT_FOUND;
  return gindex;
}
DLL_EXPORT char GlyphHasShape(int index, int glyphindex) {
  if (!IsFontIndex(index))
    return 0;
  int result = stbtt_IsGlyphEmpty(&fbfonts[index].fontinfo, glyphindex);
  if (result)
    return 0;
  return 1;
}
DLL_EXPORT int GlyphBoundingBox(int index,int gindex,int *x0, int *y0, int *x1, int *y1){
  if (!IsFontIndex(index))
    return WRONG_FONTID;
  if (gindex<1)
    return WRONG_VALUE;
  if (x0==NULL)
    return WRONG_VALUE;
  if (y0==NULL)
    return WRONG_VALUE;
  if (x1==NULL)
    return WRONG_VALUE;
  if (x1==NULL)
    return WRONG_VALUE; 
  stbtt_GetGlyphBox(&fbfonts[index].fontinfo, gindex, x0,y0,x1,y1);
  return 0;
}

DLL_EXPORT int GlyphProperties(int index,FontProps* fprops,GlyphProps* gprops,int glyphindex1,int glyphindex2){
  if (!IsFontIndex(index))
    return WRONG_FONTID;
  if (glyphindex1<=0)
    return WRONG_VALUE;
  if (glyphindex2<0)
    return WRONG_VALUE;
  if (fprops==NULL)
    return WRONG_VALUE;
  if (gprops==NULL)
    return WRONG_VALUE;
  if (fprops->scale==0.0f)
    return WRONG_VALUE;
  int x0,y0,x1,y1;
  stbtt_GetGlyphHMetrics(&fbfonts[index].fontinfo,glyphindex1,&gprops->advanceWidth,&gprops->leftSideBearing);
  gprops->kernAdvance = stbtt_GetGlyphKernAdvance(&fbfonts[index].fontinfo,glyphindex1,glyphindex2);
  stbtt_GetGlyphBitmapBoxSubpixel(&fbfonts[index].fontinfo, glyphindex1, fprops->scale, fprops->scale,
                                  0.0f,0.0f, &x0, &y0, &x1, &y1);
  gprops->w = x1 - x0;
  gprops->h = y1 - y0;
  gprops->y = y0 + fprops->ascent;
  gprops->advanceWidth    *= fprops->scale;
  gprops->leftSideBearing *= fprops->scale;
  gprops->kernAdvance     *= fprops->scale;
  return 0;
}

FBGFXImage* AllocImage(int w,int h, int b){
  FBGFXImage * img=NULL;
  int pitch  = w*b + 15;
  pitch &= ~0xF;
  int p_size = (sizeof(void *) + 0xF) & 0xF;
  void *tmp = malloc(32 + h*pitch + p_size + 0xF);
  img = (FBGFXImage*)(((intptr_t)tmp + p_size + 0xF) & ~0xF);
  ((void **)img)[-1] = tmp;

  img->image_hdr = 7;
  img->image_bpp = b;
  img->image_w   = w;
  img->image_h   = h;
  img->image_p   = pitch;
  return img;
}
void FreeImage(FBGFXImage* img) {
  if (img==NULL)
    return;
  void *tmp=((void **)img)[-1];
  if (tmp!=NULL)
    free(tmp);
}

DLL_EXPORT FBGFXImage * GlyphImageCreate(int index,FontProps* fprops,GlyphProps* gprops,int glyphindex){
  if (!IsFontIndex(index))
    return NULL;
  if (glyphindex<=0)
    return NULL;
  if (fprops==NULL)
    return NULL;
  if (gprops==NULL)
    return NULL;
  if (fprops->scale==0.0f)
    return NULL;
  if (gprops->w<1)
    return NULL;
  if (gprops->h<1)
    return NULL;
  FBGFXImage * img = AllocImage(gprops->w,gprops->h,1);
  if (img!=NULL) {
    unsigned char *output = (unsigned char *)img;
    output+=32;
    stbtt_MakeGlyphBitmapSubpixel(&fbfonts[index].fontinfo, output, 
                                  gprops->w, gprops->h, img->image_p,
                                  fprops->scale, fprops->scale, 0.0f,0.0f,
                                  glyphindex);
  }
  return img;
}
DLL_EXPORT void GlyphImageDestroy(FBGFXImage** img) {
  if (img==NULL)
    return;
  FBGFXImage* tmp = *img;
  if (tmp==NULL)
    return;
  FreeImage(tmp);
  *img=NULL;
}

#ifdef __cplusplus
}
#endif
