//
//  PickerViewImpl.h
//  Queries
//
//  Created by yangzexin on 11/7/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScriptInteraction.h"
#import "LuaImplentatable.h"

@interface PickerView : UIPickerView <LuaImplentatable>

@property(nonatomic, copy)NSInteger(^numOfComponents)();
@property(nonatomic, copy)NSInteger(^numOfRowsInComponent)(NSInteger component);
@property(nonatomic, copy)CGFloat(^widthForComponent)(NSInteger component);
@property(nonatomic, copy)CGFloat(^rowHeightForComponent)(NSInteger component);
@property(nonatomic, copy)NSString *(^titleForRowForComponent)(NSInteger row, NSInteger component);
@property(nonatomic, copy)NSAttributedString *(^attributedTitleForRowForComponent)(NSInteger row, NSInteger component);
@property(nonatomic, copy)UIView *(^viewForRowForComponentReuseView)(NSInteger row, NSInteger component, UIView *reuseView);
@property(nonatomic, copy)void(^didSelectRowInComponent)(NSInteger row, NSInteger component);

+ (NSString *)create:(NSString *)appId;

@end
