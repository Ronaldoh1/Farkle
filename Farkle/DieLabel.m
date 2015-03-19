//
//  DieLabel.m
//  Farkle
//
//  Created by Ronald Hernandez on 3/19/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "DieLabel.h"

@implementation DieLabel



-(IBAction)onTapped:(UITapGestureRecognizer *)sender
{
    [self.delegate checkLabelTapped];
}


-(void)roll{

    self.randomLabelNumber = arc4random() % 6 + 1;

}


-(BOOL)checkLabelTapped:(DieLabel *)label;


@end
