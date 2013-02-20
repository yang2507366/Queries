//
//  ImagePicker.h
//  GewaraSport
//
//  Created by yangzexin on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ImagePickerCompletion)(UIImage *image);
@interface ImagePicker : NSObject

+ (void)presentWithViewController:(UIViewController *)viewController completion:(ImagePickerCompletion)completion;

@end
