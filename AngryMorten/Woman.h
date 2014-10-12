//
//  Woman.h
//  AngryMorten
//
//  Created by Ruben Teijeiro on 6/10/14.
//  Copyright (c) 2014 Ruben Teijeiro. All rights reserved.
//

#import "Enemy.h"

@interface Woman : Enemy

-(id)initWithSize:(CGSize)screenSize;
-(id)initWithWomanUp:(CGSize)screenSize;
-(id)initWithWomanDown:(CGSize)screenSize;

@end
