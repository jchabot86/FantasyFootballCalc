//
//  SelectionsCell.h
//  FantasyFootballCalc
//
//  Created by Jon on 6/22/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *TitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *NumPlayersLabel;
@property (strong, nonatomic) IBOutlet UILabel *TotalPtsLabel;

@property (strong, nonatomic) IBOutlet UIButton *RemoveButton;

@end
