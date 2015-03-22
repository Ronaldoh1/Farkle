//
//  ViewController.m
//  Farkle
//
//  Created by Ronald Hernandez on 3/19/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "BoardViewController.h"
#import "DieLabel.h"
#import "Combinations.h"

@interface BoardViewController () <DieLabelDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userScore;

@property (strong, nonatomic) IBOutletCollection(DieLabel) NSArray *dice;
@property NSMutableArray *DieLabels;
@property NSMutableArray *combinationsArray;
@property (weak, nonatomic) IBOutlet UILabel *currentTempScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreForPlayer;
@property (weak, nonatomic) IBOutlet UILabel *currentPlayerName;
@property Combinations *combinations;
@property NSMutableArray *selectedDieLabels;
@property NSInteger scoreForSelectedDice;
@property NSInteger scoreBeforeCurrentRoll;
@property NSInteger scoreForCurrentTurn;

@end

@implementation BoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.selectedDieLabels = [[NSMutableArray alloc]init];
    self.DieLabels = [NSMutableArray new];
    for (DieLabel *die in self.dice) {
        die.delegate = self;
        die.isTapped = NO;
        [self.DieLabels addObject:die];
    }
    
     self.combinations = [[Combinations alloc]init];
    
    self.scoreForSelectedDice = 0;
    self.scoreBeforeCurrentRoll = 0;
    self.scoreForCurrentTurn = 0;
}


-(BOOL)checkLabelTapped:(UIGestureRecognizer *)tapGesture
{
   // NSInteger tempScore = 0;
    DieLabel *label = (DieLabel *)tapGesture.view;
    label.isTapped = !label.isTapped;
    

    if (label.isTapped) {
        [self.selectedDieLabels addObject:label];
        [self.DieLabels removeObject:label];
        label.backgroundColor = [UIColor blueColor];
//        NSLog(@"%@",label.text);
    } else {
        [self.selectedDieLabels removeObject:label];
        [self.DieLabels addObject:label];
        label.backgroundColor = [UIColor redColor];
    }
    NSArray *selectedDieNumbers = [self getDieNumberFromDieLabel:self.selectedDieLabels];
    self.scoreForSelectedDice = [self.combinations checkForPoints:selectedDieNumbers];
    self.scoreForCurrentTurn = self.scoreBeforeCurrentRoll + self.scoreForSelectedDice;
    self.currentTempScoreLabel.text = [NSString stringWithFormat:@"%li", (long)self.scoreForCurrentTurn];

    return label.isTapped;
}



- (IBAction)onRollButtonPressed:(UIButton *)sender
{
    self.scoreBeforeCurrentRoll = self.scoreForCurrentTurn;
    for (DieLabel *die in self.selectedDieLabels) {
        die.userInteractionEnabled = NO;
    }
    [self.selectedDieLabels removeAllObjects];
    for (DieLabel *die in self.DieLabels) {
//        if (!die.isTapped) {
            [die roll];
            die.text = [NSString stringWithFormat:@"%i",die.randomLabelNumber];
            NSLog(@"%@",die.text);
//        }
        
    }
   

}
-(NSArray *)getDieNumberFromDieLabel:(NSArray *)selectedLabels{

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];

    for (DieLabel *eachLabel in selectedLabels){

        [tempArray addObject:@([eachLabel.text intValue])];
    }

    return tempArray;


}



@end
