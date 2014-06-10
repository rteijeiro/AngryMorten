//
//  Bike.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 5/19/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Bike.h"

@implementation Bike

-(id)initWithSize:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"ipad-bike"]) {
    self.name = @"bike";
    
    // Calculate random position for car.
    float xPosition = [self randomXPosition:screenSize];
    self.position = CGPointMake(xPosition, [self scalarRandomRange:screenSize.height - screenSize.height / 3 max:screenSize.height - self.size.height / 2]);
  }
  
  [self moveVehicle:10.0f screenSize:screenSize];
  
  return self;
}

@end
