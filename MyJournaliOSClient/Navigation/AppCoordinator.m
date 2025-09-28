//
//  AppCoordinator.m
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 28.09.2025.
//

@import UIKit;

#import "Coordinator.h"
#import "AppCoordinator.h"
#import "PostsFeedViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppCoordinator(Coordinator)

@end

@implementation AppCoordinator

- (instancetype) initWithWindowScene: (UIWindowScene*) windowScene {
    self = [super init];
    if (self) {
        _window = [[UIWindow alloc] initWithWindowScene:windowScene];
    }
    return self;
}

- (void) start {
    PostsFeedViewController* rootViewController = [[PostsFeedViewController alloc] initWithCoordinator:self];
    
    _navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    self.window.rootViewController = _navigationController;
    [self.window makeKeyAndVisible];
}

#pragma mark: - Coordinator methods

- (void) pushSceneWithSceneIdentifier:(AppDestination) destination {
    switch (destination) {
        case PostScene: {
            PostsFeedViewController *postsFeedViewController = [[PostsFeedViewController alloc] init];
            [self.navigationController pushViewController:postsFeedViewController animated:YES];
            break;
        }
        case LoginScene: {
            UIViewController *viewController = [[UIViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void) popScene {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) popToRootScene {
    PostsFeedViewController *postsFeedViewController = [[PostsFeedViewController alloc] init];
    NSArray<UIViewController*>* viewControllers = [NSArray arrayWithObject:postsFeedViewController];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}


@end

NS_ASSUME_NONNULL_END
