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

@implementation GameViewController{
    SCNNode *cam;
    NSMutableArray *animations;
    SCNNode *node;
    //SCNScene *scene;
    GameScene *scene;
    GameCharacter *character;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    SCNView *scnView = (SCNView *)self.view;
    animations = [NSMutableArray array];
    
    // Setup Game Scene
    scene = [[GameScene alloc] initWithView:scnView];
    [scene setupSkyboxWithName:@"sun1" andFileExtension:@"bmp"];
    scnView.backgroundColor = [UIColor darkGrayColor];
    [self setupCamera];
    
    // create and add a light to the scene
    [self setupPointLight];
    
    // create and add an ambient light to the scene
    [self setupAmbientLight];
    
    // Setup Game Character
    [self setupCharacter];
    
    // Setup Floor
    [self setupFloor];

    // Reset character to idle pose (rather than T-pose)
    [character startIdleAnimationInScene:scene];

    
    scnView.scene = scene;
    scnView.allowsCameraControl = YES;
    scnView.showsStatistics = YES;

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [scnView addGestureRecognizer:tapGesture];
    
//    // retrieve the ship node
//    SCNNode *ship = [scene.rootNode childNodeWithName:@"ship" recursively:YES];
//    
//    // animate the 3d object
//    [ship runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Setup Helpers

- (void) setupCharacter
{
    // Create Character and add to scene
    character = [[GameCharacter alloc] initFromScene:[SCNScene sceneNamed:@"art.scnassets/Kakashi.dae"] withName:@"SpongeBob"];
    //character = [[GameCharacter alloc] initFromScene:[SCNScene sceneNamed:@"Sasuke.dae"] withName:@""];
    [scene.rootNode addChildNode:character.characterNode];
    
    // Get Walk Animations
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"art.scnassets/Kakashi(walking)" withExtension:@"dae"];
    SCNSceneSource *sceneSource = [SCNSceneSource sceneSourceWithURL:url options:@{SCNSceneSourceAnimationImportPolicyKey:SCNSceneSourceAnimationImportPolicyPlayRepeatedly} ];
    NSArray *animationIds = [sceneSource identifiersOfEntriesWithClass:[CAAnimation class]];
    for(NSString *eachId in animationIds){
        CAAnimation *animation = [sceneSource entryWithIdentifier:eachId withClass:[CAAnimation class]];
        [animations addObject:animation];
    }
    character.walkAnimations = [NSArray arrayWithArray:animations];
    
    
    // Get Idle Animations
    animations = [NSMutableArray array];
    NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"art.scnassets/Kakashi(idle)" withExtension:@"dae"];
    SCNSceneSource *sceneSource2 = [SCNSceneSource sceneSourceWithURL:url2 options:@{SCNSceneSourceAnimationImportPolicyKey:SCNSceneSourceAnimationImportPolicyPlayRepeatedly} ];
    NSArray *animationIds2 = [sceneSource2 identifiersOfEntriesWithClass:[CAAnimation class]];
    for(NSString *eachId in animationIds2){
        CAAnimation *animation = [sceneSource2 entryWithIdentifier:eachId withClass:[CAAnimation class]];
        [animations addObject:animation];
    }
    character.idleAnimations = [NSArray arrayWithArray:animations];
}

- (void) setupFloor
{
    SCNFloor *floor = [SCNFloor new];
    floor.reflectivity = 0.0;
    
    SCNNode *floorNode = [SCNNode new];
    floorNode.geometry = floor;
    
    SCNMaterial *floorMaterial = [SCNMaterial new];
    floorMaterial.litPerPixel = NO;
    floorMaterial.diffuse.contents = [UIImage imageNamed:@"art.scnassets/grass.jpg"];
    floorMaterial.diffuse.wrapS = SCNWrapModeRepeat;
    floorMaterial.diffuse.wrapT = SCNWrapModeRepeat;
    
    floor.materials = @[floorMaterial];
    
    [scene.rootNode addChildNode:floorNode];
    
}

- (void) setupCamera
{
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.zFar = 1000;
    cameraNode.position = SCNVector3Make(0, 100, 350);
    [scene.rootNode addChildNode:cameraNode];
}

- (void) setupPointLight
{
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 200, 400);
    [scene.rootNode addChildNode:lightNode];
}

- (void) setupAmbientLight
{
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
}


#pragma mark - Tap Selectors

- (void) tap
{
    if(!shouldStop){
        [character startWalkAnimationInScene:scene];
    }
    else{
        [character stopWalkAnimationInScene:scene];
    }
    shouldStop = !shouldStop;
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

#pragma mark - Orientation and Status Bar

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



@end
