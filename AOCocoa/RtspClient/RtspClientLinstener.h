//
//  RtspClientLinstener.h
//  H264Player
//
//  Created by hongbin liu on 13-11-11.
//  Copyright (c) 2013年 artwebs. All rights reserved.
//

#ifndef H264Player_RtspClientLinstener_h
#define H264Player_RtspClientLinstener_h

class RtspClientLinstener
{
public:
    virtual int sendH264Buffer(unsigned char * buf,long len)=0;
};

#endif
