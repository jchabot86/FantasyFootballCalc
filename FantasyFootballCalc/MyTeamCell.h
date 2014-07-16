//
//  MyTeamCell.h
//  FantasyFootballCalc
//
//  Created by Jon on 7/7/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTeamCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *RemoveFromSelectionBtn;
@property (strong, nonatomic) NSString *pid;
@property (strong, nonatomic) IBOutlet UILabel *PlayerLabel;
@property (strong, nonatomic) IBOutlet UILabel *TeamLabel;
@property (strong, nonatomic) IBOutlet UILabel *PosLabel;
@property (strong, nonatomic) IBOutlet UILabel *stat1;
@property (strong, nonatomic) IBOutlet UILabel *stat2;
@property (strong, nonatomic) IBOutlet UILabel *stat3;
@property (strong, nonatomic) IBOutlet UILabel *stat1Label;
@property (strong, nonatomic) IBOutlet UILabel *stat2Label;
@property (strong, nonatomic) IBOutlet UILabel *stat3Label;
@property (strong, nonatomic) IBOutlet UILabel *projPts;
@property (strong, nonatomic) IBOutlet UILabel *byeLabel;
@property (strong, nonatomic) IBOutlet UIButton *RemoveFromTeamBtn;

@end
