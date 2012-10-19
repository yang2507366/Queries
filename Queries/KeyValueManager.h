//
//  KeyValueCache.h
//  imyvoa
//
//  Created by yzx on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KeyValueManager <NSObject>  

- (void)setValue:(NSString *)value forKey:(NSString *)key;
- (NSString *)valueForKey:(NSString *)key;
- (void)removeValueForKey:(NSString *)key;
- (void)clear;
- (NSArray *)allKeys;
- (NSArray *)keyListAtIndex:(NSInteger)index size:(NSInteger)size;

@end
