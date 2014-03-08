//
//  GameScene.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 3/8/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "GameScene.h"
#import "Player.h"
#import "Enemy.h"

// Helper function for random number calculation.
#define ARC4RANDOM_MAX 0x100000000
static inline CGFloat ScalarRandomRange(CGFloat min, CGFloat max) {
  return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}

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
  [self loadPlayer];
  [self spawnCar];
  [self spawnBike];
}

-(void)loadPlayer {
  Player *player = [Player new];
  player.position = CGPointMake(self.size.width / 2, player.size.height / 2);
  [self addChild:player];
}

-(void)spawnEnemy {

}

-(void)spawnCar {
  Enemy *car = [Enemy new];
  car = [car initWithImageNamed:@"car"];
  car.position = [self randomVehiclePosition:car.size.height];
  [self addChild:car];
}

-(void)spawnBike {
  Enemy *bike = [Enemy new];
  bike = [bike initWithImageNamed:@"bike"];
  bike.position = [self randomVehiclePosition:bike.size.height];
  [self addChild:bike];
}

-(void)loadBackground {
  SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
  bg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
  [self addChild:bg];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(CGPoint)randomVehiclePosition:(float)vehicleHeight {
  // Calculate random position for vehicles.
  CGPoint position = CGPointMake(self.size.width / 2, ScalarRandomRange(self.size.height - self.size.height / 3, self.size.height - vehicleHeight / 2));
  return position;
}

@end
