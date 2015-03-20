//
//  ViewController.m
//  Farkle
//
//  Created by Ronald Hernandez on 3/19/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "BoardViewController.h"
#import "DieLabel.h"

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
    // Do any additional setup after loading the view, typically from a nib.
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
