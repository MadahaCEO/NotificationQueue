//
//  DataHandle.h
//  NotificationQueuesDemo
//
//  Created by Apple on 2018/11/18.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DataHandleDelegate<NSObject>

- (void)dataComplete:(NSArray *)array type:(int)type;

@end



@interface DataHandle : NSObject

@property (nonatomic, weak) id <DataHandleDelegate>delegate;

- (void)simulateDataHandle:(NSArray *)array type:(int)type;

@end
