//
//  OnlineAppBundle.m
//  Queries
//
//  Created by yangzexin on 11/4/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//
// https://github.com/yang2507366/TestZip/blob/master/TestZip/gtrans.zip
#import "OnlineAppBundleLoader.h"
#import "HTTPRequest.h"

@interface OnlineAppBundleLoader ()

@property(nonatomic, copy)NSString *URLString;
@property(nonatomic, retain)HTTPRequest *request;

@end

@implementation OnlineAppBundleLoader

- (void)dealloc
{
    self.URLString = nil;
    [self.request cancel]; self.request = nil;
    [super dealloc];
}

- (id)initWithURLString:(NSString *)urlString
{
    self = [super init];
    
    self.URLString = urlString;
    
    return self;
}

- (void)loadWithCompletion:(void(^)(NSString *))completion
{
    [self.request cancel];
    self.request = [[HTTPRequest new] autorelease];
    [self.request requestWithURLString:self.URLString returnData:^(NSData *data, NSError *error) {
        if(data.length != 0){
            NSString *tmpFile = [[NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]]
                                 stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *filePath = [NSString stringWithFormat:@"%@/tmp/%@", NSHomeDirectory(), tmpFile];
            [data writeToFile:filePath atomically:NO];
            completion(filePath);
        }else{
            completion(nil);
        }
    }];
}

- (void)cancel
{
    [self.request cancel];
}

@end
