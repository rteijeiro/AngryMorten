//
//  Enemy.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 3/8/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Enemy.h"

// Helper function for random number calculation.
#define ARC4RANDOM_MAX 0x100000000
static inline CGFloat ScalarRandomRange(CGFloat min, CGFloat max) {
  return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}

@implementation Enemy

-(id)initWithManUp:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"ipad-man-up1"]) {
    self.name = @"man-up";
    
    self.position = CGPointMake(screenSize.width / 2, screenSize.height / 3.5);
  }
 
  [self moveToY:screenSize.height + self.size.height duration:5.0f];
 
  // Create walking animation.
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:2];
  
  for (int i = 2; i < 4; i++) {
    NSString *imageName = [NSString stringWithFormat:@"ipad-man-up%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
    [textures addObject:texture];
  }

  SKAction *walk = [SKAction animateWithTextures:textures timePerFrame:0.15f];
  [self runAction:[SKAction repeatActionForever:walk]];
  
  return self;
}

-(id)initWithWomanUp:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"ipad-woman-up1"]) {
    self.name = @"woman-up";
    
    self.position = CGPointMake(screenSize.width / 2, screenSize.height / 3.5);
  }

  [self moveToY:screenSize.height + self.size.height duration:5.0f];

  // Create walking animation.
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:2];
  
  for (int i = 2; i < 4; i++) {
    NSString *imageName = [NSString stringWithFormat:@"ipad-woman-up%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
    [textures addObject:texture];
  }
  
  SKAction *walk = [SKAction animateWithTextures:textures timePerFrame:0.15f];
  [self runAction:[SKAction repeatActionForever:walk]];
  
  return self;
}

-(id)initWithManDown:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"ipad-man-down1"]) {
    self.name = @"man-down";
    
    self.position = CGPointMake(screenSize.width / 2, screenSize.height + self.size.height);
  }
  
  [self moveToY:screenSize.height / 3.5 duration:5.0f];

  // Create walking animation.
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:2];
  
  for (int i = 2; i < 4; i++) {
    NSString *imageName = [NSString stringWithFormat:@"ipad-man-down%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
    [textures addObject:texture];
  }
  
  SKAction *walk = [SKAction animateWithTextures:textures timePerFrame:0.15f];
  [self runAction:[SKAction repeatActionForever:walk]];
  
  return self;
}

-(id)initWithWomanDown:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"ipad-woman-down1"]) {
    self.name = @"woman-down";
    
    self.position = CGPointMake(screenSize.width / 2, screenSize.height + self.size.height);
  }
  
  [self moveToY:screenSize.height / 3.5 duration:5.0f];

  // Create walking animation.
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:2];
  
  for (int i = 2; i < 4; i++) {
    NSString *imageName = [NSString stringWithFormat:@"ipad-woman-down%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
    [textures addObject:texture];
  }
  
  SKAction *walk = [SKAction animateWithTextures:textures timePerFrame:0.15f];
  [self runAction:[SKAction repeatActionForever:walk]];
  
  return self;
}

-(void)moveVehicleToX:(float)position duration:(float)duration {
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

-(void)moveToY:(float)position duration:(float)duration {
  SKAction *moveToY = [SKAction moveToY:position duration:duration];
  SKAction *remove = [SKAction removeFromParent];
  SKAction *sequence = [SKAction sequence:@[moveToY, remove]];
  [self runAction:sequence withKey:@"MoveToY"];
}

-(float)randomXPosition:(CGSize)screenSize {
  float xPosition;
  
  // Random direction generation.
  int randomDirection = arc4random_uniform(2);
  
  switch (randomDirection) {
    case 0: // Right direction.
      xPosition = -self.size.width;
      break;
      
    case 1: // Left direction.
      xPosition = screenSize.width + self.size.width;
      break;
  }

  return xPosition;
}

-(void)moveVehicle:(float)duration screenSize:(CGSize)screenSize {
  // Check enemy direction to update move position and flip image if needed.
  if (self.position.x < 0) { // Right direction.
    [self moveVehicleToX:screenSize.width + self.size.width duration:duration];
  }
  else { // Left direction.
    // Flip enemy image.
    self.xScale = -1.0f;
    [self moveVehicleToX:-self.size.width * 2 duration:duration];
  }
}

-(void)movePedestrian:(float)duration screenSize:(CGSize)screenSize {
  // Check enemy direction to update move position and flip image if needed.
  if (self.position.x < 0) { // Right direction.
    [self movePedestrianToX:screenSize.width + self.size.width duration:duration];
  }
  else { // Left direction.
    // Flip enemy image.
    self.xScale = -1.0f;
    [self movePedestrianToX:-self.size.width * 2 duration:duration];
  }
}

-(void)movePedestrianToX:(float)position duration:(float)duration {
  SKAction *moveToX = [SKAction moveToX:position + self.size.width duration:duration];
  SKAction *remove = [SKAction removeFromParent];
  SKAction *sequence = [SKAction sequence:@[moveToX, remove]];
  [self runAction:sequence withKey:@"MoveToX"];
}

@end
