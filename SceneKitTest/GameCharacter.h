//
//  GameCharacter.h
//  SceneKitTest
//
//  Created by Odie Edo-Osagie on 27/04/2015.
//  Copyright (c) 2015 Odie Edo-Osagie. All rights reserved.
//

#import <SceneKit/SceneKit.h>

typedef enum _ActionState {
    ActionStateNone = 0,
    ActionStateIdle = 1,
    ActionStateAttack = 2,
    ActionStateWalk = 3,
    ActionStateHurt = 4,
    ActionStateKnockedOut = 5
} ActionState;

@interface GameCharacter : NSObject

/** Scene for the Collada file containing the character model */
@property (nonatomic, strong) SCNScene *scene;

/** Scene for the environment within which the character is */
@property (nonatomic, strong) SCNScene *environmentScene;

/** Stores a node for the whole character model */
@property (nonatomic, strong) SCNNode *characterNode;

/** Stores all the nodes associated with the model */
@property (nonatomic, strong) NSArray *nodes;

/** Stores all the walk animations associated with the model */
@property (nonatomic, strong) NSArray *walkAnimations;

/** Stores all the idle animations associated with the model */
@property (nonatomic, strong) NSArray *idleAnimations;

// states
@property(nonatomic, assign) ActionState actionState;



/************************ SETUP ***************************/

/**
 * Sets up and initializes a GameCharacter object from a scene.
 *
 * @param scene Scene for COLLADA model containing character.
 * @param name String identifier for character object within COLLADA model.
 */
- (id) initFromScene:(SCNScene *)scene withName:(NSString *)name;



/**
 * Updates the character's ActionState to a new specified state, while also updating
 * the character animation appropriately.
 *
 * @param newState State to be set to the character.
 * @note The calling Character object's @aenvironmentScene@a property must be set. For this
 * method to update the character animations, the @aenvironmentScene@a property must be set to the
 * scene displaying the character (ie whose child nodes include the character nodes).
 */
- (void) setActionState:(ActionState)newState;



/**
 * Starts walk animation for the calling GameCharacter that is within a specified scene.
 * @param An instance of type SCNScene (preferably GameScene) that contains the character.
 */
- (void) startWalkAnimationInScene:(SCNScene *)gameScene;



/**
 * Stops walk animation for the calling GameCharacter that is within a specified scene.
 * @param An instance of type SCNScene (preferably GameScene) that contains the character.
 */
- (void) stopWalkAnimationInScene:(SCNScene *)gameScene;



/**
 * Starts idle animation for the calling GameCharacter that is within a specified scene.
 * @param An instance of type SCNScene (preferably GameScene) that contains the character.
 */
- (void) startIdleAnimationInScene:(SCNScene *)gameScene;



/**
 * Stops idle animationw for the calling GameCharacter that is within a specified scene.
 * @param An instance of type SCNScene (preferably GameScene) that contains the character.
 */
- (void) stopIdleAnimationInScene:(SCNScene *)gameScene;

@end
