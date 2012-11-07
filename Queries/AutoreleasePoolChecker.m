//
//  AutoreleasePoolChecker.m
//  Queries
//
//  Created by yangzexin on 12-10-30.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "AutoreleasePoolChecker.h"
#import "NSString+Substring.h"
#import "LuaCommonUtils.h"

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

@interface FunctionPosition : NSObject

@property(nonatomic, assign)NSInteger beginIndex;
@property(nonatomic, assign)NSInteger endIndex;

@end

@implementation FunctionPosition

@synthesize beginIndex;
@synthesize endIndex;

- (NSString *)description
{
    return [NSString stringWithFormat:@"%d, %d", beginIndex, endIndex];
}

@end

@implementation AutoreleasePoolChecker

- (BOOL)isAlphbelt:(char)c
{
    return (c >= 48 && c <= 57) || (c >= 65 && c <= 90) || (c >= 97 && c <= 122);
}

- (NSString *)checkScript:(NSString *)script scriptName:(NSString *)scriptName bundleId:(NSString *)bundleId
{
    if(![LuaCommonUtils scriptIsMainScript:script]){
        return script;
    }
//    NSLog(@"****************************%@", scriptId);
    NSMutableArray *functionPositionList = [NSMutableArray array];
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
    StackInfo *lastStackInfo = nil;
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
//            NSLog(@"minStackInfo:%@", minStackInfo);
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
            if(minStackInfo.type == StackInfoTypeDo){
                // handle do
                char preChar = -1;
                if(minStackInfo.position - 1 >= 0){
                    preChar = [script characterAtIndex:minStackInfo.position - 1];
                }
                char nextChar = -1;
                if(minStackInfo.position + 1 < script.length){
                    nextChar = [script characterAtIndex:nextChar];
                }
                
                if((lastStackInfo && (lastStackInfo.type == StackInfoTypeFor || lastStackInfo.type == StackInfoTypeWhile))
                   || [self isAlphbelt:preChar]
                   || [self isAlphbelt:nextChar]){
                    D_Log(@"skip do:%@", [script substringToIndex:minStackInfo.position]);
                }else{
                    [stack addObject:minStackInfo];
                    lastStackInfo = minStackInfo;
                }
            }else{
                // push
                [stack addObject:minStackInfo];
                lastStackInfo = minStackInfo;
//                NSLog(@"push:%@, %@", minStackInfo, scriptId);
            }
            fromIndex = minStackInfo.position + minStackInfo.checkString.length;
        }else{
            StackInfo *lastObj = [[stack lastObject] retain];
            
//            NSLog(@"pop:%@, %@", lastObj, scriptId);
            if(stack.count != 0){
                // pop
                [stack removeObjectAtIndex:stack.count - 1];
                lastStackInfo = nil;
            }else{
                NSLog(@"error found:%@", script);
            }
            
            if(lastObj.type == StackInfoTypeFunction){
//                NSLog(@"%@, %@", lastObj, scriptId);
//                NSInteger leftBracketPosition = [script find:@"(" fromIndex:lastObj.position];
//                NSLog(@"%@", [script substringWithBeginIndex:lastObj.position endIndex:leftBracketPosition]);
                NSLog(@"%@", [script substringWithBeginIndex:lastObj.position endIndex:endPosition + endString.length]);
                FunctionPosition *fp = [[[FunctionPosition alloc] init] autorelease];
                fp.beginIndex = lastObj.position;
                fp.endIndex = endPosition + endString.length;
                [functionPositionList addObject:fp];
            }
            [lastObj release];
            fromIndex = endPosition + endString.length;
        }
    }
    NSLog(@"stack:%@", stack);
//    NSLog(@"%@, %@", scriptName, functionPositionList);
    NSMutableString *resultScript = [NSMutableString string];
    if(functionPositionList.count != 0){
        NSInteger beginIndex = 0;
        NSInteger endIndex = 0;
        for(FunctionPosition *fp in functionPositionList){
            endIndex = fp.beginIndex;
            [resultScript appendString:[script substringWithBeginIndex:beginIndex endIndex:endIndex]];
            // add function to resultScript
            [resultScript appendString:[script substringWithBeginIndex:fp.beginIndex endIndex:fp.endIndex]];
            // end
            beginIndex = fp.endIndex;
        }
//        NSLog(@"%d, %d", beginIndex, script.length);
        if(beginIndex != script.length){
            [resultScript appendString:[script substringWithBeginIndex:beginIndex endIndex:script.length]];
        }
    }else{
        [resultScript appendString:script];
    }
    
    return script;
}

@end