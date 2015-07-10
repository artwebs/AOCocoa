//
//  IServiceHttpSync.m
//  LuckyNumber
//
//  Created by artwebs on 14-6-17.
//  Copyright (c) 2014年 artwebs. All rights reserved.
//

#import "IServiceHttpSync.h"
#import "Utils.h"
static NSString *tag=@"IServiceHttpSync";
@implementation IServiceHttpSync
-(id)initWithUrl:(NSString *)_url
{
    if (self=[super init]) {
        urlStr=_url;
    }
    return self;
}

-(NSString *)sendMessage:(NSString *)params
{
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:urlStr];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    NSError *error;
    NSString *rs;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        rs=[Utils JSONObjectToString:@{@"code":@"0",@"count":@"0",@"message":[NSString stringWithFormat:@"%@",error.localizedDescription],@"result":[NSString stringWithFormat:@"%d",(int)error.code]}];
    }
    else
    {
        rs = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    }
    
    return rs;
}

-(NSString *)sendParems: (NSMutableDictionary *)postParems imageDict:(NSMutableDictionary *) dicImages
{
    NSString * res;
    
    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    //NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image;//=[params objectForKey:@"pic"];
    //得到图片的data
    //NSData* data = UIImagePNGRepresentation(image);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++) {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        //if(![key isEqualToString:@"pic"]) {
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //[body appendString:@"Content-Transfer-Encoding: 8bit"];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        //}
    }
    ////添加分界线，换行
    //[body appendFormat:@"%@\r\n",MPboundary];
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //循环加入上传图片
    if (dicImages) {
        keys = [dicImages allKeys];
        for(int i = 0; i< [keys count] ; i++){
            //要上传的图片
            image = [dicImages objectForKey:[keys objectAtIndex:i ]];
            //得到图片的data
            NSData* data =  UIImageJPEGRepresentation(image, 0.0);
            NSMutableString *imgbody = [[NSMutableString alloc] init];
            //此处循环添加图片文件
            //添加图片信息字段
            //声明pic字段，文件名为boris.png
            //[body appendFormat:[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"File\"; filename=\"%@\"\r\n", [keys objectAtIndex:i]]];
            
            ////添加分界线，换行
            [imgbody appendFormat:@"%@\r\n",MPboundary];
            [imgbody appendFormat:@"Content-Disposition: form-data; name=\"File%d\"; filename=\"%@.jpg\"\r\n", i, [keys objectAtIndex:i]];
            //声明上传文件的格式
            [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
            
            NSLog(@"上传的图片：%d  %@", i, [keys objectAtIndex:i]);
            
            //将body字符串转化为UTF8格式的二进制
            //[myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
            [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
            //将image的data加入
            [myRequestData appendData:data];
            [myRequestData appendData:[ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //[request setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
    //[request setValue:@"UTF-8" forHTTPHeaderField:@"Charsert"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    //NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //设置接受response的data
    NSHTTPURLResponse *urlResponese = nil;
    NSData *mResponseData;
    NSError *err = nil;
    mResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&err];
    
    if(mResponseData == nil){
        NSLog(@"err code : %@", [err localizedDescription]);
    }
    res = [[NSString alloc] initWithData:mResponseData encoding:NSUTF8StringEncoding];
    
    if([urlResponese statusCode] >=200&&[urlResponese statusCode]<300){
        NSLog(@"返回结果=====%@",res);
        return res;
    }
    /*
     if (conn) {
     mResponseData = [NSMutableData data];
     mResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
     
     if(mResponseData == nil){
     NSLog(@"err code : %@", [err localizedDescription]);
     }
     res = [[NSString alloc] initWithData:mResponseData encoding:NSUTF8StringEncoding];
     }else{
     res = [[NSString alloc] init];
     }*/
    NSLog(@"服务器返回：%@", res);
    return nil;

}



@end
