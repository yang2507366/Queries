//
//  LIAudioPlayer.m
//  Queries
//
//  Created by yangzexin on 13-2-5.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "LIAudioPlayer.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"

@interface LIAudioPlayer () <AVAudioPlayerDelegate>

@end

@implementation LIAudioPlayer

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    [super dealloc];
}

- (id)initWithContentsOfURL:(NSURL *)url error:(NSError **)outError
{
    self = [super initWithContentsOfURL:url error:outError];
    
    self.delegate = self;
    
    return self;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(self.audioPlayerDidFinishPlaying.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.appId]
         callFunction:self.audioPlayerDidFinishPlaying parameters:self.objId, flag ? @"YES" : @"NO", nil];
    }
}

+ (NSString *)create:(NSString *)appId
{
    return @"";
}

+ (NSString *)create:(NSString *)appId URLId:(NSString *)URLId
{
    NSURL *URL = [LuaObjectManager objectWithId:URLId group:appId];
    NSError *error = nil;
    LIAudioPlayer *tmp = [[[LIAudioPlayer alloc] initWithContentsOfURL:URL error:&error] autorelease];
    if(!error){
        tmp.objId = [LuaObjectManager addObject:tmp group:appId];
        tmp.appId = appId;
        return tmp.objId;
    }
    return @"";
}

@end
