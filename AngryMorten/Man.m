//
//  Man.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 5/14/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Man.h"

// Helper function for random number calculation.
#define ARC4RANDOM_MAX 0x100000000
static inline CGFloat ScalarRandomRange(CGFloat min, CGFloat max) {
  return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}

@implementation Man

-(id)initWithSize:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"ipad-man1"]) {
    self.name = @"man";
    
    // Calculate random position for man.
    float xPosition = [self randomXPosition:screenSize];
    self.position = CGPointMake(xPosition, ScalarRandomRange(screenSize.height / 2, screenSize.height / 2 - self.size.height / 2));
  }
  
  [self movePedestrian:10.0f screenSize:screenSize];
  
  // Create walking animation.
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:2];
  
  for (int i = 2; i < 4; i++) {
    NSString *imageName = [NSString stringWithFormat:@"ipad-man%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
    [textures addObject:texture];
  }
  
  SKAction *walk = [SKAction animateWithTextures:textures timePerFrame:0.15f];
  [self runAction:[SKAction repeatActionForever:walk]];
  
  return self;
}

@end
