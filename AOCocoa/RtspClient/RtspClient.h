/*
 * RtspClient.h
 *
 *  Created on: 2013-10-11
 *      Author: hongbinliu
 */

#ifndef RTSPCLIENT_H_
#define RTSPCLIENT_H_
#include <iostream>
#include "AOSocket.h"
#include "RTPUnpackage.h"
#include <vector>
#include <string.h>
#include <regex.h>
#include <pthread.h>
#include "RtspClientLinstener.h"

using namespace std;

class RtspClient{
public:
    RtspClient();
    RtspClient(const char * url,const char *path);
    static RtspClient * createRtspClient();
    ~RtspClient();
    void setReqUrl(const char * url);
    void setPath(const char * url);
    void setLinstener(RtspClientLinstener *newLenstener);
    void start();
    void stop();
    void readRTP();
    void readRtpData();
private:
    RtspClient(const RtspClient& obj);
    RtspClientLinstener *linstener=0;
    bool isStop;
    bool isRead;
    char* requrl;
    char* filename;
    AOSocket sok;
    RTPUnpackage rtp;
    
    enum rtsp_state {OPTIONS,DESCRIBE,SETUP,setpa1,setpa2,PLAY,TEARDOWN} state;
    char control[5][20] = {0} , response[2048]={0} , CType[10] , newline[3],*sdp;
    
    char inter[2000]={0};
    int con_num = 0 ,used_con_num=0,interleaved=0, sdplength=-1;
    char Session[40] = {0};
    char server_port[5][6]={0};
    int ser_prt = 0;
    int entity = 0;
    pthread_t _thread;
    static pthread_mutex_t mutex;
    
    void _P_RTSP();
    void _RTSP();
    void _OPTIONS(char* options ,char* http ,int CSeq );
    void _DESCRIBE(char *describe,char *http,int CSeq);
    void _SETUP( char* setup , char* http , int CSeq ,char Cport[4][5] , int num);
    void _PLAY( char* play , char* http , int CSeq );
    void _P_SETUP();
    void _P_DESCRIBE();
    
    void InternalThreadEntry();
    
    /** Returns true if the thread was successfully started, false if there was an error starting the thread */
    bool StartInternalThread()
    {
        printf("pthread_create====start\n");
        int rs=pthread_create(&_thread, NULL, InternalThreadEntryFunc, this);
        printf("pthread_create====endl\n");
        return rs==0;
    }
    
    /** Will not return until the internal thread has exited. */
    void WaitForInternalThreadToExit()
    {
        (void) pthread_join(_thread, NULL);
    }
    static void * InternalThreadEntryFunc(void * This) {
//        pthread_mutex_lock(&mutex);
        ((RtspClient *)This)->InternalThreadEntry();
//        pthread_mutex_unlock(&mutex);
        return NULL;
    }
    
    vector<string> split(string& str,const char* c);
    vector<string> searchReg(string& str,const char* reg);
    
};


#endif /* RTSPCLIENT_H_ */
