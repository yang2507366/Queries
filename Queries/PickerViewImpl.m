//
//  PickerViewImpl.m
//  Queries
//
//  Created by yangzexin on 11/7/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import "PickerViewImpl.h"
#import "LuaGroupedObjectManager.h"
#import "LuaAppRunner.h"

@interface PickerViewImplEventProxy : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation PickerViewImplEventProxy

+ (id)sharedInstance
{
    static PickerViewImplEventProxy *instance = nil;
    if(instance == nil){
        instance = [[PickerViewImplEventProxy alloc] init];
    }
    return instance;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    PickerViewImpl *tmpPickerView = (id)pickerView;
    if(tmpPickerView.numOfComponents){
        return tmpPickerView.numOfComponents();
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    PickerViewImpl *tmpPickerView = (id)pickerView;
    if(tmpPickerView.numOfRowsInComponent){
        return tmpPickerView.numOfRowsInComponent(component);
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    PickerViewImpl *tmpPickerView = (id)pickerView;
    if(tmpPickerView.widthForComponent){
        return tmpPickerView.widthForComponent(component);
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    PickerViewImpl *tmpPickerView = (id)pickerView;
    if(tmpPickerView.rowHeightForComponent){
        tmpPickerView.rowHeightForComponent(component);
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    PickerViewImpl *tmpPickerView = (id)pickerView;
    if(tmpPickerView.titleForRowForComponent){
        return tmpPickerView.titleForRowForComponent(row, component);
    }
    return nil;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    PickerViewImpl *tmpPickerView = (id)pickerView;
    if(tmpPickerView.attributedTitleForRowForComponent){
        tmpPickerView.attributedTitleForRowForComponent(row, component);
    }
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    PickerViewImpl *tmpPickerView = (id)pickerView;
    if(tmpPickerView.viewForRowForComponentReuseView){
        tmpPickerView.viewForRowForComponentReuseView(row, component, view);
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    PickerViewImpl *tmpPickerView = (id)pickerView;
    if(tmpPickerView.didSelectRowInComponent){
        tmpPickerView.didSelectRowInComponent(row, component);
    }
}

@end

@implementation PickerViewImpl

- (void)dealloc
{
    self.numOfComponents = nil;
    self.numOfRowsInComponent = nil;
    self.widthForComponent = nil;
    self.rowHeightForComponent = nil;
    self.titleForRowForComponent = nil;
    self.attributedTitleForRowForComponent = nil;
    self.viewForRowForComponentReuseView = nil;
    self.didSelectRowInComponent = nil;
    [super dealloc];
}

+ (NSString *)createWithAppId:(NSString *)appId
              numOfComponents:(NSString *)numOfComponents
         numOfRowsInComponent:(NSString *)numOfRowsInComponent
            widthForComponent:(NSString *)widthForComponent
        rowHeightForComponent:(NSString *)rowHeightForComponent
      titleForRowForComponent:(NSString *)titleForRowForComponent
attributedTitleForRowForComponent:(NSString *)attributedTitleForRowForComponent
viewForRowForComponentReuseView:(NSString *)viewForRowForComponentReuseView
      didSelectRowInComponent:(NSString *)didSelectRowInComponent
{
    id<ScriptInteraction> si = [LuaAppRunner scriptInteractionWithAppId:appId];
    PickerViewImpl *tmpPickerView = [[[PickerViewImpl alloc] init] autorelease];
    tmpPickerView.delegate = [PickerViewImplEventProxy sharedInstance];
    tmpPickerView.dataSource = [PickerViewImplEventProxy sharedInstance];
    NSString *objId = [LuaGroupedObjectManager addObject:tmpPickerView group:appId];
    if(numOfComponents.length != 0){
        [tmpPickerView setNumOfComponents:^NSInteger{
            return [[si callFunction:numOfComponents parameters:nil] intValue];
        }];
    }
    if(numOfRowsInComponent.length != 0){
        [tmpPickerView setNumOfRowsInComponent:^NSInteger(NSInteger component) {
            return [[si callFunction:numOfRowsInComponent parameters:objId, [NSString stringWithFormat:@"%d", component], nil] intValue];
        }];
    }
    if(widthForComponent.length != 0){
        [tmpPickerView setWidthForComponent:^CGFloat(NSInteger component) {
            return [[si callFunction:widthForComponent parameters:objId, [NSString stringWithFormat:@"%d", component], nil] floatValue];
        }];
    }
    if(rowHeightForComponent.length != 0){
        [tmpPickerView setRowHeightForComponent:^CGFloat(NSInteger component) {
            return [[si callFunction:rowHeightForComponent parameters:objId, [NSString stringWithFormat:@"%d", component], nil] floatValue];
        }];
    }
    if(titleForRowForComponent.length != 0){
        [tmpPickerView setTitleForRowForComponent:^NSString *(NSInteger row, NSInteger component) {
            return [si callFunction:titleForRowForComponent
                         parameters:objId, [NSString stringWithFormat:@"%d", row], [NSString stringWithFormat:@"%d", component], nil];
        }];
    }
    if(attributedTitleForRowForComponent.length != 0){
        [tmpPickerView setAttributedTitleForRowForComponent:^NSAttributedString *(NSInteger row, NSInteger component) {
            NSString *stringId = [si callFunction:attributedTitleForRowForComponent
                                    parameters:objId, [NSString stringWithFormat:@"%d", row], [NSString stringWithFormat:@"%d", component], nil];
            NSAttributedString *tmp = [[LuaGroupedObjectManager objectWithId:stringId group:appId] retain];
            [LuaGroupedObjectManager releaseObjectWithId:stringId group:appId];
            return [tmp autorelease];
        }];
    }
    if(viewForRowForComponentReuseView.length != 0){
        [tmpPickerView setViewForRowForComponentReuseView:^UIView *(NSInteger row, NSInteger component, UIView *reuseView) {
            NSString *reuseViewId = [LuaGroupedObjectManager addObject:reuseView group:appId];
            NSString *viewId = [si callFunction:viewForRowForComponentReuseView
                                     parameters:objId, [NSString stringWithFormat:@"%d", row], [NSString stringWithFormat:@"%d", component], reuseViewId, nil];
            UIView *view = [[LuaGroupedObjectManager objectWithId:viewId group:appId] retain];
            [LuaGroupedObjectManager releaseObjectWithId:viewId group:appId];
            return [view autorelease];
        }];
    }
    if(didSelectRowInComponent.length != 0){
        [tmpPickerView setDidSelectRowInComponent:^(NSInteger row, NSInteger component) {
            [si callFunction:didSelectRowInComponent parameters:objId, nil];
        }];
    }
    
    return objId;
}

@end
