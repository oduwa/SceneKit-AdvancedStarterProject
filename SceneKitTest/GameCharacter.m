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

- (id) initFromScene:(SCNScene *)scene withName:(NSString *)name
{
    self = [self init];
    
    if(self){
        _scene = scene;
        _characterNode = [scene.rootNode childNodeWithName:name recursively:YES];

        NSMutableArray *nodesMut = [NSMutableArray array];
        [nodesMut addObjectsFromArray:[scene.rootNode childNodes]];
        _nodes = [NSArray arrayWithArray:nodesMut];
        _walkAnimations = [NSArray array];

        //_leftLeg = [scene.rootNode childNodeWithName:@"leg_thigh_left" recursively:YES];
        //_rightLeg = [scene.rootNode childNodeWithName:@"leg_thigh_right" recursively:YES];
    }
    
    return self;
}

- (void) setupLimbsWithNameForLeftLeg:(NSString *)leftLegName nameForRightLeg:(NSString *)rightLegName
{
    _leftLeg = [_scene.rootNode childNodeWithName:leftLegName recursively:YES];
    _rightLeg = [_scene.rootNode childNodeWithName:rightLegName recursively:YES];
    NSLog(@"%@", [_scene.rootNode childNodeWithName:rightLegName recursively:YES]);
}

- (void) startWalkAnimationUsingLimbsWithStepDuration:(CGFloat) stepDuration
{
    if(!_leftLeg || !_rightLeg){
        [NSException raise:@"LimbNodeNullException" format:@"At least, the left or right limb is null"];
        return;
    }
    
    // LEFT UP
    [_leftLeg runAction:[SCNAction rotateByX:0 y:0.79 z:0 duration:stepDuration] completionHandler:^{
        // LEFT DOWN
        [_leftLeg runAction:[SCNAction rotateByX:0 y:-0.79 z:0 duration:stepDuration] completionHandler:^{
            // RIGHT UP
            [_rightLeg runAction:[SCNAction rotateByX:0 y:0.79 z:0 duration:stepDuration] completionHandler:^{
                // RIGHT DOWN
                [_rightLeg runAction:[SCNAction rotateByX:0 y:-0.79 z:0 duration:stepDuration] completionHandler:^{
                    if(!_shouldStopWalkingAnimation){
                        [self startWalkAnimationUsingLimbsWithStepDuration:stepDuration];
                    }
                }];
            }];
        }];
    }];
}

- (void) startWalkAnimation
{
    int i = 1;
    for(CAAnimation *animation in _walkAnimations){
        NSString *key = [NSString stringWithFormat:@"WALK_ANIM_%d", i];
        [_scene.rootNode addAnimation:animation forKey:key];
        i++;
    }
}

- (void) stopWalkAnimation
{
    _shouldStopWalkingAnimation = YES;
}

@end
