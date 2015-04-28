//
//  GameScene.h
//  SceneKitTest
//
//  Created by Odie Edo-Osagie on 27/04/2015.
//  Copyright (c) 2015 Odie Edo-Osagie. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface GameScene : SCNScene

@property (nonatomic, strong) SCNView *sceneView;
@property (nonatomic, strong) SCNNode *cameraNode;

- (id) initWithView:(SCNView *)view;
- (void) setupCamera;

@end
