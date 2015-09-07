//============================================================================
// Name        : RtspClient.cpp
// Author      :
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include "RtspClient.h"
#include "Base64.h"
#define  RTP_HEADLEN 12


//Socket sok("192.168.1.12",554);
//RTPUnpackage rtp;

RtspClient * RtspClient::createRtspClient()
{
    RtspClient *client=new RtspClient();
    return client;
}

RtspClient::RtspClient()
{
    isStop=true;
    isRead=false;
}

RtspClient::RtspClient(const char * url,const char *path)
{
    
    printf("url=%s\n",url);
    requrl=(char *)malloc(sizeof(char)*500);
    strcpy(requrl,url);
    filename=(char *)malloc(sizeof(char)*100);
    strcpy(filename,path);
   
}

void RtspClient::setReqUrl(const char *url)
{
    printf("url=%s\n",url);
    requrl=(char *)malloc(sizeof(char)*500);
    strcpy(requrl,url);
}

void RtspClient::setPath(const char *path)
{
    printf("path=%s\n",path);
    filename=(char *)malloc(sizeof(char)*100);
    strcpy(filename,path);
}

RtspClient::~RtspClient()
{
    free(requrl);
    free(filename);
    free(response);
}

void RtspClient::setLinstener(RtspClientLinstener *newLenstener)
{
    this->linstener=newLenstener;
    rtp.setLinstener(linstener);
}

void RtspClient::start()
{
    if (!isStop) {
        stop();
    }
    
    vector<string> vec;
    std::string str(requrl);
    const char *reg="rtsp://([0-9\\.]+):([0-9]+)/";
    vec=searchReg(str , reg);
    if (vec.size()==3) {
        sok.setHost(vec[1].c_str());
        sok.setPort(atoi(vec[2].c_str()));
    }
    else
    {
        const char *reg1="rtsp://([0-9\\.]+)/";
        vec=searchReg(str , reg1);
        if (vec.size()==2) {
            sok.setHost(vec[1].c_str());
            sok.setPort(554);
        }
    }
    rtp.OpenBitstreamFile((char *)filename);
    StartInternalThread();
//    InternalThreadEntry();
}

void RtspClient::stop()
{
    sok.closeSocket();
    isStop=true;
}

void RtspClient::_OPTIONS(char* options ,char* http ,int CSeq )
{
    char temp[99];
    std::string str=http;
    unsigned char pos = str.rfind("/");
    std::string str3 = str.substr (0,pos);
    std::cout << str3 << '\n';
    sprintf( options , "OPTIONS %s RTSP/1.0 \r\n" ,str3.c_str());
	sprintf( temp , "CSeq: %d\r\n\r\n" , CSeq );
	strcat( options , temp );

}

void RtspClient::_DESCRIBE(char *describe,char *http,int CSeq)
{
    char temp[99];
    sprintf( describe , "DESCRIBE %s RTSP/1.0\r\n" , http );
    sprintf( temp , "Accept: application/sdp\r\n");
    strcat( describe , temp );
    sprintf( temp , "CSeq: %d\r\n\r\n" , CSeq );
    strcat( describe , temp );

}

void RtspClient::_SETUP( char* setup , char* http , int CSeq ,char Cport[4][5] , int num)
{
    char temp[399];
//    if(strstr( control[con_num-1] , "://" ) )
//        sprintf( setup , "SETUP %s RTSP/1.0 \r\n" , control[con_num-1]);
//    else
        sprintf( setup , "SETUP %s/%s RTSP/1.0\r\n" , http , control[used_con_num++]);
    sprintf( temp , "CSeq: %d\r\n" , CSeq );
    strcat( setup , temp );
    sprintf( temp , "Transport: RTP/AVP/TCP;unicast;interleaved=%d-%d\r\n\r\n",interleaved , interleaved+1 );
    interleaved+=2;
    strcat( setup, temp );
}

void RtspClient::_PLAY( char* play , char* http , int CSeq )
{
    char temp[99];
    sprintf( play , "PLAY %s RTSP/1.0\r\n" , http );
//    sprintf( play , "PLAY %s/%s RTSP/1.0 \r\n" , http , control[con_num-1]);
    sprintf( temp , "CSeq: %d\r\nSession: %s\r\n",CSeq , Session );
    strcat( play , temp );
//    sprintf( temp , "Range: npt=%d-%d\r\n",interleaved , interleaved+1 );
//    interleaved+=2;
    strcpy( temp , "Range: npt=0-\r\n" );
    strcat( play , temp );
    strcpy( temp , "User-Agent: VLC media player(LIVE555 Streaming Media v2007.02.20) \r\n\r\n" );
    strcat( play , temp );
}


void  RtspClient::_P_SETUP()
{
    char seps[10];
    strcpy( seps , " \t\n:" );

    char* temp;
	for (temp = strtok(response, "\r\n"); temp; temp = strtok(NULL, "\r\n"))
	{
		std::string str=temp;
		size_t pos = str.find("Session: ");
		if(pos!=str.npos)
		{
			std::string str2=str.substr (pos+strlen("Session:")+1,strlen(temp));
			pos = str2.find(";");
			if(pos!=str2.npos)
			{
				str2=str2.substr (0,pos);
				strcpy( Session , str2.c_str());
				cout <<"Session="<<Session<<endl;
			}
			break;
		}
	}
}

void RtspClient::_P_DESCRIBE()
{
	char seps[10];
	strcpy( seps , " \n\t\0" );

	char*temp;
	for (temp = strtok(response, "\r\n"); temp; temp = strtok(NULL, "\r\n"))
	{
		std::string str=temp;
		size_t pos = str.find("Content-Length:");
		if(pos!=str.npos)
		{
			std::string str2=str.substr (pos+strlen("Content-Length:")+1,strlen(temp));
			strcpy( inter , str2.c_str());
			sdplength = atoi(inter);
            sdp =(char*)malloc( sizeof(char) * (sdplength+1) );

			strcpy( sdp , inter);
			memset( inter ,'\0' ,2000 );
			cout <<"sdp="<<sdp<<endl;
			continue;
		}
		pos = str.find("Content-Type:");
		if(pos!=str.npos)
		{
			std::string str2=str.substr (pos+strlen("Content-Type:")+1,strlen(temp));
			strcpy( CType , str2.c_str());
			cout <<"CType="<<CType<<endl;
			continue;
		}
		pos = str.find("control:");
		if(pos!=str.npos)
		{
			std::string str2=str.substr (pos+strlen("control:"),strlen(temp));
			if(str2.length()<3)continue;
			strcpy( control[con_num++] , str2.c_str());
			cout <<"control-1="<<control[con_num-1]<<endl;
			continue;
		}
//		pos = str.find("sprop-parameter-sets=");
//		if(pos!=str.npos)
//		{
//
//			std::string str2=str.substr (pos+strlen("sprop-parameter-sets="),strlen(temp));
//			cout <<"sprop-parameter-sets="<<str2<<endl;
//			vector<string> vec;
//			vec=split(str2,",");
//			Base64 *obj;
//			rtp.writeIntFile(0x00);
//			rtp.writeIntFile(0x00);
//			rtp.writeIntFile(0x00);
//			rtp.writeIntFile(0x01);
//			rtp.writeIntFile(0x60);
//			rtp.writeIntFile(0x00);
//			for(int i=0;i<vec.size();i++)
//			{
//				rtp.writeIntFile(0x00);
//				rtp.writeIntFile(0x00);
//				rtp.writeIntFile(0x00);
//				rtp.writeIntFile(0x01);
//				int outLen=0;
//				string d=obj->Decode(vec[i].c_str(),vec[i].length(),outLen);
//				rtp.writeFile(d.c_str(),outLen,1);
//			}
//
//			continue;
//		}

	}

}


void RtspClient::_RTSP()
{
	char http[100] ,Cport[4][5],temp[1024]={0},revBuf[1024],*sendbuf;
	static int CSeq=1 , num=0;
	strcpy( http , requrl);

	switch(state)
	{
	case OPTIONS:
		cout<<"--------------_OPTIONS---------------"<<endl;
		_OPTIONS(temp,http,CSeq++);
		sok.sendData(temp);
		_P_RTSP();
		break;
	case DESCRIBE:
		cout<<"--------------_DESCRIBE---------------"<<endl;
		_DESCRIBE( temp , http , CSeq++ );
		sendbuf =(char *)malloc(sizeof(char)*strlen(temp));
		strcpy( sendbuf , temp );
		sok.sendData(sendbuf);
		_P_RTSP();
		break;
	case SETUP:
		cout<<"--------------_SETUP---------------"<<endl;
		_SETUP( temp , http , CSeq++ , Cport , num++);
		sendbuf =(char *)malloc(sizeof(char)*(strlen(temp)+1));
		strcpy( sendbuf , temp );
		sok.sendData(sendbuf);
		_P_RTSP();
		break;
	case PLAY:
		cout<<"--------------_PLAY---------------"<<endl;
		memset(revBuf,0,1024);
		_PLAY(temp , http , CSeq++ );
		sendbuf =(char *)malloc(sizeof(char)*(strlen(temp)+1));
		strcpy( sendbuf , temp );
		sok.sendData(sendbuf);
		_P_RTSP();
		break;
	default:
		cout<<"--------------default---------------"<<endl;
		break;

	}
}

void RtspClient::readRtpData()
{
    if (isRead||isStop)return;
    long receive_bytes = 0;
//    char *revBufTemp=(char *)malloc(sizeof(char)*2048);
    memset(response,0,2048);
    if((receive_bytes = sok.revData(response,2048))>0)
    {
        isRead=true;
        rtp.sub_package(response,receive_bytes);
        isRead=false;
    }
//    free(revBufTemp);
}

void RtspClient::_P_RTSP()
{
    long receive_bytes = 0;

	switch(state)
	{
	case OPTIONS:
		sok.revData(response,2048);
		state=DESCRIBE;
		_RTSP();
		break;
	case DESCRIBE:
		memset(response,0,2048);
		sok.revData(response,2048);
		_P_DESCRIBE();
		state = SETUP;
		_RTSP();
		break;
	case SETUP:
		memset(response,0,2048);
		sok.revData(response,2048);
		_P_SETUP();
        if (used_con_num>=con_num) {
            state = PLAY;
        }else
        {
            state = SETUP;
        }
		_RTSP();
		break;
	case PLAY:
		memset(response,0,2048);
		if(filename)receive_bytes=rtp.OpenBitstreamFile(filename);
//		if(receive_bytes==0)return;
        isStop=false;
        while (!isStop)
		{
//			if(num<5)
//			{
//				num++;
//				continue;
//			}
            receive_bytes = sok.revData(response,2048);
			if(receive_bytes>0)rtp.sub_package(response,receive_bytes);
            isStop=false;
            sleep(1/5);
		}
//		rtp.CloseBitstreamFile();
//        StartInternalThread();
		break;
	default:
		cout<<"--------------default---------------"<<endl;
		break;

	}
}



//int main() {
////	cout << "!!!Hello World!!!" << endl; // prints !!!Hello World!!!
//	printf("size of int: %d\r\n", (int)sizeof(int));
//	rtp.OpenBitstreamFile(filename);
//    sok.connSocket();
//    state=OPTIONS;
//    _RTSP();
//
//	return 0;
//}

void RtspClient::InternalThreadEntry()
{
    sok.connSocket();
    state=OPTIONS;
    _RTSP();
}

vector<string> RtspClient::split(string& str,const char* c)
{
    char *cstr, *p;
    vector<string> res;
    cstr = new char[str.size()+1];
    strcpy(cstr,str.c_str());
    p = strtok(cstr,c);
    while(p!=NULL)
    {
        res.push_back(p);
        p = strtok(NULL,c);
    }
    return res;
}


vector<string> RtspClient::searchReg(string& str,const char* reg)
{
    vector<string> res;
    char* pstr = new char[str.size()+1];
    strcpy(pstr,str.c_str());
	regex_t *preg = (regex_t*)malloc(sizeof(regex_t));
	regmatch_t *pmatch;
	regcomp(preg, reg,REG_EXTENDED|REG_NEWLINE);
	pmatch = (regmatch_t*)malloc(sizeof(regmatch_t)*(1+preg->re_nsub));
	printf("There can be %d captures\n",(int)preg->re_nsub);
	if(!regexec(preg, pstr, 1+preg->re_nsub, pmatch, 0)) {
		for(int i=0;i<1+preg->re_nsub;i++)
		{
            char *submatch;
            size_t matchlen = (size_t)(pmatch[i].rm_eo - pmatch[i].rm_so);
            submatch = (char*)malloc(matchlen+1);
            strncpy(submatch, pstr+pmatch[i].rm_so, matchlen+1);
            submatch[matchlen]='\0';
            res.push_back(submatch);
            free(submatch);
            
		}
	};
	free(preg);
    free(pmatch);
    return res;
}



