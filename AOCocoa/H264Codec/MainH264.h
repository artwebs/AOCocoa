//
//  MainH264.h
//  H264Player
//
//  Created by hongbin liu on 10/28/13.
//  Copyright (c) 2013 artwebs. All rights reserved.
//

#ifndef H264Player_MainH264_h
#define H264Player_MainH264_h
#ifdef __cplusplus
extern "C"
{
#endif
    
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "common.h"
#include "avcodec.h"
typedef struct AVPicture
{
    unsigned char *data;
    int width;
    int height;
    int len;
}AVPicture;



void setSize(int width,int height);
int InitDecoder();
int DecoderNal(unsigned char* indata, int nalLen, AVPicture *outpic);
int UninitDecoder();
    
#ifdef __cplusplus
}
#endif
#endif
