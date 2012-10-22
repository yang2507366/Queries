//
//  RTProperty.m
//  RuntimeUtils
//
//  Created by yangzexin on 12-10-17.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import "RTProperty.h"
#import "RuntimeUtils.h"

@interface RTProperty ()

@property(nonatomic, copy)NSString *attributes;
@property(nonatomic, copy)NSString *objectTypeName;

@end

@implementation RTProperty

@synthesize objc_property;
@synthesize name;
@synthesize type;
@synthesize accessType;
@synthesize attributes;
@synthesize objectTypeName;

- (void)dealloc
{
    [name release];
    [attributes release];
    self.objectTypeName = nil;
    [super dealloc];
}

- (id)initWithProperty:(objc_property_t)property
{
    self = [super init];
    
    self.objc_property = property;
    
    return self;
}

- (void)setObjc_property:(objc_property_t)property
{
    objc_property = property;
    
    if(objc_property){
        const char *cname = property_getName(property);
        const char *cattributes = property_getAttributes(property);
        
        name = [[NSString stringWithFormat:@"%s", cname] retain];
        attributes = [[NSString stringWithFormat:@"%s", cattributes] retain];
        
        NSArray *attributeList = [self.attributes componentsSeparatedByString:@","];
        if(attributeList.count > 1){
            type = [self.class typeOfDesc:[attributeList objectAtIndex:0]];
            if(self.type == RTPropertyTypeObject){
                self.objectTypeName = [self.class objectTypeNameOfDesc:[attributeList objectAtIndex:0]];
            }
            accessType = [self.class accessTypeOfDesc:[attributeList objectAtIndex:1]];
        }
    }
}

- (void)setWithString:(NSString *)value targetObject:(id<NSObject>)obj
{
    if(self.accessType == RTPropertyAccessTypeReadOnly){
        return;
    }
    NSString *propertyName = self.name;
    RTPropertyType ptype = self.type;
    if(ptype != RTPropertyTypeUnknown){
        if(ptype == RTPropertyTypeArray){
        }else if(ptype == RTPropertyTypeBit){
            // no implementation
        }else if(ptype == RTPropertyTypeBOOL){
            BOOL b = [value boolValue];
            value = [value lowercaseString];
            value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(!b && [value isEqualToString:@"true"]){
                b = YES;
            }
            if(!b && [value isEqualToString:@"yes"]){
                b = YES;
            }
            if(!b && [value isEqualToString:@"1"]){
                b = YES;
            }
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&b];
        }else if(ptype == RTPropertyTypeChar){
            NSString *lowerValue = [value lowercaseString];
            if([lowerValue isEqualToString:@"true"] || [lowerValue isEqualToString:@"yes"] ){
                BOOL b = YES;
                [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&b];
            }else if([lowerValue isEqualToString:@"no"] || [lowerValue isEqualToString:@"false"]){
                BOOL b = NO;
                [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&b];
            }else{
                if(value.length != 0){
                    unsigned char ch = [value characterAtIndex:0];
                    [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&ch];
                }
            }
        }else if(ptype == RTPropertyTypeCharPoint){
            // no implementation
        }else if(ptype == RTPropertyTypeClass){
            Class class = NSClassFromString(value);
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&class];
        }else if(ptype == RTPropertyTypeDouble){
            double d = [value doubleValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&d];
        }else if(ptype == RTPropertyTypeFloat){
            float f = [value floatValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&f];
        }else if(ptype == RTPropertyTypeInt){
            int i = [value intValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&i];
        }else if(ptype == RTPropertyTypeLong){
            long l = [value longLongValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&l];
        }else if(ptype == RTPropertyTypeLongLong){
            long long l = [value longLongValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&l];
        }else if(ptype == RTPropertyTypeObject){
            if([self.objectTypeName isEqualToString:@"NSString"]){
                [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&value];
            }else{
                // no implementation
            }
        }else if(ptype == RTPropertyTypePointerToType){
            void *pointer = value;
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&pointer];
        }else if(ptype == RTPropertyTypeSEL){
            // no implementation
        }else if(ptype == RTPropertyTypeShort){
            short s = [value intValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&s];
        }else if(ptype == RTPropertyTypeStructure){
            // no implementation
        }else if(ptype == RTPropertyTypeUnion){
            // no implementation
        }else if(ptype == RTPropertyTypeUnknown){
            // no implementation
        }else if(ptype == RTPropertyTypeUnsignedChar){
            if(value.length != 0){
                unsigned char c = [value characterAtIndex:0];
                [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&c];
            }
        }else if(ptype == RTPropertyTypeUnsignedInt){
            unsigned int i = [value intValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&i];
        }else if(ptype == RTPropertyTypeUnsignedLong){
            long l = [value longLongValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&l];
        }else if(ptype == RTPropertyTypeUnsignedLongLong){
            long long l = [value longLongValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&l];
        }else if(ptype == RTPropertyTypeUnsignedShort){
            unsigned short s = [value intValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&s];
        }else if(ptype == RTPropertyTypeVoid){
            // no implementation
        }
    }
}

- (NSString *)getStringFromTargetObject:(id<NSObject>)obj
{
    NSString *propertyName = self.name;
    RTPropertyType ptype = self.type;
    
    SEL targetSelector = [RuntimeUtils.class selectorForGetterWithPropertyName:propertyName];
    if(![obj respondsToSelector:targetSelector]){
        return nil;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[obj.class instanceMethodSignatureForSelector:targetSelector]];
    invocation.target = obj;
    invocation.selector = targetSelector;
    [invocation invoke];
    
    if(ptype == RTPropertyTypeArray){
        // no implementation
    }else if(ptype == RTPropertyTypeBit){
        // no implementation
    }else if(ptype == RTPropertyTypeBOOL){
        bool b;
        [invocation getReturnValue:&b];
        return [NSString stringWithFormat:@"%@", b == 0 ? @"NO" : @"YES"];
    }else if(ptype == RTPropertyTypeChar){
        char c;
        [invocation getReturnValue:&c];
        return [NSString stringWithFormat:@"%c", c];
    }else if(ptype == RTPropertyTypeCharPoint){
        // no implementation
    }else if(ptype == RTPropertyTypeClass){
        Class class;
        [invocation getReturnValue:&class];
        return NSStringFromClass(class);
    }else if(ptype == RTPropertyTypeDouble){
        double d;
        [invocation getReturnValue:&d];
        return [NSString stringWithFormat:@"%f", d];
    }else if(ptype == RTPropertyTypeFloat){
        float f;
        [invocation getReturnValue:&f];
        return [NSString stringWithFormat:@"%f", f];
    }else if(ptype == RTPropertyTypeInt){
        int i;
        [invocation getReturnValue:&i];
        return [NSString stringWithFormat:@"%d", i];
    }else if(ptype == RTPropertyTypeLong){
        long l;
        [invocation getReturnValue:&l];
        return [NSString stringWithFormat:@"%ld", l];
    }else if(ptype == RTPropertyTypeLongLong){
        long long l;
        [invocation getReturnValue:&l];
        return [NSString stringWithFormat:@"%lld", l];
    }else if(ptype == RTPropertyTypeObject){
        id obj;
        [invocation getReturnValue:&obj];
        return [NSString stringWithFormat:@"%@", obj];
    }else if(ptype == RTPropertyTypePointerToType){
        // no implementation
    }else if(ptype == RTPropertyTypeSEL){
        // no implementation
        SEL sel;
        [invocation getReturnValue:&sel];
        return NSStringFromSelector(sel);
    }else if(ptype == RTPropertyTypeShort){
        short s;
        [invocation getReturnValue:&s];
        return [NSString stringWithFormat:@"%d", s];
    }else if(ptype == RTPropertyTypeStructure){
        // no implementation
    }else if(ptype == RTPropertyTypeUnion){
        // no implementation
    }else if(ptype == RTPropertyTypeUnknown){
        // no implementation
    }else if(ptype == RTPropertyTypeUnsignedChar){
        unsigned char c;
        [invocation getReturnValue:&c];
        return [NSString stringWithFormat:@"%c", c];
    }else if(ptype == RTPropertyTypeUnsignedInt){
        unsigned int i;
        [invocation getReturnValue:&i];
        return [NSString stringWithFormat:@"%d", i];
    }else if(ptype == RTPropertyTypeUnsignedLong){
        unsigned long l;
        [invocation getReturnValue:&l];
        return [NSString stringWithFormat:@"%ld", l];
    }else if(ptype == RTPropertyTypeUnsignedLongLong){
        unsigned long long l;
        [invocation getReturnValue:&l];
        return [NSString stringWithFormat:@"%lld", l];
    }else if(ptype == RTPropertyTypeUnsignedShort){
        unsigned short s;
        [invocation getReturnValue:&s];
        return [NSString stringWithFormat:@"%d", s];
    }else if(ptype == RTPropertyTypeVoid){
        // no implementation
    }
    return nil;
}

+ (RTPropertyAccessType)accessTypeOfDesc:(NSString *)desc
{
    if(desc.length == 1){
        return [desc isEqualToString:@"R"] ? RTPropertyAccessTypeReadOnly : RTPropertyAccessTypeReadWrite;
    }
    return RTPropertyAccessTypeReadOnly;
}

+ (RTPropertyType)typeOfDesc:(NSString *)desc
{
    if([desc hasPrefix:@"T"] && desc.length > 1){
        const unsigned char ctype = [desc characterAtIndex:1];
        switch(ctype){
            case 'c':
                return RTPropertyTypeChar;
            case 'i':
                return RTPropertyTypeInt;
            case 's':
                return RTPropertyTypeShort;
            case 'l':
                return RTPropertyTypeLong;
            case 'q':
                return RTPropertyTypeLongLong;
            case 'C':
                return RTPropertyTypeUnsignedChar;
            case 'I':
                return RTPropertyTypeUnsignedInt;
            case 'S':
                return RTPropertyTypeUnsignedShort;
            case 'L':
                return RTPropertyTypeUnsignedLong;
            case 'Q':
                return RTPropertyTypeUnsignedLongLong;
            case 'f':
                return RTPropertyTypeFloat;
            case 'd':
                return RTPropertyTypeDouble;
            case 'B':
                return RTPropertyTypeBOOL;
            case 'v':
                return RTPropertyTypeVoid;
            case '*':
                return RTPropertyTypeCharPoint;
            case '@':
                return RTPropertyTypeObject;
            case '#':
                return RTPropertyTypeClass;
            case ':':
                return RTPropertyTypeSEL;
            case '[':
                return RTPropertyTypeArray;
            case '{':
                return RTPropertyTypeStructure;
            case '(':
                return RTPropertyTypeUnion;
            case 'b':
                return RTPropertyTypeBit;
            case '^':
                return RTPropertyTypePointerToType;
            case '?':
                return RTPropertyTypeUnknown;
            default:
                return RTPropertyTypeUnknown;
        }
    }
    return RTPropertyTypeUnknown;
}

+ (NSString *)objectTypeNameOfDesc:(NSString *)desc
{
    NSRange tmpRange = [desc rangeOfString:@"\""];
    if(tmpRange.location != NSNotFound){
        ++tmpRange.location;
        int startLocation = tmpRange.location;
        tmpRange.length = desc.length - tmpRange.location;
        tmpRange = [desc rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:tmpRange];
        if(tmpRange.location != NSNotFound){
            NSString *objectType = [desc substringWithRange:NSMakeRange(startLocation, tmpRange.location - startLocation)];
            return objectType;
        }
    }
    return nil;
}


@end
