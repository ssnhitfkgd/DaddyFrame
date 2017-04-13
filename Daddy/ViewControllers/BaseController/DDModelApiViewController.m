//
//  DDModelApiViewController.m
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//


#import "DDModelApiViewController.h"
#import "DDFileClient.h"
#import "DDParamsBaseObject.h"
#import "MMDiskCacheCenter.h"
#import "DDUserInfoObject.h"
#import "NSString+Additions.h"


@interface DDModelApiViewController()
@property (nonatomic, strong) id model;
@end


@implementation DDModelApiViewController
@synthesize model;

- (NSString *)getPageName
{
    return self.title;
}

#pragma mark subclass override
- (id)paramsObject:(BOOL)more
{
//    NSAssert(NO, @"the method \"getParamsBaseModel\" Must be rewritten");
    return nil;
}

- (id)init{
    self = [super init]; 
    if (self) {
        _loadMore = NO;
        _loading = NO;
    }
    return self;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSString *pageName = [self getPageName];
    if(pageName)
    {
    //    [MobClick endLogPageView:[self getPageName]];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark data handling methods
- (void)clearArrangedObjects
{
    self.model = nil;
}

- (id)arrangedObjects
{
    return self.model;
}

- (id)objectInArrangedObjectAtIndex:(NSInteger)index
{
    id item = nil;
    if(self.model != nil && [self.model isKindOfClass:[NSArray class]])
    {
        item = [self.model objectAtIndex:index];
    }
    else if(self.model != nil && [self.model isKindOfClass:[NSDictionary class]])
    {
        item = self.model;
    }
    
    return item;
}

- (NSInteger)countOfArrangedObjects
{
    if(self.model == nil)
    {
        return 0;
    }
    
    if([self.model isKindOfClass:[NSDictionary class]])
    {
        return 1;
    }
    
    return [self.model count];
}

- (void)removeObject:(id)object
{
    if(self.model)
    {
        [self.model removeObject:object];
    }
}

- (void)appendObject:(id)object
{
    if(!self.model)
    {
        self.model = [NSMutableArray new];
    }
    
    [self.model addObject:object];
}

//- (void)addFirstObject:(id)object
//{
//    if(!self.model)
//    {
//        self.model = [NSMutableArray new];
//    }
//    
//    if ([object isKindOfClass:[NSArray class]]) {
//        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:object];
//        [tempArray addObjectsFromArray:self.model];
//        
//        self.model = tempArray;
//    }
//}

#pragma mark request methods
- (NSURLRequestCachePolicy)getPolicy
{
    return NSURLRequestReloadRevalidatingCacheData;
}

- (void)reloadData {
    
    if (![self isLoading])
    {
        [self clearArrangedObjects];
        [self loadData:NSURLRequestReloadIgnoringCacheData more:NO];
    }
}

- (void)startLoadData:(NSNumber *)loadHeader
{
    BOOL loadMore = [loadHeader boolValue];
    
    [self loadData:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
              more:loadMore];
}

- (void)loadData:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    _loading = YES;
    _loadMore = more;
    
    DDParamsBaseObject *params = [self paramsObject:_loadMore];
    
    if(params)
    {
        DDFileClient *client = [DDFileClient sharedInstance];
        [client request_send:params cachePolicy:cachePolicy delegate:self selector:@selector(requestDidFinishLoad:) selectorError:@selector(requestDidError:)];
    }
}

- (void)requestDidFinishLoad:(id)data
{
    _loading = NO;
    if(data && [data isKindOfClass:[NSDictionary class]])
    {
        id obj = [data objectForKey:[self getParseKey]];
        if(obj && [obj isKindOfClass:[NSArray class]])
        {
            id offset_id = [data objectForKey:@"lastAccessTime"];
            if(offset_id && [offset_id isKindOfClass:[NSNumber class]])
            {
                _offsetID = [offset_id stringValue];
            }
            
            if([data objectForKey:@"cache"] && !_loadMore)
            {
                [self clearArrangedObjects];
            }
            
            [self didFinishLoad:obj];
        }
        else if(!obj)
        {
            if([data objectForKey:@"cache"] && !_loadMore)
            {
                [self clearArrangedObjects];
            }
            [self didFinishLoad:[NSMutableArray new]];
        }
        else
        {
            [self didFinishLoad:[NSMutableArray new]];
        }
    }
    else
    {
        [self didFinishLoad:[NSMutableArray new]];
    }
}

- (NSString*)getParseKey
{
    return @"data";
}

- (void)requestDidError:(NSError*)error
{
    _loading = NO;
    [self didFailWithError:error];
}

- (void)didFailWithError:(NSError*)error
{
    
}

- (void)didFinishLoad:(id)object
{
    if(object && [object isEqual:model])
    {
        return;
    }
    
    if (model) {
        // is loading more here
        [self.model addObjectsFromArray:object];
    } else {
        self.model = object;
    }
}

- (BOOL)isLoading
{
    return _loading;
}

- (NSInteger)getPageSize
{
    return MODEL_PAGE_SIZE;
}

- (NSString*)getOffsetID
{
    return _offsetID?:@"0";
}

- (void)setOffsetID:(NSString*)offset
{
    _offsetID = offset;
}

- (NSString *)getCacheKey
{
    NSString *key = [NSStringFromClass([self class]) md5Value];
    return [NSString stringWithFormat:@"%@_%@",key, [DDUserInfoObject sharedInstance].uid];
}

- (id)searchCache
{
    return [[MMDiskCacheCenter sharedInstance] cacheForKey:[self getCacheKey] dataType:[NSArray class]];
}

- (void)setCache:(id)cache
{
    [[MMDiskCacheCenter sharedInstance] setCache:cache forKey:[self getCacheKey]];
}

#pragma mark didReceiveMemoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
