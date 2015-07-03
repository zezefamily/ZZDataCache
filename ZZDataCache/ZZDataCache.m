//
//  ZZDataCache.m
//  ZZDataCache
//
//  Created by zezefamily on 15/7/3.
//  Copyright (c) 2015年 zezefamily. All rights reserved.
//

#import "ZZDataCache.h"
#import "NSString+Hashing.h"
@implementation ZZDataCache
static ZZDataCache *dataCache = nil;

+(ZZDataCache *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataCache = [[self alloc]init];
        dataCache.time = 30 * 60;
    });
    return dataCache;
}


- (void)saveData:(NSData *)data withInterfaceParam:(NSMutableDictionary *)param
{
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),ZZDataCacheFileName];
    [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *md5Name = [[NSString stringWithFormat:@"%@",param] MD5Hash];
    NSString *file = [NSString stringWithFormat:@"%@/%@",path,md5Name];
    BOOL save = [data writeToFile:file atomically:YES];
    if(save == YES){
        NSLog(@"添加缓存数据成功");
    }else{
        NSLog(@"添加缓存数据错误");
    }
}

//
//- (void)saveData:(NSData *)data withInterfaceTag:(NSInteger)tag
//{
//    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),ZZDataCacheFileName];
//    [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
//    NSString *md5Name = [[NSString stringWithFormat:@"%ld",tag] MD5Hash];
//    NSString *file = [NSString stringWithFormat:@"%@/%@",path,md5Name];
//    BOOL save = [data writeToFile:file atomically:YES];
//    if(save == YES){
//        NSLog(@"添加缓存数据成功");
//    }else{
//        NSLog(@"添加缓存数据错误");
//    }
//}

- (NSData *)readDataWithInterfaceParam:(NSMutableDictionary *)param
{
    
    NSString *tagStr = [NSString stringWithFormat:@"%@",param];
    NSString *file = [NSString stringWithFormat:@"%@/Documents/%@/%@",NSHomeDirectory(),ZZDataCacheFileName,[tagStr MD5Hash]];
    if([[NSFileManager defaultManager]fileExistsAtPath:file] == NO){
        NSLog(@"没有缓存文件");
        return nil;
    }
    //  返回文件已经存在时间
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[self getFileLastModifyTimeWithFileName:file]];
    //  判断缓存是否超时
    if(interval >self.time){
        NSLog(@"缓存文件过期");
        return nil;
    }
    NSLog(@"读取缓存文件");
    NSData *data = [[NSData alloc]initWithContentsOfFile:file];
    return data;
}

//- (NSData *)readDataWithInterfaceTag:(NSInteger)tag
//{
//    NSLog(@"读取缓存文件");
//    NSString *tagStr = [NSString stringWithFormat:@"%ld",tag];
//    NSString *file = [NSString stringWithFormat:@"%@/Documents/%@/%@",NSHomeDirectory(),ZZDataCacheFileName,[tagStr MD5Hash]];
//    if([[NSFileManager defaultManager]fileExistsAtPath:file] == NO){
//        return nil;
//    }
////  返回文件已经存在时间
//    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[self getFileLastModifyTimeWithFileName:file]];
////  判断缓存是否超时
//    if(interval >self.time){
//        return nil;
//    }
//    NSData *data = [[NSData alloc]initWithContentsOfFile:file];
//    return data;
//}

//获取缓存文件最后一次的存储时间
- (NSDate *)getFileLastModifyTimeWithFileName:(NSString *)fileName
{
    NSDictionary *dict = [[NSFileManager defaultManager]attributesOfItemAtPath:fileName error:nil];
    return [dict objectForKey:NSFileModificationDate];
}

- (NSString *)CacheFileSize
{
    NSDictionary * dict = [self getFileAttribute];
    //1兆字节(mb)=1048576字节(b)
    NSLog(@"缓存文件总大小:%.0f",[[dict objectForKey:NSFileSize]floatValue]);
    return [NSString stringWithFormat:@"%fMB",[[dict objectForKey:NSFileSize]floatValue]/1048576];
}

- (BOOL)deleteCacheFileInfo
{
    BOOL isRemove = [[NSFileManager defaultManager]removeItemAtPath:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),ZZDataCacheFileName] error:nil];
    return isRemove;
}


//获取文件属性
- (NSDictionary *)getFileAttribute
{
    return [[NSFileManager defaultManager]attributesOfItemAtPath:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),ZZDataCacheFileName] error:nil];
    
}

/*
 获取文件属性 keys and values
 NSFileCreationDate = "2015-07-03 04:28:59 +0000";
 NSFileExtensionHidden = 0;
 NSFileGroupOwnerAccountID = 20;
 NSFileGroupOwnerAccountName = staff;
 NSFileModificationDate = "2015-07-03 04:29:21 +0000";
 NSFileOwnerAccountID = 501;
 NSFilePosixPermissions = 493;
 NSFileReferenceCount = 4;
 NSFileSize = 136;
 NSFileSystemFileNumber = 10889889;
 NSFileSystemNumber = 16777220;
 NSFileType = NSFileTypeDirectory;
 */



/*
 -（BOOL）contentsAtPath：path                从文件中读取数据
 -（BOOL）createFileAtPath：path contents：（BOOL）data attributes：attr      向一个文件写入数据
 -（BOOL）removeFileAtPath: path handler: handler   删除一个文件
 -（BOOL）movePath: from toPath: to handler: handler 重命名或移动一个文件（to可能已经存在）
 -（BOOL）copyPath：from toPath：to handler: handler 复制文件 （to不能存在）
 -（BOOL）contentsEqualAtPath:path1 andPath:path2    比较两个文件的内容
 -（BOOL）fileExistsAtPath：path    测试文件是否存在
 -（BOOL）isReadablefileAtPath:path 测试文件是否存在，且是否能执行读操作
 -（BOOL）isWritablefileAtPath:path 测试文件是否存在，且是否能执行写操作
 -（NSDictionary *）fileAttributesAtPath：path traverseLink:(BOOL)flag   获取文件的属性
 -（BOOL）changeFileAttributes：attr atPath：path                        更改文件的属性
 */



@end
