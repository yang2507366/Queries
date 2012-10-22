//
//  RTProperty.h
//  RuntimeUtils
//
//  Created by yangzexin on 12-10-17.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef enum{
    RTPropertyTypeObject,
    RTPropertyTypeChar,
    RTPropertyTypeInt,
    RTPropertyTypeShort,
    RTPropertyTypeLong,
    RTPropertyTypeLongLong,
    RTPropertyTypeUnsignedChar,
    RTPropertyTypeUnsignedInt,
    RTPropertyTypeUnsignedShort,
    RTPropertyTypeUnsignedLong,
    RTPropertyTypeUnsignedLongLong,
    RTPropertyTypeFloat,
    RTPropertyTypeDouble,
    RTPropertyTypeBOOL,
    RTPropertyTypeVoid,
    RTPropertyTypeCharPoint,
    RTPropertyTypeClass,
    RTPropertyTypeSEL,
    RTPropertyTypeArray,
    RTPropertyTypeStructure,
    RTPropertyTypeUnion,
    RTPropertyTypeBit,
    RTPropertyTypePointerToType,
    RTPropertyTypeUnknown,
}RTPropertyType;

typedef enum{
    RTPropertyAccessTypeReadOnly,
    RTPropertyAccessTypeReadWrite,
}RTPropertyAccessType;

@interface RTProperty : NSObject

- (id)initWithProperty:(objc_property_t)property;

@property(nonatomic, assign)objc_property_t objc_property;
@property(nonatomic, readonly)NSString *name;
@property(nonatomic, readonly)RTPropertyType type;
@property(nonatomic, readonly)RTPropertyAccessType accessType;

- (void)setWithString:(NSString *)string targetObject:(id<NSObject>)obj;
- (NSString *)getStringFromTargetObject:(id<NSObject>)obj;

@end
