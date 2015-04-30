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

/**
 * Create a GameScene associated with a specified view.
 *
 * @param View within which to create GameScene
 */
- (id) initWithView:(SCNView *)view;


/**
 * Initialize camera.
 */
- (void) setupCamera;


/**
 * Creates a skybox using 6 EQUALLY SIZED images to texture the faces of a cube around
 * the environment.\n
 *
 * The six images must have the format [skybox_name]_[position].[ext] where [position] is one of
 * right, left, top, bottom, front or back.
 *
 * @param skybox The name of the skybox.
 * @param ext The file extension of the skybox images.
 */
- (void) setupSkyboxWithName:(NSString *)skybox andFileExtension:(NSString *)ext;

@end
