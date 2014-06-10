//
//  Woman.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 6/10/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Woman.h"

@implementation Woman

-(id)initWithSize:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"ipad-woman1"]) {
    self.name = @"woman";
    
    // Calculate random position for woman.
    float xPosition = [self randomXPosition:screenSize];
    self.position = CGPointMake(xPosition, [self scalarRandomRange:screenSize.height / 2 max:screenSize.height / 2 - self.size.height / 2]);
  }
  
  [self movePedestrian:10.0f screenSize:screenSize];
  
  // Create walking animation.
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:2];
  
  for (int i = 2; i < 4; i++) {
    NSString *imageName = [NSString stringWithFormat:@"ipad-woman%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
    [textures addObject:texture];
  }
  
  SKAction *walk = [SKAction animateWithTextures:textures timePerFrame:0.15f];
  [self runAction:[SKAction repeatActionForever:walk]];
  
  return self;
}

@end
