//
//  FileUtils.h
//  Queries
//
//  Created by yangzexin on 2/19/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject

+ (void)enumerateWithDirectoryPath:(NSString *)dirPath filePathBlock:(void(^)(NSString *filePath, BOOL isDirectory))filePathBlock;

@end
