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
#import "Joystick.h"
#import <SpriteKit/SpriteKit.h>

BOOL shouldStop;

@implementation GameViewController{
    SCNNode *cameraNode;
    NSMutableArray *animations;
    SCNNode *node;
    //SCNScene *scene;
    GameScene *scene;
    GameCharacter *character;
    
    SKScene *overlay;
    Joystick *movementJoystick;
    SKSpriteNode *walkAnimButton;
    SKSpriteNode *cameraButton;
    SKSpriteNode *wrenchButton;
    
    SCNVector3 forwardDirectionVector;
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
    character.characterNode.position = SCNVector3Make(0, 0, -250);
    character.characterNode.rotation = SCNVector4Make(0, 1, 0, M_PI);
    
    
    // Setup Floor
    [self setupFloor];
    
    
    scnView.scene = scene;
    scnView.showsStatistics = YES;
    
    scnView.delegate = self;
    
    
    [self setupHUD];
    
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
    character.environmentScene = scene;
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
    
    // Reset character to idle pose (rather than T-pose)
    character.actionState = ActionStateIdle;
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
    cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.zFar = 1000;
    cameraNode.position = SCNVector3Make(0, 100, 150);//cameraNode.position = SCNVector3Make(0, 100, 0);
    [scene.rootNode addChildNode:cameraNode];
}

- (void) setupPointLight
{
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 200, -100);
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

- (void) setupHUD
{
    /* Create overlay SKScene for 3D scene */
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    SCNView *scnView = (SCNView *)self.view;
    overlay = [[SKScene alloc] initWithSize:scnView.bounds.size];
    overlay.scaleMode = SKSceneScaleModeAspectFill;
    scnView.overlaySKScene = overlay;
    
    /* Create button for controlling walk animation */
    walkAnimButton = [SKSpriteNode spriteNodeWithImageNamed:@"walking"];
    walkAnimButton.anchorPoint = CGPointMake(0.5, 0.5);
    walkAnimButton.size = CGSizeMake(32, 32);
    walkAnimButton.position = CGPointMake(screenSize.width-walkAnimButton.size.width, screenSize.height-walkAnimButton.size.height);
    walkAnimButton.name = @"WalkAnimationButton";
    //[overlay addChild:walkAnimButton];
    
    /* Create button for toggling camera control */
    cameraButton = [SKSpriteNode spriteNodeWithImageNamed:@"camera"];
    walkAnimButton.anchorPoint = CGPointMake(0.5, 0.5);
    cameraButton.size = CGSizeMake(32, 32);
    cameraButton.position = CGPointMake(screenSize.width-walkAnimButton.size.width-15-cameraButton.size.width, screenSize.height-cameraButton.size.height);
    cameraButton.name = @"CameraButton";
    [overlay addChild:cameraButton];
    
    /* Create button for toggling render information */
    wrenchButton = [SKSpriteNode spriteNodeWithImageNamed:@"wrench"];
    wrenchButton.anchorPoint = CGPointMake(0.5, 0.5);
    wrenchButton.size = CGSizeMake(32, 32);
    wrenchButton.position = CGPointMake(screenSize.width-wrenchButton.size.width, screenSize.height-wrenchButton.size.height);
    wrenchButton.name = @"WrenchButton";
    [overlay addChild:wrenchButton];

    /* Create jostick */
    SKSpriteNode *jsThumb = [SKSpriteNode spriteNodeWithImageNamed:@"joystick"];
    SKSpriteNode *jsBackdrop = [SKSpriteNode spriteNodeWithImageNamed:@"dpad"];
    movementJoystick = [Joystick joystickWithThumb:jsThumb andBackdrop:jsBackdrop];
    movementJoystick.position = CGPointMake(jsBackdrop.size.width/1.5, jsBackdrop.size.height/1.5);
    [overlay addChild:movementJoystick];
    
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
    //character.characterNode.position = SCNVector3Make(character.characterNode.position.x, character.characterNode.position.y+10, character.characterNode.position.z);
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


#pragma mark - SCNRenderer Delegate

- (void)renderer:(id<SCNSceneRenderer>)aRenderer
    updateAtTime:(NSTimeInterval)time
{
    if(movementJoystick.velocity.x != 0 || movementJoystick.velocity.y != 0){
        /* Start walk animation */
        character.actionState = ActionStateWalk;
        
        /* Calculate angle in degrees */
        float angleInDegrees = movementJoystick.angularVelocity*57.3;
        
        /* thumb is in top left region */
        if(angleInDegrees >= 0 && angleInDegrees <= 90){
            NSLog(@"TL");
        }
        /* thumb is in bottom left region */
        else if(angleInDegrees > 90 && angleInDegrees <= 179){
            NSLog(@"BL");
        }
        /* thumb is in top right region */
        else if(angleInDegrees < 0 && angleInDegrees >= -90){
            NSLog(@"TR");
        }
        /* thumb is in bottom right region */
        else if(angleInDegrees < -90 && angleInDegrees >= -180){
            NSLog(@"BR");
        }
        
        //cameraNode.rotation = SCNVector4Make(0, 1, 0, movementJoystick.angularVelocity);
        
        /* Create a vector to move forward in z direction */
        forwardDirectionVector = SCNVector3Make(0, 0, 1);
        forwardDirectionVector = [GameViewController rotateVector3:forwardDirectionVector aroundAxis:1 byAngleInRadians:movementJoystick.angularVelocity];
        NSLog(@"[%f: %f, %f, %f]", angleInDegrees, forwardDirectionVector.x, forwardDirectionVector.y, forwardDirectionVector.z);
        
        /* Increment character position by vector rotated in correct direction */
        character.characterNode.position = SCNVector3Make(character.characterNode.position.x-forwardDirectionVector.x*5, character.characterNode.position.y+forwardDirectionVector.y*5, character.characterNode.position.z-forwardDirectionVector.z*5);
        
        /* Increment camera position by vector rotated in correct direction so cam follows character */
        cameraNode.position = SCNVector3Make(cameraNode.position.x-forwardDirectionVector.x*5, cameraNode.position.y+forwardDirectionVector.y*5, cameraNode.position.z-forwardDirectionVector.z*5);
        
        character.characterNode.rotation = SCNVector4Make(0, 1, 0, M_PI+movementJoystick.angularVelocity);
    }
    else{
        character.actionState = ActionStateIdle;
    }
}


#pragma mark - Touch Delegate

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:overlay];
    SKNode *touchedNode = [overlay nodeAtPoint:location];
    
    
    if([touchedNode.name isEqualToString:@"WalkAnimationButton"]) {
        [self tap];
    }
    else if([touchedNode.name isEqualToString:@"CameraButton"]){
        [(SCNView *)self.view setAllowsCameraControl:![(SCNView *)self.view allowsCameraControl]];
    }
    else if([touchedNode.name isEqualToString:@"WrenchButton"]){
        [(SCNView *)self.view setShowsStatistics:![(SCNView *)self.view showsStatistics]];
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

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if(size.width > size.height){
            // Landscape
        }
        else{
            // Portrait
        }
        
        [overlay removeAllChildren];
        [self setupHUD];
    }];
    
}


#pragma mark - Vector Maths Helpers

+ (SCNVector3) rotateVector3:(SCNVector3)vector aroundAxis:(NSUInteger)axis byAngleInRadians:(float)angle
{
    if(axis == 1){
        SCNVector3 result = SCNVector3Make(cosf(angle)*vector.x+sinf(angle)*vector.z, vector.y, -sinf(angle)*vector.x+cosf(angle)*vector.z);
        return result;
    }
    else{
        return SCNVector3Zero;
    }
}




@end
