//
//  HTTPRequester.h
//  VOA
//
//  Created by yangzexin on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTTPRequester;

@protocol HTTPRequesterDataSource <NSObject>

@optional
/** 请求所用到的地址 */
- (NSString *)urlStringForHTTPRequester:(HTTPRequester *)requester;
/** 表单提交所需数据，如果实现了该方法，请求将使用post方式提交 */
- (NSData *)postDataForHTTPRequester:(HTTPRequester *)requester;
/** 对返回的字符串进行解析 */
- (id)HTTPRequester:(HTTPRequester *)requester resultForResponseString:(NSString *)response;
/** 返回用户数据 */
- (id)userDataForHTTPRequester:(HTTPRequester *)requester;
/** 数据返回之后，解析成为字符串所用编码 */
- (NSStringEncoding)stringEncodingForHTTPRequester:(HTTPRequester *)requester;

@end

@protocol HTTPRequesterDelegate <NSObject>

@optional
/** 请求完成并且返回了数据 */
- (void)HTTPRequester:(HTTPRequester *)requester didFinishedWithResult:(id)result;
/** 请求完成但是出错 */
- (void)HTTPRequester:(HTTPRequester *)requester didErrored:(NSError *)error;
/** 请求开始 */
- (void)HTTPRequesterRequestDidStarted:(HTTPRequester *)requester;
/** 请求完成 */
- (void)HTTPRequesterRequestDidCompleted:(HTTPRequester *)requester;

@end

@interface HTTPRequester : NSObject {
    id<HTTPRequesterDataSource> dataSource_;
    id<HTTPRequesterDelegate> delegate_;
    
    NSString *urlString;
}

@property(nonatomic, assign)id<HTTPRequesterDataSource> dataSource;
@property(nonatomic, assign)id<HTTPRequesterDelegate> delegate;

@property(nonatomic, copy)NSString *urlString;

+ (HTTPRequester *)newHTTPRequester;
- (void)request;
- (void)cancel;

@end
