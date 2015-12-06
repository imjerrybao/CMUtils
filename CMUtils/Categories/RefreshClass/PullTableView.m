//
//  PullTableView.m
//  TableViewPull
//
//  Created by Emre Berge Ergenekon on 2011-07-30.
//  Copyright 2011 Emre Berge Ergenekon. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "PullTableView.h"

@interface PullTableView (Private) <UIScrollViewDelegate,SRRefreshDelegate>
- (void) config;
- (void) configDisplayProperties;
@end

@implementation PullTableView

# pragma mark - Initialization / Deallocation

@synthesize pullDelegate;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self config];//放在drawRect中,当作viewDid方法
        //        _isWantLoadingMore = YES;
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self config];
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //    [self config];
}

//- (void)dealloc {
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startRefresh) object:nil];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopRefresh) object:nil];
//
//    pullArrowImage      = nil;
//    pullBackgroundColor = nil;
//    pullTextColor       = nil;
//    pullLastRefreshDate = nil;
//    refreshView         = nil;
//    loadMoreView        = nil;
//    delegateInterceptor = nil;
//    _slimeView          = nil;
////    [pullArrowImage release];
////    [pullBackgroundColor release];
////    [pullTextColor release];
////    [pullLastRefreshDate release];
////
////    [refreshView release];
////    [loadMoreView release];
////    [delegateInterceptor release];
//
//    pullDelegate = nil;
////    [super dealloc];
//}

//- (void)
# pragma mark - Custom view configuration

- (void) config
{
    /* Message interceptor to intercept scrollView delegate messages */
    if(!delegateInterceptor)
    {
        delegateInterceptor = [[MessageInterceptor alloc] init];
        delegateInterceptor.middleMan = self;
        delegateInterceptor.receiver = self.delegate;
        super.delegate = (id)delegateInterceptor;
    }
    
    
    /* Status Properties */
    pullTableIsRefreshing = NO;
    pullTableIsLoadingMore = NO;
    _isWantLoadingMore = YES;
    _autoLoadMore = NO;
    _loadMoreFinish = NO;
    /* Refresh View */
    if(!refreshView)
    {
        refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
        refreshView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        refreshView.delegate = self;
        //        [self addSubview:refreshView];
    }
    
    
    /* Load more view init */
    if(!loadMoreView)
    {
        loadMoreView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
        loadMoreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        loadMoreView.delegate = self;
        [self addSubview:loadMoreView];
    }
    
    if(!_slimeView)
    {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor   = [UIColor grayColor];
        _slimeView.slime.skinColor   = [UIColor whiteColor];
        _slimeView.slime.lineWith    = 1;
        _slimeView.slime.shadowBlur  = 0;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        [self addSubview:_slimeView];
    }
    
    //    [self addObserver:self forKeyPath:@"pullTableIsRefreshing" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}


# pragma mark - View changes

- (void)layoutSubviews
{
    [super layoutSubviews];
    //    CGSize size = self.contentSize;
    CGFloat visibleTableDiffBoundsHeight = (self.bounds.size.height - MIN(self.bounds.size.height, self.contentSize.height));
    CGRect loadMoreFrame = loadMoreView.frame;
    loadMoreFrame.origin.y = self.contentSize.height + visibleTableDiffBoundsHeight;
    loadMoreView.frame = loadMoreFrame;
}

#pragma mark - Preserving the original behaviour

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    if(delegateInterceptor) {
        super.delegate = nil;
        delegateInterceptor.receiver = delegate;
        super.delegate = (id)delegateInterceptor;
    } else {
        super.delegate = delegate;
    }
}

- (void)reloadData
{
    [super reloadData];
    // Give the footers a chance to fix it self.
    [loadMoreView egoRefreshScrollViewDidScroll:self];
}

#pragma mark - Status Propreties

@synthesize pullTableIsRefreshing;
@synthesize pullTableIsLoadingMore;

- (void)setPullTableIsRefreshing:(BOOL)isRefreshing
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startRefresh) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopRefresh) object:nil];
    if(!pullTableIsRefreshing && isRefreshing) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(startRefresh) withObject:nil afterDelay:0.1];
        //        });
        //        [self startRefresh];
    } else if(pullTableIsRefreshing && !isRefreshing) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:0.1];
        //        });
        //        [self stopRefresh];
    }
}

- (void)startRefresh
{
    //    [refreshView startAnimatingWithScrollView:self];
    //    [_slimeView]
    pullTableIsRefreshing = YES;
}

- (void)stopRefresh
{
    [_slimeView endRefresh];
    //    [refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    pullTableIsRefreshing = NO;
}

- (void)setPullTableIsLoadingMore:(BOOL)isLoadingMore
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startLoadMore) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopLoadMore) object:nil];
    if(!pullTableIsLoadingMore && isLoadingMore) {
        [self performSelector:@selector(startLoadMore) withObject:nil afterDelay:0.1];
        //        [self startLoadMore];
    } else if(pullTableIsLoadingMore && !isLoadingMore) {
        [self performSelector:@selector(stopLoadMore) withObject:nil afterDelay:0.1];
        //        [self stopLoadMore];
    }
}

- (void)startLoadMore
{
    if (self.isWantLoadingMore)
    {
        [loadMoreView startAnimatingWithScrollView:self];
        pullTableIsLoadingMore = YES;
    }
    
}

- (void)stopLoadMore
{
    if (self.isWantLoadingMore)
    {
        [loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
        pullTableIsLoadingMore = NO;
    }
    
}

#pragma mark - Display properties

@synthesize pullArrowImage;
@synthesize pullBackgroundColor;
@synthesize pullTextColor;
@synthesize pullLastRefreshDate;

- (void)configDisplayProperties
{
    [refreshView setBackgroundColor:self.pullBackgroundColor textColor:self.pullTextColor arrowImage:self.pullArrowImage];
    [loadMoreView setBackgroundColor:self.pullBackgroundColor textColor:self.pullTextColor arrowImage:self.pullArrowImage];
}

- (void)setPullArrowImage:(UIImage *)aPullArrowImage
{
    if(aPullArrowImage != pullArrowImage) {
        //        [pullArrowImage release];
        //        pullArrowImage = [aPullArrowImage retain];
        pullArrowImage = aPullArrowImage;
        [self configDisplayProperties];
    }
}

- (void)setPullBackgroundColor:(UIColor *)aColor
{
    if(aColor != pullBackgroundColor) {
        //        [pullBackgroundColor release];
        //        pullBackgroundColor = [aColor retain];
        pullBackgroundColor = aColor;
        [self configDisplayProperties];
    }
}

- (void)setPullTextColor:(UIColor *)aColor
{
    if(aColor != pullTextColor) {
        //        [pullTextColor release];
        //        pullTextColor = [aColor retain];
        pullTextColor = aColor;
        [self configDisplayProperties];
    }
}

- (void)setPullLastRefreshDate:(NSDate *)aDate
{
    if(aDate != pullLastRefreshDate) {
        //        [pullLastRefreshDate release];
        //        pullLastRefreshDate = [aDate retain];
        pullLastRefreshDate = aDate;
        [refreshView refreshLastUpdatedDate];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    [refreshView egoRefreshScrollViewDidScroll:scrollView];
    //    BOOL isHidden = _slimeView.slime.hidden;
    //    if (isHidden == YES) {
    //        DLOG(@"隐藏");
    //    }
    [_slimeView scrollViewDidScroll];//refreshView不要了
    
    if (self.isWantLoadingMore)
    {
        [loadMoreView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    // Also forward the message to the real delegate
    if ( delegateInterceptor.receiver && [delegateInterceptor.receiver
                                          respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [delegateInterceptor.receiver scrollViewDidScroll:scrollView];
    }
}


- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    [refreshView egoRefreshScrollViewWillBeginDragging:scrollView];
    // Also forward the message to the real delegate
    if (delegateInterceptor.receiver && [delegateInterceptor.receiver
                                         respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [delegateInterceptor.receiver scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
    //    [refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    if (self.isWantLoadingMore)
    {
        [loadMoreView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    // Also forward the message to the real delegate
    if (delegateInterceptor.receiver && [delegateInterceptor.receiver respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
    {
        [delegateInterceptor.receiver scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    else
    {
        [self loadMoreData];
    }
}

- (void)loadMoreData
{
    if (pullTableIsLoadingMore || pullTableIsRefreshing)
    {
        return;
    }
    if(_autoLoadMore && !_loadMoreFinish && (self.contentSize.height != 0.0f))
    {
        CGPoint offset     = self.contentOffset;
        CGSize size        = self.contentSize;
        CGRect frame       = self.frame;
        
        float need_to_load = frame.size.height * 1.5;// 还剩多少时加载更多
        float frame_height = frame.size.height;
        if (offset.y + frame_height >= (size.height - need_to_load))
        {
            [self loadMoreTableFooterDidTriggerLoadMore:nil];
            [self startLoadMore];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (delegateInterceptor.receiver && [delegateInterceptor.receiver
                                         respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [delegateInterceptor.receiver scrollViewDidEndDecelerating:scrollView];
    }
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    
    if(pullDelegate && [pullDelegate respondsToSelector:@selector(pullTableViewDidTriggerRefresh:)])
    {
        pullTableIsRefreshing = YES;
        [pullDelegate pullTableViewDidTriggerRefresh:self];
    }
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
    return self.pullLastRefreshDate;
}

#pragma mark - LoadMoreTableViewDelegate

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view
{
    
    if(pullDelegate && [pullDelegate respondsToSelector:@selector(pullTableViewDidTriggerLoadMore:)])
    {
        pullTableIsLoadingMore = YES;
        [pullDelegate pullTableViewDidTriggerLoadMore:self];
    }
    
}

- (void)setIsWantLoadingMore:(BOOL)isLaodMore
{
    _isWantLoadingMore = isLaodMore;
    if(isLaodMore)
    {
        loadMoreView.hidden = NO;
    }
    else
    {
        loadMoreView.hidden = YES;
    }
}

#pragma mark - SRRefresh

#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    pullTableIsRefreshing = YES;
    [pullDelegate pullTableViewDidTriggerRefresh:self];
    //    [_slimeView performSelector:@selector(endRefresh)
    //                     withObject:nil afterDelay:3
    //                        inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

@end
