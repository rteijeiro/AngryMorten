//
//  Man.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 5/14/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Man.h"

@implementation Man

-(id)initWithSize:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"ipad-man1"]) {
    self.name = @"man";
    
    // Calculate random position for man.
    float xPosition = [self randomXPosition:screenSize];
    self.position = CGPointMake(xPosition, [self scalarRandomRange:screenSize.height / 2 max:screenSize.height / 2 - self.size.height / 2]);
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

-(void)moveToY:(float)position duration:(float)duration {
  SKAction *moveToY = [SKAction moveToY:position duration:duration];
  SKAction *remove = [SKAction removeFromParent];
  SKAction *sequence = [SKAction sequence:@[moveToY, remove]];
  [self runAction:sequence withKey:@"Move"];
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
  [self runAction:sequence withKey:@"Move"];
}

@end
