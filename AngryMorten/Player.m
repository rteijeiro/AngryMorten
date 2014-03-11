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
    self.spitAnimation = [self createSpitAnimation];
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
  if (position.x < self.size.width / 2.0f) {
    position.x = self.size.width / 2.0f;
  }
  if (position.x > screenWidth - self.size.width / 2.0f) {
    position.x = screenWidth - self.size.width / 2.0f;
  }
  
  // Move player to new position.
  self.position = CGPointMake(position.x, self.position.y);
}

-(SKAction *)createSpitAnimation {
  // Spitting Animation.
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:5];
  
  for (int i = 2; i <= 4; i++) {
    NSString *textureName = [NSString stringWithFormat:@"player%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    [textures addObject:texture];
  }
  
  SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1f];
  
  return animation;
}


@end
