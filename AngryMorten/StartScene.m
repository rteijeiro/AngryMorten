//
//  StartScene.m
//  AngryMorten
//
//  Created by Mikael Ek on 22/03/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "StartScene.h"
#import "GameScene.h"

@implementation StartScene

-(id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    /* Setup your scene here */
    [self showStartScreen];
    [self playBackgroundMusic];
  }
  return self;
}

-(void)slideMorten {
  SKSpriteNode *morten = [SKSpriteNode spriteNodeWithImageNamed:@"ipad-start-morten"];
    
  int offset = 60;
    
  // Create path for Morten.
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathMoveToPoint(path, NULL, 98, 768 + offset);
  CGPathAddLineToPoint(path, NULL, 1024, 460 + offset);
  CGPathAddLineToPoint(path, NULL, 764, 549 + offset);
    
  // Animation for Morten.
  SKAction *sequence = [SKAction followPath:path asOffset:false orientToPath:false duration:3.0f ];
  sequence.timingMode = SKActionTimingEaseInEaseOut;
    
  [self addChild:morten];
  
  [morten runAction:sequence completion:^{
    [self mortenSpit];
  }];
}

-(void)mortenSpit {
  SKSpriteNode *spit = [SKSpriteNode spriteNodeWithImageNamed:@"ipad-start-spit"];
    
  // Create path for Spit.
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathMoveToPoint(path, NULL, 700.0, 550.0);
  CGPathAddLineToPoint(path, NULL, 200.0, 0.0);
    
  SKAction *sequence = [SKAction followPath:path asOffset:false orientToPath:false duration:1.0f ];
  sequence.timingMode = SKActionTimingEaseInEaseOut;
    
  [self addChild:spit];
    
  [spit runAction:sequence completion:^{
    [self showGuy];
  }];
}

-(void)showGuy {
  SKSpriteNode *guy = [SKSpriteNode spriteNodeWithImageNamed:@"ipad-start-guy"];
    
  guy.position = CGPointMake(220.0, 100.0);
    
  [self addChild:guy];
  [self showButtons];
}

-(void)showButtons {
  SKSpriteNode *startButton = [SKSpriteNode spriteNodeWithImageNamed:@"ipad-start-button"];
  SKSpriteNode *title = [SKSpriteNode spriteNodeWithImageNamed:@"ipad-start-title"];
    
  startButton.position = CGPointMake(self.size.width - startButton.size.width / 2, startButton.size.height / 2);
  startButton.name  = @"start";
  
  title.position = CGPointMake(title.size.width / 2, self.size.height - title.size.height / 2);
  
  
  SKAction *increaseButtonSize = [SKAction scaleBy:1.1 duration:0.2];
  SKAction *decreaseButtonSize = [increaseButtonSize reversedAction];
  SKAction *sequence = [SKAction sequence:@[increaseButtonSize, decreaseButtonSize]];

  [startButton runAction:[SKAction repeatActionForever:sequence]];
  
  [self addChild:startButton];
  [self addChild:title];
}

-(void)showStartScreen {
  SKSpriteNode *startBuilding = [SKSpriteNode spriteNodeWithImageNamed:@"ipad-start-building"];
  SKSpriteNode *roof = [SKSpriteNode spriteNodeWithImageNamed:@"ipad-start-roof"];
    
  startBuilding.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
  roof.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));

  [self addChild:roof];
    
  // Go Morten, go!
  [self slideMorten];
  
  [self addChild:startBuilding];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  // Verify the user touched the start button.
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  SKNode *node = [self nodeAtPoint:location];
  
  if ([node.name isEqualToString:@"start"]) {
    // Stop background music.
    [_backgroundMusicPlayer stop];
    
    // Play button sound.
    [self playButtonSound];
    
    // Start button.
    GameScene *gameScene = [[GameScene alloc] initWithSize:self.size];
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    // 3
    [self.view presentScene:gameScene transition:reveal];
  }
}

-(void)playBackgroundMusic {
  NSError *error;
  NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"Soundscape_of_a_Madman_Instrumental" withExtension:@"mp3"];
  _backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
  _backgroundMusicPlayer.numberOfLoops = -1;
  [_backgroundMusicPlayer prepareToPlay];
  [_backgroundMusicPlayer play];
}

-(void)playButtonSound {
  NSError *error;
  NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"191591__fins__button" withExtension:@"wav"];
  _backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
  _backgroundMusicPlayer.numberOfLoops = 0;
  [_backgroundMusicPlayer prepareToPlay];
  [_backgroundMusicPlayer play];
}

@end
