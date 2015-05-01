//
//  GameCharacter.m
//  SceneKitTest
//
//  Created by Odie Edo-Osagie on 27/04/2015.
//  Copyright (c) 2015 Odie Edo-Osagie. All rights reserved.
//

#import "GameCharacter.h"

@interface GameCharacter()
    @property (nonatomic, assign) BOOL shouldStopWalkingAnimation;
@end

@implementation GameCharacter

#pragma mark - Init

- (id) initFromScene:(SCNScene *)scene withName:(NSString *)name
{
    self = [self init];
    
    if(self){
        _scene = scene;
        NSMutableArray *nodesMut = [NSMutableArray array];
        [nodesMut addObjectsFromArray:[scene.rootNode childNodes]];
        _nodes = [NSArray arrayWithArray:nodesMut];
        _walkAnimations = [NSArray array];
        _idleAnimations = [NSArray array];

        /* Store character data */
        _characterNode = [SCNNode new];
        for(SCNNode *eachNode in _nodes){
            [_characterNode addChildNode:eachNode];
        }
        
        /* Initialize action state */
        _actionState = ActionStateNone;
    }
    
    return self;
}


#pragma mark - Getter & Setter Overrides

- (void) setActionState:(ActionState)newState
{
    switch (newState) {
        case ActionStateIdle:
            if(_actionState == newState){
                // do nothing
            }
            else{
                _actionState = newState;
                [self startIdleAnimationInScene:_environmentScene];
            }
            break;
            
        case ActionStateWalk:
            if(_actionState == newState){
                // do nothing
            }
            else{
                _actionState = newState;
                [self startWalkAnimationInScene:_environmentScene];
            }
            break;
            
        case ActionStateNone:
            _actionState = newState;
            [self stopIdleAnimationInScene:_environmentScene];
            [self stopWalkAnimationInScene:_environmentScene];
            break;
            
        default:
            _actionState = newState;
            [self stopIdleAnimationInScene:_environmentScene];
            [self stopWalkAnimationInScene:_environmentScene];
            break;
    }
}


#pragma mark - Walk Animations

- (void) startWalkAnimationInScene:(SCNScene *)gameScene
{
    int i = 1;
    for(CAAnimation *animation in _walkAnimations){
        NSString *key = [NSString stringWithFormat:@"ANIM_%d", i];
        [gameScene.rootNode addAnimation:animation forKey:key];
        i++;
    }
    _actionState = ActionStateWalk;
}

- (void) stopWalkAnimationInScene:(SCNScene *)gameScene
{
    for(int i = 0; i < [_walkAnimations count]; i++){
        NSString *key = [NSString stringWithFormat:@"ANIM_%d", i+1];
        [gameScene.rootNode removeAnimationForKey:key];
    }
}


#pragma mark - Idle Animations

- (void) startIdleAnimationInScene:(SCNScene *)gameScene
{
    int i = 1;
    for(CAAnimation *animation in _idleAnimations){
        NSString *key = [NSString stringWithFormat:@"ANIM_%d", i];
        [gameScene.rootNode addAnimation:animation forKey:key];
        i++;
    }
    _actionState = ActionStateIdle;
}

- (void) stopIdleAnimationInScene:(SCNScene *)gameScene
{
    for(int i = 0; i < [_idleAnimations count]; i++){
        NSString *key = [NSString stringWithFormat:@"ANIM_%d", i+1];
        [gameScene.rootNode removeAnimationForKey:key];
    }
}



@end
