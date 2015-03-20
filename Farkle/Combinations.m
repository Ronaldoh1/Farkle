//
//  Combinations.m
//  Farkle
//
//  Created by Ronald Hernandez on 3/19/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "Combinations.h"

@implementation Combinations


-(instancetype)initWithNumbers:(NSArray *)diceNumbers andWithPoints:(int)points{

    self = [super init];
    self.winningCombination = diceNumbers;
    self.points = points;

    return self;
}

@end
