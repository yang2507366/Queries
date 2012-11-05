//
//  TextViewImpl.m
//  Queries
//
//  Created by yangzexin on 12-11-5.
//  Copyright (c) 2012年 yangzexin. All rights reserved.
//

#import "TextViewImpl.h"
#import "LuaGroupedObjectManager.h"

@interface TextViewEventProxy : NSObject <UITextViewDelegate>

@end

@implementation TextViewEventProxy

+ (id)sharedInstance
{
    static id instance = nil;
    if(instance == nil){
        instance = [[self alloc] init];
    }
    return instance;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    TextViewImpl *impl = (id)textView;
    if(impl.textViewShouldBeginEditingBlock){
        return impl.textViewShouldBeginEditingBlock();
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    TextViewImpl *impl = (id)textView;
    if(impl.textViewShouldEndEditingBlock){
        return impl.textViewShouldEndEditingBlock();
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    TextViewImpl *impl = (id)textView;
    if(impl.textViewDidBeginEditingBlock){
        impl.textViewDidBeginEditingBlock();
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    TextViewImpl *impl = (id)textView;
    if(impl.textViewDidEndEditingBlock){
        impl.textViewDidEndEditingBlock();
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    TextViewImpl *impl = (id)textView;
    if(impl.shouldChangeTextInRangeBlock){
        return impl.shouldChangeTextInRangeBlock(range, text);
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    TextViewImpl *impl = (id)textView;
    if(impl.textViewDidChangeBlock){
        impl.textViewDidChangeBlock();
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    TextViewImpl *impl = (id)textView;
    if(impl.textViewDidChangeSelectionBlock){
        impl.textViewDidChangeSelectionBlock();
    }
}

@end

@implementation TextViewImpl

- (void)dealloc
{
    self.textViewDidBeginEditingBlock = nil;
    self.textViewDidChangeBlock = nil;
    self.textViewDidChangeSelectionBlock = nil;
    self.textViewDidEndEditingBlock = nil;
    self.textViewShouldBeginEditingBlock = nil;
    self.textViewShouldEndEditingBlock = nil;
    self.shouldChangeTextInRangeBlock = nil;
    [super dealloc];
}

+ (NSString *)createTextViewWithAppId:(NSString *)appId
                                   si:(id<ScriptInteraction>)si
                  didBeginEditingFunc:(NSString *)didBeginEditingFunc
                       didEndEditFunc:(NSString *)didEndEditFunc
                        didChangeFunc:(NSString *)didChangeFunc
               didChangeSelectionFunc:(NSString *)didChangeSelectionFunc
               shouldBeginEditingFunc:(NSString *)shouldBeginEditingFunc
                 shouldEndEditingFunc:(NSString *)shouldEndEditingFunc
          shouldChangeTextInRangeFunc:(NSString *)shouldChangeTextInRange
{
    TextViewImpl *impl = [[[TextViewImpl alloc] init] autorelease];
    impl.autocapitalizationType = UITextAutocapitalizationTypeNone;
    impl.autocorrectionType = UITextAutocorrectionTypeNo;
    impl.delegate = [TextViewEventProxy sharedInstance];
    NSString *tvId = [LuaGroupedObjectManager addObject:impl group:appId];
    
    [impl setTextViewDidBeginEditingBlock:^{
        [si callFunction:didBeginEditingFunc parameters:tvId, nil];
    }];
    [impl setTextViewDidEndEditingBlock:^{
        [si callFunction:didEndEditFunc parameters:tvId, nil];
    }];
    [impl setTextViewDidChangeBlock:^{
        [si callFunction:didChangeFunc parameters:tvId, nil];
    }];
    [impl setTextViewDidChangeSelectionBlock:^{
        [si callFunction:didChangeSelectionFunc parameters:tvId, nil];
    }];
    [impl setTextViewShouldEndEditingBlock:^BOOL{
        return [[si callFunction:shouldEndEditingFunc parameters:tvId, nil] boolValue];
    }];
    [impl setTextViewShouldBeginEditingBlock:^BOOL{
        return [[si callFunction:shouldBeginEditingFunc parameters:tvId, nil] boolValue];
    }];
    [impl setShouldChangeTextInRangeBlock:^BOOL(NSRange range, NSString *replacementText) {
        return [[si callFunction:shouldChangeTextInRange parameters:tvId, [NSString stringWithFormat:@"%d", range.location],
                 [NSString stringWithFormat:@"%d", range.length], replacementText, nil] boolValue];
    }];
    
    return tvId;
}

@end
