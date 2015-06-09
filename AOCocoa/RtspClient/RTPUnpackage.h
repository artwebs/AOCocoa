/*
 * RTPUnpackage.h
 *
 *  Created on: 2013-10-11
 *      Author: hongbinliu
 */

#ifndef RTPUNPACKAGE_H_
#define RTPUNPACKAGE_H_
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <fcntl.h>
#include "RtspClientLinstener.h"

typedef struct StreamHead
{
	unsigned char magic:8;
	unsigned char channel:8;
	unsigned short length:16;
}StreamHead;

typedef struct RTPpacket_t
{
	unsigned char version;              //!< Version, 2 bits, MUST be 0x2
	unsigned char padding;              //!< Padding bit, Padding MUST NOT be used
	unsigned char extension;            //!< Extension, MUST be zero
	unsigned char cc;                   //!< CSRC count, normally 0 in the absence of RTP mixers
	unsigned char marker;               //!< Marker bit
	unsigned char pt;                   //!< 7 bits, Payload Type, dynamically established
	unsigned short seq_no:16;                //!< RTP sequence number, incremented by one for each sent packet
	unsigned int timestamp:32;        //!< timestamp, 27 MHz for H.264
	unsigned int ssrc:32;             //!< Synchronization Source, chosen randomly
	unsigned char * payload;      //!< the payload including payload headers
	unsigned short paylen:16;           //!< length of payload in bytes
}RTPpacket_t;

typedef struct RTP_FIXED_HEADER
{
	/*  0                   1                   2                   3
	0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	|V=2|P|X|  CC   |M|     PT      |       sequence number         |
	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	|                           timestamp                           |
	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	|           synchronization source (SSRC) identifier            |
	+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
	|            contributing source (CSRC) identifiers             |
	|                             ....                              |
	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	*/
	//intel 的cpu 是intel为小端字节序（低端存到底地址） 而网络流为大端字节序（高端存到低地址）
	/*intel 的cpu ： 高端->csrc_len:4 -> extension:1-> padding:1 -> version:2 ->低端
	 在内存中存储 ：
	 低->4001（内存地址）version:2
		 4002（内存地址）padding:1
		 4003（内存地址）extension:1
	 高->4004（内存地址）csrc_len:4

	 网络传输解析 ： 高端->version:2->padding:1->extension:1->csrc_len:4->低端  (为正确的文档描述格式)

	 存入接收内存 ：
	 低->4001（内存地址）version:2
		 4002（内存地址）padding:1
		 4003（内存地址）extension:1
	 高->4004（内存地址）csrc_len:4
	 本地内存解析 ：高端->csrc_len:4 -> extension:1-> padding:1 -> version:2 ->低端 ，
	 即：
	 unsigned char csrc_len:4;        // expect 0
	 unsigned char extension:1;       // expect 1
	 unsigned char padding:1;         // expect 0
	 unsigned char version:2;         // expect 2
	*/
	/* byte 0 */
	 unsigned char csrc_len:4;        /* expect 0 */
	 unsigned char extension:1;       /* expect 1, see RTP_OP below */
	 unsigned char padding:1;         /* expect 0 */
	 unsigned char version:2;         /* expect 2 */
	/* byte 1 */
	 unsigned char payloadtype:7;     /* RTP_PAYLOAD_RTSP */
	 unsigned char marker:1;          /* expect 1 */
	/* bytes 2,3 */
	 unsigned short seq_no:16;
	/* bytes 4-7 */
	 unsigned int timestamp:32;
	/* bytes 8-11 */
	 unsigned int ssrc:32;              /* stream number is used here. */
}RTP_FIXED_HEADER;


typedef struct NALU_t
{
	unsigned char forbidden_bit;           //! Should always be FALSE
	unsigned char nal_reference_idc;       //! NALU_PRIORITY_xxxx
	unsigned char nal_unit_type;           //! NALU_TYPE_xxxx
	unsigned int startcodeprefix_len:16;      //! 前缀字节数
	unsigned short len:16;                      //! 包含nal 头的nal 长度，从第一个00000001到下一个000000001的长度
	unsigned short max_size:16;                 //! 做多一个nal 的长度
	unsigned char * buf;                   //! 包含nal 头的nal 数据
	unsigned short lost_packets:16;             //! 预留
}NALU_t;

/*
+---------------+
|0|1|2|3|4|5|6|7|
+-+-+-+-+-+-+-+-+
|F|NRI|  Type   |
+---------------+
*/
typedef struct NALU_HEADER
{
	//byte 0
	unsigned char TYPE:5;
	unsigned char NRI:2;
	unsigned char F:1;
}NALU_HEADER; // 1 BYTE

/*
+---------------+
|0|1|2|3|4|5|6|7|
+-+-+-+-+-+-+-+-+
|F|NRI|  Type   |
+---------------+
*/
typedef struct FU_INDICATOR
{
	//byte 0
	unsigned char TYPE:5;
	unsigned char NRI:2;
	unsigned char F:1;
}FU_INDICATOR; // 1 BYTE

/*
+---------------+
|0|1|2|3|4|5|6|7|
+-+-+-+-+-+-+-+-+
|S|E|R|  Type   |
+---------------+
*/
typedef struct FU_HEADER
{
	//byte 0
	unsigned char TYPE:5;
	unsigned char R:1;
	unsigned char E:1;
	unsigned char S:1;
}FU_HEADER;   // 1 BYTES


class RTPUnpackage {

public:
	RTPUnpackage();
    int OpenBitstreamFile (char *fn);
	NALU_t *AllocNALU(int buffersize);
	void FreeNALU(NALU_t *n);
	void sub_package(char *bufIn,long len);
	void rtp_unpackage(char *bufIn,int len);
	void CloseBitstreamFile();
    void setLinstener(RtspClientLinstener *lenstener);
	int writeIntFile(int in);
	int writeFile(unsigned char * bufin,int len,int start);
	virtual ~RTPUnpackage();
private:
    RTPUnpackage(const RTPUnpackage& obj);
    RtspClientLinstener *linstener=0;
	int num;
	int packageLen;
	int maxLen;
	unsigned char *buffered;
	int bufferedLen;
	bool start;
	unsigned short ReverseShort(unsigned short DataToShort);
	unsigned int ReverseInt(unsigned int DataToInt);
};
#endif /* RTPUNPACKAGE_H_ */

