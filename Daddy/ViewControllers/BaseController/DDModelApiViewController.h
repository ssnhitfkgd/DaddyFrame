//
//  DDModelApiViewController.h
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#include "DDBaseController.h"

#define MODEL_PAGE_SIZE 10

@interface DDModelApiViewController : DDBaseController
{
    NSString *_offsetID;
    BOOL _loadMore;
    BOOL _loading;
}

- (void)clearArrangedObjects;
- (id)arrangedObjects;
- (id)objectInArrangedObjectAtIndex:(NSInteger)index;
- (void)appendObject:(id)object;
- (void)removeObject:(id)object;
//- (void)addFirstObject:(id)object;

- (NSInteger)countOfArrangedObjects;

- (void)reloadData;
- (void)loadData:(NSURLRequestCachePolicy)cachePolicy more:(BOOL)more;
- (void)startLoadData:(NSNumber *)loadHeader;

- (void)didFinishLoad:(id)object;
//- (void)updateTableView:(id)object;
- (void)didFailWithError:(NSError *)error;

- (void)requestDidFinishLoad:(NSData*)data;
- (void)requestDidError:(NSError*)error;

- (NSString*)getOffsetID;
- (void)setOffsetID:(NSString*)offset;
- (NSInteger)getPageSize;
- (NSString *)getCacheKey;

- (id)searchCache;
- (void)setCache:(id)cache;
- (NSString*)getParseKey;
// subclass to override
- (id)paramsObject:(BOOL)more;
//option
- (NSString*)getPageName;


@end
