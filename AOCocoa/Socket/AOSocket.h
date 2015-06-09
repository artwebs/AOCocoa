/*
 * Socket.h
 *
 *  Created on: 2013-9-23
 *      Author: hongbinliu
 */

#ifndef SOCKET_H_
#define SOCKET_H_

#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>

//以下头文件是为了使样例程序正常运行
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
using namespace std;

class AOSocket {
public:
	AOSocket();
	AOSocket(const char *host,int port);
    void setHost(const char *host);
    void setPort(int port);
	long sendData(char* data);
	long revData(char* data,int size);
	void connSocket();
	void closeSocket();
	virtual ~AOSocket();
private:
	struct sockaddr_in pin;
	struct hostent *nlp_host;
	int sd;
	char host_name[256];
	int port;
};

#endif /* SOCKET_H_ */
