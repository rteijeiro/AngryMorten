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

@implementation GameScene {
  SKLabelNode *_aim;
  SKLabelNode *_time;
  SKLabelNode *_score;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
      /* Setup your scene here */
      [self startGame];
    }
    return self;
}

-(void)startGame {
  [self loadBackground];
  [self loadGUI];
  [self loadPlayer];
  [self spawnCar];
  [self spawnBike];
}

-(void)loadPlayer {
  Player *player = [[Player alloc] initWithImageNamed:@"player1"];
  player.position = CGPointMake(self.size.width / 2, player.size.height / 2);
  player.spitAnimation = [self createSpitAnimation];
  player.initialImage = [SKTexture textureWithImageNamed:@"player1"];
  player.shootImage = [SKTexture textureWithImageNamed:@"player5"];
  
  [self addChild:player];
}

-(SKAction *)createSpitAnimation {
  // Spitting Animation.
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:5];
  
  for (int i = 2; i <= 4; i++) {
    NSString *textureName = [NSString stringWithFormat:@"player%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    [textures addObject:texture];
  }
  
  SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
  
  return animation;
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

-(void)loadGUI {
  // Create Aim for targetting spits.
  _aim = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
  _aim.name = @"Aim";
  _aim.fontSize = 100.0f;
  _aim.fontColor = [SKColor whiteColor];
  _aim.text = @"▶︎";
  _aim.position = CGPointMake(0.0f, self.size.height / 3);
  
  [self addChild:_aim];
  
  // Create label for Timer.
  _time = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
  _time.name = @"Time";
  _time.fontSize = 30.0f;
  _time.fontColor = [SKColor whiteColor];
  _time.text = @"Time: 20:00:00";
  _time.position = CGPointMake(_time.frame.size.width / 1.5, self.size.height - _time.frame.size.height * 2);
  
  [self addChild:_time];
  
  // Create label for Score.
  _score = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
  _score.name = @"Score";
  _score.fontSize = 30.0f;
  _score.fontColor = [SKColor whiteColor];
  _score.text = @"Score: 666";
  _score.position = CGPointMake(self.size.width - _score.frame.size.width / 1.5, self.size.height - _score.frame.size.height * 2);
  
  [self addChild:_score];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  // Verify that user touched the player and move it.
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  SKNode *node = [self nodeAtPoint:location];
  
  if ([node.name isEqualToString:@"Player"]) {
    Player *player = (Player *) node;
    [player moveTo:location screenWidth:self.size.width];
  }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  // Verify the user touched the player and activate spit.
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  SKNode *node = [self nodeAtPoint:location];
  
  if ([node.name isEqualToString:@"Player"]) {
    Player *player = (Player *) node;
    [player spit];
  }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  SKNode *node = [self nodeAtPoint:location];
  
  if ([node.name isEqualToString:@"Player"]) {
    Player *player = (Player *) node;
    [player spitStop];
  }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  SKNode *node = [self nodeAtPoint:location];
  
  if ([node.name isEqualToString:@"Player"]) {
    Player *player = (Player *) node;
    [player spitStop];
  }
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
