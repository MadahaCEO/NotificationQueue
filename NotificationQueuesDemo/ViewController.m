//
//  ViewController.m
//  NotificationQueuesDemo
//
//  Created by Apple on 2018/11/11.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "Notification.h"
#import "DataHandle.h"


/*
 设计模式参考LFLiveKit，所有的数据处理完成后，都回调到当前类，当前类充当了业务逻辑调度者的角色，不在个别类中引入部分有业务相关的类
 */

@interface ViewController ()<NotificationDelegate,DataHandleDelegate>


@property (nonatomic, strong)    Notification *notifi;
@property (nonatomic, strong)    DataHandle *dataHandle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    UIButton     *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 100, 80, 80);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self.notifi connection];
    
}


- (void)test {
    
    SecondViewController *vc = [[SecondViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
}




#pragma mark - delegate

- (void)pushData:(NSArray *)array type:(int)type {
    
    NSLog(@"\n 代理回调收到 通知%d 数据 %lu个   ------ %@ \n",type,(unsigned long)array.count,[NSThread currentThread]);
    
    [self.dataHandle simulateDataHandle:array type:type];
}

- (void)dataComplete:(NSArray *)array type:(int)type {
    
    NSLog(@"\n 代理回调收到 加工完成的%d 数据 %lu个   ------ %@ \n",type,(unsigned long)array.count,[NSThread currentThread]);

}



#pragma mark - getter

- (Notification *)notifi {
    
    if (!_notifi) {
        _notifi = [[Notification alloc] init];
        _notifi.delegate = self;
    }
    return _notifi;
}

- (DataHandle *)dataHandle {
    
    if (!_dataHandle) {
        _dataHandle = [[DataHandle alloc] init];
        _dataHandle.delegate = self;
    }
    return _dataHandle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
