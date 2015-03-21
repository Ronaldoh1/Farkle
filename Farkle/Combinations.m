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
    self.winningCombination3 = [[NSDictionary alloc] init];
    self.winningCombination1 = [[NSDictionary alloc] init];
    self.points = 0;

    return self;

}


-(NSInteger)checkForPoints:(NSMutableArray *)selectedDice{

    NSInteger tempScore = 0;

    NSMutableArray *tempSelectedDiceArray =  selectedDice.copy;

    if(tempSelectedDiceArray.count == 6){

        for (NSArray *combination in self.winningCombination6){

            if ([combination isEqual:selectedDice]) {

                tempScore = [self.winningCombination6[combination] integerValue];

                return tempScore;


            }

        }

    }else {



        for (NSArray *combination in self.winningCombination3){

            int count = 0;
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];

            for (NSNumber *someNumber in combination){
                if ([tempSelectedDiceArray containsObject:someNumber]){
                    count++;
                    [tempArray addObject:someNumber];

                } else {
                    NSLog(@"please select another combination");

                    break;

                }


            }

            if (count == 3) {
                for (int i = 0; i<tempArray.count; i++){
                    [tempSelectedDiceArray removeObject:tempArray[i]];

                }
                tempScore = [self.winningCombination3[combination] integerValue];
                count = 0;
            }


        }
        if (tempSelectedDiceArray.count != 0) {
            for (NSArray *combination in self.winningCombination1) {
                if ([tempSelectedDiceArray containsObject:combination[0]]){
                    [tempSelectedDiceArray removeObject:combination[0]];
                    tempScore += [self.winningCombination1[combination] integerValue];

                }else{
                    NSLog(@"please select other combinations");
                    break;
                }

            }

        }

    }



    return tempScore;

}




@end

