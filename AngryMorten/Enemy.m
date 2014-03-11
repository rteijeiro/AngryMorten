//
//  Enemy.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 3/8/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

-(void)moveToX:(float)position {
  SKAction *move = [SKAction moveToX:position + self.size.width duration:10.0];
  SKAction *remove = [SKAction removeFromParent];
  SKAction *sequence = [SKAction sequence:@[move, remove]];
  [self runAction:sequence withKey:@"MoveToX"];
}

@end
