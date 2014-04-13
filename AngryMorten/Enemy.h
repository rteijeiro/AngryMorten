//
//  Enemy.h
//  AngryMorten
//
//  Created by Ruben Teijeiro on 3/8/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Enemy : SKSpriteNode

-(id)initWithCar:(CGSize)screenSize;
-(id)initWithBike:(CGSize)screenSize;
-(id)initWithSkater:(CGSize)screenSize;
-(id)initWithManHorizontal:(CGSize)screenSize;
-(id)initWithWomanHorizontal:(CGSize)screenSize;
-(id)initWithManVertical:(CGSize)screenSize;
-(id)initWithWomanVertical:(CGSize)screenSize;

-(void)moveToX:(float)position duration:(float)duration;
-(float)randomXPosition:(CGSize)screenSize;

@end
