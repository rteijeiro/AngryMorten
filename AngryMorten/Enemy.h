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
-(id)initWithMan:(CGSize)screenSize;
-(id)initWithWoman:(CGSize)screenSize;
-(id)initWithManUp:(CGSize)screenSize;
-(id)initWithWomanUp:(CGSize)screenSize;
-(id)initWithManDown:(CGSize)screenSize;
-(id)initWithWomanDown:(CGSize)screenSize;

-(void)movePedestrianToX:(float)position duration:(float)duration;
-(void)moveVehicleToX:(float)position duration:(float)duration;
-(float)randomXPosition:(CGSize)screenSize;

@end
