//
//  TextField.h
//  Queries
//
//  Created by yangzexin on 11/18/12.
//  Copyright (c) 2012 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuaImplentatable.h"

@interface LITextField : UITextField <LuaImplentatable>

@property(nonatomic, copy)NSString *shouldBeginEditing;
@property(nonatomic, copy)NSString *didBeginEditing;
@property(nonatomic, copy)NSString *shouldEndEditing;
@property(nonatomic, copy)NSString *didEndEditing;
@property(nonatomic, copy)NSString *shouldChangeCharactersInRange;
@property(nonatomic, copy)NSString *shouldClear;
@property(nonatomic, copy)NSString *shouldReturn;

@end
