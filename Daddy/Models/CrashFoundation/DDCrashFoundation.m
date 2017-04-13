//
//  DDCrashFoundation.m
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import "DDCrashFoundation.h"
#import "FMLogger.h"

@implementation  DDCrashFoundation

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeOriginalMethod:[NSArray methodOfSelector:@selector(objectAtIndex:)] withNewMethod:[NSArray methodOfSelector:@selector(_objectAtIndex:)]];
//
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(objectAtIndex:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(_objectAtIndex:)]];
        
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(addObject:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(_addObject:)]];
        
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(replaceObjectAtIndex:withObject:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(_replaceObjectAtIndex:withObject:)]];

        [self exchangeOriginalMethod:[NSMutableDictionary methodOfSelector:@selector(setObject:forKey:)] withNewMethod:[NSMutableDictionary methodOfSelector:@selector(_setObject:forKey:)]];
        
//        [self exchangeOriginalMethod:[NSMutableDictionary methodOfSelector:@selector(setValue:forKey:)] withNewMethod:[NSMutableDictionary methodOfSelector:@selector(_setValue:forKey:)]];
        
        [self exchangeOriginalMethod:[NSMutableDictionary methodOfSelector:@selector(removeObjectForKey:)] withNewMethod:[NSMutableDictionary methodOfSelector:@selector(_removeObjectForKey:)]];
        
        [self exchangeOriginalMethod:[NSMutableString methodOfSelector:@selector(appendString:)] withNewMethod:[NSMutableString methodOfSelector:@selector(_appendString:)]];
       
        [self exchangeOriginalMethod:[NSMutableString methodOfSelector:@selector(insertString:atIndex:)] withNewMethod:[NSMutableString methodOfSelector:@selector(_insertString:atIndex:)]];
        
        [self exchangeOriginalMethod:[NSMutableString methodOfSelector:@selector(setString:)] withNewMethod:[NSMutableString methodOfSelector:@selector(_setString:)]];
    
        [self exchangeOriginalMethod:[NSMutableString methodOfSelector:@selector(appendFormat:)] withNewMethod:[NSMutableString methodOfSelector:@selector(_appendFormat:)]];
        
        [self exchangeOriginalMethod:([UIView methodOfSelector:@selector(addSubview:)]) withNewMethod:([UIView methodOfSelector:@selector(_addSubview:)])];
        
        [self exchangeOriginalMethod:[NSNumber methodOfSelector:@selector(isEqualToNumber:)] withNewMethod:[NSNumber methodOfSelector:@selector(_isEqualToNumber:)]];
        
        //by king
        [self exchangeOriginalMethod:[NSNumber methodOfSelector:@selector(objectForKey:)] withNewMethod:[NSNumber methodOfSelector:@selector(_objectForKey:)]];

    });
}

+ (void)exchangeOriginalMethod:(Method)originalMethod withNewMethod:(Method)newMethod
{
    method_exchangeImplementations(originalMethod, newMethod);
}

@end


#pragma mark - NSArray
@implementation NSArray (Safe)

+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), selector);
}

- (id)_objectAtIndex:(NSUInteger)index
{
    if (index >= [self count])
    {
        FMLoggerError(@"%@",[NSString stringWithFormat:@"index[%ld] >= count[%ld]", (unsigned long)index, (unsigned long)[self count]]);
        return nil;
    }
    
    return [self _objectAtIndex:index];
}

@end


#pragma mark - NSMutableArray
@implementation NSMutableArray (Safe)

+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), selector);
}

- (void)_addObject:(id)object
{
    if (object)
    {
        [self _addObject:object];
    }
}


- (id)_objectAtIndex:(NSUInteger)index
{
    if (index >= [self count])
    {
        FMLoggerError(@"%@",[NSString stringWithFormat:@"index[%ld] >= count[%ld]", (unsigned long)index, (unsigned long)[self count]]);
        return nil;
    }
    
    return [self _objectAtIndex:index];
}

- (void)_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    
    if (index >= [self count])
    {
        FMLoggerError(@"%@",[NSString stringWithFormat:@"index[%ld] >= count[%ld]", (unsigned long)index, (unsigned long)[self count]]);
        return;
    }
    
    if (!anObject)
    {
        FMLoggerError(@"%@",@"anObject is nil");
        return;
    }
    
    [self _replaceObjectAtIndex:index withObject:anObject];
}

@end


#pragma mark - NSMutableDictionary
@implementation NSMutableDictionary (Safe)

+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), selector);
}

- (void)_removeObjectForKey:(id)sKey
{
    if (!sKey)
    {
        FMLoggerError(@"sKey is nil");
        
        return;
    }
    
    [self _removeObjectForKey:sKey];
}

- (void)_setObject:(id)sObject forKey:(id <NSCopying>)sKey
{
    if (!sObject)
    {
        return;
    }
    
    if (!sKey)
    {
        return;
    }
    
    [self _setObject:sObject forKey:sKey];
}

- (void)_setValue:(id)sObject forKey:(id <NSCopying>)sKey
{
    if (!sObject)
    {
        FMLoggerError(@"sObject is nil");
        return;
    }
    
    if (!sKey)
    {
        FMLoggerError(@"sKey is nil");
        return;
    }
    
    [self _setValue:sObject forKey:sKey];
}
@end


#pragma mark - UIView
@implementation UIView (Safe)

+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"UIView"), selector);
}

- (void)_addSubview:(UIView *)view
{
    if(!view)
    {
        return;
    }
    
    if (view && self != view) {
        [self _addSubview:view];
    }
}

@end


@implementation NSMutableString (Safe)

- (void)_appendString:(NSString *)sString
{
    if (!sString)
    {
        FMLoggerError(@"sString is nil");
        
        return;
    }
    
    [self _appendString:sString];
}

- (void)_appendFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)
{
    if (!format)
    {
        FMLoggerError(@"sString is nil");
        return;
    }
    
    va_list arguments;
    va_start(arguments, format);
    NSString *formatStr = [[NSString alloc]initWithFormat:format arguments:arguments];
    [self _appendFormat:@"%@",formatStr];
    va_end(arguments);
}

- (void)_setString:(NSString *)sString
{
    if (!sString)
    {
        FMLoggerError(@"sString is nil");
        return;
    }
    
    [self _setString:sString];
}

- (void)_insertString:(NSString *)sString atIndex:(NSUInteger)index
{
    if (index > [self length])
    {
        FMLoggerError(@"%@",[NSString stringWithFormat:@"index[%ld] > length[%ld]", (unsigned long)index, (unsigned long)[self length]]);
        return;
    }
    
    if (!sString)
    {
        FMLoggerError(@"sString is nil");
        return;
    }
    
    [self _insertString:sString atIndex:index];
}

+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSCFConstantString"),selector);
}

@end


#pragma mark - NSNumber
@implementation  NSNumber (Safe)

+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSCFNumber"),selector);
}

- (BOOL)_isEqualToNumber:(NSNumber *)sNumber
{
    if (!sNumber)
    {
        FMLoggerError(@"sNumber is nil");
        return NO;
    }
    
    return [self _isEqualToNumber:sNumber];
}

@end


//by king
#pragma mark - NSDictionary
@implementation NSDictionary (Safe)

+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), selector);
}

- (id)_objectForKey:(id)aKey
{
    id object = [self _objectForKey:aKey];
    if ([NSNull isEqual:object] || [@"<null>" isEqualToString:[object description]] || [@"(null)" isEqualToString:[object description]])
    {
        return @"";
    }
    return object;
}

@end
