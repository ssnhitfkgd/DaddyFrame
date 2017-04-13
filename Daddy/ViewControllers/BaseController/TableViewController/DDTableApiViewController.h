//
//  DDTableApiViewController.h
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import "DDModelApiViewController.h"
#import "PWLoadMoreTableFooterView.h"
#import "DDTableCellProtocol.h"
#import "DDErrorView.h"

@interface DDTableApiViewController : DDModelApiViewController <UITableViewDelegate, UITableViewDataSource, PWLoadMoreTableFooterDelegate, UIScrollViewDelegate>
{
    BOOL _headerLoading;
    BOOL _footerLoading;
    BOOL _reloading;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DDErrorView *errorView;
/**
 activityIndicator已被animateImageView替换 请使用animateImageView
*/
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIImageView * animateImageView; //代替 activityIndicator
@property (nonatomic, strong) NSNumber *loadmore;

- (Class)cellClass;
- (void)setSeparatorClear;

- (CGFloat)headerHeight;

- (void)didFailWithError:(NSError *)error;
- (void)activityIndicatorAnimal:(BOOL)animal;

//OVERRIDE
- (void)activeRefresh;
- (void)setEnableHeader:(BOOL)tf;
- (void)setEnableFooter:(BOOL)tf;
- (void)dealFinishLoad:(id)array;
- (void)updateCache:(id)array;
- (CGFloat)bottomHeight;

- (void)setupData;
- (UITableViewStyle)getTableViewStyle;
- (void)appendObject:(id)object;
//- (void)addFirstObject:(id)object;

- (void)reloadWithCache:(id)cache;
- (void)setDisplayCell:(id)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateErrorDescription;
- (void)finishLoadHeaderTableViewDataSource;
- (void)reloadHeaderTableViewDataSource;
- (NSString *)errorDescription;
- (NSString *)errorImage;
- (void)refreshTableView;
- (void)updateRefresh:(id)array;
- (void)requestError:(NSError *)error;
@end


@protocol RefreshTableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@optional

- (void)loadHeader;
- (void)loadFooter;
@end





