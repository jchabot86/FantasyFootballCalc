//
//  SelectionDetailController.h
//  FantasyFootballCalc
//
//  Created by Jon on 6/22/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionDetailController : UITableViewController

@property (nonatomic, strong) NSArray *Name;
@property (nonatomic, strong) NSArray *Team;
@property (nonatomic, strong) NSArray *Position;

@property (nonatomic, strong) NSString *SelectionID;
@property (nonatomic, strong) NSString *SelectionTitle;

@end
