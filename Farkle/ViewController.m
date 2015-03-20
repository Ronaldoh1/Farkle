//
//  ViewController.m
//  Farkle
//
//  Created by Ronald Hernandez on 3/19/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "ViewController.h"
#import "DieLabel.h"

@interface ViewController () <DieLabelDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutletCollection(DieLabel) NSArray *labelCollection;
@property NSMutableArray *dice;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dice = [NSMutableArray new];
    for (DieLabel *die in self.labelCollection) {
        die.delegate = self;
        die.isTapped = NO;
        [self.dice addObject:die];
    }
    // Do any additional setup after loading the view, typically from a nib.
}

-(BOOL)checkLabelTapped:(UIGestureRecognizer *)tapGesture
{
    
    DieLabel *label = (DieLabel *)tapGesture.view;
    label.isTapped = !label.isTapped;
    
    if (label.isTapped) {
        [self.dice removeObject:label];
    } else {
        [self.dice addObject:label];
    }
    return label.isTapped;
}


- (IBAction)onRollButtonPressed:(UIButton *)sender {
    for (DieLabel *die in self.dice) {
        
        if (!die.isTapped) {
            [die roll];
            die.text = [NSString stringWithFormat:@"%i",die.randomLabelNumber];
            NSLog(@"%@",die.text);
        }
        
    }
   

}



@end
