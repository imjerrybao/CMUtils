//
//  PhotoSquares.m
//  seafishing2
//
//  Created by mac on 14/12/19.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import "HQThumbnailController.h"
#import "HQPhotoAlbumNaView.h"
#import "HQAsset.h"
#import "HQPhotoController.h"
#import "CMConfig.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define COLNUM ((SCREEN_WIDTH >= 375) ? 5 : 4)
#define PhotoSquaresSize 65 //方格大小
#define thumbnailStartTag 100

@interface HQThumbnailController()<UIActionSheetDelegate,HQThumbnailDelegate,HQPhotoControllerDelegate>
{
    // view的原始center坐标
    CGPoint _dragFromPoint;
    
    // 要把view拖往的center坐标
    CGPoint _dragToPoint;
    
    //加号的rect
    CGRect _addFrame;
    // tile拖往的rect
    CGRect _dragToFrame;
    
    // 拖拽的tile是否被其他tile包含
    BOOL _isDragTileContainedInOtherTile;
    
    //被拖动Tag,保证HQThumbnail的tag是顺序的
    NSInteger _dragTag;
    CGFloat _thumbnailSize;
    
}

@property (nonatomic) BOOL swap;//交换
@property (nonatomic,weak) id<HQThumbnailControllerDelegate> delegate;
@property (nonatomic,strong) HQPhotoController *photoController;
@end

@implementation HQThumbnailController

- (id)initWithFrame:(CGRect)frame limit:(int)limit swap:(BOOL)swap delegate:(id<HQThumbnailControllerDelegate>)delgate
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _thumbnailSize = (SCREEN_WIDTH-20-COLNUM*THUMBNAIL_SPACE*2)/COLNUM;//默认两边留白
        _limit = limit;
        _swap  = swap;
        _allowRemove = YES;
        _isShowAdd = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        
        self.layer.cornerRadius = 5;
//        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = [NSMutableArray array];
        [self setControllerHeight];
        self.delegate = delgate;        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _thumbnailSize = (SCREEN_WIDTH-20-COLNUM*THUMBNAIL_SPACE*2)/COLNUM;//默认两边留白
        _limit = 9;
        _swap  = YES;
        _allowRemove = YES;
        _isShowAdd = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = [NSMutableArray array];
        [self setControllerHeight];
//        self.delegate = delgate;
    }
    return self;
}

- (void)reloadData
{
    for (HQThumbnail *thumbnail in self.subviews)
    {
        [thumbnail removeFromSuperview];
    }
    
    for (int i = 0; i <= _dataSource.count; i++)
    {
        int row = (i/COLNUM);
        HQThumbnail *thumbnail = [[HQThumbnail alloc] initWithFrame:CGRectMake((i%COLNUM?:THUMBNAIL_SPACE)+(_thumbnailSize+THUMBNAIL_SPACE*2)*(i%COLNUM),(row%COLNUM?:THUMBNAIL_SPACE) + row * (_thumbnailSize+THUMBNAIL_SPACE*2), _thumbnailSize , _thumbnailSize)];
        thumbnail.layer.cornerRadius = 3;
        thumbnail.layer.masksToBounds = YES;
        thumbnail.tag = i+thumbnailStartTag;
        thumbnail.delegate = self;
        [thumbnail showRemoveButton:_allowRemove];
        
        
        if(i < _dataSource.count)
        {
            thumbnail.asset = [_dataSource objectAtIndex:i];
            UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragTile:)];
            [thumbnail addGestureRecognizer:panGestureRecognizer];
        }
        else
        {
            if(_limit == i)
            {
                break;
            }
            [thumbnail setPlusAction:self action:@selector(addPhoto)];
            thumbnail.hidden = !_isShowAdd;
            _addFrame = thumbnail.frame;
        }
        [self addSubview:thumbnail];
    }
    [self setControllerHeight];
}


- (void)setControllerHeight
{
    NSInteger row = 0;
    NSInteger count = _dataSource.count + 1;
    row = (count/COLNUM)+(count%COLNUM?1:0);
    float height = row * (_thumbnailSize+THUMBNAIL_SPACE*2);
    CGRect rect = CGRectMake(10, self.frame.origin.y, SCREEN_WIDTH-20, height);
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = rect;
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoSquaresFrame:)]) {
        [self.delegate photoSquaresFrame:rect];
    }
}

- (void)addPhoto
{
    [UIKeyWindow endEditing:YES];
    self.photoController              = [[HQPhotoController alloc] initWithSourceType:HQPhotoUseTypeeWall];
    self.photoController.delegate     = self;
    self.photoController.limit        = _limit;
    self.photoController.checkedPhoto = _dataSource;
    [self.photoController showActionSheet];
    
}

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}

- (void)setIsShowAdd:(BOOL)isShowAdd
{
    _isShowAdd = isShowAdd;
    [self setAllowRemove:isShowAdd];
    
}

- (void)setAllowRemove:(BOOL)allowRemove
{
    _allowRemove = allowRemove;
    [self reloadData];
}

#pragma mark - 手势操作

- (BOOL)dragTile:(UIPanGestureRecognizer *)recognizer
{
    switch ([recognizer state])
    {
        case UIGestureRecognizerStateBegan:
            [self dragTileBegan:recognizer];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragTileMoved:recognizer];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragTileEnded:recognizer];
            break;
        default: break;
    }
    return YES;
}

- (void)dragTileBegan:(UIPanGestureRecognizer *)recognizer
{
    _dragFromPoint = recognizer.view.center;
    _dragTag       = recognizer.view.tag;
    [UIView animateWithDuration:0.2f animations:^{
        recognizer.view.transform = CGAffineTransformMakeScale(1.05, 1.05);
        recognizer.view.alpha = 0.8;
    }];
}

- (void)dragTileMoved:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer.view.superview bringSubviewToFront:recognizer.view];
    [recognizer setTranslation:CGPointZero inView:self];
    
    [self pushedTileMoveToDragFromPointIfNecessaryWiththumbnail:(HQThumbnail *)recognizer.view];
}

- (void)dragTileEnded:(UIPanGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.2f animations:^{
        recognizer.view.transform = CGAffineTransformMakeScale(1.f, 1.f);
        recognizer.view.alpha = 1.f;
    }];
    
    [UIView animateWithDuration:0.2f animations:^{
        if (_isDragTileContainedInOtherTile)
        {
            recognizer.view.center = _dragToPoint;
            recognizer.view.tag    = _dragTag;
        }
        else
        {
            recognizer.view.center = _dragFromPoint;
        }
        
    }];
    
    _isDragTileContainedInOtherTile = NO;
}

- (void)pushedTileMoveToDragFromPointIfNecessaryWiththumbnail:(HQThumbnail *)thumbnail
{
    for (int i = 0; i<_dataSource.count+1; i++)
    {
        HQThumbnail *item = (HQThumbnail *)[self viewWithTag:i+thumbnailStartTag];
        if (_swap && CGRectContainsPoint(item.frame, thumbnail.center) && item != thumbnail && thumbnail.asset && item.asset )//暂时将asset为空的判断成加号
        {
            _dragToPoint = item.center;
            _dragToFrame = item.frame;
            
            _isDragTileContainedInOtherTile = YES;
            
            [UIView animateWithDuration:0.2 animations:^{
                //保存
                CGPoint itemCenter = item.center;
                NSInteger itemTag        = item.tag;

                //改变
                item.tag           = _dragTag;
                item.center        = _dragFromPoint;

                //交换
                _dragFromPoint     = itemCenter;
                _dragTag           = itemTag;
            }];
            break;
        }
    }
}




#pragma mark - getDataSource
- (NSMutableArray *)getDataSource
{
    NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:_dataSource.count];
    for (int i = 0; i<_dataSource.count; i++)
    {
        HQThumbnail *thumbnail = (HQThumbnail *)[self viewWithTag:i+thumbnailStartTag];
        [dataSource addObject:thumbnail.asset];
    }
    return dataSource;
}


#pragma mark - HQThumbnailDelegate
- (void)removeThumbnail:(HQThumbnail *)thumbnail
{
    id asset = thumbnail.asset;
    _dragFromPoint = thumbnail.center;
    _dragTag       = thumbnail.tag;
    
    NSInteger startIndex = thumbnail.tag-thumbnailStartTag;
    
    [UIView animateWithDuration:0.2 animations:^{
        for (NSInteger i = startIndex; i<_dataSource.count+1; i++)
        {
            HQThumbnail *item = (HQThumbnail *)[self viewWithTag:i+thumbnailStartTag];
            if (item != thumbnail && item != nil)
            {
                _dragToPoint = item.center;
                _dragToFrame = item.frame;
                
                //保存
                CGPoint itemCenter = item.center;
                NSInteger itemTag        = item.tag;
                
                //改变
                item.center        = _dragFromPoint;
                item.tag           = _dragTag;
                
                //交换
                _dragFromPoint     = itemCenter;
                _dragTag           = itemTag;
            }
            
        }
    }];
    //HQThumbnail如果是最后一个就不删除
    if(_dataSource.count == _limit )
    {
        thumbnail.tag    = _dragTag;
        thumbnail.center = _dragFromPoint;
        [thumbnail setPlusAction:self action:@selector(addPhoto)];
    }
    else
    {
        [thumbnail removeFromSuperview];
    }
    
    [_dataSource removeObject:asset];
    
    [self setControllerHeight];
}

- (CGFloat)thumbnailSize
{
    return _thumbnailSize;
}

#pragma mark - HQThumbnail Delagete
- (void)showOriginal:(HQThumbnail *)thumbnail
{
    if ([self.delegate respondsToSelector:@selector(showOriginal:)])
    {
        [self.delegate showOriginal:thumbnail];
    }
}

#pragma mark - HQPhotoControllerDelegate
- (void)didFinishPickingAssets:(NSArray *)Assets
{
    [self.dataSource removeAllObjects];
    
    [self.dataSource addObjectsFromArray:Assets];
    
    [self reloadData];
}

@end
