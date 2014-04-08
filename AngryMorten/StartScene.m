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
    }
    return self;
}

-(void)slideMorten {
    SKSpriteNode *morten = [SKSpriteNode spriteNodeWithImageNamed:@"start-morten"];
    
    int offset = 60;
    
    // Create path for Morten
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 98, 768 + offset);
    CGPathAddLineToPoint(path, NULL, 1024, 460 + offset);
    CGPathAddLineToPoint(path, NULL, 764, 549 + offset);
    
    // Animation for Morten
    SKAction *sequence = [SKAction followPath:path asOffset:false orientToPath:false duration:3.0f ];
    sequence.timingMode = SKActionTimingEaseInEaseOut;
    
    [self addChild:morten];
    
    [morten runAction:sequence completion:^{
        [self mortenSpit];
    }];
}

-(void)mortenSpit {
    SKSpriteNode *spit = [SKSpriteNode spriteNodeWithImageNamed:@"start-spit"];
    
    // Create path for Spit
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 700.0, 550.0);
    CGPathAddLineToPoint(path, NULL, 200.0, 0.0);
    
    SKAction *sequence = [SKAction followPath:path asOffset:false orientToPath:false duration:1.0f ];
    sequence.timingMode = SKActionTimingEaseInEaseOut;
    
    [self addChild:spit];
    
    [spit runAction:sequence completion:^{
        [self flipTheBird];
    }];
}

-(void)flipTheBird {
    SKSpriteNode *birdFlipGuy = [SKSpriteNode spriteNodeWithImageNamed:@"start-guy"];
    
    birdFlipGuy.position = CGPointMake(220.0, 100.0);
    
    [self addChild:birdFlipGuy];
    
    [self showButtons];
}

-(void)showButtons {
    SKSpriteNode *startButton = [SKSpriteNode spriteNodeWithImageNamed:@"start-button"];
    SKSpriteNode *title = [SKSpriteNode spriteNodeWithImageNamed:@"start-title"];
    
    startButton.position = CGPointMake(700.0, 90.0);
    startButton.name  = @"start";
  
    title.position = CGPointMake(300.0, 600.0);
    
    [self addChild:startButton];
    [self addChild:title];
}

-(void)showStartScreen {
    
    SKSpriteNode *startBuilding = [SKSpriteNode spriteNodeWithImageNamed:@"start-building"];
    SKSpriteNode *roof = [SKSpriteNode spriteNodeWithImageNamed:@"start-roof"];
    
    startBuilding.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    roof.position = CGPointMake(0, 0);  
    
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
    // Start button.
    GameScene *gameScene = [[GameScene alloc] initWithSize:self.size];
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    // 3
    [self.view presentScene:gameScene transition:reveal];
  }
}


@end
