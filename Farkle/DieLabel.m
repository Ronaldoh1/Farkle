//
//  DieLabel.m
//  Farkle
//
//  Created by Ronald Hernandez on 3/19/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "DieLabel.h"

@implementation DieLabel



-(IBAction)onTapped:(UITapGestureRecognizer *)sender{

}
-(void)roll{

    self.randomLabelNumber = arc4random() % 6;

}

@end
