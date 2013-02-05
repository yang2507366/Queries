//
//  HTTPDownloader.m
//  VOA
//
//  Created by yangzexin on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HTTPDownloader.h"
#import "CommonUtils.h"

@interface HTTPDownloader ()

@property(nonatomic, copy)NSString *filePathForSave;
@property(nonatomic, retain)NSURLRequest *request;
@property(nonatomic, retain)NSFileHandle *fileHandle;
@property(nonatomic, retain)NSURLConnection *urlConnection;
@property(nonatomic, assign)long long contentDownloaded;
@property(nonatomic, assign)long long contentLength;

@property(nonatomic, copy)void(^progressBlock)(long long, long long);
@property(nonatomic, copy)void(^completionBlock)(NSString *, NSError *);

- (void)notifyDownloadDidStarted;
- (void)notifyDownloadDidFinished;
- (void)notifyDownloading;
- (void)notifyDownloadErrored:(NSError *)error;

@end

@implementation HTTPDownloader

@synthesize delegate = _delegate;
@synthesize URLString = _URLString;
@synthesize filePathForSave = _filePathForSave;
@synthesize request = _request;
@synthesize fileHandle = _fileHandle;
@synthesize urlConnection = _urlConnection;
@synthesize contentDownloaded = _contentDownloaded;
@synthesize contentLength = _contentLength;
@synthesize downloading = _downloading;

- (void)dealloc
{
    [_URLString release];
    [_filePathForSave release];
    [_request release];
    [_fileHandle release];
    [_urlConnection release];
    self.progressBlock = nil;
    self.completionBlock = nil;
    [super dealloc];
}

- (id)init
{
    NSString *tmpFilePath = [NSString stringWithFormat:@"%d", [self hash]];
    self = [self initWithURLString:nil saveToPath:[[CommonUtils tmpPath] stringByAppendingPathComponent:tmpFilePath]];
    return self;
}

- (id)initWithURLString:(NSString *)URLString saveToPath:(NSString *)path
{
    self = [super init];
    
    self.URLString = URLString;
    self.filePathForSave = path;
    
    return self;
}

#pragma mark - instance methods
- (void)startDownload
{
    if(self.URLString.length == 0){
        [self notifyDownloadErrored:[NSError errorWithDomain:NSStringFromClass(self.class)
                                                        code:-1
                                                    userInfo:[NSDictionary dictionaryWithObject:@"URL String cannot be null" forKey:NSLocalizedDescriptionKey]]];
        return;
    }
    if(self.filePathForSave.length == 0){
        [self notifyDownloadErrored:[NSError errorWithDomain:NSStringFromClass(self.class)
                                                        code:-1
                                                    userInfo:[NSDictionary dictionaryWithObject:@"tmp file path cannot be null" forKey:NSLocalizedDescriptionKey]]];
        return;
    }
    self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]];
    [[NSFileManager defaultManager] createFileAtPath:self.filePathForSave 
                                            contents:nil 
                                          attributes:nil];
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.filePathForSave];
    self.urlConnection = [[[NSURLConnection alloc] initWithRequest:self.request
                                                          delegate:self] autorelease];
    [self.urlConnection start];
}

- (void)cancel
{
    [self.urlConnection cancel];
    self.progressBlock = nil;
    self.completionBlock = nil;
    self.downloading = NO;
}

- (void)downloadWithURLString:(NSString *)URLString progress:(void (^)(long long, long long))progress completion:(void (^)(NSString *, NSError *))completion
{
    self.URLString = URLString;
    self.progressBlock = progress;
    self.completionBlock = completion;
    [self startDownload];
}

- (NSString *)pathForSave
{
    return self.filePathForSave;
}

#pragma mark - private methods
- (void)notifyDownloadDidStarted
{
    if([self.delegate respondsToSelector:@selector(HTTPDownloaderDidStarted:)]){
        [self.delegate HTTPDownloaderDidStarted:self];
    }
}
- (void)notifyDownloadDidFinished
{
    if([self.delegate respondsToSelector:@selector(HTTPDownloaderDidFinished:)]){
        [self.delegate HTTPDownloaderDidFinished:self];
    }
    if(self.completionBlock){
        self.completionBlock(self.filePathForSave, nil);
    }
}
- (void)notifyDownloading
{
    if([self.delegate respondsToSelector:@selector(HTTPDownloaderDownloading:downloaded:total:)]){
        [self.delegate HTTPDownloaderDownloading:self 
                                      downloaded:self.contentDownloaded 
                                           total:self.contentLength];
    }
    if(self.progressBlock){
        self.progressBlock(self.contentDownloaded, self.contentLength);
    }
}
- (void)notifyDownloadErrored:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(HTTPDownloader:didErrored:)]){
        [self.delegate HTTPDownloader:self didErrored:error];
    }
    
    if(self.completionBlock){
        self.completionBlock(nil, error);
    }
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.contentLength = [response expectedContentLength];
    self.contentDownloaded = 0;
    self.downloading = YES;
    [self notifyDownloadDidStarted];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.contentLength = 0;
    self.downloading = NO;
    if(self.fileHandle){
        [self.fileHandle closeFile];
    }
    self.fileHandle = nil;
    [self notifyDownloadErrored:error];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(self.fileHandle){
        [self.fileHandle writeData:data];
    }
    self.contentDownloaded += [data length];
    [self notifyDownloading];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.downloading = NO;
    if(self.fileHandle){
        [self.fileHandle closeFile];
    }
    self.fileHandle = nil;
    [self notifyDownloadDidFinished];
}

#pragma mark - ProviderPoolable
- (BOOL)providerShouldBeRemoveFromPool
{
    return !self.downloading;
}

- (void)providerWillRemoveFromPool
{
    [self cancel];
}

- (BOOL)providerIsExecuting
{
    return self.downloading;
}

@end
