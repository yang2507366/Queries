//
//  AutoreleasePoolChecker.m
//  Queries
//
//  Created by yangzexin on 12-10-30.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "AutoreleasePoolChecker.h"

@interface NSString (Substring)

- (NSString *)substringWithBeginIndex:(NSInteger)beginIndex endIndex:(NSInteger)endIndex;
- (NSInteger)find:(NSString *)str fromIndex:(NSInteger)fromInex reverse:(BOOL)reverse;
- (NSInteger)find:(NSString *)str fromIndex:(NSInteger)fromInex;
- (NSInteger)find:(NSString *)str;

@end

@implementation NSString (Substring)

- (NSString *)substringWithBeginIndex:(NSInteger)beginIndex endIndex:(NSInteger)endIndex
{
    if(endIndex > beginIndex){
        return [self substringWithRange:NSMakeRange(beginIndex, endIndex - beginIndex)];
    }
    return nil;
}

- (NSInteger)find:(NSString *)str fromIndex:(NSInteger)fromInex reverse:(BOOL)reverse
{
    if(fromInex < self.length){
        NSRange range = [self rangeOfString:str
                                    options:reverse ? NSBackwardsSearch : NSCaseInsensitiveSearch
                                      range:NSMakeRange(fromInex, self.length - fromInex)];
        return range.location == NSNotFound ? -1 : range.location;
    }
    return -1;
}

- (NSInteger)find:(NSString *)str fromIndex:(NSInteger)fromInex
{
    return [self find:str fromIndex:fromInex reverse:NO];
}

- (NSInteger)find:(NSString *)str
{
    return [self find:str fromIndex:0];
}

@end

typedef enum{
    StackInfoTypeFunction,
    StackInfoTypeWhile,
    StackInfoTypeFor,
    StackInfoTypeDo,
    StackInfoTypeIf,
}StackInfoType;

@interface StackInfo : NSObject

@property(nonatomic, assign)StackInfoType type;
@property(nonatomic, assign)NSInteger position;
@property(nonatomic, readonly)NSString *checkString;

@end

@implementation StackInfo

@synthesize type;
@synthesize position;
@synthesize checkString;

- (void)dealloc
{
    [checkString release];
    [super dealloc];
}

- (id)initWithType:(StackInfoType)pType
{
    self = [super init];
    
    self.type = pType;
    if(type == StackInfoTypeFunction){
        checkString = @"function ";
    }else if(type == StackInfoTypeWhile){
        checkString = @"while ";
    }if(type == StackInfoTypeFor){
        checkString = @"for ";
    }if(type == StackInfoTypeDo){
        checkString = @"do";
    }if(type == StackInfoTypeIf){
        checkString = @"if ";
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"StaclInfo:%@, %d", self.checkString, self.position];
}

@end

@implementation AutoreleasePoolChecker

- (NSString *)checkScript:(NSString *)script scriptId:(NSString *)scriptId
{
    if([scriptId isEqualToString:@"AutoreleasePool.lua"]){
        return script;
    }
    NSString *endString = @"end";
    NSMutableArray *stack = [NSMutableArray array];
    NSArray *checkList = [NSArray arrayWithObjects:
                          [[[StackInfo alloc] initWithType:StackInfoTypeFunction] autorelease],
                          [[[StackInfo alloc] initWithType:StackInfoTypeIf] autorelease],
                          [[[StackInfo alloc] initWithType:StackInfoTypeWhile] autorelease],
                          [[[StackInfo alloc] initWithType:StackInfoTypeFor] autorelease],
                          [[[StackInfo alloc] initWithType:StackInfoTypeDo] autorelease],
                          nil];
    NSInteger fromIndex = 0;
    while(YES){
        StackInfo *minStackInfo = nil;
        NSMutableArray *positionList = [NSMutableArray array];
        NSInteger miniValidPosition = -1;
        for(NSInteger i = 0; i < checkList.count; ++i){
            StackInfo *si = checkList[i];
            
            StackInfo *nsi = [[[StackInfo alloc] initWithType:si.type] autorelease];
            nsi.position = [script find:nsi.checkString fromIndex:fromIndex];
            [positionList addObject:nsi];
            if(nsi.position != -1 && miniValidPosition == -1){
                miniValidPosition = i;
            }
        }
        if(miniValidPosition == -1){
            minStackInfo = positionList[0];
        }else{
            minStackInfo = positionList[miniValidPosition];
            NSLog(@"minStackInfo:%@", minStackInfo);
            for(NSInteger i = 0; i < positionList.count; ++i){
                StackInfo *si = positionList[i];
                if(si.position != -1 && si.position < minStackInfo.position){
                    minStackInfo = si;
                }
            }
        }
        NSInteger endPosition = [script find:endString fromIndex:fromIndex];
        if(endPosition == -1){
            break;
        }
        if(minStackInfo.position != -1 && minStackInfo.position < endPosition){
            [stack addObject:minStackInfo];
            NSLog(@"push:%@, %@", minStackInfo, scriptId);
            fromIndex = minStackInfo.position + minStackInfo.checkString.length;
        }else{
            StackInfo *lastObj = [[stack lastObject] retain];
            
            NSLog(@"pop:%@, %@", lastObj, scriptId);
            if(stack.count != 0){
                [stack removeObjectAtIndex:stack.count - 1];
            }else{
                NSLog(@"error found:%@", script);
            }
            
            if(lastObj.type == StackInfoTypeFunction){
                //                NSLog(@"%@, %@", lastObj, scriptId);
                NSInteger leftBracketPosition = [script find:@"(" fromIndex:lastObj.position];
                NSLog(@"%@", [script substringWithBeginIndex:lastObj.position endIndex:leftBracketPosition]);
                NSLog(@"%@", [script substringWithBeginIndex:lastObj.position endIndex:endPosition + endString.length]);
            }
            [lastObj release];
            fromIndex = endPosition + endString.length;
        }
//        if(minStackInfo.position == -1){
//            NSLog(@"stack:%@", stack);
//            break;
//        }
    }
    
    return script;
}

@end