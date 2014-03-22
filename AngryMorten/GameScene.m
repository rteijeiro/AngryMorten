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

// Define enemy constants.
#define ENEMY_CAR 0
#define ENEMY_BIKE 1
#define ENEMY_SKATEBOARD 2

@implementation GameScene {
  NSTimeInterval _timeLastUpdate;
  float _spawnTime;
  
  SKLabelNode *_aim;
  SKLabelNode *_time;
  SKLabelNode *_score;
  
  Player *_player;
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
  _aim.zPosition = 100.0f;
  
  [self addChild:_aim];
  
  // Create label for Timer.
  _time = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
  _time.name = @"Time";
  _time.fontSize = 30.0f;
  _time.fontColor = [SKColor whiteColor];
  _time.text = @"Time: 20:00:00";
  _time.position = CGPointMake(_time.frame.size.width / 1.5, self.size.height - _time.frame.size.height * 2);
  _time.zPosition = 100.0f;
  
  [self addChild:_time];
  
  // Create label for Score.
  _score = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
  _score.name = @"Score";
  _score.fontSize = 30.0f;
  _score.fontColor = [SKColor whiteColor];
  _score.text = @"Score: 666";
  _score.position = CGPointMake(self.size.width - _score.frame.size.width / 1.5, self.size.height - _score.frame.size.height * 2);
  _score.zPosition = 100.0f;
  
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
    [_player moveTo:location screenWidth:self.size.width];
  }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  // Verify the user touched the player and activate spit.
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  SKNode *node = [self nodeAtPoint:location];
  
  if ([node.name isEqualToString:@"Player"]) {
    // Start spitting.
    [_player spit];
    
    // Move Aim.
    [self moveAim];
  }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  SKNode *node = [self nodeAtPoint:location];
  
  if ([node.name isEqualToString:@"Player"]) {
    // Shoot spit.
    [self shootSpit];
  }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  SKNode *node = [self nodeAtPoint:location];
  
  if ([node.name isEqualToString:@"Player"]) {
    // Shoot Spit;
    [self shootSpit];
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
  _player = [[Player alloc] initWithImageNamed:@"player1"];
  _player.position = CGPointMake(self.size.width / 2.0f, _player.size.height / 2.0f);
  _player.initialImage = [SKTexture textureWithImageNamed:@"player1"];
  _player.shootImage = [SKTexture textureWithImageNamed:@"player5"];
  
  [self addChild:_player];
}

-(SKAction *)createSpitAnimation {
  // Spitting Animation.
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:5];
  
  for (int i = 2; i <= 4; i++) {
    NSString *textureName = [NSString stringWithFormat:@"player%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    [textures addObject:texture];
  }
  
  SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1f];
  
  return animation;
}

-(void)shootSpit {
  // Stop player spitting animation.
  [_player spitStop];
  
  // Stop Aim.
  [self stopAim];
  
  // Create spit in player position.
  SKSpriteNode *spit = [[SKSpriteNode alloc] initWithImageNamed:@"spit"];
  spit.position = CGPointMake(_player.position.x, _player.size.height);
  spit.name = @"Spit";
  [self addChild:spit];
  
  // Distance and spit speed calculations.
  double distance = sqrt(pow((_aim.position.x), 2.0f) + pow((_aim.position.y), 2.0f));
  float duration = distance * 0.0009f;
  
  // Move spit to aim position.
  SKAction *spitMove = [SKAction moveToY:_aim.position.y + _aim.frame.size.height / 2.0f duration:duration];
  
  // Full animation sequence.
  SKAction *sequence = [SKAction sequence:@[spitMove]];
  
  [spit runAction:sequence completion:^{
    // Check for spit collisions.
    [self checkCollisions:spit];
    
    // Remove spit after moving.
    [spit removeFromParent];
  }];
}

-(void)checkCollisions:(SKSpriteNode *)spit {
  [self enumerateChildNodesWithName:@"Enemy" usingBlock:^(SKNode *enemy, BOOL *stop) {
      
    // Reduce enemy frame to increase difficulty.
    CGRect collisionRect = CGRectMake(enemy.position.x, enemy.position.y, enemy.frame.size.width, enemy.frame.size.height);
      
    // Check if spit collided with enemy reduced frame.
    if (CGRectIntersectsRect(spit.frame, collisionRect)) {
      [enemy removeActionForKey:@"MoveToX"];
      Enemy *e = (Enemy *)enemy;
      e.texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hit", e.name]];
    }
  }];
}

// **********************
// Enemy related methods.
// **********************

-(void)spawnEnemy {
  // Spawn random enemies.
  int randomInt = arc4random_uniform(3);
  
  [self createEnemy:randomInt];
}

-(void)createEnemy:(int)type {
  
  NSString *imageName;
  float duration;
  
  switch (type) {
    case ENEMY_CAR:
      imageName = @"car";
      duration = 10.0;
      break;
      
    case ENEMY_BIKE:
      imageName = @"bike";
      duration = 10.0;
      break;
      
    case ENEMY_SKATEBOARD:
      imageName = @"skateboard";
      duration = 10.0;
      break;
      
    default:
      break;
  }

  Enemy *enemy = [[Enemy alloc] initWithImageNamed:imageName];
  enemy.position = [self randomEnemyPosition:enemy.size enemyType:type];
  enemy.name = imageName;
  [self addChild:enemy];
  
  // Check enemy direction to update move position and flip image if needed.
  if (enemy.position.x < 0) { // Right direction.
    [enemy moveToX:self.size.width + enemy.size.width duration:duration];
  }
  else { // Left direction.
    // Flip enemy image.
    enemy.xScale = -1.0f;
    [enemy moveToX:-enemy.size.width * 2 duration:duration];
  }
}

-(CGPoint)randomEnemyPosition:(CGSize)vehicleSize enemyType:(int)enemyType {
  float xPosition;
  
  // Random direction generation.
  int randomDirection = arc4random_uniform(2);
  
  switch (randomDirection) {
    case 0: // Right direction.
      xPosition = -vehicleSize.width;
      break;
      
    case 1: // Left direction.
      xPosition = self.size.width + vehicleSize.width;
      break;
  }
  
  CGPoint position;
  
  switch (enemyType) {
    case ENEMY_SKATEBOARD:
      // Calculate random position for skateboard enemies.
      position = CGPointMake(xPosition, ScalarRandomRange(self.size.height / 2, self.size.height - self.size.height / 2 - vehicleSize.height / 2));
      break;
      
    default:
      // Calculate random position for car and bike enemies.
      position = CGPointMake(xPosition, ScalarRandomRange(self.size.height - self.size.height / 3, self.size.height - vehicleSize.height / 2));
      break;
  }

  return position;
}

@end
