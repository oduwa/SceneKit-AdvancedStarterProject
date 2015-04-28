//
//  GameScene.m
//  SceneKitTest
//
//  Created by Odie Edo-Osagie on 27/04/2015.
//  Copyright (c) 2015 Odie Edo-Osagie. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

- (id) initWithView:(SCNView *)view
{
    self = [super init];
    
    if(self){
        _sceneView = view;
    }
    
    return self;
}

- (void) setupCamera
{
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, 0, 5);
    [self.rootNode addChildNode:cameraNode];
}

@end
