//
//  NSStringAdditions.m
//  Wall
//
//  Created by wang on 12-6-2.
//  Copyright (c) 2012年 草莓. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreFoundation/CFURL.h>

@implementation NSNull (Addtion)
- (NSInteger)length
{
    return 0;
}
@end

@implementation NSString(Addtion)

/**
 *  比较字符内容是否相同
 */
- (BOOL) myIsEqual:(NSString *) other
{
    //  判断是不同一个字符串
    if (self == other) {
        return YES;
    }
    //  如果长度不同内容肯定不同
    if (self.length != other.length) {
        return NO;
    }
    //  一个一个的比较
    for (int i = 0; i < self.length; i++) {
        unichar myC  = [self characterAtIndex:i];
        unichar otherC = [other characterAtIndex:i];
        if (myC != otherC) {
            return NO;
        }
    }
    
    return YES;
}


+ (NSString *)getMD5ForStr:(NSString *)str
{
    if (str == nil) {
        return nil;
    }
    const char *ptr = [str UTF8String];
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    return output;
}

- (NSString *)md5Value
{
    const char *ptr = [self UTF8String];
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    return output;
}

- (NSString *)js_stringByTrimingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)js_numberOfLines
{
    return [[self componentsSeparatedByString:@"\n"] count] + 1;
}

- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8));
    return encodedString;
}
@end


@implementation NSString (EKBAdditons)

- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)width {
    return [self heightWithFont:font constrainedWidth:width lineBreakMode:NSLineBreakByTruncatingTail];
}

- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)width numberOfLines:(NSUInteger)numberOfLines{
    
    CGFloat lineHeight = font.lineHeight * numberOfLines;
    
    CGFloat realHeight = [self heightWithFont:font constrainedWidth:width lineBreakMode:NSLineBreakByTruncatingTail];
    
    return MIN(lineHeight, realHeight);
}

- (CGFloat)heightWithFont:(UIFont *)font constrainedWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    return [self boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    
}

- (CGFloat)widthWithFont:(UIFont *)font constrainedWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode {

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};

    return [self boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
}

-(CGSize)sizeWithFont:(UIFont *)font constrainedWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    return [self boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}

@end



@implementation NSString(UnicodeLength)

+ (NSUInteger) unicodeLengthOfString:(NSString *)string
{
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < string.length; i++) {
        
        
        unichar uc = [string characterAtIndex:i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength / 2;
    
    if(asciiLength % 2) {
        unicodeLength++;
    }
    NSLog(@"length %lu", (unsigned long)unicodeLength);
    
    return unicodeLength;
}

@end
