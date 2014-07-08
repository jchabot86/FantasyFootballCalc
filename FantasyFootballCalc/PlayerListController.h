//
//  PlayerListController.h
//  FantasyFootballCalc
//
//  Created by Jon on 7/7/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerListController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *PID;
@property (nonatomic, strong) NSArray *Player;
@property (nonatomic, strong) NSArray *Team;
@property (nonatomic, strong) NSArray *Pos;

@property (nonatomic, strong) NSArray *players;
@property (nonatomic, strong) NSMutableData *data;

@property (nonatomic, strong) NSMutableArray *selectedIndexes;
@property (strong, nonatomic) IBOutlet UIButton *calculateButton;

@end