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
#import "Player.h"

@interface BoardViewController () <DieLabelDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UICollisionBehaviorDelegate>

@property (weak, nonatomic) IBOutlet UIView *rollView;
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (strong, nonatomic) IBOutletCollection(DieLabel) NSArray *dice;
@property (weak, nonatomic) IBOutlet UILabel *currentTempScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreForPlayer;
@property (weak, nonatomic) IBOutlet UILabel *currentPlayerName;
@property (weak, nonatomic) IBOutlet UILabel *roundLabel;
@property (weak, nonatomic) IBOutlet UILabel *turnLabel;

@property NSMutableArray *players;
@property NSInteger indexOfCurrentPlayer;

@property NSMutableArray *dieLabels;
@property NSMutableArray *combinationsArray;

@property Combinations *combinations;
@property NSMutableArray *selectedDieLabels;
@property NSInteger scoreForSelectedDice;
@property NSInteger scoreBeforeCurrentRoll;
@property NSInteger scoreForCurrentTurn;
@property NSMutableArray *dieLabelPositionsInRollView;
@property NSMutableArray *dieLabelPositionsInScoreView;
@property NSArray *dieLabelDefaultPositionsInRollView;
@property NSInteger indexOfDieLabelInScoreView;
@property CGFloat dieLabelWidth;
@property CGFloat dieLabelHeight;

@property NSInteger maxNumberOfRolls;
@property NSInteger maxNumberOfTurns;
@property NSInteger numberOfRolls;
@property NSMutableArray *numberOfTurns;

@property NSArray *winners;

@property UICollisionBehavior *collisionBehavior;
@property UIDynamicAnimator *animator;


@end

@implementation BoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.selectedDieLabels = [[NSMutableArray alloc]init];
    self.dieLabels = [NSMutableArray new];
    self.dieLabelPositionsInRollView = [NSMutableArray new];
    self.dieLabelPositionsInScoreView = [NSMutableArray new];
    for (DieLabel *dieLabel in self.dice) {
        [dieLabel roll];
        dieLabel.text = [NSString stringWithFormat:@"%i",dieLabel.randomLabelNumber];
        dieLabel.delegate = self;
        dieLabel.userInteractionEnabled = NO;
        dieLabel.isTapped = NO;
        [self.dieLabels addObject:dieLabel];
        [self.dieLabelPositionsInRollView addObject:[NSValue valueWithCGPoint:dieLabel.frame.origin]];
    }
 
    self.dieLabelDefaultPositionsInRollView = self.dieLabelPositionsInRollView.copy;
    
    self.dieLabelWidth = [self.dice[0] frame].size.width;
    self.dieLabelHeight = [self.dice[0] frame].size.height;
    for (int i = 0; i < self.dice.count; i++) {
        CGPoint position = CGPointMake(20 + (self.dieLabelWidth + 5) * i , 50);
        [self.dieLabelPositionsInScoreView addObject:[NSValue valueWithCGPoint:position]];
    }
    
    self.combinations = [[Combinations alloc]init];
    
    self.scoreForSelectedDice = 0;
    self.scoreBeforeCurrentRoll = 0;
    self.scoreForCurrentTurn = 0;
    self.indexOfDieLabelInScoreView = 0;
    self.roundLabel.text = @"Round: 0";
    self.turnLabel.text = @"Turn: 1";
    
    
    self.maxNumberOfRolls = 5;
    self.maxNumberOfTurns = 2;
    self.players = [NSMutableArray new];
    
    [self.players addObject:[[Player alloc] initWithPlayerName:@"Ron"]];
    [self.players addObject:[[Player alloc] initWithPlayerName:@"Justin"]];
    [self.players addObject:[[Player alloc] initWithPlayerName:@"Mert"]];
    self.indexOfCurrentPlayer = 0;
    self.currentPlayerName.text = [self.players[self.indexOfCurrentPlayer] playerName];
    self.numberOfRolls = 0;
    
    self.numberOfTurns = @[@0,@0,@0].mutableCopy;
    self.winners  = [NSArray new];
    
    
}


//Set up the viewcontroller becomes first responder to the shakegesture
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

//the following method detects the UIEvent (UIEvent Motion Shakes)
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if(event.type == UIEventSubtypeMotionShake)
    {
        
        self.scoreBeforeCurrentRoll = self.scoreForCurrentTurn;
        
        for (DieLabel *die in self.selectedDieLabels) {
            die.userInteractionEnabled = NO;
        }
        
        [self.selectedDieLabels removeAllObjects];
        for (DieLabel *die in self.dieLabels) {
            
            [die roll];
            [self animateDice:self.dice];
            die.text = [NSString stringWithFormat:@"%i",die.randomLabelNumber];
            NSLog(@"%@",die.text);
            
            
        }
        
    }
}

//Method neeeded to recognize gesture.

- (BOOL)canBecomeFirstResponder
{
    return YES;
}


//Animate the Dice

-(void)animateDice:(NSArray *)Arraylabel{
    
    
    for (int i = 0; i<Arraylabel.count; i++) {
        
        UILabel *label = Arraylabel[i];
        
        [UIView animateWithDuration:(5) animations:^{
            //label.center = self.originalFutureCenter;
            label.transform= CGAffineTransformMakeRotation (3.14*2);
            //[self addPhysicsToLabels:label];
            [self addPhysicsToLabels:Arraylabel];
            // self.theFutureLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:4 animations:^{
                
                label.transform= CGAffineTransformMakeRotation (3.14*2);
                //[self addPhysicsToLabels:label];
            }];
        }];
    }
    
}

-(void)addPhysicsToLabels:(NSArray *)availableLabelsArray{
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    
    for (UILabel *label in availableLabelsArray){
        
        //Add Gravity to each label
        UIGravityBehavior* gravityBehavior =
        [[UIGravityBehavior alloc] initWithItems:@[label]];
        [self.animator addBehavior:gravityBehavior];
        
        //Add Collision to each label
        self.collisionBehavior =
        [[UICollisionBehavior alloc] initWithItems:@[label]];
        self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        [self.animator addBehavior:self.collisionBehavior];
        
        //Add ellasticity to each label to make it bounce,allow rotation, allow angular resistance.
        UIDynamicItemBehavior *propertyBehavior =
        [[UIDynamicItemBehavior alloc] initWithItems:@[label]];
        propertyBehavior.elasticity = 0.9f;
        propertyBehavior.allowsRotation = true;
        propertyBehavior.angularResistance = .5;
        [self.animator addBehavior:propertyBehavior];
        
        
        [propertyBehavior addAngularVelocity:10.0 forItem:label];
    }
    
    //Add bounce behaviour to all the labels
    
    UIDynamicBehavior *bounceBehavior = [[UIDynamicItemBehavior alloc]initWithItems:availableLabelsArray];
    [self.animator addBehavior:bounceBehavior];
    
    UIPushBehavior *instantPushBehavior = [[UIPushBehavior alloc] initWithItems:availableLabelsArray mode:UIPushBehaviorModeContinuous];
    instantPushBehavior.angle = 1.57;
    instantPushBehavior.magnitude = .90;
    
    [self.animator addBehavior:instantPushBehavior];
    
    
    
    
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier{
    //  [self animateDice:self.dice];
    
}


-(BOOL)checkLabelTapped:(UIGestureRecognizer *)tapGesture
{
   // NSInteger tempScore = 0;
    DieLabel *label = (DieLabel *)tapGesture.view;
    NSInteger indexOfDieLabelInRollView = [self.dice indexOfObjectIdenticalTo:label];
    label.isTapped = !label.isTapped;
    

    if (label.isTapped) {
        [self.selectedDieLabels addObject:label];
        [self.dieLabels removeObject:label];
        [self moveDieLabel:label toView:self.scoreView
                      atPosition:[self.dieLabelPositionsInScoreView[self.indexOfDieLabelInScoreView] CGPointValue]];
        self.indexOfDieLabelInScoreView += 1;
    } else {
        [self.selectedDieLabels removeObject:label];
        [self.dieLabels addObject:label];
        [self moveDieLabel:label toView:self.rollView
                      atPosition:[self.dieLabelPositionsInRollView[indexOfDieLabelInRollView] CGPointValue]];
        self.indexOfDieLabelInScoreView -= 1;
    }
    
    NSArray *selectedDieNumbers = [self getDieNumberFromDieLabel:self.selectedDieLabels];
    self.scoreForSelectedDice = [self.combinations checkForPoints:selectedDieNumbers];
    if (self.dieLabels.count == 0 && self.scoreForSelectedDice > 0) {
        [self issueAlertWithMessage:@"Switch player!" tagNumber:0];
    }
    self.scoreForSelectedDice = MAX(0,self.scoreForSelectedDice);
    self.scoreForCurrentTurn = self.scoreBeforeCurrentRoll + self.scoreForSelectedDice;

    self.currentTempScoreLabel.text = [NSString stringWithFormat:@"%li", (long)self.scoreForCurrentTurn];
    self.totalScoreForPlayer.text = [NSString stringWithFormat:@"%li", (long)(self.scoreForCurrentTurn + [self.players[self.indexOfCurrentPlayer] playerScore])];

    return label.isTapped;
}


-(void)moveDieLabel:(DieLabel *)dieLabel toView:(UIView *)view atPosition:(CGPoint)position
{
    CGFloat dieLabelWidth = dieLabel.frame.size.width;
    CGFloat dieLabelHeight = dieLabel.frame.size.height;
    [dieLabel removeFromSuperview];
    [view addSubview:dieLabel];
    [dieLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [dieLabel setFrame:CGRectMake(position.x, position.y, dieLabelWidth, dieLabelHeight)];
    
//    NSDictionary *metrics = @{@"dieLabelWidth": @(dieLabelWidth),
//                              @"dieLabelHeight": @(dieLabelHeight),
//                              @"topMargin": @30,
//                              @"leftMargin": @20,
//                              };
//    NSDictionary *dieLabelViewDic = @{@"dieLabel":dieLabel};
//
//
//    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[dieLabel]" options:0 metrics:metrics views:dieLabelViewDic]];
//    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[dieLabel]" options:0 metrics:metrics views:dieLabelViewDic]];
//    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dieLabel(dieLabelHeight)]" options:0 metrics:metrics views:dieLabelViewDic]];
//    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[dieLabel(dieLabelWidth)]" options:0 metrics:metrics views:@{@"dieLabel":dieLabel}]];

//    dieLabel.center = CGPointMake(-100,-100);
}



- (IBAction)onRollButtonPressed:(UIButton *)sender
{
    self.scoreBeforeCurrentRoll = self.scoreForCurrentTurn;
    for (DieLabel *dieLabel in self.selectedDieLabels) {
        dieLabel.userInteractionEnabled = NO;
    }
    [self.selectedDieLabels removeAllObjects];

    for (DieLabel *dieLabel in self.dieLabels) {
        [dieLabel roll];
        dieLabel.userInteractionEnabled = YES;
        dieLabel.text = [NSString stringWithFormat:@"%i",dieLabel.randomLabelNumber];
        NSLog(@"%@",dieLabel.text);
    }
    
    self.numberOfRolls += 1;
    self.roundLabel.text = [NSString stringWithFormat:@"Round: %li",(long)self.numberOfRolls];
    
    NSArray *availableDieNumbers = [self getDieNumberFromDieLabel:self.dieLabels];
    if ([self.combinations checkForPoints:availableDieNumbers] == 0 ) {
        [self issueAlertWithMessage:@"Farkle!" tagNumber:1];
        NSLog(@"Farkle!");
    }
    
   if (self.numberOfRolls > self.maxNumberOfRolls) {
       [self issueAlertWithMessage:@"No more rolls!" tagNumber:2];
        NSLog(@"No more rolls!Change player!");
    }
}







-(void)updatePlayerStates
{
    Player *currentPlayer = self.players[self.indexOfCurrentPlayer];
    currentPlayer.playerScore += self.scoreForCurrentTurn;
    self.numberOfTurns[self.indexOfCurrentPlayer] = @([self.numberOfTurns[self.indexOfCurrentPlayer] integerValue] + 1);
    if ([self.numberOfTurns isEqual:@[@(self.maxNumberOfTurns),@(self.maxNumberOfTurns),@(self.maxNumberOfTurns)]]) {
        [self checkWinners];
    }
    
    self.indexOfCurrentPlayer = (self.indexOfCurrentPlayer + 1) % self.players.count;
    self.turnLabel.text = [NSString stringWithFormat:@"Turn: %li",(long)[self.numberOfTurns[self.indexOfCurrentPlayer] integerValue] + 1];
    self.numberOfRolls = 0;
    self.roundLabel.text = [NSString stringWithFormat:@"Round: %li",(long)self.numberOfRolls];
    self.currentPlayerName.text = [self.players[self.indexOfCurrentPlayer] playerName];
    self.currentTempScoreLabel.text =  @"0";
    self.totalScoreForPlayer.text = [NSString stringWithFormat:@"%li", (long)([self.players[self.indexOfCurrentPlayer] playerScore])];


    [self returnDiceToDefaultPositions];
    self.indexOfDieLabelInScoreView = 0;

    for (DieLabel *dieLabel in self.dice) {
        [dieLabel roll];
        dieLabel.text = [NSString stringWithFormat:@"%i",dieLabel.randomLabelNumber];
        dieLabel.userInteractionEnabled = NO;
        dieLabel.isTapped = NO;
    }
    self.dieLabels = self.dice.mutableCopy;
    self.scoreBeforeCurrentRoll = 0;
    self.scoreForCurrentTurn = 0;
    [self.selectedDieLabels removeAllObjects];
    
 
}


-(void)returnDiceToDefaultPositions
{
    for (int i = 0;i < self.dice.count; i++) {
        [self moveDieLabel:self.dice[i] toView:self.rollView atPosition:[self.dieLabelDefaultPositionsInRollView[i] CGPointValue]];
    }
}

-(void)checkWinners
{
    NSInteger maxScore = 0;
    for (Player *player in self.players) {
        maxScore = MAX(maxScore, player.playerScore);
    }
    NSIndexSet *indexSetOfWinners = [self.players indexesOfObjectsPassingTest:^BOOL(Player *obj, NSUInteger idx, BOOL *stop) {
        return obj.playerScore == maxScore;
    }];
    self.winners = [self.players objectsAtIndexes:indexSetOfWinners];
    NSString *winnerMessage;
    if (self.winners.count == self.players.count) {
        winnerMessage = @"No winner!";
    } else {
        if (self.winners.count > 1) {
            winnerMessage = @"Winners are";
        } else {
            winnerMessage = @"Winner is";
        }
        for (Player *winner in self.winners) {
            winner.winnings += 1;
            winnerMessage = [NSString stringWithFormat:@"%@ %@",winnerMessage,winner.playerName];
        }
    }
    [self issueAlertWithMessage:winnerMessage tagNumber:3];

}


-(NSArray *)getDieNumberFromDieLabel:(NSArray *)selectedLabels{

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];

    for (DieLabel *eachLabel in selectedLabels){
        [self.dieLabelPositionsInRollView addObject:[NSValue valueWithCGPoint:eachLabel.frame.origin]];

        [tempArray addObject:@([eachLabel.text intValue])];
    }

    return tempArray;
}


-(void)issueAlertWithMessage:(NSString *)message tagNumber:(int)tagNumber
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alertView.tag = tagNumber;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 0:
        case 1:
        case 2:
            [self updatePlayerStates];
            break;
        case 3:
            [self resetStatesForNewGame];
            break;
        default:
            break;
    }

}

-(void)resetStatesForNewGame
{
    
    for (DieLabel *dieLabel in self.dice) {
        [dieLabel roll];
        dieLabel.text = [NSString stringWithFormat:@"%i",dieLabel.randomLabelNumber];
        dieLabel.userInteractionEnabled = NO;
        dieLabel.isTapped = NO;
    }
    self.dieLabels = self.dice.mutableCopy;
    self.scoreBeforeCurrentRoll = 0;
    self.scoreForCurrentTurn = 0;
    [self.selectedDieLabels removeAllObjects];
 
 
    self.scoreForSelectedDice = 0;
    self.scoreBeforeCurrentRoll = 0;
    self.scoreForCurrentTurn = 0;
    self.indexOfDieLabelInScoreView = 0;
    self.roundLabel.text = @"Round: 0";
    self.turnLabel.text = @"Turn: 1";
    self.currentTempScoreLabel.text =  @"0";
    self.totalScoreForPlayer.text = @"0";

    
    for (Player *player in self.players) {
        player.playerScore = 0;
    }
    self.indexOfCurrentPlayer = 0;
    self.currentPlayerName.text = [self.players[self.indexOfCurrentPlayer] playerName];
    self.numberOfRolls = 0;
    
    self.numberOfTurns = @[@0,@0,@0].mutableCopy;
    self.winners  = [NSArray new];
    
    [self returnDiceToDefaultPositions];
}


@end
