//
//  TaskQueue.m
//  VOA
//
//  Created by yangzexin on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TaskQueue.h"

@interface TaskQueue ()

@property(nonatomic, retain)NSMutableArray *taskList;
@property(nonatomic, retain)NSMutableDictionary *userDataDict;
@property(nonatomic, retain)NSCondition *taskListCondition;

- (NSString *)userDataKeyForTask:(id<TaskExecutable>)task;

@end

@implementation TaskQueue

@synthesize delegate = _delegate;
@synthesize taskList = taskList_;
@synthesize userDataDict = _userDataDict;
@synthesize taskListCondition = taskListCondition_;

- (void)dealloc
{
    [taskList_ release];
    [_userDataDict release];
    [taskListCondition_ release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    self.taskList = [NSMutableArray array];
    self.userDataDict = [NSMutableDictionary dictionary];
    self.taskListCondition = [[[NSCondition alloc] init] autorelease];
    return self;
}

+ (TaskQueue *)newTaskQueue
{
    return [[[TaskQueue alloc] init] autorelease];
}

- (void)start
{
    if([self.delegate respondsToSelector:@selector(taskQueueDidStarted:)]){
        [self.delegate taskQueueDidStarted:self];
    }
    [self executeNextTask];
}

- (void)executeNextTask
{
    if([self.taskList count] != 0){
        id<TaskExecutable> task = [[self.taskList objectAtIndex:0] retain];
        [self removeTask:task];
        if([self.delegate respondsToSelector:@selector(taskQueue:willStartTask:)]){
            [self.delegate taskQueue:self willStartTask:task];
        }
        NSString *userDataKey = [self userDataKeyForTask:task];
        [task execute:[self.userDataDict objectForKey:userDataKey]];
        [self.userDataDict removeObjectForKey:userDataKey];
        
        if([task respondsToSelector:@selector(autoExecuteNextTask)]){
            if([task autoExecuteNextTask]){
                [self executeNextTask];
            }
        }
        [task release];
    }else{
        if([self.delegate respondsToSelector:@selector(taskQueueDidFinished:)]){
            [self.delegate taskQueueDidFinished:self];
        }
    }
}

- (void)addTask:(id<TaskExecutable>)task userData:(id)userData
{
    [self.taskListCondition lock];
    [self.taskList addObject:task];
    if(userData){
        [self.userDataDict setObject:userData forKey:[self userDataKeyForTask:task]];
    }
    [self.taskListCondition unlock];
}

- (void)addTask:(id<TaskExecutable>)task
{
    [self addTask:task userData:nil];
}

- (void)removeTask:(id<TaskExecutable>)task
{
    [self.taskListCondition lock];
    [self.taskList removeObject:task];
    [self.userDataDict removeObjectForKey:[self userDataKeyForTask:task]];
    [self.taskListCondition unlock];
}

- (void)skipTask:(NSInteger)count
{
    for(NSInteger i = 0; i < count && self.taskList.count != 0; ++i){
        id<TaskExecutable> task = [self.taskList objectAtIndex:0];
        [self removeTask:task];
    }
}

- (void)skipAllTask
{
    [self skipTask:self.taskList.count];
}

- (void)interrupt
{
    [self skipAllTask];
    if([self.delegate respondsToSelector:@selector(taskQueueDidInterrupted:)]){
        [self.delegate taskQueueDidInterrupted:self];
    }
}
#pragma mark - private methods
- (NSString *)userDataKeyForTask:(id<TaskExecutable>)task
{
    return [NSString stringWithFormat:@"%@", task];
}

@end
