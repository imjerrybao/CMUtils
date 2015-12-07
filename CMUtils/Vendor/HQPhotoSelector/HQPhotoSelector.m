//
//  HQPhotoSelector.m
//  seafishing2
//
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import "HQPhotoSelector.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HQPhotoPageOne.h"
#import "HQPhotoPageVC.h"
#import "HQPhotoLibrary.h"
#import "HQPhotoAlbumNaView.h"
#import "UIColor+hex.h"
#import "CMConfig.h"
#import "UIView+size.h"
#define CellNumber(count) (count/LineImageNumber + ((count%LineImageNumber)?1:0))
#define PhotoIndex(image) ((image.indexPath.row*LineImageNumber+(image.tag-100)))
@interface HQPhotoSelector ()
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;
@end

@implementation HQPhotoSelector
#pragma mark - 初始化方法
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

- (id)initWithALAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    if(self = [super init])
    {
        _assetsGroup = assetsGroup;
        self.title = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    }
    return self;
    
}

- (id)initWithPhotos:(NSMutableArray *)photoArray toplimit:(int)toplimit
{
    if(self = [super init])
    {
    }
    return self;
}

#pragma mark - 系统方法
- (void)loadView
{
    [super loadView];
    if(IsIOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self loadTableView];
    [self loadControlView];
    [self loadRightBar];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataSource = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self loadAssets];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self changeControlBar];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 装载代码
- (void)loadTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-AbandonHeight-40) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate  :self];
//    [self.tableView setRowHeight:self.view.width/LineImageNumber];
    [self.view addSubview:self.tableView];
    
}

- (void)loadRightBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
}

- (void)dismiss
{
    HQPhotoAlbumNaView *nav = (HQPhotoAlbumNaView *)self.navigationController;
    [nav dismissModalViewControllerAnimated:YES];
}

- (void)loadControlView
{
    UIView *bgView = nil;
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 40 - AbandonHeight, self.view.width, 40)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    
    [self.view addSubview:bgView];
    
    UIButton *preview = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    preview.tag             = 100001;
    preview.backgroundColor = [UIColor clearColor];
    preview.frame           = CGRectMake(10, 5, 60, 30);
    if(IsIOS7)
    {
        [preview setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    
    [preview setTitle:Locale(@"HQPhotoSelector.preview") forState:UIControlStateNormal];
    [preview setTitle:Locale(@"HQPhotoSelector.preview") forState:UIControlStateSelected];

    [preview setEnabled:NO];
    [preview addTarget:self action:@selector(photoPreview:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:preview];
    
    UIButton *finish       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    finish.tag             = 100002;
    finish.frame           = CGRectMake(bgView.width-60, 5, 50, 30);
    finish.backgroundColor = [UIColor clearColor];
    finish.selected        = YES;
    if(IsIOS7)
    {
        [finish setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    
    
    [finish setTitle:Locale(@"sm.general.ok") forState:UIControlStateNormal];
    [finish setTitle:Locale(@"sm.general.ok") forState:UIControlStateSelected];
    [finish addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:finish];
    
    UIFont *font             = [UIFont systemFontOfSize:12];
    UILabel *countLab        = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-60)*0.5, (40-font.lineHeight)*0.5, 60, font.lineHeight)];
    countLab.tag             = 100003;
    countLab.backgroundColor = [UIColor clearColor];
    countLab.textAlignment   = NSTextAlignmentCenter;
    countLab.textColor       = [UIColor whiteColor];
    countLab.text            = [NSString stringWithFormat:@"%d/%d",[HQPHOTO_LIBARARY selectedCount],[HQPHOTO_LIBARARY photoToplimit]];
    if([HQPHOTO_LIBARARY selectedCount] == 0)
    {
        countLab.enabled = NO;
    }
    [bgView addSubview:countLab];
}

- (void)loadAssets
{
    [_assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result) {
            [_dataSource addObject:result];
            NSString *type = [result valueForProperty:ALAssetPropertyType];
            
            if ([type isEqual:ALAssetTypePhoto])
                self.numberOfPhotos ++;
            else if ([type isEqual:ALAssetTypeVideo])
                self.numberOfVideos ++;
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                if([_tableView numberOfRowsInSection:0]-1 > 0)
                {
                    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_tableView numberOfRowsInSection:0]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
            });
        }
    }];

}




//当_selectedList.count=0时 需要禁用 预览 OK 按钮
#pragma mark -  Action
- (void)photoPreview:(id)sender
{
    HQPhotoPageVC *pageVC = [[HQPhotoPageVC alloc] initWithDataSource:[HQPHOTO_LIBARARY selectedPhoto] index:0 isPreview:NO];
    [self.navigationController pushViewController:pageVC animated:YES];
}

- (void)finish
{
    HQPhotoAlbumNaView *nva = (HQPhotoAlbumNaView *)self.navigationController;
    [nva dismissAlbum:YES];
}


#pragma mark - HQPhotoSelectorCellDelegate
- (void)clickImage:(UITapGestureRecognizer *)sender
{
    HQMarkView *markImage = (HQMarkView *)sender.view;
    int index = PhotoIndex(markImage);
    
    HQPhotoPageVC *pageVC = [[HQPhotoPageVC alloc] initWithDataSource:_dataSource index:index isPreview:NO];
    [self.navigationController pushViewController:pageVC animated:YES];

}

- (void)clickCheck:(UIButton *)sender
{
    HQMarkView *image = (HQMarkView *)sender.superview;
    NSIndexPath *indexPath = image.indexPath;
    BOOL isExists = NO;
    
    if(indexPath.section == 0)
    {
        ALAsset *asset = [_dataSource objectAtIndex:PhotoIndex(image)];
        isExists =  [HQPHOTO_LIBARARY assetExistsWithAsset:asset assetHandle:YES];
    }
    else
    {
        NSString *newImage = [[HQPHOTO_LIBARARY netPhoto] objectAtIndex:PhotoIndex(image)];
        isExists = [HQPHOTO_LIBARARY assetExistsWithAsset:newImage assetHandle:YES];
    }
    
    [image switchCheckState:isExists];
    [self changeControlBar];
}






- (void)changeControlBar
{
    UIButton *preview = (UIButton *)[self.view viewWithTag:100001];
    UILabel *countLab = (UILabel *)[self.view viewWithTag:100003];
    int number = [HQPHOTO_LIBARARY selectedCount];
    if(number == 0)
    {
        preview.enabled = NO;
        preview.selected = NO;
    }
    else
    {
        preview.enabled = YES;
        preview.selected = YES;
        
    }
    if(number == 0)
    {
        countLab.enabled = NO;
    }
    else
    {
        countLab.enabled = YES;
    }
    countLab.text = [NSString stringWithFormat:@"%d/%d",number,[HQPHOTO_LIBARARY photoToplimit]];

}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == CellNumber(_dataSource.count))
    {
        return 40;
    }
    return self.view.width/LineImageNumber;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return CellNumber(_dataSource.count)+1;
    }
    else if (section == 1)
    {
        return CellNumber([HQPHOTO_LIBARARY netPhoto].count);
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [HQPHOTO_LIBARARY netPhoto].count > 0?2:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0;
    }
    else if (section == 1)
    {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return nil;
    }
    else if (section == 1)
    {
        UIView *bgView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        bgView.backgroundColor = [UIColor colorWithHex:0xF6F6F6];

        UIFont *font           = [UIFont systemFontOfSize:16];
        UILabel *title         = [[UILabel alloc] initWithFrame:CGRectMake(10, (40-font.lineHeight)*0.5, 200, font.lineHeight)];
        title.font             = font;
        title.textColor = [UIColor colorWithHex:0x333333];
        title.backgroundColor  = [UIColor clearColor];
        title.text             = @"网络图片";
        [bgView addSubview:title];
        return bgView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //页脚
    if(indexPath.section == 0)
    {
        if(indexPath.row == CellNumber(_dataSource.count))
        {
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellFooter"];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFooter"];
                cell.textLabel.font            = [UIFont systemFontOfSize:18];
                cell.textLabel.backgroundColor = [UIColor clearColor];
                cell.textLabel.textAlignment   = NSTextAlignmentCenter;
                cell.textLabel.textColor       = [UIColor blackColor];
                cell.backgroundColor           = [UIColor clearColor];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
            NSString *title;
            
            if (_numberOfVideos == 0)
                title = [NSString stringWithFormat:NSLocalizedString(@"HQPhoto.photo", nil), (long)_numberOfPhotos];
            else if (_numberOfPhotos == 0)
                title = [NSString stringWithFormat:NSLocalizedString(@"HQPhoto.video", nil), (long)_numberOfVideos];
            else
                title = [NSString stringWithFormat:NSLocalizedString(@"HQPhoto.photoAndVideo", nil), (long)_numberOfPhotos, (long)_numberOfVideos];
            
            cell.textLabel.text = title;
            return cell;
        }
        
        //照片
        static NSString *reuseIdetify = @"HQPhotoSelectorCell";
        HQPhotoSelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
        if (cell == nil)
        {
            cell = [[HQPhotoSelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
            cell.delegate = self;
        }
        [cell loadPhoto:_dataSource indexPath:indexPath];
        return cell;

    }
    else if(indexPath.section == 1)
    {
        //照片
        static NSString *reuseIdetify = @"HQPhotoSelectorCell";
        HQPhotoSelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
        if (cell == nil)
        {
            cell = [[HQPhotoSelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
            cell.delegate = self;
        }
        [cell loadPhoto:[HQPHOTO_LIBARARY netPhoto] indexPath:indexPath];
        return cell;

    }
    return nil;
}


@end
