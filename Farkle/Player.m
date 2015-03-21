//
//  Player.m
//  Farkle
//
//  Created by Ronald Hernandez on 3/20/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "Player.h"

@implementation Player

-(instancetype)initWithPlayerName:(NSString *)name {
    self.playerName = name;
    self.playerScore = 0;
    self.winnings = 0;
    self.highestScore = 0;
    return self;
}

@end
