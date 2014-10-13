//
//  Skater.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 5/14/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Skater.h"

@implementation Skater

-(id)initWithSize:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"ipad-skater"]) {
    self.name = @"skater";
    
    // Calculate random position for skater.
    float xPosition = [self randomXPosition:screenSize];
    self.position = CGPointMake(xPosition, [self scalarRandomRange:screenSize.height / 2 max:screenSize.height / 2 - self.size.height / 2]);
  }
  
  [self moveVehicle:5.0f screenSize:screenSize];
  
  return self;
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

-(void)moveVehicleToX:(float)position duration:(float)duration {
  CGPoint origin = self.position;
  SKAction *moveToX = [SKAction moveToX:position + self.size.width duration:duration];
  SKAction *bounceUp = [SKAction moveToY:origin.y - 1 duration:0.08];
  SKAction *bounceDown = [SKAction moveToY:origin.y + 1 duration:0.08];
  SKAction *bounce = [SKAction repeatActionForever:[SKAction sequence:@[bounceUp, bounceDown]]];
  SKAction *move = [SKAction group:@[moveToX, bounce]];
  SKAction *remove = [SKAction removeFromParent];
  SKAction *sequence = [SKAction sequence:@[move, remove]];
  [self runAction:sequence withKey:@"Move"];
}

@end
