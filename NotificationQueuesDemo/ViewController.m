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



@interface ViewController ()<NotificationDelegate>
{
    
    dispatch_queue_t  taskQueue;
    
}

@property (nonatomic, strong)    Notification *notifi;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    taskQueue = dispatch_queue_create("com.no.test", DISPATCH_QUEUE_SERIAL);
    
    
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





- (void)pushData:(NSArray *)array {
    
    NSLog(@"\n 代理回调收到通知数据 %@ ------ %@ \n",array,[NSThread currentThread]);
    
}



#pragma mark - getter

- (Notification *)notifi {
    
    if (!_notifi) {
        _notifi = [[Notification alloc] init];
        _notifi.delegate = self;
    }
    return _notifi;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
