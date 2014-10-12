//
//  Enemy.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 3/8/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Enemy.h"

#define ARC4RANDOM_MAX 0x100000000

@implementation Enemy

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

// Helper function for random number calculation.
-(CGFloat)scalarRandomRange:(CGFloat)min max:(CGFloat)max {
  return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}

@end
