//
//  GameScene.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 3/8/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"
#import "Player.h"
#import "Enemy.h"
#import "Car.h"
#import "Bike.h"
#import "Skater.h"
#import "Man.h"
#import "Woman.h"

// Define enemy constants.
#define ENEMY_CAR 0
#define ENEMY_BIKE 1
#define ENEMY_SKATEBOARD 2
#define ENEMY_MAN 3
#define ENEMY_WOMAN 4
#define ENEMY_MAN_UP 5
#define ENEMY_WOMAN_UP 6
#define ENEMY_MAN_DOWN 7
#define ENEMY_WOMAN_DOWN 8

@implementation GameScene {
  NSTimeInterval _timeLastUpdate;
  float _spawnTime;
  
  SKLabelNode *_aim;
  
  SKLabelNode *_timeLabel;
  int _time;
  
  SKLabelNode *_scoreLabel;
  int _score;
  
  SKSpriteNode *door;
  
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
  [self playBackgroundMusic];
  [self loadGUI];
  [self loadPlayer];
}

-(void)loadBackground {
  SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"ipad-background"];
  bg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
  [self addChild:bg];
}

-(void)loadGUI {
  // Create Aim for targetting spits.
  _aim = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
  _aim.name = @"Aim";
  _aim.fontSize = 100.0f;
  _aim.fontColor = [SKColor whiteColor];
  _aim.text = @"⌖";
  _aim.position = CGPointMake(0.0f, -self.size.height);
  _aim.zPosition = 100.0f;
  
  [self addChild:_aim];
  
  // Create label for timer and init time variable.
  _time = 120;
  _timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
  _timeLabel.name = @"Time";
  _timeLabel.fontSize = 30.0f;
  _timeLabel.fontColor = [SKColor whiteColor];
  _timeLabel.text = [NSString stringWithFormat:@"Time: %d", _time];
  _timeLabel.position = CGPointMake(_timeLabel.frame.size.width / 1.5, self.size.height - _timeLabel.frame.size.height * 2);
  _timeLabel.zPosition = 100.0f;
  
  [self addChild:_timeLabel];
  
  // Create label for score and init score variable.
  _score = 0;
  _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
  _scoreLabel.name = @"Score";
  _scoreLabel.fontSize = 30.0f;
  _scoreLabel.fontColor = [SKColor whiteColor];
  _scoreLabel.text = [NSString stringWithFormat:@"Score: %d", _score];
  _scoreLabel.position = CGPointMake(self.size.width - _scoreLabel.frame.size.width / 1.3, self.size.height - _scoreLabel.frame.size.height * 2);
  _scoreLabel.zPosition = 100.0f;
  
  [self addChild:_scoreLabel];
}

-(void)moveAim {
  _aim.position = CGPointMake(_player.position.x + _aim.frame.size.width / 4, self.size.height / 3);
  SKAction *moveUp = [SKAction moveToY:self.size.height - _aim.frame.size.height / 1.5 duration:1.0];
  SKAction *moveDown = [SKAction moveToY:self.size.height / 3 duration:1.0];
  SKAction *sequence = [SKAction sequence:@[moveUp, moveDown]];
  
  [_aim runAction:[SKAction repeatActionForever:sequence] withKey:@"aimAnimation"];
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
    _aim.position = CGPointMake(_player.position.x, _aim.position.y);
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
    
    // Play loogie sound.
    [self playLoogieSound];
    
    [self openDoor];
    
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
    [self closeDoor];
  }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  SKNode *node = [self nodeAtPoint:location];
  
  if ([node.name isEqualToString:@"Player"]) {
    // Shoot Spit;
    [self shootSpit];
    [self closeDoor];
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
  
  // Spawn a new enemy every second and update timer.
  if (_spawnTime > 1.0f) {
    [self spawnEnemy];
    
    // Update timer variable and label.
    _time -= 1;
    _timeLabel.text = [NSString stringWithFormat:@"Time: %d", _time - 1];
    
    // Check if time is over.
    [self checkTimeOver];
    
    _spawnTime = 0.0f;
  }
}

-(void)checkTimeOver {
  if (_time == 0) {
    [self gameOver];
  }
}

-(void)gameOver {
  // Stop backgound music.
  [_backgroundMusicPlayer stop];
  
  GameOverScene *gameOverScene = [[GameOverScene alloc] initWithSize:self.size score:_score];
  [self.view presentScene:gameOverScene transition:[SKTransition fadeWithDuration:2.0]];
}

// ***********************
// Player related methods.
// ***********************

-(void)loadPlayer {
  _player = [[Player alloc] initWithImageNamed:@"ipad-player1"];
  _player.position = CGPointMake(self.size.width / 2.0f, _player.size.height / 2.0f);
  _player.initialImage = [SKTexture textureWithImageNamed:@"ipad-player1"];
  _player.shootImage = [SKTexture textureWithImageNamed:@"ipad-player5"];
  _player.zPosition = 100;
  
  [self addChild:_player];
}

-(SKAction *)createSpitAnimation {
  // Spitting Animation.
  NSMutableArray *textures = [NSMutableArray arrayWithCapacity:5];
  
  for (int i = 2; i <= 4; i++) {
    NSString *textureName = [NSString stringWithFormat:@"ipad-player%d", i];
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    [textures addObject:texture];
  }
  
  SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1f];
  
  return animation;
}

-(void)shootSpit {
  // Stop player spitting animation.
  [_player spitStop];
  
  // Play spit sound.
  [_loogieSoundPlayer stop];
  [self playSpitSound];
  
  // Stop Aim.
  [self stopAim];
  
  // Create spit in player position.
  SKSpriteNode *spit = [[SKSpriteNode alloc] initWithImageNamed:@"ipad-spit"];
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
    CGRect collisionRect = CGRectMake(enemy.position.x, enemy.position.y, enemy.frame.size.width / 2, enemy.frame.size.height / 2);
      
    // Check if spit collided with enemy reduced frame.
    if (CGRectIntersectsRect(spit.frame, collisionRect)) {
      
      // Play hit sound.
      [self playHitSound];
      
      [enemy removeActionForKey:@"Move"];
      Enemy *e = (Enemy *)enemy;
      e.texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"ipad-%@-hit", e.name]];
     
      if ([enemy.name isEqualToString:@"car"] || [enemy.name isEqualToString:@"bike"] || [enemy.name isEqualToString:@"skater"]) {
        _score += 50;
      }
      else if ([enemy.name isEqualToString:@"man-up"] || [enemy.name isEqualToString:@"man-down"] || [enemy.name isEqualToString:@"woman-up"] || [enemy.name isEqualToString:@"woman-down"]) {
        _score += 10;
      }
      else if ([enemy.name isEqualToString:@"man"] || [enemy.name isEqualToString:@"woman"]) {
        _score += 5;
      }
      
      _scoreLabel.text = [NSString stringWithFormat:@"Score: %d", _score];
    }
  }];
}

// **********************
// Enemy related methods.
// **********************

-(void)spawnEnemy {
  // Spawn random enemies.
  int randomInt = arc4random_uniform(9);
  
  [self createEnemy:randomInt];
}

-(void)createEnemy:(int)type {
  
  Enemy *enemy;
  
  switch (type) {
    case ENEMY_CAR:
      enemy = [[Car alloc] initWithSize:self.size];
      break;
      
    case ENEMY_BIKE:
      enemy = [[Bike alloc] initWithSize:self.size];
      break;
      
    case ENEMY_SKATEBOARD:
      enemy = [[Skater alloc] initWithSize:self.size];
      break;
      
    case ENEMY_MAN:
      enemy = [[Man alloc] initWithSize:self.size];
      break;
      
    case ENEMY_WOMAN:
      enemy = [[Woman alloc] initWithSize:self.size];
      break;
      
    case ENEMY_MAN_UP:
      enemy = [[Man alloc] initWithManUp:self.size];
      break;
      
    case ENEMY_WOMAN_UP:
      enemy = [[Woman alloc] initWithWomanUp:self.size];
      break;

    case ENEMY_MAN_DOWN:
      enemy = [[Man alloc] initWithManDown:self.size];
      break;
      
    case ENEMY_WOMAN_DOWN:
      enemy = [[Woman alloc] initWithWomanDown:self.size];
      break;

    default:
      break;
  }
  
  [self addChild:enemy];
}

-(void)openDoor {
  door = [SKSpriteNode spriteNodeWithImageNamed:@"ipad-open-door"];
  door.position = CGPointMake(CGRectGetMidX(self.frame) + 4, CGRectGetMidY(self.frame) / 2 - 22.5);
  [self addChild:door];
}

-(void)closeDoor {
  [door removeFromParent];
}

-(void)playBackgroundMusic {
  NSError *error;
  NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"Psycho_Nu_Metal_Loop" withExtension:@"mp3"];
  _backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
  _backgroundMusicPlayer.numberOfLoops = -1;
  [_backgroundMusicPlayer prepareToPlay];
  [_backgroundMusicPlayer play];
}

-(void)playLoogieSound {
  NSError *error;
  NSURL *loogieSoundURL = [[NSBundle mainBundle] URLForResource:@"loogie" withExtension:@"mp3"];
  _loogieSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:loogieSoundURL error:&error];
  _loogieSoundPlayer.numberOfLoops = 0;
  [_loogieSoundPlayer prepareToPlay];
  [_loogieSoundPlayer play];
}

-(void)playSpitSound {
  NSError *error;
  NSURL *spitSoundURL = [[NSBundle mainBundle] URLForResource:@"spit" withExtension:@"mp3"];
  _spitSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:spitSoundURL error:&error];
  _spitSoundPlayer.numberOfLoops = 0;
  [_spitSoundPlayer prepareToPlay];
  [_spitSoundPlayer play];
}

-(void)playHitSound {
  NSError *error;
  NSURL *hitSoundURL = [[NSBundle mainBundle] URLForResource:@"hit" withExtension:@"mp3"];
  _hitSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:hitSoundURL error:&error];
  _hitSoundPlayer.numberOfLoops = 0;
  [_hitSoundPlayer prepareToPlay];
  [_hitSoundPlayer play];
}

@end
