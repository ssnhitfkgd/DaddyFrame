//
//  DDCrashFoundation.h
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface DDCrashFoundation : NSObject

+ (void)exchangeOriginalMethod:(Method)originalMethod withNewMethod:(Method)newMethod;
@end

@interface NSArray (Safe)
+ (Method)methodOfSelector:(SEL)selector;
- (id)_objectAtIndex:(NSUInteger)index;
@end

@interface NSMutableArray (Safe)

+ (Method)methodOfSelector:(SEL)selector;
- (void)_addObject:(id)object;
- (id)_objectAtIndex:(NSUInteger)index;
- (void)_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
@end


@interface NSMutableDictionary (Safe)

+ (Method)methodOfSelector:(SEL)selector;
- (void)_setObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)_removeObjectForKey:(id)sKey;
- (void)_setValue:(id)sObject forKey:(id <NSCopying>)sKey;
@end


@interface UIView (Safe)

+ (Method)methodOfSelector:(SEL)selector;
- (void)_addSubview:(UIView *)view;
@end


@interface NSNumber (Safe)

+ (Method)methodOfSelector:(SEL)selector;
- (BOOL)_isEqualToNumber:(NSNumber *)sNumber;
@end


@interface NSMutableString(Safe)

+ (Method)methodOfSelector:(SEL)selector;
- (void)_appendString:(NSString *)sString;
- (void)_appendFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (void)_setString:(NSString *)sString;
- (void)_insertString:(NSString *)sString atIndex:(NSUInteger)index;
@end


@interface NSDictionary (Safe)

+ (Method)methodOfSelector:(SEL)selector;
- (id)_objectForKey:(id)aKey;

@end
