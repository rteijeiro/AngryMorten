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
@property (strong, nonatomic)  AVAudioPlayer *loogieSoundPlayer;
@property (strong, nonatomic)  AVAudioPlayer *spitSoundPlayer;
@property (strong, nonatomic)  AVAudioPlayer *hitSoundPlayer;
@property (strong, nonatomic)  AVAudioPlayer *claxonSoundPlayer;
@property (strong, nonatomic)  AVAudioPlayer *buaghSoundPlayer;

-(id)initWithSize:(CGSize)size;

@end
