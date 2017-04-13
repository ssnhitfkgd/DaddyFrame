//
//  DDTableApiViewController.m
//  Daddy
//
//  Created by jor on 17/4/13.
//  Copyright © 2017年 jor. All rights reserved.
//

#import "DDTableApiViewController.h"
#import "DDTableCellProtocol.h"
#import "DDFileClient.h"
#import "GlobalHelper.h"

@interface DDTableApiViewController()

@property (nonatomic, strong) PWLoadMoreTableFooterView *tableFooterView;
@property (nonatomic, assign) BOOL enableHeader;
@property (nonatomic, assign) BOOL enableFooter;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) NSMutableArray *idleImages;
@property (nonatomic, strong) NSMutableArray *pullingImages;


- (void)setupSubviews;
- (void)reloadHeaderTableViewDataSource;
- (void)reloadFooterTableViewDataSource;
- (void)finishLoadHeaderTableViewDataSource;
- (void)finishLoadFooterTableViewDataSource;
- (void)refreshTableView;
- (void)setupTableView;
@end

@implementation DDTableApiViewController

- (Class)cellClass {
    NSAssert(NO, @"the method \"cellClass\" Must be rewritten");
    return NULL;
}

#pragma mark - option
- (NSString *)errorDescription
{
    return @"";
}

- (NSString *)errorImage
{
    return nil;
}

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_tableView reloadData];
}

- (void)setupTableView
{
    [self.view setBackgroundColor:TableViewBackGroundColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:[self getTableViewStyle]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = TableViewBackGroundColor;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
    _tableView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_tableView];
    
    _headerLoading = NO;
    _footerLoading = NO;
    
    _hasMore = NO;
    self.loadmore = [NSNumber numberWithInt:0];
    
    // Do any additional setup after loading the view.
    
    [self activityIndicatorAnimal:YES];
    
    [self setEnableHeader:YES];
    [self setEnableFooter:NO];
}

- (PWLoadMoreTableFooterView *)tableFooterView
{
    if(!_tableFooterView)
    {
        _tableFooterView = [PWLoadMoreTableFooterView new];
        _tableFooterView.delegate = self;
        [_tableFooterView setPWState:PWLoadMoreNormal];
    }
    
    return _tableFooterView;
}

- (void)updateErrorDescription
{
    NSString *description = [self errorDescription];
    if(description && description.length > 0)
    {
        [self.errorView setText:description image:[self errorImage]];
    }
    else
    {
        [self.errorView setText:NSLocalizedString(@"暂无内容",nil) image:[self errorImage]];
    }
}

- (UIActivityIndicatorView*)activityIndicator
{
    if(!_activityIndicator)
    {
        // Do any additional setup after loading the view.
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.tableView addSubview:_activityIndicator];

        [_activityIndicator setHidesWhenStopped:YES];
        [_activityIndicator setCenterX: _tableView.width/2];
        [_activityIndicator setTop: (ScreenHeight - self.topHeight - [self bottomHeight] - [self headerHeight] - 20)/2 + [self headerHeight]];

        [self activityIndicatorAnimal:YES];
        
    }
    
    [self.tableView bringSubviewToFront:_activityIndicator];
    return _activityIndicator;
}

- (UIImageView *)animateImageView
{
    if (!_animateImageView) {
        _animateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
       
        [self.tableView addSubview:_animateImageView];
        _animateImageView.backgroundColor = [UIColor clearColor];
        
        [_animateImageView setCenterX: _tableView.width/2];
        [_animateImageView setTop: (ScreenHeight - self.topHeight - [self bottomHeight] - [self headerHeight] - 20)/2 + [self headerHeight]];

        NSMutableArray *images = [NSMutableArray array];
        for (int i = 1; i <= 6; i ++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"i_shuaxin_64_%d", i]];
            [images addObject:image];
        }
        _animateImageView.animationImages = images;
        _animateImageView.animationDuration = 6 * 0.09;
        _animateImageView.animationRepeatCount = 0;
    
        [self activityIndicatorAnimal:YES];
    }
     [self.tableView bringSubviewToFront:_animateImageView];
    return _animateImageView;
}

- (DDErrorView *)errorView
{
    if(!_errorView)
    {
        _errorView = [[DDErrorView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
        
        [_errorView setCenterX: _tableView.width/2];
        [_errorView setTop:(ScreenHeight - self.topHeight - [self bottomHeight] - [self headerHeight] - _errorView.height)/2 + [self headerHeight]];
        [self.tableView addSubview:_errorView];

    }
    
    return _errorView;
}

- (CGFloat)topHeight
{
    return 69;
}

- (CGFloat)bottomHeight
{
    return 0;
}

- (CGFloat)headerHeight
{
    return 0;
}


- (void)setupSubviews
{
    [self setupTableView];
}

- (void)appendObject:(id)object
{
    [super appendObject:object];
    [self.tableView reloadData];
}

//- (void)addFirstObject:(id)object
//{
//    [self updateRefresh:object];
//    [super addFirstObject:object];
//    [self.tableView reloadData];
//}

- (void)activityIndicatorAnimal:(BOOL)animal
{
    if(animal)
    {
//        if ([self.activityIndicator isDescendantOfView:self.tableView]) {
//            [self.activityIndicator removeFromSuperview];
//        }
        
        [self.tableView bringSubviewToFront:self.animateImageView];
        [self.animateImageView startAnimating];
        self.animateImageView.hidden = NO;
    }
    else
    {
        [self.animateImageView stopAnimating];
        self.animateImageView.hidden = YES;
    }
//    if(animal)
//    {
//        [self.tableView bringSubviewToFront:self.activityIndicator];
//        [self.activityIndicator startAnimating];
//    }
//    else
//    {
//        [self.activityIndicator stopAnimating];
//    }
    
}

- (void)setSeparatorClear
{
    [_tableView setSeparatorColor:[UIColor clearColor]];
}

- (UITableViewStyle)getTableViewStyle
{
    return UITableViewStylePlain;
}

- (BOOL)getCacheWithRefresh
{
    return YES;
}

#pragma mark - request callback
- (void)didFailWithError:(NSError *)error
{
//    if(self.activityIndicator)
//    {
//        [self activityIndicatorAnimal:NO];
//    }
    
    if(self.animateImageView)
    {
        [self activityIndicatorAnimal:NO];
    }
    
    if(_footerLoading)
    {
        _footerLoading = NO;
        [self performSelector:@selector(finishLoadFooterTableViewDataSource) withObject:nil afterDelay:0.01];
    }
    
    if(_headerLoading)
    {
        [self performSelector:@selector(finishLoadHeaderTableViewDataSource) withObject:nil afterDelay:0.01];
    }
    
    //    [self setEnableFooter:NO];
    
    [self.errorView setHidden:YES];
    
    
    NSString *strFailText = @"网络异常，请稍后重试";
    if ([error.domain isEqualToString:ERROR_DOMAIN])
    {
        if (error.code == 171000) {
            strFailText = @"此用户不是才主";
        } else {
            strFailText = [error.userInfo objectForKey:@"reason"];
        }
    }
    else
    {
        if([[DDFileClient sharedInstance] getNetworkingType] == 0)
        {
            strFailText = NSLocalizedString(@"networking_timeout", nil);
        }
        else if(error.code == -1001){
            strFailText = NSLocalizedString(@"networking_timeout", nil);
        }
        else if(error.code == -1202)
        {
            //过滤https证书得错误
            strFailText = nil;
        }else if(error.code == -1003){
            
        }
        
        else if(error.localizedDescription)
        {
            strFailText = error.localizedDescription;
        }
    }
    
    
    if([self countOfArrangedObjects] > 0)
    {
        if(strFailText)
        {
            [SVProgressHUD showErrorWithStatus:strFailText];
        }
    }
    else
    {
        //        [self.errorView setText:strFailText detail:nil];
        [self.errorView setText:[self errorDescription] image:[self errorImage]];
    }
    
    [self requestError:error];
}

- (void)requestError:(NSError *)error
{
    //over
}

- (void)updateCache:(id)array
{
    //存储缓存
    if (self.loadmore == [NSNumber numberWithBool:NO])
    {
        if (array && [array isKindOfClass:[NSArray class]])
        {
            [self setCache:array];
        }
    }
}

- (void)dealFinishLoad:(id)array
{
    
    [self updateCache:array];
    
//    if(self.activityIndicator)
//    {
//        [self activityIndicatorAnimal:NO];
//    }
    
    if(self.animateImageView)
    {
        [self activityIndicatorAnimal:NO];
    }
    
    if(![self.errorView isHidden])
    {
        [self.errorView setHidden:YES];
    }
    
    //    if(_enableFooter)
    //    {
    //        [self setEnableFooter:YES]; // look 312 line
    //    }
    
    
    if([(NSArray*)array count] == 0)
    {
        if([self arrangedObjects] == nil || [self countOfArrangedObjects] == 0)
        {
            //list 为空
            [self.errorView setHidden:NO];
            [self updateErrorDescription];
            [_tableView reloadData];
            
            [self setEnableFooter:NO];
            self.tableView.tableFooterView = nil;
            if(_headerLoading)
            {
                [self clearArrangedObjects];
                [self performSelector:@selector(finishLoadHeaderTableViewDataSource) withObject:nil afterDelay:0.01];
            }
            
            return;
        }
    }
    
    if ([(NSArray*)array count] < [self getPageSize])
    {
        self.hasMore = NO;
        [self setEnableFooter:NO];
    }
    else
    {
        self.hasMore = YES;
        [self setEnableFooter:YES]; //by king
        [self.tableFooterView setPWState:PWLoadMoreNormal];
    }
    
    if(_footerLoading)
    {
        _footerLoading = NO;
        [self performSelector:@selector(finishLoadFooterTableViewDataSource) withObject:nil afterDelay:0.01];
    }
    
    if(_headerLoading)
    {
        [self clearArrangedObjects];
        [self performSelector:@selector(finishLoadHeaderTableViewDataSource) withObject:nil afterDelay:0.01];
    }
}

- (void)updateRefresh:(id)array
{
    [self dealFinishLoad:array];
}

- (void)didFinishLoad:(id)array
{
    [self updateRefresh:array];
    [super didFinishLoad:array];
    [_tableView reloadData];
}


- (void)refreshTableView
{
    [self performSelector:@selector(reloadHeaderTableViewDataSource) withObject:nil afterDelay:0.0];
}

- (void)setupData
{
    //取缓存
    id cache = [self searchCache];
    
    if (cache && [cache isKindOfClass:[NSArray class]])
    {
        //有缓存
        [self reloadWithCache:[[NSMutableArray alloc] initWithArray:cache]];
    }
    else if (cache && [cache isKindOfClass:[NSDictionary class]])
    {
        [self reloadWithCache:[[NSMutableDictionary alloc] initWithDictionary:cache]];
    }
    else
    {
        //无缓存
        [self reloadData];
    }
}

- (void)reloadData
{
    self.loadmore = [NSNumber numberWithBool:NO];
    [super reloadData];
}

- (void)reloadWithCache:(id)cache
{
    [self didFinishLoad:cache];
    [self setEnableFooter:NO];
    [self refreshTableView];
}

#pragma mark -
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self countOfArrangedObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Class cls = [self cellClass];
    NSString *identifier = [NSStringFromClass(cls) stringByAppendingString:[NSString stringWithFormat:@"_%ld", (long)indexPath.row % 2]];
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[cls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [self setDisplayCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)setDisplayCell:(id)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setObject:)])
    {
        if([self countOfArrangedObjects] > indexPath.row)
        {
            id item = [self objectInArrangedObjectAtIndex:indexPath.row];
            [cell setObject:item];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([self countOfArrangedObjects] > indexPath.row)
    {
        id item = [self objectInArrangedObjectAtIndex:indexPath.row];
        
        Class cls = [self cellClass];
        if ([cls respondsToSelector:@selector(rowHeightForObject:)])
        {
            return [cls rowHeightForObject:item];
        }
    }
    
    return tableView.rowHeight; // failover
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell respondsToSelector:@selector(cellSelected)])
    {
        [cell performSelector:@selector(cellSelected) withObject:nil afterDelay:0];
    }
}

#pragma mark -
#pragma mark refreshView Methods

- (void)activeRefresh
{
    [_tableView setContentOffset:CGPointMake(0, -([_tableView contentInset].top + 60)) animated:NO];
//    [self.tableView.mj_header beginRefreshing];
    _headerLoading = YES;
}

- (void)setEnableFooter:(BOOL)tf
{
    _enableFooter = tf;
    
    if (tf)
    {
        [self.tableFooterView setPWState:PWLoadMoreNormal];
        self.tableView.tableFooterView = self.tableFooterView;
    }
    else
    {
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 66)];
        if ([self countOfArrangedObjects] == 0) {
            self.tableView.tableFooterView = nil;
        }
    }
}

- (NSMutableArray *)idleImages
{
    if (_idleImages == nil) {
        _idleImages = [[NSMutableArray alloc] init];
        //				循环添加图片
        for (NSUInteger i = 1; i<=4; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"i_shuaxin_64_%ld", i]];
            [_idleImages addObject:image];
        }
    }
    return _idleImages;
}

- (NSMutableArray *)pullingImages
{
    if (_pullingImages == nil) {
        _pullingImages = [[NSMutableArray alloc] init];
        //				循环添加图片
        for (NSUInteger i = 1; i<=6; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"i_shuaxin_64_%ld", i]];
            [_pullingImages addObject:image];
        }
    }
    return _pullingImages;
}

- (void)setEnableHeader:(BOOL)tf
{
    _enableHeader = tf;
    if (tf)
    {
        __weak typeof(self) weak_self = self;
      
        
    }
    else
    {
   
    }
    
    
}

#pragma mark -
#pragma mark UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    if ([[QJFileClient sharedInstance] getNetworkingType] > 0)
    {
        
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 10;
        if(y > h + reload_distance)
        {
            if (self.enableFooter && !_footerLoading && self.hasMore)
            {
                [self.tableFooterView startLoadMore];
                //                [NSThread detachNewThreadSelector:@selector(startLoadMore) toTarget:self.tableFooterView withObject:nil];
            }
        }
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //勿删
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //勿删
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //勿删
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    //勿删
    return YES;
}

#pragma mark -
#pragma mark loadmore delegate
- (void)pwLoadMore
{
    [self reloadFooterTableViewDataSource];
}

- (BOOL)pwLoadMoreTableDataSourceAllLoaded
{
    return !self.hasMore;
}

- (BOOL)pwLoadMoreTableDataSourceIsLoading
{
    return _footerLoading;
}


- (void)reloadHeaderTableViewDataSource
{
//    if([self.activityIndicator isAnimating])
//    {
//        return;
//    }
    
    if([self.animateImageView isAnimating])
    {
        return;
    }
    
    _headerLoading = YES;
    
    self.loadmore = [NSNumber numberWithBool:NO];
    
    if ([self respondsToSelector:@selector(startLoadData:)] == YES)
    {
        [NSThread detachNewThreadSelector:@selector(startLoadData:)
                                 toTarget:self
                               withObject:self.loadmore];
    }
}

- (void)reloadFooterTableViewDataSource
{
    _footerLoading = YES;
    
    self.loadmore = [NSNumber numberWithBool:YES];
    
    if ([self respondsToSelector:@selector(startLoadData:)] == YES)
    {
        [NSThread detachNewThreadSelector:@selector(startLoadData:)
                                 toTarget:self
                               withObject:self.loadmore];
    }
    
}

- (void)finishLoadHeaderTableViewDataSource
{
    _headerLoading = NO;
    
//    [self.tableView.mj_header endRefreshing];
    //    if([self.refresh respondsToSelector:@selector(endRefreshing)])
    //    [self.refresh performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:NO];
}

- (void)finishLoadFooterTableViewDataSource
{
    _footerLoading = NO;
    if([self.tableFooterView respondsToSelector:@selector(pwLoadMoreTableDataSourceDidFinishedLoading)])
    {
        [self.tableFooterView performSelectorOnMainThread:@selector(pwLoadMoreTableDataSourceDidFinishedLoading) withObject:nil waitUntilDone:NO];
    }
}

- (void)startLoadData:(NSNumber *)loadHeader
{
    [super startLoadData:loadHeader];
}

- (void)dealloc
{
    self.tableFooterView.delegate = nil;
    self.tableFooterView = nil;
    self.errorView = nil;
    self.activityIndicator = nil;
    self.animateImageView = nil;
    
    self.loadmore = nil;
    //    self.refresh = nil;
    
    [_tableView setDataSource:nil];
    [_tableView setDelegate:nil];
    _tableView = nil;
}


- (BOOL)shouldAutorotate
{
    return NO;
}

@end
