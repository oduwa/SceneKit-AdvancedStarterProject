//
//  GameViewController.m
//  SceneKitTest
//
//  Created by Odie Edo-Osagie on 27/04/2015.
//  Copyright (c) 2015 Odie Edo-Osagie. All rights reserved.
//

#import "GameViewController.h"
#import "GameCharacter.h"
#import "GameScene.h"

BOOL shouldStop;

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SCNView *scnView = (SCNView *)self.view;
    
    // Setup Game Scene
    GameScene *scene = [[GameScene alloc] initWithView:scnView];
    [scene setupCamera];
    scnView.backgroundColor = [UIColor lightGrayColor];
    
    // Setup Game Character
    GameCharacter *character = [[GameCharacter alloc] initFromScene:[SCNScene sceneNamed:@"art.scnassets/SpongeBob.dae"] withName:@"SpongeBob"];
    [character setupLimbsWithNameForLeftLeg:@"leg_thigh_left" nameForRightLeg:@"leg_thigh_right"];
    [scene.rootNode addChildNode:character.characterNode];
    
    // Populate scene with all nodes associated with game character
    for(SCNNode *eachNode in character.nodes){
        [scene.rootNode addChildNode:eachNode];
    }
    
    // rotate character. NOTE: this is not necessary. Doing it because i know my model is facing down and i want to correct it.
    [character startWalkAnimationUsingLimbsWithStepDuration:0.4];
    [[scene.rootNode childNodeWithName:@"Armature" recursively:YES] runAction:[SCNAction rotateByX:-1.7 y:0 z:0 duration:1]];
    
    scnView.scene = scene;
    
    scnView.allowsCameraControl = YES;
    scnView.showsStatistics = YES;
    
    
    
    /*
    // create a new scene
    //SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.dae"];
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/SpongeBob.dae"];
    [[scene.rootNode childNodeWithName:@"Armature" recursively:YES] runAction:[SCNAction rotateByX:-1.57 y:0 z:0 duration:0]];
    
    
    SCNScene *plainScene = [SCNScene sceneNamed:@"art.scnassets/ship.dae"];
    
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, 0, 5);
    [scene.rootNode addChildNode:cameraNode];
    
    //[scene.rootNode addChildNode:[scene.rootNode childNodeWithName:@"SpongeBob" recursively:YES]];
    
    SCNNode *leftLeg = [scene.rootNode childNodeWithName:@"leg_thigh_left" recursively:YES];
    SCNNode *rightLeg = [scene.rootNode childNodeWithName:@"leg_thigh_right" recursively:YES];
    //[self walkAnimationLeftLeg:leftLeg andRightLeg:rightLeg withSpeed:0.4];
    //[ship runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    
    //SCNView *scnView = (SCNView *)self.view;
    scnView.scene = scene;
    scnView.allowsCameraControl = YES;
    */
    

    /*
    // create and add a camera to the scene
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    [scene.rootNode addChildNode:cameraNode];
    
    // place the camera
    cameraNode.position = SCNVector3Make(0, 0, 15);
    
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [scene.rootNode addChildNode:lightNode];
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    // retrieve the ship node
    SCNNode *ship = [scene.rootNode childNodeWithName:@"ship" recursively:YES];
    
    // animate the 3d object
    [ship runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // set the scene to the view
    scnView.scene = scene;
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = YES;
        
    // show statistics such as fps and timing information
    scnView.showsStatistics = YES;

    // configure the view
    scnView.backgroundColor = [UIColor blackColor];
    
    // add a tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:scnView.gestureRecognizers];
    scnView.gestureRecognizers = gestureRecognizers;
     */
    
    //UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    //[scnView addGestureRecognizer:tapGesture];
}

- (void) tap
{
    shouldStop = !shouldStop;
    if(!shouldStop){
        
    }
}

- (void) walkAnimationLeftLeg:(SCNNode *)leftLeg andRightLeg:(SCNNode *)rightLeg withSpeed:(CGFloat) speed
{
    // LEFT UP
    [leftLeg runAction:[SCNAction rotateByX:0 y:0.79 z:0 duration:speed] completionHandler:^{
        // LEFT DOWN
        [leftLeg runAction:[SCNAction rotateByX:0 y:-0.79 z:0 duration:speed] completionHandler:^{
            // RIGHT UP
            [rightLeg runAction:[SCNAction rotateByX:0 y:0.79 z:0 duration:speed] completionHandler:^{
                // RIGHT DOWN
                [rightLeg runAction:[SCNAction rotateByX:0 y:-0.79 z:0 duration:speed] completionHandler:^{
                    if(!shouldStop){
                        [self walkAnimationLeftLeg:leftLeg andRightLeg:rightLeg withSpeed:speed];
                    }
                }];
            }];
        }];
    }];
}

- (void) stopWalkAnimation
{
    shouldStop = YES;
}

- (void) handleTap:(UIGestureRecognizer*)gestureRecognize
{
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // check what nodes are tapped
    CGPoint p = [gestureRecognize locationInView:scnView];
    NSArray *hitResults = [scnView hitTest:p options:nil];
    
    // check that we clicked on at least one object
    if([hitResults count] > 0){
        // retrieved the first clicked object
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        
        // get its material
        SCNMaterial *material = result.node.geometry.firstMaterial;
        
        // highlight it
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];
        
        // on completion - unhighlight
        [SCNTransaction setCompletionBlock:^{
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.5];
            
            material.emission.contents = [UIColor blackColor];
            
            [SCNTransaction commit];
        }];
        
        material.emission.contents = [UIColor redColor];
        
        [SCNTransaction commit];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
