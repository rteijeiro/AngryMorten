//
//  Enemy.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 3/8/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

+(id)initWithImageNamed:(NSString *)name {
  Enemy *enemy = [super spriteNodeWithImageNamed:name];
  return enemy;
}

@end