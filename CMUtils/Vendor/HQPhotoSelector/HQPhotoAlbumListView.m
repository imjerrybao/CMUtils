//
//  PhotoAlbumListView.m
//  seafishing2
//
//  Created by mac on 14/12/16.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import "HQPhotoAlbumListView.h"
#import "HQPhotoLibrary.h"
#import "HQPhotoSelector.h"
#import "CMConfig.h"
#import "UIView+size.h"
@interface HQPhotoAlbumListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation HQPhotoAlbumListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
       self.title = Locale(@"photoAlbumList.album");
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [NSMutableArray array];
    [self loadAssets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)loadView
{
    [super loadView];
    [self loadTableView];
    [self loadRigthBut];
    
}

- (void)loadRigthBut
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
}

- (void)dismiss
{
    HQPhotoAlbumNaView *nav = (HQPhotoAlbumNaView *)self.navigationController;
    [nav dismissModalViewControllerAnimated:YES];
}

- (void)loadTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate  :self];
    [self.tableView setRowHeight:90];
    [self.view addSubview:self.tableView];
}


- (void)loadAssets
{
    
//    NSMutableArray *assetsGroups = [NSMutableArray array];
    ALAssetsLibraryGroupsEnumerationResultsBlock assetsGroupsEnumerationBlock = ^(ALAssetsGroup *assetsGroup, BOOL *stop)
    {
        if(assetsGroup)
        {
            [_dataSource addObject:assetsGroup];
        }
        else
        {
            
            _dataSource = [NSMutableArray arrayWithArray:[[_dataSource reverseObjectEnumerator] allObjects]];
            [self.tableView reloadData];
            
            //默认 最近添加页
            for (ALAssetsGroup *assetsGroup in _dataSource)
            {
                id type = [assetsGroup valueForProperty:ALAssetsGroupPropertyType];
                if ([type longValue] == 16)
                {
                    HQPhotoSelector *ps = [[HQPhotoSelector alloc] initWithALAssetsGroup:assetsGroup];
                    [self.navigationController pushViewController:ps animated:NO];
                    return;
                }
            }
//            ALAssetsGroup *assetsGroup = [_dataSource objectAtIndex:0];
//            HQPhotoSelector *ps = [[HQPhotoSelector alloc] initWithALAssetsGroup:assetsGroup];
//            [self.navigationController pushViewController:ps animated:NO];
        }
    };
    void (^assetsGroupsFailureBlock)(NSError *) = ^(NSError *error) {
        [self showNotAllowed];
    };
    NSUInteger type = ALAssetsGroupSavedPhotos | ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
    [[HQPHOTO_LIBARARY assetsLibrary] enumerateGroupsWithTypes:type usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
}

- (void)showNotAllowed
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        [self setEdgesForExtendedLayout:UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom];
    
    self.title              = nil;
    
    UIImageView *padlock    = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ZYQAssetPicker.Bundle/Images/AssetsPickerLocked@2x.png"]]];
    padlock.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *title          = [UILabel new];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.preferredMaxLayoutWidth = 304.0f;
    
    UILabel *message        = [UILabel new];
    message.translatesAutoresizingMaskIntoConstraints = NO;
    message.preferredMaxLayoutWidth = 304.0f;
    
    title.text              = NSLocalizedString(@"HQPhoto.canntUserPhotoVideo", nil);
    title.font              = [UIFont boldSystemFontOfSize:17.0];
    title.textColor         = [UIColor colorWithRed:129.0/255.0 green:136.0/255.0 blue:148.0/255.0 alpha:1];
    title.textAlignment     = NSTextAlignmentCenter;
    title.numberOfLines     = 5;
    
    message.text            = NSLocalizedString(@"HQPhoto.openPrivateSetting", nil);
    message.font            = [UIFont systemFontOfSize:14.0];
    message.textColor       = [UIColor colorWithRed:129.0/255.0 green:136.0/255.0 blue:148.0/255.0 alpha:1];
    message.textAlignment   = NSTextAlignmentCenter;
    message.numberOfLines   = 5;
    
    [title sizeToFit];
    [message sizeToFit];
    
    UIView *centerView = [UIView new];
    centerView.translatesAutoresizingMaskIntoConstraints = NO;
    [centerView addSubview:padlock];
    [centerView addSubview:title];
    [centerView addSubview:message];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(padlock, title, message);
    
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:padlock attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:centerView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:padlock attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:message attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:padlock attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[padlock]-[title]-[message]|" options:0 metrics:nil views:viewsDictionary]];
    
    UIView *backgroundView = [UIView new];
    [backgroundView addSubview:centerView];
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    self.tableView.backgroundView = backgroundView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdetify = @"PhotoAlbumListViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdetify];
    }
    ALAssetsGroup *assetsGroup = [_dataSource objectAtIndex:indexPath.row];
    
    CGImageRef posterImage      = assetsGroup.posterImage;
    size_t height               = CGImageGetHeight(posterImage);
    float scale                 = height / 78.0;
    
    cell.imageView.image      = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    cell.textLabel.text       = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)[assetsGroup numberOfAssets]];
    cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ALAssetsGroup *assetsGroup = [_dataSource objectAtIndex:indexPath.row];
    HQPhotoSelector *ps = [[HQPhotoSelector alloc] initWithALAssetsGroup:assetsGroup];
    [self.navigationController pushViewController:ps animated:YES];
}
@end
