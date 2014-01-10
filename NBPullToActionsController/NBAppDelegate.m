//
//  NBAppDelegate.m
//  NBPullToActionsController
//
//  Created by zhe on 1/6/14.
//  Copyright (c) 2014 xuzhe.com. All rights reserved.
//

#import "NBAppDelegate.h"

#import "NBTableViewController.h"

@implementation NBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NBTableViewController *tableViewController = [[NBTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
