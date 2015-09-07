//
//  SubPackage.h
//  H264Player
//
//  Created by hongbin liu on 13-11-11.
//  Copyright (c) 2013年 artwebs. All rights reserved.
//

#ifndef __H264Player__SubPackage__
#define __H264Player__SubPackage__

#include "MainH264.h"
#include "SubPackageListener.h"

class SubPackage
{
public:
    SubPackage();
   
    ~SubPackage();
    int subPackage(unsigned char *buf, int len,AVPicture *outpic);
    void setSubPackageListener(SubPackageListener *listener);
private:
    SubPackage(const SubPackage& obj);
    int size=0;
    int maxLen=100*1024;
    unsigned char * cacheBuf=0;
    SubPackageListener *listener=0;
    
    int FindStartCode(unsigned char *dataBuf,int zeros_in_startcode);
};


#endif /* defined(__H264Player__SubPackage__) */
