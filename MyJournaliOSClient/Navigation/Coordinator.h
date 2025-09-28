//
//  Coordinator.h
//  MyJournaliOSClient
//
//  Created by Azizbek Asadov on 28.09.2025.
//

#ifndef Coordinator_h
#define Coordinator_h

#import "AppDestination.h"

@protocol Coordinator <NSObject>

- (void) pushSceneWithSceneIdentifier:(AppDestination) destination;
- (void) popScene;
- (void) popToRootScene;

@end

#endif /* Coordinator_h */
