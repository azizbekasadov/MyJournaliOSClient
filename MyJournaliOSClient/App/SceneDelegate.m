//
//  SceneDelegate.m
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 27.09.2025.
//

#import "SceneDelegate.h"
#import "AppCoordinator.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    UIWindowScene* windowScene = [[UIWindowScene alloc] initWithSession:session connectionOptions:connectionOptions];
    _coordinator = [[AppCoordinator alloc] initWithWindowScene:windowScene];
    [_coordinator start];
}

@end
