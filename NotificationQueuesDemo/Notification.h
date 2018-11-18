//
//  Notification.h
//  NotificationQueuesDemo
//
//  Created by Apple on 2018/11/18.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol NotificationDelegate<NSObject>

- (void)pushData:(NSArray *)array;

@end


@interface Notification : NSObject


@property (nonatomic, weak) id <NotificationDelegate>delegate;


- (void)connection;

@end
