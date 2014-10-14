//
//  GameOverScene.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 9/16/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"

@implementation GameOverScene

-(id)initWithSize:(CGSize)size score:(int)score {
  if (self = [super initWithSize:size]) {
    /* Setup your scene here */
    self.score = score;
    [self showGameOverScene];
  }
  return self;
}

-(void)showGameOverScene {
  
  // Play Game Over sound.
  [self playGameOverSound];
  
  SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"ipad-gameover-background"];
  SKSpriteNode *skull = [SKSpriteNode spriteNodeWithImageNamed:@"ipad-gameover-skull"];
  SKSpriteNode *text = [SKSpriteNode spriteNodeWithImageNamed:@"ipad-gameover-text"];
  SKSpriteNode *morten = [SKSpriteNode spriteNodeWithImageNamed:@"ipad-gameover-morten"];
  
  background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
  skull.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - skull.size.height / 2);
  text.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
  morten.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) / 2);
  
  [self addChild:background];
  [self addChild:skull];
  [self addChild:text];
  [self addChild:morten];
  
  // Create label for score and init score variable.
  SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
  scoreLabel.name = @"Score";
  scoreLabel.fontSize = 60.0f;
  scoreLabel.fontColor = [SKColor whiteColor];
  scoreLabel.text = [NSString stringWithFormat:@"Total Score: %d", _score];
  scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), scoreLabel.frame.size.height);
  scoreLabel.zPosition = 100.0f;
  
  [self addChild:scoreLabel];
  
  // Create label for restart button.
  SKLabelNode *restartLabel = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
  restartLabel.name = @"Restart";
  restartLabel.fontSize = 60.0f;
  restartLabel.fontColor = [SKColor whiteColor];
  restartLabel.text = @"Restart";
  restartLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) / 2 - restartLabel.frame.size.height);
  restartLabel.zPosition = 100.0f;
  
  // Animate restart label button.
  SKAction *increaseRestartLabelSize = [SKAction scaleBy:1.5 duration:0.2];
  SKAction *decreaseRestartLabelSize = [increaseRestartLabelSize reversedAction];
  SKAction *sequence = [SKAction sequence:@[increaseRestartLabelSize, decreaseRestartLabelSize]];
  [restartLabel runAction:[SKAction repeatActionForever:sequence]];
  
  [self addChild:restartLabel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  // Verify the user touched the restart label.
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  SKNode *node = [self nodeAtPoint:location];
  
  if ([node.name isEqualToString:@"Restart"]) {
    // Load start scene.
    GameScene *gameScene = [[GameScene alloc] initWithSize:self.size];
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    [self.view presentScene:gameScene transition:reveal];
  }
}

-(void)playGameOverSound {
  NSError *error;
  NSURL *gameoverSoundURL = [[NSBundle mainBundle] URLForResource:@"gameover" withExtension:@"mp3"];
  _gameoverMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:gameoverSoundURL error:&error];
  _gameoverMusicPlayer.numberOfLoops = 0;
  [_gameoverMusicPlayer prepareToPlay];
  [_gameoverMusicPlayer play];
}

@end
