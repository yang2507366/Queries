//
//  LuaScriptManager.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LuaScriptManager.h"
#import "LuaScriptInteraction.h"
#import "LuaInvoker.h"

@interface LuaScriptManager ()

@property(nonatomic, retain)NSMutableDictionary *scriptDict;

@end

@implementation LuaScriptManager

+ (id)sharedManager
{
    static typeof(self) instance = nil;
    @synchronized(self.class){
        if(instance == nil){
            instance = [[self.class alloc] init];
        }
    }
    return instance;
}

- (void)dealloc
{
    self.scriptDict = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.scriptDict = [NSMutableDictionary dictionary];
    
    return self;
}

- (void)addScript:(NSString *)script
{
    LuaInvoker *invoker = [[[LuaInvoker alloc] initWithScript:script] autorelease];
    NSString *scriptId = [invoker invokeProperty:@"scriptId"];
    if(scriptId.length != 0){
        [self.scriptDict setObject:script forKey:scriptId];
    }
}

- (NSString *)scriptForIdentifier:(NSString *)identifier
{
    return [self.scriptDict objectForKey:identifier];
}

@end
