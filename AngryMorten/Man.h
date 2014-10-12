//
//  Man.h
//  AngryMorten
//
//  Created by Ruben Teijeiro on 5/14/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Enemy.h"

@interface Man : Enemy

-(id)initWithSize:(CGSize)screenSize;
-(id)initWithManUp:(CGSize)screenSize;
-(id)initWithManDown:(CGSize)screenSize;

@end
