//
//  SelectionsController.h
//  FantasyFootballCalc
//
//  Created by Jon on 6/22/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionsController : UITableViewController

@property (nonatomic, strong) NSArray *SelectionID;
@property (nonatomic, strong) NSArray *SelectionTitle;
@property (nonatomic, strong) NSArray *NumPlayers;

@property (strong, nonatomic) IBOutlet UIButton *editButton;

@end
