//
//  GameScene.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 3/8/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
      /* Setup your scene here */
      [self startGame];
    }
    return self;
}

-(void)startGame {
  [self loadBackground];
}

-(void)loadBackground {
  SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
  bg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
  [self addChild:bg];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
