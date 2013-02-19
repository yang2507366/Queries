//
//  FiltUtils.h
//  Queries
//
//  Created by yangzexin on 13-2-5.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject

+ (void)moveFileWithSourcePath:(NSString *)srcPath destinationPath:(NSString *)desPath;
+ (NSString *)readString:(NSString *)path;
+ (void)upzipFile:(NSString *)zipFilePath
           toPath:(NSString *)path
        overWrite:(BOOL)overWrite
            appId:(NSString *)appId
            objId:(NSString *)objId
     completeFunc:(NSString *)completeFunc;
+ (void)zipDirectory:(NSString *)dirPath
          toFilePath:(NSString *)toFilePath
               appId:(NSString *)appId
               objId:(NSString *)objId
        completeFunc:(NSString *)completeFunc;

@end
