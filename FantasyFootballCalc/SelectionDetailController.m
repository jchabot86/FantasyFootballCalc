//
//  SelectionDetailController.m
//  FantasyFootballCalc
//
//  Created by Jon on 6/22/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import "SelectionDetailController.h"
#import "SelectionDetailCell.h"
#import "Config.h"
#import "SQLite.h"

@interface SelectionDetailController ()
{
    NSArray *selectionPlayers;
}
@end

@implementation SelectionDetailController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    NSString *selectionQuery = [NSString stringWithFormat:@"select p.*, tid from team t join player p on t.pid =p.pid where key = \"%@\" order by pid desc",_SelectionID];
    selectionPlayers = [database performQuery: selectionQuery];
    [database closeConnection];
    self.navigationItem.title =  _SelectionTitle;
        [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        {
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            SelectionDetailCell *selCell = (SelectionDetailCell *)cell;
            
            [selCell.RemoveFromSelectionBtn setHidden:YES];
        }
    }
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [selectionPlayers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionDetailCell" forIndexPath:indexPath];
    
    if(indexPath.row % 2 == 0){
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSString *pos = [[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:2];
    cell.PlayerLabel.text = [[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:1];
    cell.PosLabel.text = pos;
    cell.TeamLabel.text = [[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:3];
    cell.byeLabel.text = [NSString stringWithFormat:@"Bye: %d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:24] integerValue]];
    cell.projPts.text = [NSString stringWithFormat:@"%d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:27] integerValue]];
    //Based on position, display appropriate stats
    if([pos caseInsensitiveCompare:@"QB"] == NSOrderedSame){
        cell.stat1Label.text = @"Pass Yds:";
        cell.stat2Label.text = @"Pass TDs:";
        cell.stat3Label.text = @"Int:";
        cell.stat1.text = [NSString stringWithFormat:@"%d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:7] integerValue]];
        cell.stat2.text = [NSString stringWithFormat:@"%d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:8] integerValue]];
        cell.stat3.text = [NSString stringWithFormat:@"%d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:9] integerValue]];
    } else
        if([pos caseInsensitiveCompare:@"RB"] == NSOrderedSame){
            cell.stat1Label.text = @"Rush Att:";
            cell.stat2Label.text = @"Rush Yds:";
            cell.stat3Label.text = @"Rush TDs:";
            cell.stat1.text = [NSString stringWithFormat:@"%d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:10] integerValue]];
            cell.stat2.text = [NSString stringWithFormat:@"%d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:11] integerValue]];
            cell.stat3.text = [NSString stringWithFormat:@"%d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:12] integerValue]];
            
            
        } else
            if([pos caseInsensitiveCompare:@"WR"] == NSOrderedSame || [pos caseInsensitiveCompare:@"TE"] == NSOrderedSame){
                cell.stat1Label.text = @"Receptions:";
                cell.stat2Label.text = @"Rec Yds:";
                cell.stat3Label.text = @"Rec TDs:";
                cell.stat1.text = [NSString stringWithFormat:@"%d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:13] integerValue]];
                cell.stat2.text = [NSString stringWithFormat:@"%d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:14] integerValue]];
                cell.stat3.text = [NSString stringWithFormat:@"%d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:15] integerValue]];
            }
            else
                if([pos caseInsensitiveCompare:@"K"] == NSOrderedSame){
                    cell.stat1Label.text = @"Extra Pts:";
                    cell.stat2Label.text = @"FG < 50";
                    cell.stat3Label.text = @"FG > 50";
                    cell.stat1.text = [NSString stringWithFormat:@"%d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:16] integerValue]];
                    cell.stat2.text = [NSString stringWithFormat:@"%d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:17] integerValue]];
                    cell.stat3.text = [NSString stringWithFormat:@"%d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:18] integerValue]];
                }
                else
                    if([pos caseInsensitiveCompare:@"DST"] == NSOrderedSame){
                        cell.stat1Label.text = @"Def TDs:";
                        cell.stat2Label.text = @"Def Sacks:";
                        cell.stat3Label.text = @"Def Int:";
                        cell.stat1.text = [NSString stringWithFormat:@"%d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:19]integerValue]];
                        cell.stat2.text = [NSString stringWithFormat:@"%d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:22] integerValue]];
                        cell.stat3.text = [NSString stringWithFormat:@"%d", [[[selectionPlayers objectAtIndex: indexPath.row] objectAtIndex:21] integerValue]];
                    }

    cell.RemoveFromSelectionBtn.accessibilityIdentifier = [[[selectionPlayers objectAtIndex:indexPath.row] objectAtIndex:29] stringValue];
    return cell;

}

- (IBAction)removePlayerFromSelection:(id)sender {
    UIButton *button = (UIButton *) sender;
    NSString *tid = button.accessibilityIdentifier;
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    NSString *deleteSelectedPlayer = [NSString stringWithFormat:@"delete from team where tid = %@", tid];
    [database performQuery: deleteSelectedPlayer];
    NSString *selectionQuery = [NSString stringWithFormat:@"select p.*, tid from team t join player p on t.pid =p.pid where key = \"%@\" order by score desc",_SelectionID];
    selectionPlayers = [database performQuery: selectionQuery];
    [database closeConnection];
    [self.tableView reloadData];
}

- (IBAction)editButtonClick:(id)sender {
    NSLog(@"editButtonClick");
    
    UIButton *button = (UIButton *) sender;
    if([button.currentTitle isEqualToString:@"Edit"]){
        
        for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
        {
            for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
            {
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                SelectionDetailCell *selCell = (SelectionDetailCell *)cell;
                
                [selCell.RemoveFromSelectionBtn setHidden:NO];
            }
        }
        
        [button setTitle:@"Done" forState:UIControlStateNormal];
    } else if([button.currentTitle isEqualToString:@"Done"]){
        for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
        {
            for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
            {
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                SelectionDetailCell *selCell = (SelectionDetailCell *)cell;
                
                [selCell.RemoveFromSelectionBtn setHidden:YES];
            }
        }
        [button setTitle:@"Edit" forState:UIControlStateNormal];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
