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
{
    
    dispatch_queue_t queue1;
    dispatch_queue_t queue2;

}

@property (nonatomic, strong) NSMutableArray *dataSource1;
@property (nonatomic, strong) NSMutableArray *dataSource2;


@end

@implementation Notification

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        
//         串行、并行都解决问题，要看具体场景。
        
        queue1 = dispatch_queue_create("com.notification.queue1", DISPATCH_QUEUE_SERIAL);
        queue2 = dispatch_queue_create("com.notification.queue2", DISPATCH_QUEUE_SERIAL);
 /*
        queue1 = dispatch_queue_create("com.notification.queue1", DISPATCH_QUEUE_CONCURRENT);
        queue2 = dispatch_queue_create("com.notification.queue2", DISPATCH_QUEUE_CONCURRENT);
*/
        
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
                                                           queue:[NSOperationQueue currentQueue]
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
//    sleep(1.0);
    /*
     依次加入数组，够条件就回调，然后清空数组，只适合串行队列
     如果并行，添加和删除在两个线程， 会造成某个时间点同时操作数组（刚加进去就被清空了 或 清空后马上就加进去一个），这样判断条件就失效了。
     */
    dispatch_async(queue1, ^{
        
        [self.dataSource1 addObject:note];
        NSLog(@"\n 通知1 加入数组 %lu ----- %@ ",(unsigned long)self.dataSource1.count, [NSThread currentThread]);
    });
    
    dispatch_async(queue1, ^{
        
        if (self.dataSource1.count == 2) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(pushData:type:)]) {
                [self.delegate pushData:self.dataSource1 type:1];
            }
            
            [self.dataSource1 removeAllObjects];
        }
    });
}

- (void)receviedNotificaion2:(NSNotification *)note {
    
    NSLog(@"\n 收到 通知2 数据 ----- %@ ", [NSThread currentThread]);
//    sleep(2.0);

    dispatch_async(queue2, ^{
        
        [self.dataSource2 addObject:note];
        NSLog(@"\n 通知2加入数组 %lu ----- %@ ",(unsigned long)self.dataSource2.count, [NSThread currentThread]);
    });
    
    dispatch_async(queue2, ^{
        
        if (self.dataSource2.count == 2) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(pushData:type:)]) {
                [self.delegate pushData:self.dataSource2 type:2];
            }
            
            [self.dataSource2 removeAllObjects];
        }
    });
}


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
