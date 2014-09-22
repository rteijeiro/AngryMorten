//
//  GameOverScene.m
//  AngryMorten
//
//  Created by Ruben Teijeiro on 9/16/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "GameOverScene.h"

@implementation GameOverScene

-(id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    /* Setup your scene here */
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
