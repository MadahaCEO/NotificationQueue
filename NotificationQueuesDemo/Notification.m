//
//  Notification.m
//  NotificationQueuesDemo
//
//  Created by Apple on 2018/11/18.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import "Notification.h"


static NSString *const kNotificationName1 = @"name1";
static NSString *const kNotificationName2 = @"name2";

@interface Notification ()


@property (nonatomic, strong) NSMutableArray *dataSource1;
@property (nonatomic, strong) NSMutableArray *dataSource2;


@end

@implementation Notification

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self addNotifications];
    }
    return self;
}


- (void)connection {
    

}

#pragma mark - Notification

- (void)addNotifications {
    
    
    __weak typeof(self) weakSelf = self;
    
    
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        NSLog(@"\n 注册 通知  %@----- %@ ", [NSThread currentThread],[NSOperationQueue currentQueue]);
    
    /*
     queue: 决定接收通知的线程
            nil-与发通知的线程一致，
            currentQueue-与注册通知的线程一致，
            mainQueue-在主线程
     usingBlock: 在规定的线程回调收到的通知
     */
    [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationName1
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          
                                                          [weakSelf receviedNotificaion1:note];
                                                      }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receviedNotificaion2:)
                                                 name:kNotificationName2
                                               object:nil];
        });
}

- (void)receviedNotificaion1:(NSNotification *)note {
    
    NSLog(@"\n 收到 通知1 数据 ----- %@ ", [NSThread currentThread]);
    sleep(1.0);
    
    [self.dataSource1 addObject:note];
    
    if (self.dataSource1.count == 20) {
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushData:)]) {
        [self.delegate pushData:@[@"11"]];
    }

}

- (void)receviedNotificaion2:(NSNotification *)note {
    
    NSLog(@"\n 收到 通知2 数据 ----- %@ ", [NSThread currentThread]);
    sleep(2.0);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushData:)]) {
        [self.delegate pushData:@[@"22"]];
    }
}

//NSLog(@"\n %@************%@",self,self.delegate);


- (NSMutableArray *)dataSource1 {
    if (!_dataSource1) {
        _dataSource1 = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataSource1;
}

- (NSMutableArray *)dataSource2 {
    if (!_dataSource2) {
        _dataSource2 = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataSource2;
}

@end
