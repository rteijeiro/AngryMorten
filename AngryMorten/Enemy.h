//
//  Enemy.h
//  AngryMorten
//
//  Created by Ruben Teijeiro on 3/8/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Enemy : SKSpriteNode

-(float)randomXPosition:(CGSize)screenSize;
-(CGFloat)scalarRandomRange:(CGFloat)min max:(CGFloat)max;
-(void)hit;

@end
