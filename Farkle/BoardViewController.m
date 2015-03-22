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
@property NSMutableArray *selectedDieArray;

@end

@implementation BoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.selectedDieArray = [[NSMutableArray alloc]init];
    self.DieLabels = [NSMutableArray new];
    for (DieLabel *die in self.dice) {
        die.delegate = self;
        die.isTapped = NO;
        [self.DieLabels addObject:die];
    }
    NSArray *ary1 = @[@1,@1,@5,@5,@2];
    NSArray *ary2 = @[@5,@5,@5];
    
//    NSCountedSet *set1 =[[NSCountedSet alloc]initWithArray:ary1];
//    NSCountedSet *set2 =[[NSCountedSet alloc]initWithArray:ary2];
//    NSSet *set1 =[[NSSet alloc]initWithArray:ary1];
//    NSSet *set2 =[[NSSet alloc]initWithArray:ary2];
//    NSLog(@"%@",[set2 isSubsetOfSet:set1]?@"YES":@"NO");
    
     self.combinations = [[Combinations alloc]init];
 // NSInteger score = [self.combinations checkForPoints:@[@5]];
}


-(BOOL)checkLabelTapped:(UIGestureRecognizer *)tapGesture
{
    NSInteger tempScore = 0;
    DieLabel *label = (DieLabel *)tapGesture.view;
    label.isTapped = !label.isTapped;
    
    if (label.isTapped) {
        [self.selectedDieArray addObject:label];
       NSArray *someArray = [self getDieNumberFromDieLabel:self.selectedDieArray];

      tempScore = tempScore + [self.combinations checkForPoints:someArray];

        self.currentTempScoreLabel.text = [NSString stringWithFormat:@"%i", tempScore];

        [self.DieLabels removeObject:label];
        label.backgroundColor = [UIColor blueColor];
        NSLog(@"%@",label.text);
    } else {
        [self.DieLabels addObject:label];
        label.backgroundColor = [UIColor redColor];
        tempScore = tempScore + [self.combinations checkForPoints:self.DieLabels];

    }

    return label.isTapped;
}



- (IBAction)onRollButtonPressed:(UIButton *)sender {
    for (DieLabel *die in self.DieLabels) {
        
        if (!die.isTapped) {
            [die roll];
            die.text = [NSString stringWithFormat:@"%i",die.randomLabelNumber];
            NSLog(@"%@",die.text);
        }
        
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
