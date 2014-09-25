//
//  GameOverScene.h
//  AngryMorten
//
//  Created by Ruben Teijeiro on 9/16/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@import AVFoundation;

@interface GameOverScene : SKScene

@property (strong, nonatomic) AVAudioPlayer *gameoverMusicPlayer;
@property (nonatomic) int score;

-(id)initWithSize:(CGSize)size score:(int)score;

@end
