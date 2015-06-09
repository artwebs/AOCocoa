//
//  SubPackage.cpp
//  H264Player
//
//  Created by hongbin liu on 13-11-11.
//  Copyright (c) 2013年 artwebs. All rights reserved.
//

#include "SubPackage.h"
SubPackage::SubPackage()
{
    size=0;
    maxLen=100*1024;
    cacheBuf=(unsigned char *)malloc(sizeof(unsigned char)*maxLen);
    
}

SubPackage::~SubPackage()
{
    free(cacheBuf);

}

void SubPackage::setSubPackageListener(SubPackageListener *listener)
{
    this->listener=listener;
}

int SubPackage::subPackage(unsigned char *buf, int len,AVPicture *outpic)
{
    printf("SubPackage size====%d\n",size);
    if(cacheBuf==NULL)cacheBuf=(unsigned char *)malloc(sizeof(unsigned char)*maxLen);
    memcpy(cacheBuf+size,buf, len);
    size+=len;
    int pos=0;
    int StartCodeFound=0;
    int info2=0;
    int info3=0;
    int rs=0;
    printf("SubPackage ============len=%d,size=%d========\n",len,size);
    unsigned char* frameBuf=(unsigned char *)malloc(sizeof(unsigned char)*maxLen);
    unsigned char* temp=(unsigned char *)malloc(sizeof(unsigned char)*maxLen);
    while (pos<size) {
        if (pos>8) {
            info3=this->FindStartCode(&cacheBuf[pos-4], 3);
            if(info3 != 1)
                info2=this->FindStartCode(&cacheBuf[pos-3], 2);
            StartCodeFound = (info2 == 1 || info3 == 1);
            if(StartCodeFound)
            {
                memset(temp,0,maxLen);
                memset(frameBuf,0,maxLen);
                memcpy(frameBuf,cacheBuf, pos);
                printf("SubPackage -------size=%d----------\n",size);
                printf("%0x %0x %0x %0x %0x %0x %0x %0x \n",frameBuf[0],frameBuf[1],frameBuf[2],frameBuf[3],frameBuf[4],frameBuf[5],frameBuf[6],frameBuf[7]);
                printf("%0x %0x %0x %0x %0x %0x %0x %0x \n",frameBuf[pos-8],frameBuf[pos-7],frameBuf[pos-6],frameBuf[pos-5],frameBuf[pos-4],frameBuf[pos-3],frameBuf[pos-2],frameBuf[pos-1]);
                rs= DecoderNal(frameBuf, pos ,outpic);
                
                if (rs>0) {
                    if (listener) {
                        listener->sendRGB24Picture();
                    }
                    
                }
                size=size-pos+4;
                memcpy(temp,cacheBuf+pos-4, size);
                memset(cacheBuf,0,maxLen);
                memcpy(cacheBuf,temp, size);
                
                pos = 0;
                StartCodeFound = 0;
                info2 = 0;
                info3 = 0;
                
            }
        }
        pos++;
    }
    free(frameBuf);
    free(temp);
    printf("-------size=%d----------\n",size);

    return 0;
}


int SubPackage::FindStartCode(unsigned char *dataBuf,int zeros_in_startcode)
{
    int info;
    int i;
    
    info = 1;
    for (i = 0; i < zeros_in_startcode; i++)
        if(dataBuf[i] != 0)
            info = 0;
            
            if(dataBuf[i] != 1)
                info = 0;
                return info;
}