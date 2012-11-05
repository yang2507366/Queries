//if(ctype == 'c'){//char
//}else if(ctype == 'i'){//integer
//}else if(ctype == 's'){//short
//}else if(ctype == 'l'){//long
//}else if(ctype == 'q'){//long long
//}else if(ctype == 'C'){//unsigned char
//}else if(ctype == 'I'){//unsigned int
//}else if(ctype == 'S'){//unsigned short
//}else if(ctype == 'L'){//unsigned long
//}else if(ctype == 'Q'){//unsigned long long
//}else if(ctype == 'f'){//float
//}else if(ctype == 'd'){//double
//}else if(ctype == 'B'){//bool
//}else if(ctype == 'v'){//void
//}else if(ctype == '*'){//char *
//}else if(ctype == '@'){//id
//}else if(ctype == '#'){//Class
//}else if(ctype == ':'){//SEL
//}else if(ctype == '['){//C array
//}else if(ctype == '{'){//struct
//}else if(ctype == '('){//union
//}else if(ctype == 'b'){//bit
//}else if(ctype == '^'){//pointer to type
//}else if(ctype == '?'){//unknown
//}

#import "MethodInvokerForLua.h"
#import "LuaGroupedObjectManager.h"
#import "LuaConstants.h"
#import "LuaCommonUtils.h"

@implementation MethodInvokerForLua

+ (NSString *)invokeWithObject:(id)object methodName:(NSString *)methodName parameters:(NSString *)firstParameter, ...
{
    if(firstParameter && ![methodName hasSuffix:@":"]){
        methodName = [NSString stringWithFormat:@"%@:", methodName];
    }
    SEL selector = NSSelectorFromString(methodName);
    NSMethodSignature *methodSignature = [object methodSignatureForSelector:selector];
    if(firstParameter && methodSignature){
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        invocation.target = object;
        invocation.selector = selector;
        
        va_list params;
        NSInteger i = 2;
        NSInteger numberOfArguments = [methodSignature numberOfArguments];
        va_start(params, firstParameter);
        for(NSString *tmpParam = firstParameter; tmpParam && i < numberOfArguments; tmpParam = va_arg(params, NSString *), ++i){
            const unsigned char ctype = *[methodSignature getArgumentTypeAtIndex:i];
            void *argumentData = NULL;
            if(ctype == 'c'){//char
                if(tmpParam.length != 0){
                    char c = [tmpParam characterAtIndex:0];
                    argumentData = &c;
                }
            }else if(ctype == 'i'){//integer
                int integer = [tmpParam intValue];
                argumentData = &integer;
            }else if(ctype == 's'){//short
                short s = [tmpParam intValue];
                argumentData = &s;
            }else if(ctype == 'l'){//long
                long l = [tmpParam longLongValue];
                argumentData = &l;
            }else if(ctype == 'q'){//long long
                long long ll = [tmpParam longLongValue];
                argumentData = &ll;
            }else if(ctype == 'C'){//unsigned char
                if(tmpParam.length != 0){
                    unsigned char uc = [tmpParam characterAtIndex:0];
                    argumentData = &uc;
                }
            }else if(ctype == 'I'){//unsigned int
                unsigned int ui = [tmpParam intValue];
                argumentData = &ui;
            }else if(ctype == 'S'){//unsigned short
                unsigned short us = [tmpParam intValue];
                argumentData = &us;
            }else if(ctype == 'L'){//unsigned long
                unsigned long ul = [tmpParam longLongValue];
                argumentData = &ul;
            }else if(ctype == 'Q'){//unsigned long long
                unsigned long long ull = [tmpParam longLongValue];
                argumentData = &ull;
            }else if(ctype == 'f'){//float
                float f = [tmpParam floatValue];
                argumentData = &f;
            }else if(ctype == 'd'){//double
                double d = [tmpParam doubleValue];
                argumentData = &d;
            }else if(ctype == 'B'){//bool
                int b = [tmpParam intValue];
                argumentData = &b;
            }else if(ctype == 'v'){//void
                
            }else if(ctype == '*'){//char *
                const char *string = [tmpParam UTF8String];
                argumentData = &string;
            }else if(ctype == '@'){//id
                id obj = [self getObject:tmpParam];
                argumentData = &obj;
            }else if(ctype == '#'){//Class
                Class class = NSClassFromString(tmpParam);
                argumentData = &class;
            }else if(ctype == ':'){//SEL
                SEL s = NSSelectorFromString(tmpParam);
                argumentData = &s;
            }else if(ctype == '['){//C array
            }else if(ctype == '{'){//struct
                NSLog(@"set struct:%s", [methodSignature getArgumentTypeAtIndex:i]);//未处理
            }else if(ctype == '('){//union
            }else if(ctype == 'b'){//bit
            }else if(ctype == '^'){//pointer to type
            }else if(ctype == '?'){//unknown
            }
            
            [invocation setArgument:argumentData atIndex:i];
        }
        va_end(params);
        
        [invocation invoke];
        if([methodSignature methodReturnLength] != 0){
            const char ctype = *[methodSignature methodReturnType];
            if(ctype == 'c'){//char
                char c;
                [invocation getReturnValue:&c];
                return [NSString stringWithFormat:@"%c", c];
            }else if(ctype == 'i'){//integer
                int i;
                [invocation getReturnValue:&i];
                return [NSString stringWithFormat:@"%d", i];
            }else if(ctype == 's'){//short
                short s;
                [invocation getReturnValue:&s];
                return [NSString stringWithFormat:@"%d", s];
            }else if(ctype == 'l'){//long
                long l;
                [invocation getReturnValue:&l];
                return [NSString stringWithFormat:@"%lu", l];
            }else if(ctype == 'q'){//long long
                long long l;
                [invocation getReturnValue:&l];
                return [NSString stringWithFormat:@"%llu", l];
            }else if(ctype == 'C'){//unsigned char
                unsigned char c;
                [invocation getReturnValue:&c];
                return [NSString stringWithFormat:@"%c", c];
            }else if(ctype == 'I'){//unsigned int
                unsigned int i;
                [invocation getReturnValue:&i];
                return [NSString stringWithFormat:@"%d", i];
            }else if(ctype == 'S'){//unsigned short
                unsigned short s;
                [invocation getReturnValue:&s];
                return [NSString stringWithFormat:@"%d", s];
            }else if(ctype == 'L'){//unsigned long
                unsigned long l;
                [invocation getReturnValue:&l];
                return [NSString stringWithFormat:@"%ld", l];
            }else if(ctype == 'Q'){//unsigned long long
                unsigned long long l;
                [invocation getReturnValue:&l];
                return [NSString stringWithFormat:@"%lld", l];
            }else if(ctype == 'f'){//float
                float f;
                [invocation getReturnValue:&f];
                return [NSString stringWithFormat:@"%f", f];
            }else if(ctype == 'd'){//double
                double d;
                [invocation getReturnValue:&d];
                return [NSString stringWithFormat:@"%f", d];
            }else if(ctype == 'B'){//bool
                bool b;
                [invocation getReturnValue:&b];
                return [NSString stringWithFormat:@"%@", b == 0 ? @"false" : @"true"];
            }else if(ctype == 'v'){//void
            }else if(ctype == '*'){//char *
                char *chars;
                [invocation getReturnValue:&chars];
                return [NSString stringWithFormat:@"%s", chars];
            }else if(ctype == '@'){//id
                id obj;
                [invocation getReturnValue:&obj];
                return obj;
            }else if(ctype == '#'){//Class
                Class class;
                [invocation getReturnValue:&class];
                return NSStringFromClass(class);
            }else if(ctype == ':'){//SEL
                SEL sel;
                [invocation getReturnValue:&sel];
                return NSStringFromSelector(sel);
            }else if(ctype == '['){//C array
            }else if(ctype == '{'){//struct
                NSLog(@"get struct:%s", [methodSignature methodReturnType]);//未处理
            }else if(ctype == '('){//union
            }else if(ctype == 'b'){//bit
            }else if(ctype == '^'){//pointer to type
            }else if(ctype == '?'){//unknown
            }
        }
    }
    return @"";
}

+ (id)getObject:(NSString *)objectId
{
    return objectId;
}

+ (NSString *)objectIdOfObject:(id)obj
{
    return [NSString stringWithFormat:@"%@", obj];
}

+ (NSString *)invokeWithGroup:(NSString *)group objectId:(NSString *)objectId methodName:(NSString *)methodName parameters:(NSArray *)parameters
{
    id object = [LuaGroupedObjectManager objectWithId:objectId group:group];
    if(parameters.count != 0 && ![methodName hasSuffix:@":"]){
        methodName = [NSString stringWithFormat:@"%@:", methodName];
    }
    SEL selector = NSSelectorFromString(methodName);
    NSMethodSignature *methodSignature = [object methodSignatureForSelector:selector];
    if(methodSignature){
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        invocation.target = object;
        invocation.selector = selector;
        
        NSInteger numberOfArguments = [methodSignature numberOfArguments];
        for(NSInteger i = 2, j = 0; i < numberOfArguments && j < parameters.count; ++i, ++j){
            NSString *tmpParam = [parameters objectAtIndex:j];
            const unsigned char ctype = *[methodSignature getArgumentTypeAtIndex:i];
            void *argumentData = NULL;
            if(ctype == 'c'){//char
                if(tmpParam.length != 0){
                    char c = [tmpParam characterAtIndex:0];
                    
                    if(tmpParam.length == 2 || tmpParam.length == 3){
                        tmpParam = [tmpParam lowercaseString];
                        if([tmpParam isEqualToString:@"yes"]){
                            c = YES;
                        }else if([tmpParam isEqualToString:@"no"]){
                            c = NO;
                        }
                    }
                    argumentData = &c;
                }
            }else if(ctype == 'i'){//integer
                int integer = [tmpParam intValue];
                argumentData = &integer;
            }else if(ctype == 's'){//short
                short s = [tmpParam intValue];
                argumentData = &s;
            }else if(ctype == 'l'){//long
                long l = [tmpParam longLongValue];
                argumentData = &l;
            }else if(ctype == 'q'){//long long
                long long ll = [tmpParam longLongValue];
                argumentData = &ll;
            }else if(ctype == 'C'){//unsigned char
                if(tmpParam.length != 0){
                    unsigned char uc = [tmpParam characterAtIndex:0];
                    argumentData = &uc;
                }
            }else if(ctype == 'I'){//unsigned int
                unsigned int ui = [tmpParam intValue];
                argumentData = &ui;
            }else if(ctype == 'S'){//unsigned short
                unsigned short us = [tmpParam intValue];
                argumentData = &us;
            }else if(ctype == 'L'){//unsigned long
                unsigned long ul = [tmpParam longLongValue];
                argumentData = &ul;
            }else if(ctype == 'Q'){//unsigned long long
                unsigned long long ull = [tmpParam longLongValue];
                argumentData = &ull;
            }else if(ctype == 'f'){//float
                float f = [tmpParam floatValue];
                argumentData = &f;
            }else if(ctype == 'd'){//double
                double d = [tmpParam doubleValue];
                argumentData = &d;
            }else if(ctype == 'B'){//bool
                int b = [tmpParam intValue];
                argumentData = &b;
            }else if(ctype == 'v'){//void
                
            }else if(ctype == '*'){//char *
                const char *string = [tmpParam UTF8String];
                argumentData = &string;
            }else if(ctype == '@'){//id
                id obj = tmpParam;//****************************
                if([LuaCommonUtils isObjCObject:tmpParam]){
                    obj = [LuaGroupedObjectManager objectWithId:tmpParam group:group];
                }
                argumentData = &obj;
            }else if(ctype == '#'){//Class
                Class class = NSClassFromString(tmpParam);
                argumentData = &class;
            }else if(ctype == ':'){//SEL
                SEL s = NSSelectorFromString(tmpParam);
                argumentData = &s;
            }else if(ctype == '['){//C array
            }else if(ctype == '{'){//struct
                NSLog(@"set struct:%s", [methodSignature getArgumentTypeAtIndex:i]);//未处理
            }else if(ctype == '('){//union
            }else if(ctype == 'b'){//bit
            }else if(ctype == '^'){//pointer to type
            }else if(ctype == '?'){//unknown
            }
            
            [invocation setArgument:argumentData atIndex:i];
        }
        
        [invocation invoke];
        if([methodSignature methodReturnLength] != 0){
            const char ctype = *[methodSignature methodReturnType];
            if(ctype == 'c'){//char
                char c;
                [invocation getReturnValue:&c];
                return [NSString stringWithFormat:@"%c", c];
            }else if(ctype == 'i'){//integer
                int i;
                [invocation getReturnValue:&i];
                return [NSString stringWithFormat:@"%d", i];
            }else if(ctype == 's'){//short
                short s;
                [invocation getReturnValue:&s];
                return [NSString stringWithFormat:@"%d", s];
            }else if(ctype == 'l'){//long
                long l;
                [invocation getReturnValue:&l];
                return [NSString stringWithFormat:@"%lu", l];
            }else if(ctype == 'q'){//long long
                long long l;
                [invocation getReturnValue:&l];
                return [NSString stringWithFormat:@"%llu", l];
            }else if(ctype == 'C'){//unsigned char
                unsigned char c;
                [invocation getReturnValue:&c];
                return [NSString stringWithFormat:@"%c", c];
            }else if(ctype == 'I'){//unsigned int
                unsigned int i;
                [invocation getReturnValue:&i];
                return [NSString stringWithFormat:@"%d", i];
            }else if(ctype == 'S'){//unsigned short
                unsigned short s;
                [invocation getReturnValue:&s];
                return [NSString stringWithFormat:@"%d", s];
            }else if(ctype == 'L'){//unsigned long
                unsigned long l;
                [invocation getReturnValue:&l];
                return [NSString stringWithFormat:@"%ld", l];
            }else if(ctype == 'Q'){//unsigned long long
                unsigned long long l;
                [invocation getReturnValue:&l];
                return [NSString stringWithFormat:@"%lld", l];
            }else if(ctype == 'f'){//float
                float f;
                [invocation getReturnValue:&f];
                return [NSString stringWithFormat:@"%f", f];
            }else if(ctype == 'd'){//double
                double d;
                [invocation getReturnValue:&d];
                return [NSString stringWithFormat:@"%f", d];
            }else if(ctype == 'B'){//bool
                bool b;
                [invocation getReturnValue:&b];
                return [NSString stringWithFormat:@"%@", b == 0 ? @"false" : @"true"];
            }else if(ctype == 'v'){//void
            }else if(ctype == '*'){//char *
                char *chars;
                [invocation getReturnValue:&chars];
                return [NSString stringWithFormat:@"%s", chars];
            }else if(ctype == '@'){//id
                id obj;
                [invocation getReturnValue:&obj];
                if(obj){
                    if([obj isKindOfClass:NSString.class]){
                        return obj;
                    }else{
                        NSString *objId = [LuaGroupedObjectManager addObject:obj group:group];
                        return objId;
                    }
                }
                return obj;//*************************************
            }else if(ctype == '#'){//Class
                Class class;
                [invocation getReturnValue:&class];
                return NSStringFromClass(class);
            }else if(ctype == ':'){//SEL
                SEL sel;
                [invocation getReturnValue:&sel];
                return NSStringFromSelector(sel);
            }else if(ctype == '['){//C array
            }else if(ctype == '{'){//struct
                NSLog(@"get struct:%s", [methodSignature methodReturnType]);//未处理
            }else if(ctype == '('){//union
            }else if(ctype == 'b'){//bit
            }else if(ctype == '^'){//pointer to type
            }else if(ctype == '?'){//unknown
            }
        }
    }
    return @"";
}

+ (NSString *)createObjectWithGroup:(NSString *)group
                          className:(NSString *)className
                     initMethodName:(NSString *)initMethodName
                         parameters:(NSArray *)parameters
{
    /**
     根据className创建对象，先创建一个未初始化的对象，加入到对象池中，然后调用初始化方法进行初始化，如果初始化失败的话，就将该为初始化的对象移除
     */
    Class class = NSClassFromString(className);
    id object = [[class alloc] autorelease];
    if(object){
        NSString *objId = [LuaGroupedObjectManager addObject:object group:group];
        NSString *resultObjId = [self invokeWithGroup:group objectId:objId methodName:initMethodName parameters:parameters];
        if(resultObjId.length == 0){
            [LuaGroupedObjectManager removeObjectWithId:objId group:group];
        }
        
        return resultObjId;
    }
    
    return @"";
}

+ (NSString *)invokeClassMethodWithGroup:(NSString *)group
                               className:(NSString *)className
                              methodName:(NSString *)methodName
                              parameters:(NSArray *)parameters
{
    Class class = NSClassFromString(className);
    SEL selector = NSSelectorFromString(methodName);
    if(class && selector){
        id object = class;
        NSString *objId = [LuaGroupedObjectManager addObject:object group:group];
        NSString *resultObjId = [self invokeWithGroup:group objectId:objId methodName:methodName parameters:parameters];
        
        [LuaGroupedObjectManager removeObjectWithId:objId group:group];
        
        return resultObjId;
    }
    return @"";
}

@end
