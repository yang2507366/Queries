//
//  LIAudioPlayer.h
//  Queries
//
//  Created by yangzexin on 13-2-5.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaImplentatable.h"
#import <AVFoundation/AVFoundation.h>

@interface LIAudioPlayer : AVAudioPlayer <LuaImplentatable>

@property(nonatomic, copy)NSString *audioPlayerDidFinishPlaying;

@end
