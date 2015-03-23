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
@property (weak, nonatomic) IBOutlet UILabel *userScore;

@property (weak, nonatomic) IBOutlet UIView *rollView;
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (strong, nonatomic) IBOutletCollection(DieLabel) NSArray *dice;
@property (weak, nonatomic) IBOutlet UILabel *currentTempScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreForPlayer;
@property (weak, nonatomic) IBOutlet UILabel *currentPlayerName;
@property (weak, nonatomic) IBOutlet UILabel *roundLabel;

@property NSMutableArray *players;
@property NSInteger indexOfCurrentPlayer;

@property NSMutableArray *DieLabels;
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
    self.DieLabels = [NSMutableArray new];
    self.dieLabelPositionsInRollView = [NSMutableArray new];
    self.dieLabelPositionsInScoreView = [NSMutableArray new];
    for (DieLabel *die in self.dice) {
        die.delegate = self;
        die.isTapped = NO;
        [self.DieLabels addObject:die];
        [self.dieLabelPositionsInRollView addObject:[NSValue valueWithCGPoint:die.frame.origin]];
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
    self.roundLabel.text = @"0";
    
    
    self.maxNumberOfRolls = 10;
    self.maxNumberOfTurns = 10;
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
        for (DieLabel *die in self.DieLabels) {
            
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
        [self.DieLabels removeObject:label];
        [self moveDieLabel:label toView:self.scoreView
                      atPosition:[self.dieLabelPositionsInScoreView[self.indexOfDieLabelInScoreView] CGPointValue]];
        self.indexOfDieLabelInScoreView += 1;
    } else {
        [self.selectedDieLabels removeObject:label];
        [self.DieLabels addObject:label];
        [self moveDieLabel:label toView:self.rollView
                      atPosition:[self.dieLabelPositionsInRollView[indexOfDieLabelInRollView] CGPointValue]];
        self.indexOfDieLabelInScoreView -= 1;
    }
    
    NSArray *selectedDieNumbers = [self getDieNumberFromDieLabel:self.selectedDieLabels];
    self.scoreForSelectedDice = [self.combinations checkForPoints:selectedDieNumbers];
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
    for (DieLabel *die in self.selectedDieLabels) {
        die.userInteractionEnabled = NO;
    }
    [self.selectedDieLabels removeAllObjects];

    for (DieLabel *die in self.DieLabels) {
     
        [die roll];
        die.text = [NSString stringWithFormat:@"%i",die.randomLabelNumber];
        NSLog(@"%@",die.text);
    }
    
    self.numberOfRolls += 1;
    self.roundLabel.text = [NSString stringWithFormat:@"%li",(long)self.numberOfRolls];
    
    NSArray *availableDieNumbers = [self getDieNumberFromDieLabel:self.DieLabels];
    if ([self.combinations checkForPoints:availableDieNumbers] == 0 ) {
//        [self updatePlayerStates];
        [self issueWarnings:@"Farkle!"];
        NSLog(@"Farkle!");
    }
    
   if (self.numberOfRolls == self.maxNumberOfRolls - 1 ) {
//        [self updatePlayerStates];
       [self issueWarnings:@"No more rolls!"];
        NSLog(@"No more rolls!Change player!");
    }
}

-(void)issueWarnings:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self updatePlayerStates];
}





-(void)updatePlayerStates
{
        Player *currentPlayer = self.players[self.indexOfCurrentPlayer];
        currentPlayer.playerScore += self.scoreForCurrentTurn;
        self.numberOfTurns[self.indexOfCurrentPlayer] = @([self.numberOfTurns[self.indexOfCurrentPlayer] integerValue] + 1);
        self.indexOfCurrentPlayer = (self.indexOfCurrentPlayer + 1) % self.players.count;
        self.currentPlayerName.text = [self.players[self.indexOfCurrentPlayer] playerName];
        self.currentTempScoreLabel.text =  @"0";
        self.totalScoreForPlayer.text = [NSString stringWithFormat:@"%li", (long)([self.players[self.indexOfCurrentPlayer] playerScore])];
        self.numberOfRolls = 0;
        self.roundLabel.text = [NSString stringWithFormat:@"%li",(long)self.numberOfRolls];
        [self returnDiceToDefaultPositions];
    
    for (DieLabel *dieLabel in self.dice) {
        dieLabel.userInteractionEnabled = YES;
    }
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
}


-(NSArray *)getDieNumberFromDieLabel:(NSArray *)selectedLabels{

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];

    for (DieLabel *eachLabel in selectedLabels){
        [self.dieLabelPositionsInRollView addObject:[NSValue valueWithCGPoint:eachLabel.frame.origin]];

        [tempArray addObject:@([eachLabel.text intValue])];
    }

    return tempArray;
}


@end
