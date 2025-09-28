//
//  SceneDelegate.m
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 27.09.2025.
//

#import "SceneDelegate.h"
#import "PostsFeedViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *) scene];
    
    PostsFeedViewController* rootViewController = [[PostsFeedViewController alloc] init];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [self.window makeKeyAndVisible];
}

@end
