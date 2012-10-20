//
//  HTTPRequester.m
//  VOA
//
//  Created by yangzexin on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HTTPRequester.h"

@interface HTTPRequester ()

- (void)notifyRequestDidStarted;
- (void)notifyRequestDidCompleted;
- (void)notifyRequestDidFinishedWithResult:(id)result;
- (void)notifyRequestDiDErrored:(NSError *)error;

@end

@implementation HTTPRequester

@synthesize dataSource = dataSource_;
@synthesize delegate = delegate_;

@synthesize urlString;

+ (HTTPRequester *)newHTTPRequester
{
    return [[[HTTPRequester alloc] init] autorelease];
}

- (void)dealloc
{
    [urlString release];
    [super dealloc];
}

- (void)request
{
    if(!self.urlString){
        if([self.dataSource respondsToSelector:@selector(urlStringForHTTPRequester:)]){
            self.urlString = [self.dataSource urlStringForHTTPRequester:self];
        }
    }
    if(self.urlString){
        [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
    }
}

- (void)cancel
{
    self.delegate = nil;
    self.dataSource = nil;
}

- (void)run
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self performSelectorOnMainThread:@selector(notifyRequestDidStarted) withObject:self waitUntilDone:YES];
    
    BOOL usePost = NO;
    if([self.dataSource respondsToSelector:@selector(postDataForHTTPRequester:)]){
        usePost = YES;
    }
    NSMutableURLRequest *req = [[[NSMutableURLRequest alloc] init] autorelease];
    [req setURL:[NSURL URLWithString:self.urlString]];
    if(!usePost){
        // GET 方式提交
        [req setHTTPMethod:@"GET"];
    }else{
        // POST 方式提交
        [req setHTTPMethod:@"POST"];
        NSData *postData = [self.dataSource postDataForHTTPRequester:self];
        [req setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setHTTPBody:postData];
    }
    
    NSStringEncoding enc = NSUTF8StringEncoding;
    if([self.dataSource respondsToSelector:@selector(stringEncodingForHTTPRequester:)]){
        enc = [self.dataSource stringEncodingForHTTPRequester:self];
    }
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *resultData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    NSString *resultString = nil;
    if([response statusCode] >= 200 && [response statusCode] <= 300){
        resultString = [[[NSString alloc] initWithData:resultData encoding:enc] autorelease];
    }
    
    [self performSelectorOnMainThread:@selector(notifyRequestDidCompleted) withObject:nil waitUntilDone:YES];
    
    if(!error){
        id result = nil;
        if([self.dataSource respondsToSelector:@selector(HTTPRequester:resultForResponseString:)]){
            result = [self.dataSource HTTPRequester:self resultForResponseString:resultString];
        }else{
            result = resultString;
        }
        [self performSelectorOnMainThread:@selector(notifyRequestDidFinishedWithResult:) withObject:result waitUntilDone:YES];
    }else{
        [self performSelectorOnMainThread:@selector(notifyRequestDiDErrored:) withObject:error waitUntilDone:YES];
    }
    [pool drain];
}

#pragma mark - Private Methods
- (void)notifyRequestDidStarted
{
    if([self.delegate respondsToSelector:@selector(HTTPRequesterRequestDidStarted:)]){
        [self.delegate HTTPRequesterRequestDidStarted:self];
    }
}
- (void)notifyRequestDidCompleted
{
    if([self.delegate respondsToSelector:@selector(HTTPRequesterRequestDidCompleted:)]){
        [self.delegate HTTPRequesterRequestDidCompleted:self];
    }
}
- (void)notifyRequestDidFinishedWithResult:(id)result
{
    if([self.delegate respondsToSelector:@selector(HTTPRequester:didFinishedWithResult:)]){
        [self.delegate HTTPRequester:self didFinishedWithResult:result];
    }
}
- (void)notifyRequestDiDErrored:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(HTTPRequester:didErrored:)]){
        [self.delegate HTTPRequester:self didErrored:error];
    }
}

@end
