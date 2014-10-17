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

// Define game constants.
#define GAME_TIME 60
#define SPAWN_TIME 4
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
  float _gameTime;
  float _spawnTime;
  
  SKLabelNode *_aim;
  
  SKLabelNode *_timerLabel;
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
  [self createAim];
  
  // Create label for time and timer.
  [self createTimerLabels];
  
  // Create label for score and init score variable.
  [self createScoreLabels];
  
  // Add door image.
  [self addDoor];
}

-(void)createAim {
  _aim = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
  _aim.name = @"Aim";
  _aim.fontSize = 100.0f;
  _aim.fontColor = [SKColor whiteColor];
  _aim.text = @"⌖";
  _aim.position = CGPointMake(0.0f, -self.size.height);
  _aim.zPosition = 100.0f;
  
  [self addChild:_aim];
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

-(void)createTimerLabels {
  
  // Time label.
  SKLabelNode *timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
  timeLabel.fontSize = 30.0f;
  timeLabel.fontColor = [SKColor whiteColor];
  timeLabel.text = @"Time";
  timeLabel.position = CGPointMake(timeLabel.frame.size.width * 2.15f, self.size.height - timeLabel.frame.size.height);
  timeLabel.zPosition = 100.0f;
  timeLabel.alpha = 0.5f;
  
  [self addChild:timeLabel];
  
  // Timer label.
  _time = GAME_TIME;
  _timerLabel = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
  _timerLabel.name = @"Time";
  _timerLabel.fontSize = 60.0f;
  _timerLabel.fontColor = [SKColor whiteColor];
  _timerLabel.text = [NSString stringWithFormat:@"%d", _time];
  _timerLabel.position = CGPointMake(_timerLabel.frame.size.width / 0.5, self.size.height - _timerLabel.frame.size.height * 2);
  _timerLabel.zPosition = 100.0f;
  _timerLabel.alpha = 0.5f;
  
  [self addChild:_timerLabel];
}

-(void)createScoreLabels {
  
  // Score text label.
  SKLabelNode *scoreText = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
  scoreText.fontSize = 30.0f;
  scoreText.fontColor = [SKColor whiteColor];
  scoreText.text = @"Score";
  scoreText.position = CGPointMake(self.size.width - scoreText.frame.size.width * 1.5, self.size.height - scoreText.frame.size.height);
  scoreText.zPosition = 100.0f;
  scoreText.alpha = 0.5f;
  
  [self addChild:scoreText];
  
  // Score label.
  _score = 0;
  _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
  _scoreLabel.name = @"Score";
  _scoreLabel.fontSize = 60.0f;
  _scoreLabel.fontColor = [SKColor whiteColor];
  _scoreLabel.text = [NSString stringWithFormat:@"%d", _score];
  _scoreLabel.position = CGPointMake(self.size.width - _scoreLabel.frame.size.width * 4, self.size.height - _scoreLabel.frame.size.height * 2);
  _scoreLabel.zPosition = 100.0f;
  _scoreLabel.alpha = 0.5f;
  
  [self addChild:_scoreLabel];
}

// ***************************
// Touch and Movement methods.
// ***************************

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
  _gameTime += elapsed;
  _spawnTime += elapsed;
  
  // Update timer every second.
  if (_gameTime > 1.0) {
    
    // Update timer and check if time is over.
    [self updateTimer];
    
    _gameTime = 0.0f;
  }
  
  if (_spawnTime > SPAWN_TIME) {
    [self spawnEnemy];
    _spawnTime = 0.0f;
  }
  
  // Check for open or close door.
  [self checkDoor];
}

-(void)updateTimer {
  // Update timer variable and label.
  _time -= 1;
  _timerLabel.text = [NSString stringWithFormat:@"%d", _time];

  if (_time == 0) {
    [self gameOver];
  }
  else if (_time <= 10) {
    if (_timerLabel.alpha != 1.0f) {
      _timerLabel.fontColor = [SKColor redColor];
      _timerLabel.alpha = 1.0f;
      
      // Animate timer.
      SKAction *increaseLabelSize = [SKAction scaleBy:2.0 duration:0.2];
      SKAction *decreaseLabelSize = [increaseLabelSize reversedAction];
      SKAction *sequence = [SKAction sequence:@[increaseLabelSize, decreaseLabelSize]];
      
      [_timerLabel runAction:[SKAction repeatActionForever:sequence]];
    }
  }
  else {
    _timerLabel.fontColor = [SKColor whiteColor];
  }
}

-(void)gameOver {
  // Stop backgound music.
  [_backgroundMusicPlayer stop];
  
  // Load Game Over scene.
  GameOverScene *gameOverScene = [[GameOverScene alloc] initWithSize:self.size score:_score];
  [self.view presentScene:gameOverScene transition:[SKTransition fadeWithDuration:2.0]];
  
  // Remove actual scene.
  [self removeFromParent];
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
  
  // Animate spit size.
  SKAction *spitSize = [SKAction sequence:@[[SKAction scaleBy:2.0 duration:duration / 1.5], [SKAction scaleBy:0.2 duration:duration / 4]]];
  
  // Full animation sequence.
  SKAction *sequence = [SKAction group:@[spitSize, spitMove]];
  
  [spit runAction:sequence completion:^{
    // Check for spit collisions.
    [self checkCollisions:spit];
    
    // Remove spit after moving.
    [spit removeFromParent];
  }];
}

-(void)checkCollisions:(SKSpriteNode *)spit {
  [self enumerateChildNodesWithName:@"Enemy" usingBlock:^(SKNode *enemy, BOOL *stop) {

    // Check if spit collided with enemy reduced frame.
    if (CGRectIntersectsRect(spit.frame, enemy.frame)) {
      
      // Play hit sound.
      [self playHitSound];

      // Enemy hit.
      Enemy *e = (Enemy *)enemy;
      [e hit];
      
      // Update score.
      int hitScore = 0;
      
      if ([enemy.name isEqualToString:@"car"]) {
        hitScore = 50;
        _score += hitScore;
        [self playClaxonSound];
      }
      else if ([enemy.name isEqualToString:@"bike"]) {
        hitScore = 30;
        _score += hitScore;
      }
      else if ([enemy.name isEqualToString:@"skater"]) {
        hitScore = 30;
        _score += hitScore;
        [self playHuhhSound];
      }
      else if ([enemy.name isEqualToString:@"man"]) {
        hitScore = 5;
        _score += hitScore;
        [self playWehSound];
      }
      else if ([enemy.name isEqualToString:@"man-up"] || [enemy.name isEqualToString:@"man-down"]) {
        hitScore = 10;
        _score += hitScore;
        [self playWehSound];
      }
      else if ([enemy.name isEqualToString:@"woman"]) {
        hitScore = 5;
        _score += hitScore;
        [self playGirlShoutSound];
      }
      else if ([enemy.name isEqualToString:@"woman-up"] || [enemy.name isEqualToString:@"woman-down"]) {
        hitScore = 10;
        _score += hitScore;
        [self playGirlShoutSound];
      }
      
      // Create hit score label.
      [self scoreLabel:hitScore frame:e.frame];
      
      // Update score label and animate it.
      _scoreLabel.text = [NSString stringWithFormat:@"%d", _score];
      
      SKAction *increaseLabelSize = [SKAction group:@[[SKAction fadeAlphaBy:1.0 duration:0.2], [SKAction scaleBy:1.5 duration:0.2]]];
      SKAction *decreaseLabelSize = [increaseLabelSize reversedAction];
      SKAction *sequence = [SKAction sequence:@[increaseLabelSize, decreaseLabelSize]];
      
      [_scoreLabel runAction:sequence];
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

// Game methods.

-(void)scoreLabel:(int)hitScore frame:(CGRect)frame {
  SKLabelNode *hitScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
  hitScoreLabel.fontSize = 30.0f;
  hitScoreLabel.fontColor = [SKColor whiteColor];
  hitScoreLabel.text = [NSString stringWithFormat:@"%d", hitScore];
  hitScoreLabel.position = CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height);
  hitScoreLabel.zPosition = 100.0f;
  [self addChild:hitScoreLabel];

  SKAction *fadeOff = [SKAction fadeOutWithDuration:0.5];
  SKAction *scale = [SKAction scaleBy:5.0 duration:0.5];
  SKAction *remove = [SKAction removeFromParent];
  [hitScoreLabel runAction:[SKAction sequence:@[scale, fadeOff, remove]]];
}

-(void)addDoor {
  door = [SKSpriteNode spriteNodeWithImageNamed:@"ipad-open-door"];
  door.position = CGPointMake(CGRectGetMidX(self.frame) + 4, CGRectGetMidY(self.frame) / 2 - 22.5);
  door.alpha = 0.0;
  [self addChild:door];
}

-(void)checkDoor {
  [self enumerateChildNodesWithName:@"Enemy" usingBlock:^(SKNode *enemy, BOOL *stop) {
    // Check if enemy collided with door. We only check man and woman up/down.
    if ([enemy.name isEqualToString:@"man-up"] || [enemy.name isEqualToString:@"man-down"] || [enemy.name isEqualToString:@"woman-up"] || [enemy.name isEqualToString:@"woman-down"]) {
      if (enemy.position.y < self.frame.size.height / 2) {
        // Open door.
        door.alpha = 1.0;
      }
      else {
        // Close door.
        door.alpha = 0.0;
      }
    }
  }];
}

-(void)playBackgroundMusic {

  NSError *error;
  
  // Create a random number.
  int randomInt = arc4random_uniform(4);
  
  // Define default background music.
  NSString *backgroundMusic;
  
  switch (randomInt) {
    case 1:
      backgroundMusic = @"Psycho_Nu_Metal_Loop";
      break;
    
    case 2:
      backgroundMusic = @"Ive_Got_a_Bazooka_Man";
      break;
      
    case 3:
      backgroundMusic = @"Simple_Metal";
      break;
      
    case 4:
      backgroundMusic = @"Six_by_Eight_Thunder";
      break;
  }
  
  NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:backgroundMusic withExtension:@"mp3"];
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

-(void)playClaxonSound {
  NSError *error;
  NSURL *claxonSoundURL = [[NSBundle mainBundle] URLForResource:@"claxon" withExtension:@"mp3"];
  _claxonSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:claxonSoundURL error:&error];
  _claxonSoundPlayer.numberOfLoops = 0;
  [_claxonSoundPlayer prepareToPlay];
  [_claxonSoundPlayer play];
}

-(void)playWehSound {
  NSError *error;
  NSURL *wehSoundURL = [[NSBundle mainBundle] URLForResource:@"weh" withExtension:@"mp3"];
  _wehSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:wehSoundURL error:&error];
  _wehSoundPlayer.numberOfLoops = 0;
  [_wehSoundPlayer prepareToPlay];
  [_wehSoundPlayer play];
}

-(void)playGirlShoutSound {
  NSError *error;
  NSURL *girlShoutSoundURL = [[NSBundle mainBundle] URLForResource:@"girl-shout" withExtension:@"mp3"];
  _girlShoutSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:girlShoutSoundURL error:&error];
  _girlShoutSoundPlayer.numberOfLoops = 0;
  [_girlShoutSoundPlayer prepareToPlay];
  [_girlShoutSoundPlayer play];
}

-(void)playHuhhSound {
  NSError *error;
  NSURL *huhhSoundURL = [[NSBundle mainBundle] URLForResource:@"huhh" withExtension:@"mp3"];
  _huhhSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:huhhSoundURL error:&error];
  _huhhSoundPlayer.numberOfLoops = 0;
  [_huhhSoundPlayer prepareToPlay];
  [_huhhSoundPlayer play];
}

@end
