//
//  SystemUtils.m
//  Queries
//
//  Created by yangzexin on 10/19/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "SystemUtils.h"
#import <mach/mach.h>

@implementation SystemUtils

+ (unsigned int)bytesOfMemoryUsed
{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if(kerr == KERN_SUCCESS){
        return info.resident_size;
    }
    return 0;
}

@end
