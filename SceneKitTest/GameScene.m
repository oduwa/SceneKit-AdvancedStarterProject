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
        //self.background.contents = @[@"bluefreeze_right.jpg", @"bluefreeze_back.jpg", @"bluefreeze_top.jpg", @"bluefreeze_front.jpg", @"bluefreeze_left.jpg", @"bluefreeze_front.jpg"];

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

- (void) setupSkyboxWithName:(NSString *)skybox andFileExtension:(NSString *)ext
{
    NSString *right = [NSString stringWithFormat:@"%@_right.%@",skybox, ext];
    NSString *left = [NSString stringWithFormat:@"%@_left.%@",skybox, ext];
    NSString *top = [NSString stringWithFormat:@"%@_top.%@",skybox, ext];
    NSString *bottom = [NSString stringWithFormat:@"%@_bottom.%@",skybox, ext];
    NSString *front = [NSString stringWithFormat:@"%@_front.%@",skybox, ext];
    NSString *back = [NSString stringWithFormat:@"%@_back.%@",skybox, ext];
    
    self.background.contents = @[right, back, top, bottom, left, front];
}

@end
