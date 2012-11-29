//
//  PickerViewImpl.m
//  Queries
//
//  Created by yangzexin on 11/7/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "LIPickerView.h"
#import "LuaObjectManager.h"
#import "LuaAppManager.h"

@interface PickerViewImplEventProxy : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, assign)LIPickerView *impl;

@end

@implementation PickerViewImplEventProxy

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    LIPickerView *tmpPickerView = (id)pickerView;
    if(tmpPickerView.numOfComponents){
        return tmpPickerView.numOfComponents();
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    LIPickerView *tmpPickerView = (id)pickerView;
    if(tmpPickerView.numOfRowsInComponent){
        return tmpPickerView.numOfRowsInComponent(component);
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    LIPickerView *tmpPickerView = (id)pickerView;
    if(tmpPickerView.widthForComponent){
        return tmpPickerView.widthForComponent(component);
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    LIPickerView *tmpPickerView = (id)pickerView;
    if(tmpPickerView.rowHeightForComponent){
        tmpPickerView.rowHeightForComponent(component);
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    LIPickerView *tmpPickerView = (id)pickerView;
    if(tmpPickerView.titleForRowForComponent){
        return tmpPickerView.titleForRowForComponent(row, component);
    }
    return nil;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    LIPickerView *tmpPickerView = (id)pickerView;
    if(tmpPickerView.attributedTitleForRowForComponent){
        tmpPickerView.attributedTitleForRowForComponent(row, component);
    }
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
//    PickerViewImpl *tmpPickerView = (id)pickerView;
//    if(tmpPickerView.viewForRowForComponentReuseView){
//        tmpPickerView.viewForRowForComponentReuseView(row, component, view);
//    }
//    return nil;
    UILabel *tmpLabel = (id)view;
    if(tmpLabel == nil){
        tmpLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)] autorelease];
    }else{
        NSLog(@"reusing:%@", tmpLabel);
    }
    tmpLabel.backgroundColor = [UIColor blackColor];
    tmpLabel.textAlignment = UITextAlignmentCenter;
    tmpLabel.text = @"text";
    return tmpLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    LIPickerView *tmpPickerView = (id)pickerView;
    if(tmpPickerView.didSelectRowInComponent){
        tmpPickerView.didSelectRowInComponent(row, component);
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    NSString *selectorName = NSStringFromSelector(aSelector);
    
    if([selectorName isEqualToString:@"numberOfComponentsInPickerView:"] && _impl.numOfComponents == nil){
        return NO;
    }else if([selectorName isEqualToString:@"pickerView:numberOfRowsInComponent:"] && _impl.numOfRowsInComponent == nil){
        return NO;
    }else if([selectorName isEqualToString:@"pickerView:attributedTitleForRow:forComponent:"]){
        return NO;
    }else if([selectorName isEqualToString:@"pickerView:didSelectRow:inComponent:"] && _impl.didSelectRowInComponent == nil){
        return NO;
    }else if([selectorName isEqualToString:@"pickerView:rowHeightForComponent:"] && _impl.rowHeightForComponent == nil){
        return NO;
    }else if([selectorName isEqualToString:@"pickerView:titleForRow:forComponent:"] && self.impl.titleForRowForComponent == nil){
        return NO;
    }else if([selectorName isEqualToString:@"pickerView:viewForRow:forComponent:reusingView:"] && self.impl.viewForRowForComponentReuseView == nil){
        return NO;
    }else if([selectorName isEqualToString:@"pickerView:widthForComponent:"] && _impl.widthForComponent == nil){
        return NO;
    }
    
    return [super respondsToSelector:aSelector];
}

@end

@interface LIPickerView ()

@property(nonatomic, retain)PickerViewImplEventProxy *eventProxy;

@end

@implementation LIPickerView

@synthesize appId;
@synthesize objId;

- (void)dealloc
{
    self.appId = nil;
    self.objId = nil;
    
    self.numOfComponents = nil;
    self.numOfRowsInComponent = nil;
    self.widthForComponent = nil;
    self.rowHeightForComponent = nil;
    self.titleForRowForComponent = nil;
    self.attributedTitleForRowForComponent = nil;
    self.viewForRowForComponentReuseView = nil;
    self.didSelectRowInComponent = nil;
    self.eventProxy = nil;
    [super dealloc];
}

- (id)init
{
    self = [self initWithFrame:CGRectZero];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
   
    self.eventProxy = [[[PickerViewImplEventProxy alloc] init] autorelease];
    self.eventProxy.impl = self;
    self.delegate = self.eventProxy;
    self.dataSource = self.eventProxy;
    
    return self;
}

- (void)updateDelegate
{
    self.delegate = self.eventProxy;
    self.dataSource = self.eventProxy;
}

- (void)setNumberOfComponentsFunc:(NSString *)func
{
    if(func.length != 0){
        [self setNumOfComponents:^NSInteger{
            NSString *num = [[LuaAppManager scriptInteractionWithAppId:self.appId] callFunction:func parameters:self.objId, nil];
            return [num intValue];
        }];
    }else{
        self.numOfComponents = nil;
    }
    [self updateDelegate];
}

- (void)setNumberOfRowsInComponentFunc:(NSString *)func
{
    if(func.length != 0){
        [self setNumOfRowsInComponent:^NSInteger(NSInteger component) {
            NSString *rows = [[LuaAppManager scriptInteractionWithAppId:self.appId]
                              callFunction:func parameters:self.objId, [NSString stringWithFormat:@"%d", component], nil];
            return [rows intValue];
        }];
    }else{
        self.numOfRowsInComponent = nil;
    }
    [self updateDelegate];
}

- (void)setWidthForComponentFuc:(NSString *)func
{
    if(func.length != 0){
        [self setWidthForComponent:^CGFloat(NSInteger component) {
            NSString *width = [[LuaAppManager scriptInteractionWithAppId:self.appId]
                               callFunction:func parameters:objId, [NSString stringWithFormat:@"%d", component], nil];
            return [width floatValue];
        }];
    }else{
        self.widthForComponent = nil;
    }
    [self updateDelegate];
}

- (void)setRowHeightForComponentFunc:(NSString *)func
{
    if(func.length != 0){
        [self setRowHeightForComponent:^CGFloat(NSInteger component) {
            NSString *rowHeight = [[LuaAppManager scriptInteractionWithAppId:appId]
                                   callFunction:func parameters:objId, [NSString stringWithFormat:@"%d", component], nil];
            return [rowHeight floatValue];
        }];
    }else{
        self.rowHeightForComponent = nil;
    }
    [self updateDelegate];
}

- (void)setTitleForRowForComponentFunc:(NSString *)func
{
    if(func.length != 0){
        [self setTitleForRowForComponent:^NSString *(NSInteger row, NSInteger componnet) {
            NSString *title = [[LuaAppManager scriptInteractionWithAppId:appId]
                               callFunction:func parameters:objId, [NSString stringWithFormat:@"%d", row], [NSString stringWithFormat:@"%d", componnet], nil];
            return title;
        }];
    }else{
        self.titleForRowForComponent = nil;
    }
    [self updateDelegate];
}

- (void)setAttributedTitleForRowForComponentFunc:(NSString *)func
{
    if(func.length != 0){
        [self setAttributedTitleForRowForComponent:^NSAttributedString *(NSInteger row, NSInteger component) {
            return nil;
        }];
    }else{
        self.attributedTitleForRowForComponent = nil;
    }
}

- (void)setViewForRowForComponentReusingViewFunc:(NSString *)func
{
    if(func.length!= 0){
        [self setViewForRowForComponentReuseView:^UIView *(NSInteger row, NSInteger component, UIView *reusingView) {
            NSString *reusingViewId = @"";
            if(reusingView){
                reusingViewId = [LuaObjectManager addObject:reusingView group:appId];
            }
            NSString *viewId = [[LuaAppManager scriptInteractionWithAppId:appId]
                                callFunction:func parameters:objId, [NSString stringWithFormat:@"%d", row],
                                [NSString stringWithFormat:@"%d", component], reusingViewId, nil];
            if(reusingView){
                [LuaObjectManager releaseObjectWithId:reusingViewId group:appId];
            }
            UIView *view = [LuaObjectManager objectWithId:viewId group:appId];
            return view;
        }];
    }else{
        self.viewForRowForComponentReuseView = nil;
    }
    [self updateDelegate];
}

- (void)setDidSelectRowInComponentFunc:(NSString *)func
{
    if(func.length != 0){
        [self setDidSelectRowInComponent:^(NSInteger row, NSInteger component) {
            
        }];
    }else{
        self.didSelectRowInComponent = nil;
    }
    [self updateDelegate];
}

+ (NSString *)create:(NSString *)appId
{
    LIPickerView *impl = [[LIPickerView new] autorelease];
    impl.appId = appId;
    impl.objId = [LuaObjectManager addObject:impl group:appId];
    
    return impl.objId;
}

@end
