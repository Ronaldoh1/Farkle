//
//  Game.m
//  Farkle
//
//  Created by Ronald Hernandez on 3/20/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "Game.h"
#import "Player.h"

@implementation Game


-(instancetype)initWith:(Player *)player{
    self = [super init];


    //initial states
    //0 = hasn't begun
    //1 = currently playing
    //2 = has ended
    self.gameState = 0;
    self.turns =10;
    
    self.playArray = [[NSMutableArray alloc] init];



    return self;
}


@end
