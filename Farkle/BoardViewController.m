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

@end

@implementation BoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
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
    
    Combinations *combinations = [[Combinations alloc]init];
//    NSInteger score = [combinations checkForPoints:@[@1,@1,@2,@3,@1,@1]];
}


-(BOOL)checkLabelTapped:(UIGestureRecognizer *)tapGesture
{
    
    DieLabel *label = (DieLabel *)tapGesture.view;
    label.isTapped = !label.isTapped;
    
    if (label.isTapped) {
        [self.DieLabels removeObject:label];
        label.backgroundColor = [UIColor blueColor];
        NSLog(@"%@",label.text);
    } else {
        [self.DieLabels addObject:label];
        label.backgroundColor = [UIColor redColor];
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



@end
