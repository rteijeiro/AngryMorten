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
  NSTimeInterval _timeLastUpdate;
  float _spawnTime;
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

// *********************
// Game related methods.
// *********************

-(void)startGame {
  [self loadBackground];
  [self loadGUI];
  [self loadPlayer];
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

-(void)moveAim {
  _aim.position = CGPointMake(0.0f, self.size.height / 3);
  SKAction *animation = [SKAction moveToY:self.size.height - _aim.frame.size.height / 1.5 duration:1.0];
  [_aim runAction:animation withKey:@"aimAnimation"];
}

-(void)stopAim {
  [_aim removeActionForKey:@"aimAnimation"];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  // Verify that user touched the player and move it.
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  SKNode *node = [self nodeAtPoint:location];
  
  if ([node.name isEqualToString:@"Player"]) {
    // Move player.
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
    // Start spitting.
    Player *player = (Player *) node;
    [player spit];
    
    // Move Aim.
    [self moveAim];
  }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  SKNode *node = [self nodeAtPoint:location];
  
  if ([node.name isEqualToString:@"Player"]) {
    // Stop spitting.
    Player *player = (Player *) node;
    [player spitStop];
    
    // Stop Aim.
    [self stopAim];
  }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  SKNode *node = [self nodeAtPoint:location];
  
  if ([node.name isEqualToString:@"Player"]) {
    // Stop spitting.
    Player *player = (Player *) node;
    [player spitStop];
    
    // Stop Aim.
    [self stopAim];
  }
}

-(void)update:(CFTimeInterval)currentTime {
  /* Called before each frame is rendered */
  float elapsed;
  if (_timeLastUpdate) {
    elapsed = currentTime - _timeLastUpdate;
  }
  else {
    elapsed = 0;
  }
  _timeLastUpdate = currentTime;
  _spawnTime += elapsed;
  
  // Spawn a new enemy every second.
  if (_spawnTime > 1.0f) {
    [self spawnEnemy];
    _spawnTime = 0.0f;
  }
}

// ***********************
// Player related methods.
// ***********************

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

// **********************
// Enemy related methods.
// **********************

-(void)spawnEnemy {
  // Spawn random enemies.
  int randomInt = arc4random_uniform(2);
  switch (randomInt) {
    case 0:
      [self spawnCar];
      break;
      
    case 1:
      [self spawnBike];
      break;
      
    default:
      break;
  }
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

-(CGPoint)randomVehiclePosition:(float)vehicleHeight {
  // Calculate random position for vehicles.
  CGPoint position = CGPointMake(self.size.width / 2, ScalarRandomRange(self.size.height - self.size.height / 3, self.size.height - vehicleHeight / 2));
  return position;
}

@end
