//
//  FileHelper.m
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper

+ (BOOL)isExist:(NSString *)file
{
    BOOL tf = YES;
    NSFileManager *nfm = [NSFileManager defaultManager];
	BOOL isDir;
	BOOL isExist = [nfm fileExistsAtPath:file isDirectory:&isDir];
    if (isExist == NO || isDir == YES) {
        tf = NO;
        return tf;
    }
    tf = [nfm fileExistsAtPath:file];
    return tf;
}


+ (NSString *)getHttpServerPath
{
    return [[FileHelper getBasePath] stringByAppendingPathComponent:@"VideosCache"];
}

+ (NSString *)getApiCachePath
{
    return [[FileHelper getBasePath] stringByAppendingPathComponent:@"APICache"];
}

+ (NSString *)getConfigPath
{
    return [[FileHelper getBasePath] stringByAppendingPathComponent:@"Config"];
}

+ (NSString *)getFileName:(NSString *)path
{
    NSRange range = [path rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *name = nil;
    if (range.location == NSNotFound) {
        name = path;
    } else {
        // audio
        name = [path substringFromIndex:range.location+1];
    }
    return name;
}

+ (NSString *)getFilePart:(NSString *)name idx:(NSInteger)idx
{
    NSString *part = nil;
    NSRange range = [name rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        if (idx == 0) {
            part = [name substringToIndex:range.location];
        } else {
            part = [name substringFromIndex:range.location+1];
        }
    } else {
        if (idx == 0) {
            part = name;
        } else {
            part = @"";
        }
    }
    return part;

}

+ (NSString *)getFileName:(NSString *)path suffix:(NSString *)suffix
{
    NSString *name = nil;
    NSString *name2 = [FileHelper getFileName:path];
    NSRange range = [name2 rangeOfString:suffix options:NSBackwardsSearch];
    if (range.location != NSNotFound && range.location+range.length == name2.length-1) {
        name = [name2 substringToIndex:range.location];
    } else {
        name = name2;
    }
    return name;
}

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSURL*) URL
{
    //     URL= [NSURL fileURLWithPath: filePathString];
    if(![[NSFileManager defaultManager] fileExistsAtPath: [URL path]]) {
        return NO;
    }
    NSLog(@"addSkipBackupAttributeToItemAtPath %@", [URL path]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    } else {
        NSLog(@"success");
        NSLog(@"OK excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

+ (void) addSkipBackupAttributeToLibraryDirectory
{
    NSError*error =nil;
    
    NSString*stringPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    
    NSArray*filePathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: stringPath error:&error];
    
    //    NSLog(@"-------Add Skip Backup File Start-------");
    for(int i=0;i<[filePathsArray count];i++)
    {
        NSString*strFilePath = [filePathsArray objectAtIndex:i];
        
        //        NSLog(@"[%@]--[%@]",[NSNumber numberWithInt:i],strFilePath);
        if (([strFilePath isEqualToString:@"Caches"])
            || ([strFilePath isEqualToString:@"Application Support"])){
            continue;
        }
        NSURL*pathURL = [NSURL fileURLWithPath:[[stringPath stringByAppendingString:@"/"] stringByAppendingString:strFilePath]];
        [FileHelper addSkipBackupAttributeToItemAtPath:pathURL];
        //        NSLog(@"[Value For NSURLIsExcludedFromBackupKey]--[%@]",[pathURL resourceValuesForKeys:@[NSURLIsExcludedFromBackupKey]error:&error]);
    }
    
    //    NSLog(@"-------Add Skip Backup File End---------");
    
}

+ (void)showAllFilesUnderLibraryDirectory {
    
    NSError*error =nil;
    
    NSString*stringPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    
    NSArray*filePathsArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: stringPath error:&error];
    
    NSLog(@"-------print File Start-------");
    
    for(int i=0;i<[filePathsArray count];i++)
        
    {
        NSString*strFilePath = [filePathsArray objectAtIndex:i];
        NSLog(@"[%@]--[%@]",[NSNumber numberWithInt:i],strFilePath);
        NSURL*pathURL = [NSURL fileURLWithPath:[[stringPath stringByAppendingString:@"/"] stringByAppendingString:strFilePath]];
        
        NSError*error =nil;
        
        NSLog(@"[Value For NSURLIsExcludedFromBackupKey]--[%@]",[pathURL resourceValuesForKeys:@[NSURLIsExcludedFromBackupKey]error:&error]);
        
        //        NSLog(@"error:%@",error);
        
        //        NSDictionary*fileDictionary = [[NSFileManager defaultManager]attributesOfItemAtPath:[[stringPath stringByAppendingString:@"/"]stringByAppendingString:strFilePath]error:&error];
        
        //        unsigned long long  fileSize = [fileDictionary fileSize];
        
        //        NSLog(@"FileSize:%@",@(fileSize));
        
        //        NSLog(@"error:%@",error);
    }
    
    NSLog(@"-------print File End---------");
    
}

+ (NSString *)getBasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (BOOL)isLocalFile:(NSString *)path
{
    if(!path)
        return NO;
    BOOL tf = YES;
    NSRange range = [path rangeOfString:[FileHelper getBasePath]];
    if (range.location == 0 && range.length > 0) {
        tf = YES;
    } else {
        tf = NO;
    }
    return tf;
}

+ (BOOL)clearDir:(NSString *)path
{
    BOOL tf = YES;
    NSFileManager *nfm = [NSFileManager defaultManager];
	BOOL isDir;
	BOOL isExist = [nfm fileExistsAtPath:path isDirectory:&isDir];
    if (isExist == YES && isDir == YES) {
        NSArray *array = [nfm contentsOfDirectoryAtPath:path error:nil];
        for (int i=0; i<array.count; i++) {
            tf = [nfm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", path, [array objectAtIndex:i]] error:nil];
        }
    }
    return tf;
}

+ (BOOL)clearFile:(NSString *)path
{
    BOOL tf = YES;
    NSFileManager *nfm = [NSFileManager defaultManager];
    BOOL isExist = [nfm fileExistsAtPath: path];

    if (isExist == YES) {
        tf = [nfm removeItemAtPath: path error: nil];
    }

    return tf;
}

+ (void)createDir:(NSString *)dirPath
{
	NSFileManager *fileManage = [NSFileManager defaultManager];
	BOOL isDir;
	BOOL isExist = [fileManage fileExistsAtPath:dirPath isDirectory:&isDir];
	if (isExist == NO || isDir == NO) {
		NSError *error;
		isDir = [fileManage createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
		NSLog(@"Create dir %@ %@", dirPath, isDir == YES ? @"OK":@"Fail");
	}
}


+ (NSString *)getUploadPath
{
    return [[FileHelper getBasePath] stringByAppendingString:@"Upload"];
}

+ (void)load
{
    NSFileManager * manager = [NSFileManager defaultManager];
    
    if(![manager fileExistsAtPath:[self getApiCachePath]])
    {
        [manager createDirectoryAtPath:[self getApiCachePath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if(![manager fileExistsAtPath:[self getConfigPath]])
    {
        [manager createDirectoryAtPath:[self getConfigPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
       
    if (![manager fileExistsAtPath:[self getHttpServerPath]]) {
        
        [manager createDirectoryAtPath:[self getHttpServerPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
}

+ (void)moveItemToDir:(NSString*)file_path dir:(NSString*)dirPath
{
    if([FileHelper isExist:file_path]){
        NSFileManager * manager = [NSFileManager defaultManager];
        [manager moveItemAtPath:file_path toPath:dirPath error:nil];
    }
}
//
//+ (void)clearCache
//{
//    [FileHelper clearDir:[FileHelper getAudioPath]];
//    [FileHelper clearDir:[FileHelper getHttpServerPath]];
//    [FileHelper clearDir:[FileHelper getUploadPath]];
//    [FileHelper clearDir:[FileHelper getFeedImagePath]];
//    [FileHelper clearDir:[FileHelper getPhotoPath]];
//    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
//    
//}
//+ (void)clearCacheOutOfAudio{
//    [FileHelper clearDir:[FileHelper getHttpServerPath]];
//    [FileHelper clearDir:[FileHelper getUploadPath]];
//    [FileHelper clearDir:[FileHelper getFeedImagePath]];
//    [FileHelper clearDir:[FileHelper getPhotoPath]];
//    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
//}
//+ (float)cacheSize
//{
//    @try {
//        float folderSize;
//        NSFileManager *fileManager=[NSFileManager defaultManager];
//        if ([fileManager fileExistsAtPath:[FileHelper getBasePath]])
//        {
//            folderSize = 0.0;
////            if ([FileHelper folderSizeAtPath:[FileHelper getAudioPath]] <= 10000) {
////                folderSize = [FileHelper folderSizeAtPath:[FileHelper getAudioPath]];
////            }
//            folderSize = [FileHelper folderSizeAtPath:[FileHelper getHttpServerPath]] + [FileHelper folderSizeAtPath:[FileHelper getUploadPath]] + [FileHelper folderSizeAtPath:[FileHelper getPhotoPath]] + [FileHelper folderSizeAtPath:[FileHelper getApiCachePath]] + [FileHelper folderSizeAtPath:[FileHelper getFeedImagePath]];
//            long long size =[[SDImageCache sharedImageCache] getSize];
//            folderSize += size/1024.0/1024.0;
//            return folderSize;
//        }
//        return 0.;
//    }
//    @catch (NSException *exception) {
//    }
//    @finally {
//    }
//    
//    return 0.;
//}

+(float)folderSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[FileHelper fileSizeAtPath:absolutePath];
        }
       //SDWebImage框架自身计算缓存的实现
//        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}


+(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

@end
