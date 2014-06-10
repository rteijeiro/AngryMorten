//
//  Enemy.h
//  AngryMorten
//
//  Created by Ruben Teijeiro on 3/8/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Enemy : SKSpriteNode

-(id)initWithManUp:(CGSize)screenSize;
-(id)initWithWomanUp:(CGSize)screenSize;
-(id)initWithManDown:(CGSize)screenSize;
-(id)initWithWomanDown:(CGSize)screenSize;

-(void)movePedestrian:(float)duration screenSize:(CGSize)screenSize;
-(void)movePedestrianToX:(float)position duration:(float)duration;
-(void)moveVehicleToX:(float)position duration:(float)duration;
-(void)moveVehicle:(float)duration screenSize:(CGSize)screenSize;
-(float)randomXPosition:(CGSize)screenSize;
-(CGFloat)scalarRandomRange:(CGFloat)min max:(CGFloat)max;

@end
