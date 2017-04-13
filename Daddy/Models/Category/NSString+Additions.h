//
//  NSStringAdditions.h
//  Wall
//
//  Created by wang on 12-6-2.
//  Copyright (c) 2012年 草莓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Additions.h"

@interface NSNull (Addtion)
- (NSInteger)length;
@end


@interface NSString (EKBAdditons)
- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)width;// Uses UILineBreakModeTailTruncation
- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)width numberOfLines:(NSUInteger)numberOfLines;
- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGFloat)widthWithFont:(UIFont *)font constrainedWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode ;
- (CGSize)sizeWithFont:(UIFont *)font constrainedWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end


@interface NSString(Addtion)

/**
 *  比较字符内容是否相同
 */
- (BOOL) myIsEqual:(NSString *) other;

+ (NSString *)getMD5ForStr:(NSString *)str;

- (NSString *)md5Value;

- (NSString *)js_stringByTrimingWhitespace;

- (NSUInteger)js_numberOfLines;
@end



@interface NSString(UnicodeLength)

+ (NSUInteger) unicodeLengthOfString:(NSString *)string;

@end