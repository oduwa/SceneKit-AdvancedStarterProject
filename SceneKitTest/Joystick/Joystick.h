//
//  Joystick.h
//  Joystick
//
//  Created by Derrick Liu on 8/6/13.
//  Copyright (c) 2013 TheSneakyNarwhal. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Joystick : SKNode
{
    SKSpriteNode *thumbNode;
    BOOL isTracking;
    CGPoint velocity;
    CGPoint travelLimit;
    float angularVelocity;
    float size;
}

@property(nonatomic, readonly) CGPoint velocity;
@property(nonatomic, readonly) float angularVelocity;
@property(nonatomic, readonly) float size;

-(id) initWithThumb: (SKSpriteNode*) aNode;
+(id) joystickWithThumb: (SKSpriteNode*) aNode;
-(id) initWithThumb: (SKSpriteNode*) thumbNode andBackdrop: (SKSpriteNode*) backgroundNode;
+(id) joystickWithThumb: (SKSpriteNode*) thumbNode andBackdrop: (SKSpriteNode*) backgroundNode;
@end
