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
    
    [self generateCombinations];
    
    self.points = 0;

    return self;

}


-(void)generateCombinations
{
    NSDictionary *comb1 = @{@1:@100, @5:@50};
    NSDictionary *comb3 = @{@[@1,@1,@1]:@1000,
                            @[@2,@2,@2]:@200,
                            @[@3,@3,@3]:@300,
                            @[@4,@4,@4]:@400,
                            @[@5,@5,@5]:@500,
                            @[@6,@6,@6]:@600};
    
    NSMutableDictionary *comb6 = [NSMutableDictionary new];
    [comb6 setObject:@2000 forKey:@[@1,@1,@1,@1,@1,@1]];
    [comb6 setObject:@1200 forKey:@[@6,@6,@6,@6,@6,@6]];
    [comb6 setObject:@1000 forKey:@[@2,@2,@2,@2,@2,@2]];
    [comb6 setObject:@1000 forKey:@[@3,@3,@3,@3,@3,@3]];
    [comb6 setObject:@1000 forKey:@[@4,@4,@4,@4,@4,@4]];
    [comb6 setObject:@1000 forKey:@[@5,@5,@5,@5,@5,@5]];
    [comb6 setObject:@1000 forKey:@[@1,@2,@3,@4,@5,@6]];
    
    
    for (int i = 1; i < 7; i++) {
        for (int j = i+1; j < 7; j++) {
            for (int k = j+1; k < 7; k++) {
                [comb6 setObject:@1000 forKey:@[@(i),@(i),@(j),@(j),@(k),@(k)]];
            }
        }
    }
    self.winningCombination1 = comb1;
    self.winningCombination3 = comb3;
    self.winningCombination6 = comb6;
}

-(NSInteger)checkForPoints:(NSArray *)selectedDice
{

    NSInteger score = 0;

    NSMutableArray *tempSelectedDiceArray =  selectedDice.mutableCopy;

    if(tempSelectedDiceArray.count == 6){

        for (NSArray *combination in self.winningCombination6){

            if ([combination isEqual:selectedDice]) {

                score = [self.winningCombination6[combination] integerValue];

                return score;

            }

        }

    }
    
    for (NSArray *combination in self.winningCombination3){
//        int count = 0;
//        NSMutableArray *tempArray = [[NSMutableArray alloc] init];

//        for (NSNumber *someNumber in combination){
//            if ([tempSelectedDiceArray containsObject:someNumber]){
//                count++;
//                [tempArray addObject:someNumber];
//
//            } else {
//                NSLog(@"please select another combination");
//
//                break;
//
//            }
//
//
//        }
        if ([[NSCountedSet setWithArray:combination] isSubsetOfSet:[NSCountedSet setWithArray:tempSelectedDiceArray]]) {
//            count = 3;
//        }

//        if (count == 3) {
            for (int i = 0; i<combination.count; i++){
                [tempSelectedDiceArray removeObjectAtIndex:[tempSelectedDiceArray indexOfObject:combination[i]]];

            }
            score += [self.winningCombination3[combination] integerValue];
//            count = 0;
        }


    }

//        while (tempSelectedDiceArray.count > 0) {
//            NSNumber *aNumber = tempSelectedDiceArray[0];
//            if ([self.winningCombination1.allKeys containsObject:aNumber]) {
//                    [tempSelectedDiceArray removeObjectAtIndex:0]; //has to use removeObjectAtIndex to prevent removing all occurences of one nsnumber at once
//                    score += [self.winningCombination1[aNumber] integerValue];
//            } else {
//                NSLog(@"please select other combinations");
//                break;
//            }
//        }
    
    if (tempSelectedDiceArray.count != 0) {
        BOOL hasInvalidNumber = NO;
        NSCountedSet *setForSelectedDice = [NSCountedSet setWithArray:tempSelectedDiceArray];
        for (NSNumber *aNumber in setForSelectedDice) {
            NSInteger scoreForNumber = [setForSelectedDice countForObject:aNumber] * [self.winningCombination1[aNumber] integerValue];
            if (scoreForNumber == 0) {
                hasInvalidNumber = YES;
            } else {
                score += scoreForNumber;
            }
        }
        if (hasInvalidNumber) {
            if (score > 0) {
                score = -1; //need to re-select;
            } else {
                score = 0; //Farkle
            }
        }
    }

return score;

}





@end

