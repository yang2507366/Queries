//
//  TextViewImpl.h
//  Queries
//
//  Created by yangzexin on 12-11-5.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInteraction.h"

@interface TextViewImpl : UITextView

@property(nonatomic, copy)void(^textViewDidBeginEditingBlock)();
@property(nonatomic, copy)void(^textViewDidEndEditingBlock)();
@property(nonatomic, copy)void(^textViewDidChangeBlock)();
@property(nonatomic, copy)void(^textViewDidChangeSelectionBlock)();
@property(nonatomic, copy)BOOL(^textViewShouldBeginEditingBlock)();
@property(nonatomic, copy)BOOL(^textViewShouldEndEditingBlock)();
@property(nonatomic, copy)BOOL(^shouldChangeTextInRangeBlock)(NSRange range, NSString *replacementText);

+ (NSString *)createTextViewWithAppId:(NSString *)appId
                                   si:(id<ScriptInteraction>)si
                  didBeginEditingFunc:(NSString *)didBeginEditingFunc
                       didEndEditFunc:(NSString *)didEndEditFunc
                        didChangeFunc:(NSString *)didChangeFunc
               didChangeSelectionFunc:(NSString *)didChangeSelectionFunc
               shouldBeginEditingFunc:(NSString *)shouldBeginEditingFunc
                 shouldEndEditingFunc:(NSString *)shouldEndEditingFunc
          shouldChangeTextInRangeFunc:(NSString *)shouldChangeTextInRange;

@end
