//
//  ZZDataCache.h
//  ZZDataCache
//
//  Created by zezefamily on 15/7/3.
//  Copyright (c) 2015年 zezefamily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZDataCache : NSObject

#define ZZDataCacheFileName @"DataCache"

@property (nonatomic,assign) float time;

+(ZZDataCache *)shareInstance;

/*
 方法中的tag参数可根据实际情况自行定义(可以请求各种数据的接口URL)
*/

//存储缓存文件
- (void)saveData:(NSData *)data withInterfaceTag:(NSInteger)tag;

//读取缓存文件
- (NSData *)readDataWithInterfaceTag:(NSInteger)tag;

//读取当前缓存文件大小(总值)
- (NSString *)CacheFileSize;

//清空缓存数据
- (BOOL)deleteCacheFileInfo;

@end
