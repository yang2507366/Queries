//
//  TaskQueue.h
//  VOA
//
//  Created by yangzexin on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TaskExecutable <NSObject>

@required
- (void)execute:(id)userData;
@optional
- (BOOL)autoExecuteNextTask;
- (NSString *)taskDescription;

@end

@class TaskQueue;

@protocol TaskQueueDelegate <NSObject>

@optional
- (void)taskQueue:(TaskQueue *)taskQueue willStartTask:(id<TaskExecutable>)task;
- (void)taskQueueDidStarted:(TaskQueue *)taskQueue;
- (void)taskQueueDidInterrupted:(TaskQueue *)taskQueue;
- (void)taskQueueDidFinished:(TaskQueue *)taskQueue;

@end

@interface TaskQueue : NSObject {
    id<TaskQueueDelegate> _delegate;
    
    NSMutableArray *taskList_;
    NSMutableDictionary *_userDataDict;
    NSCondition *taskListCondition_;
}

@property(nonatomic, assign)id<TaskQueueDelegate> delegate;

+ (TaskQueue *)newTaskQueue;
- (void)addTask:(id<TaskExecutable>)task;
- (void)addTask:(id<TaskExecutable>)task userData:(id)userData;
- (void)removeTask:(id<TaskExecutable>)task;
- (void)start;
- (void)executeNextTask;
- (void)skipTask:(NSInteger)count;
- (void)skipAllTask;
- (void)interrupt;

@end
