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
    
    for (DieLabel *die in self.labelCollection) {
        die.delegate = self;
    }
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)checkLabelTapped:(DieLabel *)label
{
    label.isTapped = !label.isTapped;
}


- (IBAction)onRollButtonPressed:(UIButton *)sender {
    for (DieLabel *die in self.labelCollection) {
        
        if (!die.checkLabelTapped) {
            [die roll];
            die.text = [NSString stringWithFormat:@"%i",die.randomLabelNumber];
            NSLog(@"%@",die.text);
        }
        
    }
   

}



@end
