//
//  SubPackageListener.h
//  H264Player
//
//  Created by hongbin liu on 13-11-12.
//  Copyright (c) 2013年 artwebs. All rights reserved.
//

#ifndef H264Player_SubPackageListener_h
#define H264Player_SubPackageListener_h
#include "avcodec.h"
class SubPackageListener
{
public:
    virtual int sendRGB24Picture()=0;
};
#endif
