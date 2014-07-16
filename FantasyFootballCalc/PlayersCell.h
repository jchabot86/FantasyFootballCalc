//
//  PlayersCell.h
//  FantasyFootballCalc
//
//  Created by Jon on 7/4/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayersCell : UITableViewCell

@property (strong, nonatomic) NSString *pid;
@property (strong, nonatomic) IBOutlet UILabel *PlayerLabel;
@property (strong, nonatomic) IBOutlet UILabel *TeamLabel;
@property (strong, nonatomic) IBOutlet UILabel *PosLabel;
@property (strong, nonatomic) IBOutlet UIButton *AddToTeamButton;
@property (strong, nonatomic) IBOutlet UIButton *ScratchFromTeamButton;
@property (strong, nonatomic) IBOutlet UILabel *stat1;
@property (strong, nonatomic) IBOutlet UILabel *stat2;
@property (strong, nonatomic) IBOutlet UILabel *stat3;
@property (strong, nonatomic) IBOutlet UILabel *stat1Label;
@property (strong, nonatomic) IBOutlet UILabel *stat2Label;
@property (strong, nonatomic) IBOutlet UILabel *stat3Label;
@property (strong, nonatomic) IBOutlet UILabel *projPts;
@property (strong, nonatomic) IBOutlet UILabel *byeLabel;
@end
