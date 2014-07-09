//
//  MyTeamCell.h
//  FantasyFootballCalc
//
//  Created by Jon on 7/7/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTeamCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *NameLabel;
@property (strong, nonatomic) IBOutlet UILabel *TeamLabel;
@property (strong, nonatomic) IBOutlet UILabel *PositionLabel;
@property (strong, nonatomic) IBOutlet UIButton *RemoveFromTeamBtn;

@end
