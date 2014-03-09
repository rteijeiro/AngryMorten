//
//  Player.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 3/8/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Player.h"

@implementation Player

-(id)init {
  Player *player = [Player spriteNodeWithImageNamed:@"player1"];
  player.name = @"Player";
  
  return player;
}

-(void)reset {
  [self runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"player1"]]];
}

-(void)spit {
  [self runAction:_spitAnimation withKey:@"Spit"];
}

-(void)spitStop {
  [self removeActionForKey:@"Spit"];
  [self reset];
}

@end
