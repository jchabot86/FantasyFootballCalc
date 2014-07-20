//
//  MyTeamController.h
//  FantasyFootballCalc
//
//  Created by Jon on 7/7/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTeamController : UIViewController
@property IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *noPlayersText;
@property (strong, nonatomic) IBOutlet UILabel *totalPtsLabel;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@end
