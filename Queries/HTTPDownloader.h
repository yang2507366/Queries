//
//  HTTPDownloader.h
//  VOA
//
//  Created by yangzexin on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPDownload.h"
#import "ProviderPool.h"

@class HTTPDownloader;

@protocol HTTPDownloaderDelegate <NSObject>

@optional
- (void)HTTPDownloaderDidStarted:(HTTPDownloader *)downloader;
- (void)HTTPDownloaderDidFinished:(HTTPDownloader *)downloader;
- (void)HTTPDownloader:(HTTPDownloader *)downloader didErrored:(NSError *)error;
- (void)HTTPDownloaderDownloading:(HTTPDownloader *)downloader downloaded:(long long)downloaded total:(long long)total;

@end

@interface HTTPDownloader : NSObject <HTTPDownload, ProviderPoolable> {
    id<HTTPDownloaderDelegate> _delegate;
    
    NSString *_URLString;
    NSString *_filePathForSave;
    
    NSURLRequest *_request;
    NSFileHandle *_fileHandle;
    NSURLConnection *_urlConnection;
    
    long long _contentDownloaded;
    long long _contentLength;
    
    BOOL _downloading;
}

- (id)init;
- (id)initWithURLString:(NSString *)URLString saveToPath:(NSString *)path;

@property(nonatomic, assign)id<HTTPDownloaderDelegate> delegate;
@property(nonatomic, copy)NSString *URLString;
@property(nonatomic, assign)BOOL downloading;

- (void)startDownload;
- (void)cancel;
- (NSString *)pathForSave;

@end
