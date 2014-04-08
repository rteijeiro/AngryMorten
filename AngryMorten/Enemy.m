//
//  Enemy.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 3/8/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

-(void)moveToX:(float)position duration:(float)duration {
  CGPoint origin = self.position;
  SKAction *moveToX = [SKAction moveToX:position + self.size.width duration:duration];
  SKAction *bounceUp = [SKAction moveToY:origin.y - 1 duration:0.08];
  SKAction *bounceDown = [SKAction moveToY:origin.y + 1 duration:0.08];
  SKAction *bounce = [SKAction repeatActionForever:[SKAction sequence:@[bounceUp, bounceDown]]];
  SKAction *move = [SKAction group:@[moveToX, bounce]];
  SKAction *remove = [SKAction removeFromParent];
  SKAction *sequence = [SKAction sequence:@[move, remove]];
  [self runAction:sequence withKey:@"MoveToX"];
}

@end
