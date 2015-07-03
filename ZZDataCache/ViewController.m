//
//  ViewController.m
//  ZZDataCache
//
//  Created by zezefamily on 15/7/3.
//  Copyright (c) 2015年 zezefamily. All rights reserved.
//

#import "ViewController.h"
#import "ZZDataCache.h"
@interface ViewController ()
{
    __block NSData *data1;
    __block NSData *data2;
    
    ZZDataCache *cache;
}
@property (weak, nonatomic) IBOutlet UIButton *reloadBtl;

@property (weak, nonatomic) IBOutlet UIImageView *left;
@property (weak, nonatomic) IBOutlet UIImageView *right;
@property (weak, nonatomic) IBOutlet UILabel *fileSizelabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.reloadBtl.userInteractionEnabled = NO;
    
    cache = [ZZDataCache shareInstance];
    
    if([cache readDataWithInterfaceTag:110]==nil||[cache readDataWithInterfaceTag:111]==nil){
//        重新下载
       [self downData];
    }
    else {
//        读取缓存
        self.fileSizelabel.text = [NSString stringWithFormat:@"缓存数据大小：%@",[cache CacheFileSize]];
        self.left.image = [UIImage imageWithData:[cache readDataWithInterfaceTag:110]];
        self.right.image = [UIImage imageWithData:[cache readDataWithInterfaceTag:111]];
        
    }
    
    
}

- (void)downData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        data1 = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:@"http://e.hiphotos.baidu.com/image/pic/item/c9fcc3cec3fdfc03f60bb0f0d63f8794a4c22602.jpg"]];
        data2 = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:@"http://c.hiphotos.baidu.com/image/pic/item/dcc451da81cb39db2458144ed2160924ab183009.jpg"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [cache saveData:data1 withInterfaceTag:110];
            [cache saveData:data2 withInterfaceTag:111];
            self.left.image = [UIImage imageWithData:data1];
            self.right.image = [UIImage imageWithData:data2];
            self.fileSizelabel.text = [NSString stringWithFormat:@"缓存数据大小：%@",[cache CacheFileSize]];
            
        });
    });
}

- (IBAction)deleteData:(id)sender {
    
    if([cache deleteCacheFileInfo] == YES){
        self.fileSizelabel.text = [NSString stringWithFormat:@"缓存数据大小：%@",[cache CacheFileSize]];
    }
    
    self.reloadBtl.userInteractionEnabled = YES;
}
- (IBAction)reload:(id)sender {

    [self downData];
    self.reloadBtl.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
