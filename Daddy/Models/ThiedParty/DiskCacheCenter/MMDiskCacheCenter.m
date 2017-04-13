//
//  MMCacheCenter.m
//  MoreMore
//
//  Created by Jagie on 1/12/14.
//  Copyright (c) 2014 Jagie. All rights reserved.
//

#import "MMDiskCacheCenter.h"
#import "DateHelper.h"
#import "FileHelper.h"

static const NSInteger kCacheMaxCacheAge = 7; //7 days

@implementation MMDiskCacheCenter
NS_INLINE NSString * getCacheDir(){
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths objectAtIndex:0];
    return [FileHelper getApiCachePath];
}


+ (id)sharedInstance {
    static MMDiskCacheCenter *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [self new];
    });
    
    return __sharedInstance;
}

- (id)cacheForKey:(NSString *)key dataType:(Class)dataClass{
    
    NSString *cacheDir = getCacheDir();
    NSString *cacheFile = [cacheDir stringByAppendingPathComponent:key];
    NSData * data = [NSData dataWithContentsOfFile:cacheFile];
    if (data != nil) {
        
        id cache = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return cache;
    }
    return nil;
   
}

- (void)setCache:(id)cache forKey:(NSString *)key {
    
    @try {
        NSAssert(key != nil, @"cache key can't be nil");
        NSString *cacheDir = getCacheDir();
        NSString *cacheFile = [cacheDir stringByAppendingPathComponent:key];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cache];
        BOOL didWriteSuccessfull = [data writeToFile:cacheFile atomically:YES];
        if (!didWriteSuccessfull) {
            
            NSLog(@"save cache %@ error",key);
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)clearCache
{
//    NSString *cacheDir = getCacheDir();
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    NSArray *contents = [fileManager contentsOfDirectoryAtPath:cacheDir error:NULL];
//    NSEnumerator *e = [contents objectEnumerator];
//    NSString *filename;
//    while ((filename = [e nextObject])) {
//        if ([filename rangeOfString:@"API_CACHE_"].location != NSNotFound) {
//            [fileManager removeItemAtPath:[cacheDir stringByAppendingPathComponent:filename] error:NULL];
//        }
//    }

}

- (void)clearCacheByDateTime
{
  
    NSString *cacheDir = getCacheDir();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:cacheDir error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([filename rangeOfString:@"API_CACHE_"].location != NSNotFound) {

            id obj = [[NSUserDefaults standardUserDefaults] objectForKey:filename];
            
            if(obj)
            {
                
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *senddate=[NSDate date];
                //当前时间
                NSDate *startDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
                
                NSDate *endDate = [dateFormatter dateFromString:obj];
                //得到相差秒数
                NSTimeInterval time = [startDate timeIntervalSinceDate:endDate];
                
                int days = ((int)time)/(3600*24);
                if(days > kCacheMaxCacheAge)
                {
                    [fileManager removeItemAtPath:[cacheDir stringByAppendingPathComponent:filename] error:NULL];
                }

            }
        }
      
    }
}

- (void)clearCacheForkey:(NSString *)key
{
    
    NSString *cacheDir = getCacheDir();
    NSString *cacheFile = [cacheDir stringByAppendingPathComponent:key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([cacheFile rangeOfString:@"APICache"].location != NSNotFound) {
        [fileManager removeItemAtPath:[cacheDir stringByAppendingPathComponent:cacheFile] error:NULL];
    }
}
@end
