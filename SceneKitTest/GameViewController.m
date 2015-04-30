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

    [character startIdleAnimationInScene:scene];
    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"art.scnassets/walking" withExtension:@"dae"];
//    SCNSceneSource *sceneSource = [SCNSceneSource sceneSourceWithURL:url options:nil ];
//    node = [sceneSource entryWithIdentifier:@"BetaHighResMeshes" withClass:[SCNNode class]];
//    //node.scale = SCNVector3Make(4, 4, 4);
//    //node.position = SCNVector3Make(0, 0, 4);
//
    
//    scene.rootNode.scale = SCNVector3Make(scaleFactor, scaleFactor, scaleFactor);
//    NSLog(@"%@", node);
//    
//    SCNNode *cameraNode = [SCNNode node];
//    cameraNode.camera = [SCNCamera camera];
//    cameraNode.position = SCNVector3Make(0, 20, 50);
//    [scene.rootNode addChildNode:cameraNode];
//    cam = cameraNode;
//    [scene.rootNode addChildNode:node];
//    
//    NSArray *animationIds = [sceneSource identifiersOfEntriesWithClass:[CAAnimation class]];
//    for(NSString *eachId in animationIds){
//        CAAnimation *animation = [sceneSource entryWithIdentifier:eachId withClass:[CAAnimation class]];
//        [animations addObject:animation];
//        [node addAnimation:animation forKey:eachId];
//    }
    
    scnView.scene = scene;
    //scnView.allowsCameraControl = YES;
    scnView.showsStatistics = YES;
    
    
    
    //[SCNTransaction setAnimationDuration:5.0];
    
    
    //UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCameraLocation)];
    //[scnView addGestureRecognizer:tapGesture];
    
//    SCNScene *s = [SCNScene sceneNamed:@"art.scnassets/walking.dae"];
//    for(SCNNode *eachChild in s.rootNode.childNodes){
//        for(NSString *eachId in eachChild.animationKeys){
//            NSLog(@"%@", [eachChild animationForKey:eachId]);
//            CAAnimation *animation = [eachChild animationForKey:eachId];
//            [scene.rootNode/*[scene.rootNode childNodeWithName:@"BetaHighResMeshes" recursively:YES]*/ addAnimation:animation forKey:eachId];
//            //NSLog(@"SCEEENNNEEE");
//        }
//    }
    
    /*
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
    */
    
    
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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [scnView addGestureRecognizer:tapGesture];
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
    for(SCNNode *eachNode in character.nodes){
        [scene.rootNode addChildNode:eachNode];
    }
    
    
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
    //floor.reflectivity = 0.0;
    
    SCNNode *floorNode = [SCNNode new];
    floorNode.geometry = floor;
    
    SCNMaterial *floorMaterial = [SCNMaterial new];
    floorMaterial.litPerPixel = NO;
    floorMaterial.diffuse.contents = [UIImage imageNamed:@"grass.jpg"];
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
