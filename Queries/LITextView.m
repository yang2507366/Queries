//
//  TextView.m
//  Queries
//
//  Created by yangzexin on 11/18/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LITextView.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"

@interface TextViewDelegateProxy : NSObject <UITextViewDelegate>

@property(nonatomic, assign)LITextView *targetTextView;

@end

@implementation TextViewDelegateProxy

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(self.targetTextView.shouldBeginEditing.length != 0){
        return [[[LuaAppManager scriptInteractionWithAppId:self.targetTextView.appId]
                callFunction:self.targetTextView.shouldBeginEditing parameters:self.targetTextView.objId, nil] boolValue];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(self.targetTextView.shouldEndEditing.length != 0){
        return [[[LuaAppManager scriptInteractionWithAppId:self.targetTextView.appId]
                 callFunction:self.targetTextView.shouldEndEditing parameters:self.targetTextView.objId, nil] boolValue];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(self.targetTextView.didBeginEditing.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.targetTextView.appId] callFunction:self.targetTextView.didBeginEditing
                                                                                parameters:self.targetTextView.objId, nil];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(self.targetTextView.didEndEditing.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.targetTextView.appId] callFunction:self.targetTextView.didEndEditing
                                                                                parameters:self.targetTextView.objId, nil];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(self.targetTextView.shouldChangeTextInRange.length != 0){
        return [[[LuaAppManager scriptInteractionWithAppId:self.targetTextView.appId]
                 callFunction:self.targetTextView.shouldChangeTextInRange parameters:
                 self.targetTextView.objId, [NSString stringWithFormat:@"%d", range.location], [NSString stringWithFormat:@"%d", range.length],
                 text, nil] boolValue];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(self.targetTextView.didChange.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.targetTextView.appId] callFunction:self.targetTextView.didChange
                                                                                parameters:self.targetTextView.objId, nil];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if(self.targetTextView.didChangeSelection.length != 0){
        [[LuaAppManager scriptInteractionWithAppId:self.targetTextView.appId] callFunction:self.targetTextView.didChangeSelection
                                                                                parameters:self.targetTextView.objId, nil];
    }
}

@end

@interface LITextView ()

@property(nonatomic, retain)TextViewDelegateProxy *delegateProxy;

@end

@implementation LITextView

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    
    self.shouldBeginEditing = nil;
    self.shouldEndEditing = nil;
    self.didBeginEditing = nil;
    self.didEndEditing = nil;
    self.shouldChangeTextInRange = nil;
    self.didChange = nil;
    self.didChangeSelection = nil;
    
    self.delegateProxy = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.delegateProxy = [[TextViewDelegateProxy new] autorelease];
    self.delegateProxy.targetTextView = self;
    [self updateDelegate];
    
    return self;
}

- (void)updateDelegate
{
    self.delegate = self.delegateProxy;
}

+ (NSString *)create:(NSString *)appId
{
    LITextView *tmp = [[LITextView new] autorelease];
    tmp.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tmp.autocorrectionType = UITextAutocorrectionTypeNo;
    tmp.appId = appId;
    tmp.objId = [LuaObjectManager addObject:tmp group:appId];
    
    return tmp.objId;
}

@end
