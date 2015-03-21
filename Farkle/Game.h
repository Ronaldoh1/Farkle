//
//  Game.h
//  Farkle
//
//  Created by Ronald Hernandez on 3/20/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject

@property NSInteger gameState;
@property NSInteger turns;
@property NSString *currentPlayer;
@property NSMutableArray *playArray;



@end
