
/*
 * Copyright (C) 2009 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#include "MainH264.h"
#define UpAlign4(n) (((n) + 3) & ~3)

struct AVCodec *codec=NULL;			  // Codec
struct AVCodecContext *c=NULL;		  // Codec Context
struct AVFrame *picture=NULL;		  // Frame
		
int iWidth=0;
int iHeight=0;
	
int *colortab=NULL;
int *u_b_tab=NULL;
int *u_g_tab=NULL;
int *v_g_tab=NULL;
int *v_r_tab=NULL;

//short *tmp_pic=NULL;

unsigned int *rgb_2_pix=NULL;
unsigned int *r_2_pix=NULL;
unsigned int *g_2_pix=NULL;
unsigned int *b_2_pix=NULL;
		
void DeleteYUVTab()
{
//	av_free(tmp_pic);
	
	av_free(colortab);
	av_free(rgb_2_pix);
}

void CreateYUVTab_16()
{
	int i;
	int u, v;
	
//	tmp_pic = (short*)av_malloc(iWidth*iHeight*2); // ª∫¥Ê iWidth * iHeight * 16bits

	colortab = (int *)av_malloc(4*256*sizeof(int));
	u_b_tab = &colortab[0*256];
	u_g_tab = &colortab[1*256];
	v_g_tab = &colortab[2*256];
	v_r_tab = &colortab[3*256];

	for (i=0; i<256; i++)
	{
		u = v = (i-128);

		u_b_tab[i] = (int) ( 1.772 * u);
		u_g_tab[i] = (int) ( 0.34414 * u);
		v_g_tab[i] = (int) ( 0.71414 * v); 
		v_r_tab[i] = (int) ( 1.402 * v);
	}

	rgb_2_pix = (unsigned int *)av_malloc(3*768*sizeof(unsigned int));

	r_2_pix = &rgb_2_pix[0*768];
	g_2_pix = &rgb_2_pix[1*768];
	b_2_pix = &rgb_2_pix[2*768];

	for(i=0; i<256; i++)
	{
		r_2_pix[i] = 0;
		g_2_pix[i] = 0;
		b_2_pix[i] = 0;
	}

	for(i=0; i<256; i++)
	{
		r_2_pix[i+256] = (i & 0xF8) << 8;
		g_2_pix[i+256] = (i & 0xFC) << 3;
		b_2_pix[i+256] = (i ) >> 3;
	}

	for(i=0; i<256; i++)
	{
		r_2_pix[i+512] = 0xF8 << 8;
		g_2_pix[i+512] = 0xFC << 3;
		b_2_pix[i+512] = 0x1F;
	}

	r_2_pix += 256;
	g_2_pix += 256;
	b_2_pix += 256;
}

void DisplayYUV_16(unsigned char* pdst1, unsigned char *y, unsigned char *u, unsigned char *v, int width, int height, int src_ystride, int src_uvstride, int dst_ystride)
{
	int i, j;
	int r, g, b, rgb;

	int yy, ub, ug, vg, vr;

	unsigned char* yoff;
	unsigned char* uoff;
	unsigned char* voff;
	
	unsigned char* pdst=pdst1;

	int width2 = width/2;
	int height2 = height/2;
	
	if(width2>iWidth/2)
	{
		width2=iWidth/2;

		y+=(width-iWidth)/4*2;
		u+=(width-iWidth)/4;
		v+=(width-iWidth)/4;
	}

	if(height2>iHeight)
		height2=iHeight;

	for(j=0; j<height2; j++) // “ª¥Œ2x2π≤Àƒ∏ˆœÒÀÿ
	{
		yoff = y + j * 2 * src_ystride;
		uoff = u + j * src_uvstride;
		voff = v + j * src_uvstride;

		for(i=0; i<width2; i++)
		{
			yy  = *(yoff+(i<<1));
			ub = u_b_tab[*(uoff+i)];
			ug = u_g_tab[*(uoff+i)];
			vg = v_g_tab[*(voff+i)];
			vr = v_r_tab[*(voff+i)];

			b = yy + ub;
			g = yy - ug - vg;
			r = yy + vr;

			rgb = r_2_pix[r] + g_2_pix[g] + b_2_pix[b];

			yy = *(yoff+(i<<1)+1);
			b = yy + ub;
			g = yy - ug - vg;
			r = yy + vr;

			pdst[(j*dst_ystride+i)] = (rgb)+((r_2_pix[r] + g_2_pix[g] + b_2_pix[b])<<16);

			yy = *(yoff+(i<<1)+src_ystride);
			b = yy + ub;
			g = yy - ug - vg;
			r = yy + vr;

			rgb = r_2_pix[r] + g_2_pix[g] + b_2_pix[b];

			yy = *(yoff+(i<<1)+src_ystride+1);
			b = yy + ub;
			g = yy - ug - vg;
			r = yy + vr;

			pdst [((2*j+1)*dst_ystride+i*2)>>1] = (rgb)+((r_2_pix[r] + g_2_pix[g] + b_2_pix[b])<<16);
		}
	}
}

void setSize(int width,int height)
{
    iWidth = width;
	iHeight = height;
}

int InitDecoder()
{
	CreateYUVTab_16();
	c = avcodec_alloc_context();
	avcodec_open(c);

	picture  = avcodec_alloc_frame();
	return 1;
}

int UninitDecoder()
{
	if(c)
	{
		decode_end(c);
	    free(c->priv_data);

		free(c);
		c = NULL;
	}

	if(picture)
	{
		free(picture);
		picture = NULL;
	}

	DeleteYUVTab();

	return 1;
}



void DisplayYUV_24(unsigned char* pdst1, unsigned char *yd, unsigned char *ud, unsigned char *vd, int width, int height, int src_ystride, int src_uvstride, int dst_ystride)
{
     int R,G,B;
    unsigned char y, u,v;
    unsigned char *rgb = pdst1;
    
    unsigned char  *yptr = yd;
    unsigned char  *uptr = ud;
    unsigned char  *vptr = vd;
    
    int i =0;
    for (int py=0; py < height; py++)
    {
        for (int px =0; px < width; px++, i+= 3)
        {
            
            y = yptr[py*src_ystride+px];
            u = uptr[py/2*src_uvstride+px/2];
            v = vptr[py/2*src_uvstride+px/2];
            
            R = y + 1.402* (v-128);
            G = y - 0.34414* (u-128) - 0.71414 *(v-128);
            B = y + 1.772 *(u-128);
//            printf("R=%d,G=%d,B=%d\n",R,G,B);
            //防止越界
            if (R>255)R=255;
            if (R<0)R=0;
            if (G>255)G=255;
            if (G<0)G=0;
            if (B>255)B=255;
            if (B<0)B=0;
            
            rgb[ i ] = R;
            rgb[ i + 1 ] = G;
            rgb[ i + 2] = B;
        }
    }
}

int subPackage(unsigned char* indata, int nalLen, AVPicture *outpic)
{
    return 0;
}

int DecoderNal(unsigned char* indata, int nalLen, AVPicture *outpic)
{
#if 1
//	int i;
//	int imod;
	int got_picture;
	int consumed_bytes = decode_frame(c, picture, &got_picture, indata, nalLen);
    outpic->data=(unsigned char *)malloc(c->width*c->height*3*sizeof(unsigned char));
    outpic->width=c->width;
    outpic->height=c->height;
    outpic->len=c->width*c->height*3*sizeof(char);
	if(consumed_bytes > 0)
	{
     
//		DisplayYUV_16(outdata, picture->data[0], picture->data[1], picture->data[2], c->width, c->height, picture->linesize[0], picture->linesize[1], iWidth);
        
        DisplayYUV_24( outpic->data, picture->data[0], picture->data[1], picture->data[2], c->width, c->height, picture->linesize[0], picture->linesize[1], outpic->width);
       

        
/*
		for(i=0; i<c->height; i++)
			fwrite(picture->data[0] + i * picture->linesize[0], 1, c->width, outf);

		for(i=0; i<c->height/2; i++)
			fwrite(picture->data[1] + i * picture->linesize[1], 1, c->width/2, outf);

		for(i=0; i<c->height/2; i++)
			fwrite(picture->data[2] + i * picture->linesize[2], 1, c->width/2, outf);
// */
	}
    

	return consumed_bytes;

#else

  return nalLen;

#endif
}



//
//int rgb565_to_rgb888(unsigned char  * psrc, int w, int h, unsigned char  * pdst)
//{
//    int srclinesize = UpAlign4(w * 2);
//    int dstlinesize = UpAlign4(w * 3);
//    
//    const unsigned char  * psrcline;
//    const unsigned short * psrcdot;
//    unsigned char  * pdstline;
//    unsigned char  * pdstdot;
//    
//    int i,j;
//    
//    if (!psrc || !pdst || w <= 0 || h <= 0) {
//        printf("rgb565_to_rgb888 : parameter error\n");
//        return -1;
//    }
//    
//    psrcline = (const unsigned char *)psrc;
//    pdstline = (unsigned char *)pdst;
//    for (i=0; i<h; i++) {
//        psrcdot = (const unsigned short *)psrcline;
//        pdstdot = pdstline;
//        for (j=0; j<w; j++) {
//            //565 b|g|r -> 888 r|g|b
//            *pdstdot++ = (unsigned char)(((*psrcdot) >> 0 ) << 3);
//            *pdstdot++ = (unsigned char)(((*psrcdot) >> 5 ) << 2);
//            *pdstdot++ = (unsigned char)(((*psrcdot) >> 11) << 3);
//            psrcdot++;
//        }
//        psrcline += srclinesize;
//        pdstline += dstlinesize;
//    }
//    
//    return 0;
//}
//
//
//void rgb16to24(const uint8_t *src, uint8_t *dst, int src_size)
//{
//    uint8_t *d          = dst;
//    const uint16_t *s   = (const uint16_t *)src;
//    const uint16_t *end = s + src_size / 2;
//    
//    while (s < end) {
//        register uint16_t bgr = *s++;
//        *d++ = ((bgr&0xF800)>>8) | ((bgr&0xF800)>>13);
//        *d++ = ((bgr&0x07E0)>>3) | ((bgr&0x07E0)>> 9);
//        *d++ = ((bgr&0x001F)<<3) | ((bgr&0x001F)>> 2);
//    }
//}
//
//void InitConvertTable()
//{
//    long int crv,cbu,cgu,cgv;
//    int i,ind;
//    
//    
//    crv = 104597; cbu = 132201;  /* fra matrise i global.h */
//    cgu = 25675;  cgv = 53279;
//    
//    for (i = 0; i < 256; i++) {
//        crv_tab[i] = (i-128) * crv;
//        cbu_tab[i] = (i-128) * cbu;
//        cgu_tab[i] = (i-128) * cgu;
//        cgv_tab[i] = (i-128) * cgv;
//        tab_76309[i] = 76309*(i-16);
//    }
//    
//    for (i=0; i<384; i++)
//        clp[i] =0;
//    ind=384;
//    for (i=0;i<256; i++)
//        clp[ind++]=i;
//    ind=640;
//    for (i=0;i<384;i++)
//        clp[ind++]=255;
//}
//
//void ConvertYUV2RGB(unsigned char *src0,unsigned char *src1,unsigned char *src2,unsigned char *dst_ori,
//                    int width,int height)
//{
//    int y1,y2,u,v;
//    unsigned char *py1,*py2;
//    int i,j, c1, c2, c3, c4;
//    unsigned char *d1, *d2;
//    
//    py1=src0;
//    py2=py1+width;
//    d1=dst_ori;
//    d2=d1+3*width;
//    for (j = 0; j < height; j += 2) {
//        for (i = 0; i < width; i += 2) {
//            
//            u = *src1++;
//            v = *src2++;
//            
//            c1 = crv_tab[v];
//            c2 = cgu_tab[u];
//            c3 = cgv_tab[v];
//            c4 = cbu_tab[u];
//            
//            //up-left
//            y1 = tab_76309[*py1++];
//            *d1++ = clp[384+((y1 + c1)>>16)];
//            *d1++ = clp[384+((y1 - c2 - c3)>>16)];
//            *d1++ = clp[384+((y1 + c4)>>16)];
//            
//            //down-left
//            y2 = tab_76309[*py2++];
//            *d2++ = clp[384+((y2 + c1)>>16)];
//            *d2++ = clp[384+((y2 - c2 - c3)>>16)];
//            *d2++ = clp[384+((y2 + c4)>>16)];
//            
//            //up-right
//            y1 = tab_76309[*py1++];
//            *d1++ = clp[384+((y1 + c1)>>16)];
//            *d1++ = clp[384+((y1 - c2 - c3)>>16)];
//            *d1++ = clp[384+((y1 + c4)>>16)];
//            
//            //down-right
//            y2 = tab_76309[*py2++];
//            *d2++ = clp[384+((y2 + c1)>>16)];
//            *d2++ = clp[384+((y2 - c2 - c3)>>16)];
//            *d2++ = clp[384+((y2 + c4)>>16)];
//        }
//        d1 += 3*width;
//        d2 += 3*width;
//        py1+=   width;
//        py2+=   width;
//    }
//}

