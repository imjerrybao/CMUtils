//
//  APIClient+image.m
//  CMUtils
//
//  Created by LiuHuanQing on 15/3/20.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "APIClient+image.h"
#import "DirectoryUtil.h"
#import "NSData+util.h"
#import "UIImage+Saving.h"
#import "UIImage+Util.h"
#import "Hex62ToStr11.h"
#import "HQAsset.h"
#import "NSString+util.h"
#import "CMConfig.h"

@implementation APIClient (image)

+ (dispatch_queue_t)shareImageQueue
{
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.solot.imageDealQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

//图片存储路径
- (NSString *)imageRootPath
{
    NSString *cachePath = [DirectoryUtil libCachePath];
    NSString *path = [cachePath stringByAppendingPathComponent:@"CRImage"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
        if (!success) {
            DLOG(@"error : %@", error);
        }
    }
    return path;
}

//获取图片存储路径
- (NSString *)getPathForImage:(NSString *)imageId
{
    return [self getPathForImage:imageId size:CGSizeZero];
}
- (NSString *)getPathForImage:(NSString *)imageId size:(CGSize)size
{
    NSString *dir = [self imageRootPath];
    NSString *idWithSize = [self imageId:imageId size:size];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        NSError *error;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
        if (!success) {
            DLOG(@"error : %@", error);
        }
    }
    return [dir stringByAppendingPathComponent:idWithSize];
}

//获取图片本地名

- (NSString *)imageId:(NSString *)imageId size:(CGSize)size
{
    NSString *hash = [[[imageId dataUsingEncoding:NSUTF8StringEncoding] MD5] toHexString];
    if (!CGSizeEqualToSize(CGSizeZero, size)) {
        hash = [NSString stringWithFormat:@"%@_%d.%d", hash, (int)size.width, (int)size.height];
    }
    return hash;
}

//获取图片URL路径
- (NSString *)imageURLForImageId:(NSString *)imageId size:(CGSize)size
{
    if ([NSString isBlankString:imageId]) {
        return nil;
    }
    NSString *url = nil;
    NSRange range = [imageId rangeOfString:@"img/\\w+-" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        range.location  += 4;
        range.length    -= 5;
        imageId = [imageId substringWithRange:range];
    }
    
    NSRange range1 = [imageId rangeOfString:@"group1/[\\w/]+-" options:NSRegularExpressionSearch];
    if (range1.location != NSNotFound) {
        NSString *ext = @"";
        NSRange range2 = [imageId rangeOfString:@"." options:NSBackwardsSearch];
        if (range2.location != NSNotFound) {
            ext = [imageId substringFromIndex:range2.location];
        }
        range1.location = range1.location;
        range1.length = range1.length - 1;
        imageId = [imageId substringWithRange:range1];
        imageId = [NSString stringWithFormat:@"%@%@", imageId, ext];
    }
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        url = [NSString stringWithFormat:@"%@@.webp", imageId];
    } else {
        if((int)size.width==0){
            url = [NSString stringWithFormat:@"%@@%dh_1c_1e.webp", imageId, (int)size.height];
        }else if((int)size.height==0){
            url = [NSString stringWithFormat:@"%@@%dw_1c_1e.webp", imageId, (int)size.width];
        }else{
            url = [NSString stringWithFormat:@"%@@%dw_%dh_1c_1e.webp",imageId, (int)size.width, (int)size.height];
        }
    }
    return url;
}

//删除图片

- (BOOL)deleteImageWithId:(NSString *)imageId
{
    if ([NSString isBlankString:imageId]) {
        DLOG(@"imageId 不能为空");
        return NO;
    }
    NSString *filePath = [self getPathForImage:imageId];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error;
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (!success) {
            DLOG(@"delete image %@", error);
            return NO;
        }
        return success;
    }
    return NO;
}

- (BOOL)deleteImageWithId:(NSString *)imageId size:(CGSize)size
{
    if ([NSString isBlankString:imageId]) {
        DLOG(@"imageId 不能为空");
    }
    NSString *filePath = [self getPathForImage:imageId size:size];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error;
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (!success) {
            DLOG(@"delete image %@", error);
            return NO;
        }
        return success;
    }
    return NO;
}

//下载图片
- (void)downloadImage:(NSString *)imageId success:(imageHandlerSuccess)success failure:(fHandler)failure
{
    
    [self downloadImage:imageId size:CGSizeZero success:success failure:failure];
}
- (void)downloadImage:(NSString *)imageId size:(CGSize)size success:(imageHandlerSuccess)success failure:(fHandler)failure
{
    NSString *path = [self imageURLForImageId:imageId size:size];
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.imageUrlPrefix, path]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageUrl];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIImage *image = (UIImage *)responseObject;
        if (success) {
            success(imageId, image);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [[NSOperationQueue mainQueue] addOperation:operation];
}

- (void)downloadImage:(NSString *)imageId size:(CGSize)size success:(imageHandlerSuccess)success failure:(fHandler)failure progress:(void(^)(long long, long long))progress
{
    //    [APIClient sharedInstance].imageClient;
    //    http://pic.angler.im/51kx0aoLTx7Bax3qLI1ppi@.webp
    //    NSString *url = [self imageURLForImageId:imageId size:size];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //    AFHTTPRequestOperation *operatioin = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //    AFImageResponseSerializer
    //    [self.imageClient api]
    //    AFImageRequestOperation *operation = [AFImageResponseSerializer]
    
}

//从缓存种获取图片
- (UIImage *)getImageFromCacheWithId:(NSString *)imageId;
{
    return [self getImageFromCacheWithId:imageId size:CGSizeZero];
}

- (UIImage *)getImageFromCacheWithId:(NSString *)imageId size:(CGSize)size
{
    if ([NSString isBlankString:imageId]) {
        return nil;
    }
    
    NSString *filePath = [self getPathForImage:imageId size:size];
    UIImage *image = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        image = [UIImage imageWithContentsOfFile:filePath];
    }
    return image;
}

//通过图片Id获取图片，先缓存，没缓存再下载。
- (void)getImageWithId:(NSString *)imageId success:(imageHandlerSuccess)success failure:(fHandler)failure
{
    [self getImageWithId:imageId size:CGSizeZero success:success failure:failure];
}
- (void)getImageWithId:(NSString *)imageId size:(CGSize)size success:(imageHandlerSuccess)success failure:(fHandler)failure
{
    dispatch_async([APIClient shareImageQueue], ^{
        UIImage *image = [self getImageFromCacheWithId:imageId size:size];
        if (!image) {
            [self downloadImage:imageId size:size success:success failure:failure];
        } else {
            success(imageId, image);
        }
    });
}

//上传图片
- (void)uploadImage:(NSData *)imageData success:(void(^)(NSString *imageId))success failure:(fHandler)failure
{
    [self.imageClient apiPostPath:@"upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> fromData) {
        [fromData appendPartWithFileData:imageData name:@"image" fileName:@"image.jepg" mimeType:@"image/jepg"];
    } sHandler:^(id responseObject) {
        if(success)
        {
            NSString *imageId = [responseObject objectForKey:@"filename"];
            success(imageId);
        }
    } fHandler:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)multiUploadImageWithHQAsset:(NSArray *)assets complete:(void(^)(NSArray *imageIds,NSArray *failImageIds))complete
{
    WEAK_SELF;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSMutableArray *imageIds = [NSMutableArray arrayWithCapacity:assets.count];
        for (HQAsset *asset in assets)
        {
            UIImage *image = asset.compressedImage;
            NSString *imageId = [[[image image2Data] MD5] toHexString];
            [[APIClient sharedInstance] saveImage:image imageId:imageId size:CGSizeZero];
            [imageIds addObject:imageId];
        }
        [wSelf multiUploadImageWithImageIds:imageIds complete:complete];
    });
}

- (void)multiUploadImageWithImageIds:(NSArray *)imageIds complete:(void(^)(NSArray *imageIds,NSArray *failImageIds))complete
{
    [self multiUploadImageWithImageId:imageIds successMaps:nil failImageIds:nil complete:^(NSDictionary *imageIdMaps, NSArray *failImageIds) {
        for (NSString *imageId in [imageIdMaps allKeys])
        {
            [self modifyImageId:imageId newImageId:[imageIdMaps objectForKey:imageId] size:CGSizeZero];
        }
        if(complete)
        {
            complete(imageIdMaps.allValues,failImageIds);
        }
    }];
}

- (void)multiUploadImageWithImageId:(NSArray *)imageIds
                        successMaps:(NSMutableDictionary *)successMaps
                       failImageIds:(NSMutableArray *)failImageIds
                           complete:(void(^)(NSDictionary *imageIdMaps,NSArray *failImageIds))complete
{
    //存储成功的数据
    if(!successMaps)
    {
        successMaps = [NSMutableDictionary dictionary];
    }
    //存储失败的数据
    if(!failImageIds)
    {
        failImageIds = [NSMutableArray array];
    }
    //结束标志:imageIds没有东西
    NSString *imageId = [imageIds lastObject];
    if(imageId == nil)
    {
        complete(successMaps,failImageIds);
        return;
    }
    
    NSMutableArray *tempImageIds = [NSMutableArray arrayWithArray:imageIds];
    [tempImageIds removeLastObject];
    [self uploadImageWithImageId:imageId success:^(NSString *newImageId) {
        [successMaps setObject:newImageId forKey:imageId];
        [self multiUploadImageWithImageId:tempImageIds successMaps:successMaps failImageIds:failImageIds complete:complete];
    } failure:^(NSError *error) {
        [failImageIds addObject:imageId];
        [self multiUploadImageWithImageId:tempImageIds successMaps:successMaps failImageIds:failImageIds complete:complete];
    }];
}

//- (void)multiUploadImageWithImageId:(NSArray *)imageIds successMaps:(NSDictionary *)successMaps  failureImageIds success:(void(^)(NSDictionary *imageIdMaps))success failure:(fHandler)failure
//{
//    NSMutableDictionary *temp;
//    if(maps)
//    {
//        temp = [NSMutableDictionary dictionaryWithDictionary:maps];
//    }
//
//    NSString *imageId = [imageIds lastObject];
//    NSMutableArray *imageIdTemps = [NSMutableArray arrayWithArray:imageIds];
//    [imageIdTemps removeLastObject];
//    if (imageId == nil)
//    {
//        if(success)
//        {
//            success(temp);
//        }
//        return;
//    }
//
//    [self uploadImageWithImageId:imageId success:^(NSString *imageId)
//    {
//        [self multiUploadImageWithImageId:imageIdTemps imageIdMaps:temp success:success failure:failure];
//    } failure:^(NSError *error)
//    {
//        [self multiUploadImageWithImageId:imageIdTemps imageIdMaps:temp success:success failure:failure];
//    }];
//}

- (void)uploadImageWithImageId:(NSString *)imageId success:(void(^)(NSString *newImageId))success failure:(fHandler)failure
{
    NSData *data = [[self getCachedImageById:imageId] image2Data];
    NSString *md5 = [[data MD5] toHexString];
    
    NSString *str;
    NSRange rang = [imageId rangeOfString:@"img/\\w+-" options:NSRegularExpressionSearch];
    NSString *imageMD5;
    if(rang.location != NSNotFound)
    {
        rang.location=rang.location+4;
        rang.length=rang.length-5;
        str = [imageId substringWithRange:rang];
        imageMD5 = [Hex62ToStr11 str62Tostr16:str];
        if(success)
        {
            success(imageId);
        }
    }
    else
    {
        __weak __typeof(self) wSelf = self;
        //上传检查图片是否存在
        [self checkExist:md5 sHandler:^(id responseObject)
         {
             NSDictionary *dataDic = [responseObject objectForKey:@"data"];
             if(data && [[dataDic objectForKey:md5] length] != 0 )
             {
                 NSString *newImageId = [dataDic objectForKey:md5];
                 if(success)
                 {
                     success(newImageId);
                 }
             }
             else
             {
                 [wSelf uploadImage:data success:success failure:failure];
             }
         } fHandler:failure];
    }
    
    
}

//检查存在与否
- (void)checkExist:(NSString *)MD5 sHandler:(sHandler)sHandler fHandler:(fHandler)fHandler
{
    if(!MD5)
    {
        if(fHandler)fHandler(nil);
    }
    [self.imageClient apiGetPath:@"check" parameters:@{@"md5":MD5} sHandler:sHandler fHandler:fHandler];
}

//清空缓存
- (void)clearCache
{
    NSString *dir = [self imageRootPath];
    [[NSFileManager defaultManager] removeItemAtPath:dir error:nil];
    NSString *cachesPath = [DirectoryUtil libCachePath];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachesPath];
    for (NSString *file in files) {
        NSString *path = [cachesPath stringByAppendingPathComponent:file];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachesPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:cachesPath error:nil];
    }
}

//获取缓存大小
- (long long)getCacheSize
{
    NSString *cachePath = [DirectoryUtil libCachePath];
    long long result = 0;
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    for (NSString *file in files) {
        NSString *path = [cachePath stringByAppendingPathComponent:file];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            result += [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
        }
    }
    return result;
}

- (NSString *)saveImage:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    if(data == nil)
    {
        return nil;
    }
    NSString *filename = [[data MD5] toHexString];
    NSString *filepath = [self getPathForImage:filename];
    [image saveToPath:filepath];
    return filename;
}

- (NSString *)saveImage:(UIImage *)image size:(CGSize)size
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    if(data == nil)
    {
        return nil;
    }
    NSString *filename = [[data MD5] toHexString];
    NSString *filepath = [self getPathForImage:filename size:size];
    [image saveToPath:filepath];
    return filename;
}

- (NSString *)saveImage:(UIImage *)image imageId:(NSString *)imageId size:(CGSize)size
{
    
    NSString *filepath = [self getPathForImage:imageId size:size];
    [image saveToPath:filepath];
    return filepath;
    
}

//修改文件名
- (void)modifyImageId:(NSString *)imageId newImageId:(NSString *)newImageId size:(CGSize)size
{
    NSError *error;
    NSFileManager *filemanager = [[NSFileManager alloc]init];
    NSString *path = [self getPathForImage:imageId size:size];
    NSString *newPath = [self getPathForImage:newImageId size:size];
    if([filemanager fileExistsAtPath:path])
    {
        if ([filemanager moveItemAtPath:path toPath:newPath error:&error] != YES)
            DLOG(@"Unable to move file: %@", [error localizedDescription]);
    }
}

- (NSString *)imageUrlForId:(NSString *)imageId size:(CGSize)size {
    if (imageId == nil || imageId.length == 0) {
        return nil;
    }
    NSString *url;
    NSRange rang = [imageId rangeOfString:@"img/\\w+-" options:NSRegularExpressionSearch];
    if(rang.location != NSNotFound)
    {
        rang.location=rang.location+4;
        rang.length=rang.length-5;
        imageId = [imageId substringWithRange:rang];
    }
    NSRange rang1 = [imageId rangeOfString:@"group1/[\\w/]+-" options:NSRegularExpressionSearch];
    if(rang1.location != NSNotFound)
    {
        NSString *ext = @"";
        NSRange range2 = [imageId rangeOfString:@"." options:NSBackwardsSearch];
        if (range2.location != NSNotFound) {
            ext = [imageId substringFromIndex:(range2.location)];
        }
        rang1.location=rang1.location;
        rang1.length=rang1.length-1;
        imageId = [imageId substringWithRange:rang1];
        imageId=[NSString stringWithFormat:@"%@%@",imageId,ext];
    }
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        url = [NSString stringWithFormat:@"%@%@@.webp", self.imageUrlPrefix, imageId];
    } else {
        if((int)size.width==0){
            url = [NSString stringWithFormat:@"%@%@@%dh_1c_1e.webp", self.imageUrlPrefix, imageId, (int)size.height];
        }else if((int)size.height==0){
            url = [NSString stringWithFormat:@"%@%@@%dw_1c_1e.webp", self.imageUrlPrefix, imageId, (int)size.width];
        }else{
            url = [NSString stringWithFormat:@"%@%@@%dw_%dh_1c_1e.webp", self.imageUrlPrefix, imageId, (int)size.width, (int)size.height];
        }
        
    }
    return url;
}

- (UIImage *)getCachedImageById:(NSString *)imageId {
    return [self getCachedImageById:imageId size:CGSizeZero];
}

- (UIImage *)getCachedImageById:(NSString *)imageId size:(CGSize)size {
    if (imageId == nil || imageId.length == 0) {
        return nil;
    }
    NSString *filepath = [self getPathForImage:imageId size:size];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        UIImage *image = [UIImage imageWithContentsOfFile:filepath];
        return image;
    } else {
        return nil;
    }
}

- (void)getCachedImageById:(NSString *)imageId size:(CGSize)size finish:(void(^)(UIImage *image))result
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
                   {
                       if (imageId == nil || imageId.length == 0)
                       {
                           if(result)
                           {
                               result(nil);
                           }
                       }
                       NSString *filepath = [self getPathForImage:imageId size:size];
                       if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
                       {
                           UIImage *image = [UIImage imageWithContentsOfFile:filepath];
                           if(result)
                           {
                               result(image);
                           }
                       }
                       else
                       {
                           if(result)
                           {
                               result(nil);
                           }
                       }
                   });
}
@end
