//
//  MyTeamController.m
//  FantasyFootballCalc
//
//  Created by Jon on 7/7/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import "MyTeamController.h"
#import "MyTeamCell.h"
#import "Config.h"
#import "SQLite.h"

@interface MyTeamController ()
{
    NSArray *myTeamPlayers;
}
@end

@implementation MyTeamController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:52.0f/255.0f green:111.0f/255.0f blue:200.0f/255.0f alpha:255.0f/255.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    // Do any additional setup after loading the view.
   
}

-(void)viewWillAppear:(BOOL)animated
{
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    NSString *myTeamQuery = [NSString stringWithFormat:@"select p.*, tid from team t join player p on t.pid =p.pid where key = 0"];
    myTeamPlayers = [database performQuery: myTeamQuery];
    NSArray *totalScoreArray;
    if(myTeamPlayers.count > 0){
        totalScoreArray = [database performQuery: @"select sum(score) from team t join player p on t.pid = p.pid where key = 0"];
        
    }
    self.totalPtsLabel.text = [NSString stringWithFormat:@"Total Pts: %d", [[[totalScoreArray objectAtIndex:0] objectAtIndex:0] integerValue]];
    [database closeConnection];
    /*if (myTeamPlayers.count == 0){
        [_noPlayersText setHidden:NO];
    } else {
        [_noPlayersText setHidden:YES];
    }*/
    
    [self.tableView reloadData];
    for (NSInteger j = 0; j < [tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [tableView numberOfRowsInSection:j]; ++i)
        {
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            MyTeamCell *myTeamCell = (MyTeamCell *)cell;
            
            [myTeamCell.RemoveFromTeamBtn setHidden:YES];
        }
    }
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [myTeamPlayers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTeamCell" forIndexPath:indexPath];
    
    if(indexPath.row % 2 == 0){
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSString *pos = [[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:2];
    cell.PlayerLabel.text = [[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:1];
    cell.PosLabel.text = pos;
    cell.TeamLabel.text = [[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:3];
    cell.byeLabel.text = [NSString stringWithFormat:@"Bye: %d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:24] integerValue]];
    cell.projPts.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:27] integerValue]];
    //Based on position, display appropriate stats
    if([pos caseInsensitiveCompare:@"QB"] == NSOrderedSame){
        cell.stat1Label.text = @"Pass Yds:";
        cell.stat2Label.text = @"Pass TDs:";
        cell.stat3Label.text = @"Int:";
        cell.stat1.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:7] integerValue]];
        cell.stat2.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:8] integerValue]];
        cell.stat3.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:9] integerValue]];
    } else
        if([pos caseInsensitiveCompare:@"RB"] == NSOrderedSame){
            cell.stat1Label.text = @"Rush Att:";
            cell.stat2Label.text = @"Rush Yds:";
            cell.stat3Label.text = @"Rush TDs:";
            cell.stat1.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:10] integerValue]];
            cell.stat2.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:11] integerValue]];
            cell.stat3.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:12] integerValue]];
            
            
        } else
            if([pos caseInsensitiveCompare:@"WR"] == NSOrderedSame || [pos caseInsensitiveCompare:@"TE"] == NSOrderedSame){
                cell.stat1Label.text = @"Receptions:";
                cell.stat2Label.text = @"Rec Yds:";
                cell.stat3Label.text = @"Rec TDs:";
                cell.stat1.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:13] integerValue]];
                cell.stat2.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:14] integerValue]];
                cell.stat3.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:15] integerValue]];
            }
            else
                if([pos caseInsensitiveCompare:@"K"] == NSOrderedSame){
                    cell.stat1Label.text = @"Extra Pts:";
                    cell.stat2Label.text = @"FG < 50";
                    cell.stat3Label.text = @"FG > 50";
                    cell.stat1.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:16] integerValue]];
                    cell.stat2.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:17] integerValue]];
                    cell.stat3.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:18] integerValue]];
                }
                else
                    if([pos caseInsensitiveCompare:@"DST"] == NSOrderedSame){
                        cell.stat1Label.text = @"Def TDs:";
                        cell.stat2Label.text = @"Def Sacks:";
                        cell.stat3Label.text = @"Def Int:";
                        cell.stat1.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:19]integerValue]];
                        cell.stat2.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:22] integerValue]];
                        cell.stat3.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:21] integerValue]];
                    }
    
    cell.RemoveFromTeamBtn.accessibilityIdentifier = [[[myTeamPlayers objectAtIndex:indexPath.row] objectAtIndex:29] stringValue];
    return cell;
    
}

// MyTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTeamCell" forIndexPath:indexPath];

- (IBAction)editButtonClick:(id)sender {
    NSLog(@"editButtonClick");
    
    UIButton *button = (UIButton *) sender;
    if([button.currentTitle isEqualToString:@"Edit"]){
        
        for (NSInteger j = 0; j < [tableView numberOfSections]; ++j)
        {
            for (NSInteger i = 0; i < [tableView numberOfRowsInSection:j]; ++i)
            {
            
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                MyTeamCell *myTeamCell = (MyTeamCell *)cell;
    
                [myTeamCell.RemoveFromTeamBtn setHidden:NO];
            }
        }
    
        [button setTitle:@"Done" forState:UIControlStateNormal];
    } else if([button.currentTitle isEqualToString:@"Done"]){
        for (NSInteger j = 0; j < [tableView numberOfSections]; ++j)
        {
            for (NSInteger i = 0; i < [tableView numberOfRowsInSection:j]; ++i)
            {
                
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                MyTeamCell *myTeamCell = (MyTeamCell *)cell;
                
                [myTeamCell.RemoveFromTeamBtn setHidden:YES];
            }
        }
        [button setTitle:@"Edit" forState:UIControlStateNormal];
    }
}

- (IBAction)removePlayerFromTeam:(id)sender {
    UIButton *button = (UIButton *) sender;
    NSString *tid = button.accessibilityIdentifier;
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    NSString *deleteSelectedPlayer = [NSString stringWithFormat:@"delete from team where tid = %@", tid];
    [database performQuery: deleteSelectedPlayer];
    NSString *selectionQuery = [NSString stringWithFormat:@"select p.*, tid from team t join player p on t.pid =p.pid where key = 0"];
    myTeamPlayers = [database performQuery: selectionQuery];
    NSArray *totalScoreArray;
    if(myTeamPlayers.count > 0){
         totalScoreArray = [database performQuery: @"select sum(score) from team t join player p on t.pid = p.pid where key = 0"];
        
    }
    self.totalPtsLabel.text = [NSString stringWithFormat:@"Total Pts: %d", [[[totalScoreArray objectAtIndex:0] objectAtIndex:0] integerValue]];

    [database closeConnection];
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
