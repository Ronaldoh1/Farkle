//
//  Combinations.m
//  Farkle
//
//  Created by Ronald Hernandez on 3/19/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "Combinations.h"

@implementation Combinations

-(instancetype)init{
      self = [super init];


    self.winningCombination6 = [[NSDictionary alloc] init];
    self.winningCombination3 = [[NSMutableArray alloc] init];
    self.winningCombination1 = [[NSMutableArray alloc] init];
    self.points = 0;

    return self;

}


-(NSInteger)checkForPoints:(NSMutableArray *)selectedDice{

    if(selectedDice.count == 6){

    for (NSArray *combination in self.winningCombination6.allKeys){

    if ([combination isEqual:selectedDice]) {

        return [self.winningCombination6[combination] integerValue];

       }

    }
}
    }else {
        for (<#initialization#>; <#condition#>; <#increment#>) {
            <#statements#>
        }

    }



    return 0;

}




@end

