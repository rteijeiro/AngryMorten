//
//  Enemy.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 3/8/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Enemy.h"

// Define enemy constants.
#define ENEMY_CAR 0
#define ENEMY_BIKE 1
#define ENEMY_SKATEBOARD 2
#define ENEMY_MAN 3
#define ENEMY_WOMAN 4

// Helper function for random number calculation.
#define ARC4RANDOM_MAX 0x100000000
static inline CGFloat ScalarRandomRange(CGFloat min, CGFloat max) {
  return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}

@implementation Enemy

-(id)initWithCar:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"car"]) {
    self.name = @"Car";
    
    // Calculate random position for car.
    float xPosition = [self randomXPosition:screenSize];
    self.position = CGPointMake(xPosition, ScalarRandomRange(screenSize.height - screenSize.height / 3, screenSize.height - self.size.height / 2));
  }
  
  [self moveVehicle:10.0f screenSize:screenSize];
  
  return self;
}

-(id)initWithBike:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"bike"]) {
    self.name = @"Bike";
    
    // Calculate random position for car.
    float xPosition = [self randomXPosition:screenSize];
    self.position = CGPointMake(xPosition, ScalarRandomRange(screenSize.height - screenSize.height / 3, screenSize.height - self.size.height / 2));
  }
  
  [self moveVehicle:10.0f screenSize:screenSize];
  
  return self;
}

-(id)initWithSkater:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"skater"]) {
    self.name = @"Skater";
    
    // Calculate random position for skater.
    float xPosition = [self randomXPosition:screenSize];
    self.position = CGPointMake(xPosition, ScalarRandomRange(screenSize.height / 2, screenSize.height / 2 - self.size.height / 2));
  }

  [self moveVehicle:10.0f screenSize:screenSize];
  
  return self;
}

-(id)initWithMan:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"man1"]) {
    self.name = @"Man";
    
    // Calculate random position for man.
    float xPosition = [self randomXPosition:screenSize];
    self.position = CGPointMake(xPosition, ScalarRandomRange(screenSize.height / 2, screenSize.height / 2 - self.size.height / 2));
  }

  [self movePedestrian:10.0f screenSize:screenSize];

  // Create walking animation.
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:2];
  
  for (int i = 2; i < 4; i++) {
    NSString *imageName = [NSString stringWithFormat:@"man%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
    [textures addObject:texture];
  }
  
  SKAction *walk = [SKAction animateWithTextures:textures timePerFrame:0.15f];
  [self runAction:[SKAction repeatActionForever:walk]];

  return self;
}

-(id)initWithWoman:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"woman1"]) {
    self.name = @"Woman";
    
    // Calculate random position for woman.
    float xPosition = [self randomXPosition:screenSize];
    self.position = CGPointMake(xPosition, ScalarRandomRange(screenSize.height / 2, screenSize.height / 2 - self.size.height / 2));
  }
 
  [self movePedestrian:10.0f screenSize:screenSize];
  
  // Create walking animation.
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:2];
  
  for (int i = 2; i < 4; i++) {
    NSString *imageName = [NSString stringWithFormat:@"woman%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
    [textures addObject:texture];
  }
  
  SKAction *walk = [SKAction animateWithTextures:textures timePerFrame:0.15f];
  [self runAction:[SKAction repeatActionForever:walk]];
  
  return self;
}

-(id)initWithManUp:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"man-up1"]) {
    self.name = @"Man";
    
    self.position = CGPointMake(screenSize.width / 2, screenSize.height / 3.5);
  }
 
  [self moveToY:screenSize.height + self.size.height duration:5.0f];
 
  // Create walking animation.
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:2];
  
  for (int i = 2; i < 4; i++) {
    NSString *imageName = [NSString stringWithFormat:@"man-up%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
    [textures addObject:texture];
  }

  SKAction *walk = [SKAction animateWithTextures:textures timePerFrame:0.15f];
  [self runAction:[SKAction repeatActionForever:walk]];
  
  return self;
}

-(id)initWithWomanUp:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"woman-up1"]) {
    self.name = @"Woman";
    
    self.position = CGPointMake(screenSize.width / 2, screenSize.height / 3.5);
  }

  [self moveToY:screenSize.height + self.size.height duration:5.0f];

  // Create walking animation.
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:2];
  
  for (int i = 2; i < 4; i++) {
    NSString *imageName = [NSString stringWithFormat:@"woman-up%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
    [textures addObject:texture];
  }
  
  SKAction *walk = [SKAction animateWithTextures:textures timePerFrame:0.15f];
  [self runAction:[SKAction repeatActionForever:walk]];
  
  return self;
}

-(id)initWithManDown:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"man-down1"]) {
    self.name = @"Man";
    
    self.position = CGPointMake(screenSize.width / 2, screenSize.height + self.size.height);
  }
  
  [self moveToY:screenSize.height / 3.5 duration:5.0f];

  // Create walking animation.
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:2];
  
  for (int i = 2; i < 4; i++) {
    NSString *imageName = [NSString stringWithFormat:@"man-down%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
    [textures addObject:texture];
  }
  
  SKAction *walk = [SKAction animateWithTextures:textures timePerFrame:0.15f];
  [self runAction:[SKAction repeatActionForever:walk]];
  
  return self;
}

-(id)initWithWomanDown:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"woman-down1"]) {
    self.name = @"Woman";
    
    self.position = CGPointMake(screenSize.width / 2, screenSize.height + self.size.height);
  }
  
  [self moveToY:screenSize.height / 3.5 duration:5.0f];

  // Create walking animation.
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:2];
  
  for (int i = 2; i < 4; i++) {
    NSString *imageName = [NSString stringWithFormat:@"woman-down%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
    [textures addObject:texture];
  }
  
  SKAction *walk = [SKAction animateWithTextures:textures timePerFrame:0.15f];
  [self runAction:[SKAction repeatActionForever:walk]];
  
  return self;
}

-(void)movePedestrianToX:(float)position duration:(float)duration {
  SKAction *moveToX = [SKAction moveToX:position + self.size.width duration:duration];
  SKAction *remove = [SKAction removeFromParent];
  SKAction *sequence = [SKAction sequence:@[moveToX, remove]];
  [self runAction:sequence withKey:@"MoveToX"];
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

@end
