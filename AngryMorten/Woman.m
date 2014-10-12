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
