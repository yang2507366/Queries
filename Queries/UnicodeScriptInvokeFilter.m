//
//  UnicodeScriptInvokeFilter.m
//  Queries
//
//  Created by yangzexin on 10/20/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "UnicodeScriptInvokeFilter.h"
#import "CommonUtils.h"
#import "CodeUtils.h"

@implementation UnicodeScriptInvokeFilter

- (NSString *)filterParameter:(NSString *)parameter
{
    if([CommonUtils stringContainsChinese:parameter]){
        parameter = [CodeUtils encodeAllChinese:parameter];
    }
    return parameter;
}

- (NSString *)filterReturnValue:(NSString *)returnValue
{
    return [CodeUtils decodeAllChinese:returnValue];
}

@end
