/*
 * Socket.cpp
 *
 *  Created on: 2013-9-23
 *      Author: hongbinliu
 */

#include "AOSocket.h"

AOSocket::AOSocket() {
	// TODO Auto-generated constructor stub

}

AOSocket::AOSocket(const char *host,int port)
{
	this->port=port;
	strcpy(host_name,host);
}

void AOSocket::setHost(const char *host)
{
    strcpy(host_name,host);
}
void AOSocket::setPort(int port)
{
    this->port=port;
}

long AOSocket::sendData(char* data)
{
	cout<<"sendData:"<<endl;
	long temp=send(sd,data,sizeof(char)*strlen(data),0);
	cout<<"-->"<<data<<endl;
	return temp;
}
long AOSocket::revData(char* data,int size)
{
//	cout<<"\r\nrevData:"<<endl;
	long temp=recv(sd,data,size,0);
//	cout<<"-->"<<data<<endl;
	return temp;
}

void AOSocket::closeSocket()
{
	close(sd);
}

void AOSocket::connSocket()
{

    printf("host=%s,port=%d\n",host_name,port);
	//解析域名，如果是IP则不用解析，如果出错，显示错误信息
	while ((nlp_host=gethostbyname(host_name))==0){
	    printf("Resolve Error!\n");
	}


	//设置pin变量，包括协议、地址、端口等，此段可直接复制到自己的程序中
	bzero(&pin,sizeof(pin));
	pin.sin_family=AF_INET;                 //AF_INET表示使用IPv4
	pin.sin_addr.s_addr=htonl(INADDR_ANY);
	pin.sin_addr.s_addr=((struct in_addr *)(nlp_host->h_addr))->s_addr;
	pin.sin_port=htons(port);

	//建立socket
	sd=socket(AF_INET,SOCK_STREAM,0);

	//建立连接
	while (connect(sd,(struct sockaddr*)&pin,sizeof(pin))==-1){
	  printf("Connect Error!\n");
	}
	cout<<"connect success!"<<endl;
}
AOSocket::~AOSocket() {
	// TODO Auto-generated destructor stub
}

