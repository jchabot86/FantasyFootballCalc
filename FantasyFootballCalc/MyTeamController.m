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
    // Do any additional setup after loading the view.
   
}

-(void)viewWillAppear:(BOOL)animated
{
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    NSString *myTeamQuery = [NSString stringWithFormat:@"select p.*, tid from team t join player p on t.pid =p.pid where key = 0"];
    myTeamPlayers = [database performQuery: myTeamQuery];
    [database closeConnection];
    [self.tableView reloadData];
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
                    if([pos caseInsensitiveCompare:@"Def"] == NSOrderedSame){
                        cell.stat1Label.text = @"Def TDs:";
                        cell.stat2Label.text = @"Def Sacks:";
                        cell.stat3Label.text = @"Def Int:";
                        cell.stat1.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:19]integerValue]];
                        cell.stat2.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:22] integerValue]];
                        cell.stat3.text = [NSString stringWithFormat:@"%d", [[[myTeamPlayers objectAtIndex: indexPath.row] objectAtIndex:21] integerValue]];
                    }
    
    cell.RemoveFromTeamBtn.accessibilityIdentifier = [[[myTeamPlayers objectAtIndex:indexPath.row] objectAtIndex:27] stringValue];
    return cell;
    
}

- (IBAction)removePlayerFromTeam:(id)sender {
    UIButton *button = (UIButton *) sender;
    NSString *tid = button.accessibilityIdentifier;
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    NSString *deleteSelectedPlayer = [NSString stringWithFormat:@"delete from team where tid = %@", tid];
    [database performQuery: deleteSelectedPlayer];
    NSString *selectionQuery = [NSString stringWithFormat:@"select p.*, tid from team t join player p on t.pid =p.pid where key = 0"];
    myTeamPlayers = [database performQuery: selectionQuery];
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
