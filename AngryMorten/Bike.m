//
//  Bike.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 5/19/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Bike.h"

// Helper function for random number calculation.
#define ARC4RANDOM_MAX 0x100000000
static inline CGFloat ScalarRandomRange(CGFloat min, CGFloat max) {
  return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}

@implementation Bike

-(id)initWithSize:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"ipad-bike"]) {
    self.name = @"bike";
    
    // Calculate random position for car.
    float xPosition = [self randomXPosition:screenSize];
    self.position = CGPointMake(xPosition, ScalarRandomRange(screenSize.height - screenSize.height / 3, screenSize.height - self.size.height / 2));
  }
  
  [self moveVehicle:10.0f screenSize:screenSize];
  
  return self;
}

@end
