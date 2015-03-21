//
//  Player.h
//  Farkle
//
//  Created by Ronald Hernandez on 3/20/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject
@property NSString *playerName;
@property NSString *playerScore;
@property NSInteger winnings;
@property NSInteger  highestScore;

-(instancetype)initWithPlayerName:(NSString *)name ;


@end
