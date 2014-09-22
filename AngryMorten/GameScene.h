//
//  GameScene.h
//  AngryMorten
//

//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@import AVFoundation;

@interface GameScene : SKScene

@property (strong, nonatomic)  AVAudioPlayer *backgroundMusicPlayer;

-(id)initWithSize:(CGSize)size;

@end
