/*
 * RTPUnpackage.cpp
 *
 *  Created on: 2013-10-11
 *      Author: hongbinliu
 */

#include "RTPUnpackage.h"
#define PORT    1234
#define BUFFER_SIZE 10
FILE* poutfile =  NULL;

RTPUnpackage::RTPUnpackage() {
	num=1;
	packageLen=0;
	bufferedLen=0;
	maxLen=10*1024;
	start=false;
    buffered=(unsigned char *)malloc(sizeof(char)*bufferedLen);
}

RTPUnpackage::~RTPUnpackage() {
	// TODO Auto-generated destructor stub
}

void RTPUnpackage::setLinstener(RtspClientLinstener *lenstener)
{
    this->linstener=lenstener;
}

int  RTPUnpackage::OpenBitstreamFile (char *fn)
{
    if (NULL == (poutfile = fopen(fn, "wb")))
    {
        printf("Error: Open input file error\n");
//        getchar();
        return 0;
    }
    printf("Error: Open input file ok\n");
    poutfile = fopen(fn,"ab+");
    return 1;
}
void RTPUnpackage::CloseBitstreamFile()
{
	fclose(poutfile);
}

NALU_t *RTPUnpackage::AllocNALU(int buffersize)
{
    NALU_t *n;
    
    if ((n = (NALU_t*)calloc (1, sizeof(NALU_t))) == NULL)
    {
        printf("AllocNALU Error: Allocate Meory To NALU_t Failed ");
        exit(0);
    }
    return n;
}

void RTPUnpackage::FreeNALU(NALU_t *n)
{
    if (n)
    {
        free (n);
    }
}

void RTPUnpackage::sub_package(char *bufIn,long len)
{


	if(num==1){
		num++;
		return;
	}
	printf("-------num=%d---bufferedLen=%d--len=%ld------\r\n",num++,bufferedLen,len);

	unsigned char recvHead[4];
	char unPack[maxLen];
	unsigned char temp[maxLen];
	StreamHead *streamHead;
	memcpy(buffered+bufferedLen,bufIn, len);
	bufferedLen+=len;
//	printf("%0x %0x %0x %0x \r\n",buffered[0],buffered[1],buffered[2],buffered[3]);
	while(bufferedLen>5)
	{
		memset(recvHead,0,4);
		memcpy(recvHead,buffered, 4);

		streamHead=(StreamHead*)&recvHead[0];
		short unPackLen=ReverseShort(streamHead->length);
//		printf("\r\nbufferedLen=%d-->%d\r\n",bufferedLen,unPackLen);
//		printf("%0x %0x %d %d\r\n",streamHead->magic,streamHead->channel,bufferedLen,unPackLen+4);
		if(streamHead->magic==0x24&&unPackLen>0&&unPackLen<=bufferedLen-4)
		{
			memcpy(unPack,buffered, unPackLen+4);
			rtp_unpackage(unPack,unPackLen+4);
			bufferedLen=bufferedLen-unPackLen-4;
			memcpy(temp,buffered+unPackLen+4, bufferedLen);
			memset(buffered,0,maxLen);
			memcpy(buffered,temp, bufferedLen);
			memset(temp,0,maxLen);

		}
//        else if(streamHead->magic==0x24&&streamHead->channel==0x01&&unPackLen>0&&unPackLen<=bufferedLen-4)
//        {
//            bufferedLen=bufferedLen-unPackLen-4;
//			memcpy(temp,buffered+unPackLen+4, bufferedLen);
//			memset(buffered,0,maxLen);
//			memcpy(buffered,temp, bufferedLen);
//			memset(temp,0,maxLen);
//        }
        else
		{
			break;
		}
	}

}

/*
*bufIn:rtppackage
*len: the lengthe of rtppackage
*/
void RTPUnpackage::rtp_unpackage(char *bufIn,int len)
{
	unsigned char recvHead[4];
	StreamHead *streamHead;
    unsigned char recvbuf[maxLen];
    RTPpacket_t *p = NULL;
    RTP_FIXED_HEADER * rtp_hdr = NULL;
    NALU_HEADER * nalu_hdr = NULL;
    NALU_t * n  = NULL;
    FU_INDICATOR    *fu_ind = NULL;
    FU_HEADER       *fu_hdr= NULL;

    int total_bytes = 0;                 //当前包传出的数据
//    int fwrite_number = 0;

    memcpy(recvHead,bufIn, 4);
    streamHead=(StreamHead*)&recvHead[0];
//    printf("%0x %0x %d %d\r\n",streamHead->magic,streamHead->channel,ReverseShort(streamHead->length),len-4);

    len=len-4;
    //存入文件的数据长度
    memcpy(recvbuf,bufIn+4, len);          //复制rtp包
//    printf("%0x %0x %0x %0x \r\n",recvbuf[12],recvbuf[13],recvbuf[14],recvbuf[15]);
//    printf("%0x %0x %0x %0x \r\n",recvbuf[0],recvbuf[1],recvbuf[2],recvbuf[3]);
//    printf("包长度+ rtp头：   = %d\r\n",len);
    //////////////////////////////////////////////////////////////////////////
    //begin rtp_payload and rtp_header

    p = (RTPpacket_t*)&recvbuf[0];
    if ((p =(RTPpacket_t *)malloc (sizeof (RTPpacket_t)))== NULL)
    {
        printf ("RTPpacket_t MMEMORY ERROR\n");
    }
    if ((p->payload =(unsigned char*)malloc (maxLen))== NULL)
    {
        printf ("RTPpacket_t payload MMEMORY ERROR\n");
    }

    if ((rtp_hdr =(RTP_FIXED_HEADER *) malloc(sizeof(RTP_FIXED_HEADER))) == NULL)
    {
        printf("RTP_FIXED_HEADER MEMORY ERROR\n");
    }

    rtp_hdr =(RTP_FIXED_HEADER*)&recvbuf[0];
//    printf("版本号     : %d\n",rtp_hdr->version);
    p->version  = rtp_hdr->version;
    p->padding  = rtp_hdr->padding;
    p->extension  = rtp_hdr->extension;
    p->cc = rtp_hdr->csrc_len;
//    printf("标志位     : %d\n",rtp_hdr->marker);
    p->marker = rtp_hdr->marker;
//    printf("负载类型    :%d\n",rtp_hdr->payloadtype);
    p->pt = rtp_hdr->payloadtype;
//    printf("包号      : %d\n",ReverseShort(rtp_hdr->seq_no));
    p->seq_no = ReverseShort(rtp_hdr->seq_no);
//    printf("时间戳     : %u\n",ReverseInt(rtp_hdr->timestamp));
    p->timestamp = ReverseInt(rtp_hdr->timestamp);
//    printf("帧号      : %u\n",ReverseInt(rtp_hdr->ssrc));
    p->ssrc = ReverseInt(rtp_hdr->ssrc);

    //end rtp_payload and rtp_header
    //////////////////////////////////////////////////////////////////////////
    //begin nal_hdr
    if (!(n = AllocNALU(maxLen)))          //为结构体nalu_t及其成员buf分配空间。返回值为指向nalu_t存储空间的指针
    {
        printf("NALU_t MMEMORY ERROR\n");
    }
    if ((nalu_hdr =(NALU_HEADER*)malloc(sizeof(NALU_HEADER))) == NULL)
    {
        printf("NALU_HEADER MEMORY ERROR\n");
    }

    nalu_hdr =(NALU_HEADER*)&recvbuf[12];                        //网络传输过来的字节序 ，当存入内存还是和文档描述的相反，只要匹配网络字节序和文档描述即可传输正确。
//    printf("forbidden_zero_bit: %d\n",nalu_hdr->F);              //网络传输中的方式为：F->NRI->TYPE.. 内存中存储方式为 TYPE->NRI->F (和nal头匹配)。
    n->forbidden_bit= nalu_hdr->F << 7;                          //内存中的字节序。
//    printf("nal_reference_idc:  %d\n",nalu_hdr->NRI);
    n->nal_reference_idc = nalu_hdr->NRI << 5;
//    printf("nal 负载类型:       %d\n",nalu_hdr->TYPE);
    n->nal_unit_type = nalu_hdr->TYPE;

    if(!start)
    {
    	if(nalu_hdr->TYPE==7||nalu_hdr->TYPE==8||nalu_hdr->TYPE==5)
    	{
    		start=true;
    	}
    	else
        {
//            printf("nalu_hdr->TYPE=%d\n",nalu_hdr->TYPE);
            return;
        }
    		
    }

    //end nal_hdr
    //////////////////////////////////////////////////////////////////////////
    //开始解包
    if ( nalu_hdr->TYPE  == 0)
    {
        printf("这个包有错误，0无定义\n");
    }
    else if ( nalu_hdr->TYPE >0 &&  nalu_hdr->TYPE < 24)  //单包
    {
//        printf("当前包为单包->%d\n",nalu_hdr->TYPE);
//        putc(0x00, poutfile);
//        putc(0x00, poutfile);
//        putc(0x00, poutfile);
//        putc(0x01, poutfile);   //写进起始字节0x00000001
        total_bytes +=4;
        memcpy(p->payload,&recvbuf[13],len-13);
        p->paylen = len-13;
//        fwrite(nalu_hdr,1,1,poutfile);  //写NAL_HEADER
        total_bytes += 1;
//        fwrite_number = fwrite(p->payload,1,p->paylen,poutfile);  //写NAL数据
        total_bytes = p->paylen;
//        printf("包长度 + nal= %d\n",total_bytes);
        
        unsigned char *writeTmp=(unsigned char *)malloc(sizeof(char)*(p->paylen+5));
        writeTmp[0]=0x00;
        writeTmp[1]=0x00;
        writeTmp[2]=0x00;
        writeTmp[3]=0x01;
        memcpy(writeTmp+4,nalu_hdr,1);
        memcpy(writeTmp+5,p->payload,p->paylen);
        writeFile(writeTmp,p->paylen+5,1);
        free(writeTmp);
        
    }
    else if ( nalu_hdr->TYPE == 24)                    //STAP-A   单一时间的组合包
    {
        printf("当前包为STAP-A\n");
    }
    else if ( nalu_hdr->TYPE == 25)                    //STAP-B   单一时间的组合包
    {
        printf("当前包为STAP-B\n");
    }
    else if (nalu_hdr->TYPE == 26)                     //MTAP16   多个时间的组合包
    {
        printf("当前包为MTAP16\n");
    }
    else if ( nalu_hdr->TYPE == 27)                    //MTAP24   多个时间的组合包
    {
        printf("当前包为MTAP24\n");
    }
     else if ( nalu_hdr->TYPE == 28)                    //FU-A分片包，解码顺序和传输顺序相同
    {
        if ((fu_ind =(FU_INDICATOR*)malloc(sizeof(FU_INDICATOR))) == NULL)
        {
            printf("FU_INDICATOR MEMORY ERROR\n");
        }
        if ((fu_hdr =(FU_HEADER*)malloc(sizeof(FU_HEADER))) == NULL)
        {
            printf("FU_HEADER MEMORY ERROR\n");
        }
        fu_ind=(FU_INDICATOR*)&recvbuf[12];     //分片包用的是FU_INDICATOR而不是NALU_HEADER
//        printf("FU_INDICATOR->F     :%d\n",fu_ind->F);
        n->forbidden_bit = fu_ind->F << 7;
//        printf("FU_INDICATOR->NRI   :%d\n",fu_ind->NRI);
        n->nal_reference_idc = fu_ind->NRI << 5;
//        printf("FU_INDICATOR->TYPE  :%d\n",fu_ind->TYPE);
        n->nal_unit_type = fu_ind->TYPE;

        fu_hdr=(FU_HEADER*)&recvbuf[13];        //FU_HEADER赋值
//        printf("FU_HEADER->S        :%d\n",fu_hdr->S);
//        printf("FU_HEADER->E        :%d\n",fu_hdr->E);
//        printf("FU_HEADER->R        :%d\n",fu_hdr->R);
//        printf("FU_HEADER->TYPE     :%d\n",fu_hdr->TYPE);
        n->nal_unit_type = fu_hdr->TYPE;               //应用的是FU_HEADER的TYPE

        if (rtp_hdr->marker == 1)                      //分片包最后一个包
        {
//            printf("当前包为FU-A分片包最后一个包\n");
            memcpy(p->payload,&recvbuf[14],len - 14);
            p->paylen = len - 14;
//            fwrite_number = fwrite(p->payload,1,p->paylen,poutfile);  //写NAL数据
            total_bytes = p->paylen;
//            printf("包长度 + FU = %d\n",total_bytes);
            
            
            writeFile(p->payload,p->paylen,1);
        }
        else if (rtp_hdr->marker == 0)                 //分片包 但不是最后一个包
        {
            if (fu_hdr->S == 1)                        //分片的第一个包
            {
                unsigned char F;
                unsigned char NRI;
                unsigned char TYPE;
                unsigned char nh;
//                printf("当前包为FU-A分片包第一个包\n");
//                putc(0x00, poutfile);
//                putc(0x00, poutfile);
//                putc(0x00, poutfile);
//                putc(0x01, poutfile);               //写起始字节码0x00000001
                total_bytes += 4;

                F = fu_ind->F << 7;
                NRI = fu_ind->NRI << 5;
                TYPE = fu_hdr->TYPE;                                            //应用的是FU_HEADER的TYPE
                //nh = n->forbidden_bit|n->nal_reference_idc|n->nal_unit_type;  //二进制文件也是按 大字节序存储
                nh = F | NRI | TYPE;

//                putc(nh,poutfile);              //写NAL HEADER

                total_bytes +=1;
                memcpy(p->payload,&recvbuf[14],len - 14);
                p->paylen = len - 14;
//                fwrite_number = fwrite(p->payload,1,p->paylen,poutfile);  //写NAL数据
                total_bytes = p->paylen;
//                printf("包长度 + FU_First = %d\n",total_bytes);
                
                unsigned char writeTmp[p->paylen+5];
                writeTmp[0]=0x00;
                writeTmp[1]=0x00;
                writeTmp[2]=0x00;
                writeTmp[3]=0x01;
                writeTmp[4]=nh;
                memcpy(writeTmp+5,p->payload,p->paylen);
                writeFile(writeTmp,p->paylen+5,1);
//                free(writeTmp);

            }
            else                                      //如果不是第一个包
            {
//                printf("当前包为FU-A分片包\n");
                memcpy(p->payload,&recvbuf[14],len - 14);
                p->paylen= len - 14;
//                fwrite_number = fwrite(p->payload,1,p->paylen,poutfile);  //写NAL数据
                total_bytes = p->paylen;
//                printf("包长度 + FU = %d\n",total_bytes);
                
                writeFile(p->payload,p->paylen,1);
            }
        }
    }
    else if ( nalu_hdr->TYPE == 29)                //FU-B分片包，解码顺序和传输顺序相同
    {
        if (rtp_hdr->marker == 1)                  //分片包最后一个包
        {
//            printf("当前包为FU-B分片包最后一个包\n");

        }
        else if (rtp_hdr->marker == 0)             //分片包 但不是最后一个包
        {
//            printf("当前包为FU-B分片包\n");
        }
    }
    else
    {
        printf("这个包有错误，30-31 没有定义\n");
    }
    free (p->payload);
    free (p);
    FreeNALU(n);
//    if(streamHead)free(streamHead);
//    if(rtp_hdr)free(rtp_hdr);
//    if(nalu_hdr)free(nalu_hdr);
//    if(fu_ind)free(fu_ind);
//    if(fu_hdr)free(fu_hdr);

//    memset(recvbuf,0,maxLen);
    //结束解包
    //////////////////////////////////////////////////////////////////////////
    return ;
}

int RTPUnpackage::writeIntFile(int in)
{
	putc(in, poutfile);
	return 1;
}

int RTPUnpackage::writeFile(unsigned char * bufin,int len,int start)
{
    printf(">>>>>>>>>>>>>>>>>>>RTPUnpackage writeFileSize=%d >>>>>>>>>>>>>>>>\n",len);
    int rs=0;
//    unsigned char *wbuf=(unsigned char *)malloc(sizeof(char*)*len);
//    memcpy(wbuf,bufin, len);
//    free(wbuf);
//    free(bufin);
    if (poutfile) {
        rs=fwrite(bufin,start,len,poutfile);
        fflush(poutfile);
    }
//    if (linstener) {
//        rs=linstener->sendH264Buffer(bufin, len);
//    }
//    free(wbuf);
	return rs;
}


unsigned short RTPUnpackage::ReverseShort(unsigned short b)
{
	unsigned short y=b;
    y= ((y&0x00FF)<<8)+((y&0xFF00)>>8);
	b=y;
	return b;
}
unsigned int RTPUnpackage::ReverseInt(unsigned int a)
{
	unsigned int x=a;
	x= (x>>24)+((x&0x00FF0000)>>8)+((x&0x0000FF00)<<8)+((x&0x000000FF)<<24);
	a=x;
	return a;
}
