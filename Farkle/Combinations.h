//
//  Combinations.h
//  Farkle
//
//  Created by Ronald Hernandez on 3/19/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Combinations : NSObject

@property (nonatomic) int points;
@property (nonatomic) NSArray * winningCombination;

-(instancetype) initWithNumbers:(NSArray *)diceNumbers andWithPoints:(int)points;

@end
