//
//  main.m
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 27.09.2025.
//

@import Foundation;
@import UIKit;

#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
