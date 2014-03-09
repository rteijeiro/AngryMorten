//
//  Player.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 3/8/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Player.h"

@implementation Player

-(id)initWithImageNamed:(NSString *)name {
  if (self = [super initWithImageNamed:name]) {
    self.name = @"Player";
  }
  return self;
}

-(void)shoot {
  self.texture = _shootImage;
}

-(void)playerInit {
  self.texture = _initialImage;
}

-(void)spit {
  [self runAction:_spitAnimation withKey:@"Spit"];
}

-(void)spitStop {
  [self removeActionForKey:@"Spit"];
  [self shoot];
}

-(void)moveTo:(CGPoint)position screenWidth:(float)screenWidth {
  // Verify that player fits into the screen bounds.
  if (position.x < self.size.width / 2) {
    position.x = self.size.width / 2;
  }
  if (position.x > screenWidth - self.size.width / 2) {
    position.x = screenWidth - self.size.width / 2;
  }
  
  // Move player to new position.
  self.position = CGPointMake(position.x, self.position.y);
}

@end
