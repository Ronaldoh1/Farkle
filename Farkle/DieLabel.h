//
//  DieLabel.h
//  Farkle
//
//  Created by Ronald Hernandez on 3/19/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DieLabel;

@protocol DieLabelDelegate <NSObject>

-(BOOL)checkLabelTapped:(DieLabel *)label;


@end

@interface DieLabel : UILabel

@property int randomLabelNumber;
@property id<DieLabelDelegate> delegate;


-(void)roll;
@end
