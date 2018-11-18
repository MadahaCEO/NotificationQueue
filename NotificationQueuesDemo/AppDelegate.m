//
//  AppDelegate.m
//  NotificationQueuesDemo
//
//  Created by Apple on 2018/11/11.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    
    dispatch_queue_t  taskQueue;
    
    NSMutableArray *array;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    array = [NSMutableArray arrayWithCapacity:0];
    
    taskQueue = dispatch_queue_create("com.no.test11", DISPATCH_QUEUE_SERIAL);

    
    __weak typeof(self)weakSelf = self;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[NSNotificationCenter defaultCenter] addObserverForName:@"test"
                                                          object:nil
                                                           queue:[NSOperationQueue currentQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          
                                                          [weakSelf handleNotifi:note];
                                                          
                                                      }];
        
    });
    return YES;
}


- (void)handleNotifi:(NSNotification *)notification {
    
    [self test:notification];
}


- (void)test:(NSNotification *)notification {
    
    NSLog(@" \n\n %@=======%@",notification.userInfo.description,[NSThread currentThread]);
    
    dispatch_async(taskQueue, ^{
       
        [array addObject:notification];
        
//        NSLog(@" \n\n %d=======%@",array.count,[NSThread currentThread]);

    });
    
    dispatch_async(taskQueue, ^{
        
        if (array.count > 9) {
            NSLog(@" \n\n 条件达到 %@=======%d",[NSThread currentThread],array.count);

            [array removeAllObjects];
        }
        
        
    });

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
