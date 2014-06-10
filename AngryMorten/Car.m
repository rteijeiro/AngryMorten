//
//  Car.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 5/13/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Car.h"

@implementation Car

-(id)initWithSize:(CGSize)screenSize {
  if (self = [super initWithImageNamed:@"ipad-car"]) {
    self.name = @"car";
    
    // Calculate random position for car.
    float xPosition = [self randomXPosition:screenSize];
    self.position = CGPointMake(xPosition, [self scalarRandomRange:screenSize.height - screenSize.height / 3 max:screenSize.height - self.size.height / 2]);
  }
  
  [self moveVehicle:10.0f screenSize:screenSize];
  
  return self;
}

@end
