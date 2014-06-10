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
  
  [self moveVehicle:10.0f screenSize:screenSize];
  
  return self;
}

@end
