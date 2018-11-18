//
//  SecondViewController.m
//  NotificationQueuesDemo
//
//  Created by Apple on 2018/11/18.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import "SecondViewController.h"


static NSString *const kNotificationName1 = @"name1";
static NSString *const kNotificationName2 = @"name2";


@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    
    UIButton     *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"串行队列 推" forState:UIControlStateNormal];
    button.tag = 100;
    button.frame = CGRectMake(0, 100, 100, 80);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.center = button.center;
    [self.view addSubview:indicatorView];
    
    [indicatorView startAnimating];

    
    UIButton     *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = 200;
    [button2 setTitle:@"并发队列 推" forState:UIControlStateNormal];
    button2.frame = CGRectMake(0, 200, 100, 80);
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    
    UIButton     *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.tag = 300;
    [button3 setTitle:@"主发队列 推" forState:UIControlStateNormal];
    button3.frame = CGRectMake(0, 300, 100, 80);
    button3.backgroundColor = [UIColor redColor];
    [button3 addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    
    
    UIButton     *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"Back" forState:UIControlStateNormal];
    button1.frame = CGRectMake(0, 400, 100, 80);
    button1.backgroundColor = [UIColor redColor];
    [button1 addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    
}


- (void)backMethod {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)test:(UIButton *)button {
    
    dispatch_queue_t queue ;
    NSString *pushMethod = @"";
    if (button.tag == 100) {
       
        pushMethod = @"串行队列";
        queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    
    } else if (button.tag == 200) {
    
        pushMethod = @"并发队列";
        queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
   
    } else if (button.tag == 300) {
       
        pushMethod = @"主队列";
        queue = dispatch_get_main_queue();
    }
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {

            NSLog(@"\n %@ 发出 通知1 数据 ----- %@ ",pushMethod, [NSThread currentThread]);
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName1
                                                                object:nil
                                                              userInfo:@{@"index":@(i+200)}];
            NSLog(@"\n %@ 结束 通知1  ----- %@ ", pushMethod, [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 2; i++) {
            
            NSLog(@"\n %@ 发出 通知2 数据 ----- %@ ",pushMethod, [NSThread currentThread]);
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName2
                                                                object:nil
                                                              userInfo:@{@"index":@(i+100)}];
            NSLog(@"\n %@ 结束 通知2  ----- %@ ",pushMethod, [NSThread currentThread]);
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
