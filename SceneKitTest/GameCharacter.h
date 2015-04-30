//
//  GameCharacter.h
//  SceneKitTest
//
//  Created by Odie Edo-Osagie on 27/04/2015.
//  Copyright (c) 2015 Odie Edo-Osagie. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface GameCharacter : NSObject

/** Scene containing character model */
@property (nonatomic, strong) SCNScene *scene;

/** Stores a node for the whole character model */
@property (nonatomic, strong) SCNNode *characterNode;

/** Stores all the nodes associated with the model */
@property (nonatomic, strong) NSArray *nodes;

/** Stores all the walk animations associated with the model */
@property (nonatomic, strong) NSArray *walkAnimations;

/** Stores all the idle animations associated with the model */
@property (nonatomic, strong) NSArray *idleAnimations;

/** Stores a node for the character's left leg. Can be nil if character does not have one */
@property (nonatomic, strong) SCNNode *leftLeg;

/** Stores a node for the character's right leg. Can be nil if character does not have one */
@property (nonatomic, strong) SCNNode *rightLeg;


/************************ SETUP ***************************/

/**
 * Sets up and initializes a GameCharacter object from a scene.
 *
 * @param scene Scene for COLLADA model containing character.
 * @param name String identifier for character object within COLLADA model.
 */
- (id) initFromScene:(SCNScene *)scene withName:(NSString *)name;


/**
 * Initializes left and right leg of character using node names given.
 */
- (void) setupLimbsWithNameForLeftLeg:(NSString *)leftLegName nameForRightLeg:(NSString *)rightLegName;


/**
 * Initiates walk animation where a character's legs are raised and lowered in turn.
 *
 * @param stepDuration The amount of time it should take the character to lift (and equally lower) a leg.
 */
- (void) startWalkAnimationUsingLimbsWithStepDuration:(CGFloat) stepDuration;


/**
 * Stops walk animation. Lowers both of the characters legs together.
 */
- (void) stopWalkAnimation;


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
