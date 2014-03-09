//
//  Player.h
//  AngryMorten
//
//  Created by Ruben Teijeiro on 3/8/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode

@property SKAction *spitAnimation;
@property SKTexture *shootImage;
@property SKTexture *initialImage;

-(void)spit;
-(void)shoot;
-(void)playerInit;
-(void)spitStop;
-(void)moveTo:(CGPoint)position screenWidth:(float)screenWidth;

@end
