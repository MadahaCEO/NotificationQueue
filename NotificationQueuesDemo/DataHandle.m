//
//  DataHandle.m
//  NotificationQueuesDemo
//
//  Created by Apple on 2018/11/18.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import "DataHandle.h"

@implementation DataHandle


- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)simulateDataHandle:(NSArray *)array type:(int)type {
    
    NSLog(@"\n 开始数据深加工 ----- %@ ", [NSThread currentThread]);
    sleep(3);
    NSLog(@"\n 数据深加工 ----结束  %@ ", [NSThread currentThread]);

    if (self.delegate && [self.delegate respondsToSelector:@selector(dataComplete:type:)]) {
        [self.delegate dataComplete:array type:type];
    }
    
}

@end
