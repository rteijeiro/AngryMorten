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

@end
