//
//  DialogTools.m
//  GewaraSport
//
//  Created by yangzexin on 12-9-21.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import "DialogTools.h"

@interface Dialog : NSObject <UIAlertViewDelegate>

@property(nonatomic, copy)DialogCompletion callback;

@end

@implementation Dialog

- (void)dealloc
{
    self.callback = nil;
    [super dealloc];
}

- (void)dialogWithTitle:(NSString *)title message:(NSString *)message completion:(DialogCompletion)completion cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    [self retain];
    self.callback = completion;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:nil];
    for(NSString *title in otherButtonTitles){
        [alertView addButtonWithTitle:title];
    }
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.callback){
        self.callback(buttonIndex, [alertView buttonTitleAtIndex:buttonIndex]);
    }
    [self release];
}

@end

@implementation DialogTools

+ (void)dialogWithTitle:(NSString *)title message:(NSString *)message completion:(DialogCompletion)completion cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    NSMutableArray *titleList = [NSMutableArray array];
    va_list params;
    va_start(params, otherButtonTitles);
    for(id item = otherButtonTitles; item != nil; item = va_arg(params, id)){
        [titleList addObject:item];
    }
    va_end(params);
    [[[[Dialog alloc] init] autorelease] dialogWithTitle:title
                                                 message:message
                                              completion:completion
                                       cancelButtonTitle:cancelButtonTitle
                                       otherButtonTitles:titleList];
}

@end
