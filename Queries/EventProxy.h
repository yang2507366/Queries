//
//  EventProxy.h
//  Queries
//
//  Created by yangzexin on 10/21/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"
#import "Singleton.h"

@interface EventObject : NSObject

@property(nonatomic, retain)id<ScriptInteraction> si;
@property(nonatomic, copy)NSString *funcName;
@property(nonatomic, copy)NSString *viewId;

@end

@interface EventProxy : Singleton

@property(nonatomic, retain)NSMutableDictionary *eventDict;
- (void)event:(id)source;
- (void)addEventSource:(id)eventSource scriptInteraction:(id<ScriptInteraction>)si funcName:(NSString *)funcName viewId:(NSString *)viewId;
@end
