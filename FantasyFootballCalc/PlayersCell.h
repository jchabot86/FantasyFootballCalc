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

@property (strong, nonatomic) IBOutlet UIImageView *emptyCheckImage;

@property (strong, nonatomic) IBOutlet UIImageView *checkImage;
@end
