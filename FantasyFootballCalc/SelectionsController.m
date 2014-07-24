//
//  SelectionsController.m
//  FantasyFootballCalc
//
//  Created by Jon on 6/22/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import "SelectionsController.h"
#import "SelectionsCell.h"
#import "SelectionDetailController.h"
#import "SQLite.h"
#import "Config.h"

@interface SelectionsController ()
{
    NSArray *selections;
}
@end

@implementation SelectionsController

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
    
}
-(void)viewWillAppear:(BOOL)animated
{
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    selections = [database performQuery:@"select key, count(key), sum(score) from team t join player p on t.pid = p.pid where key != 0 group by key order by key desc"];
    [database closeConnection];
    [self.tableView reloadData];
    
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        {
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            SelectionsCell *selCell = (SelectionsCell *)cell;
            
            [selCell.RemoveButton setHidden:YES];
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
    return [selections count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionsCell" forIndexPath:indexPath];
    
    if(indexPath.row % 2 == 0){
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    // Configure the cell...
    NSString *selectionKey = [[[selections objectAtIndex: indexPath.row] objectAtIndex:0] stringValue];
    NSString *numPlayers = [[[selections objectAtIndex: indexPath.row] objectAtIndex:1] stringValue];
    NSInteger *totalPts = [[[selections objectAtIndex: indexPath.row] objectAtIndex:2] integerValue];
    

    cell.TitleLabel.text = [NSString stringWithFormat:@"%@%@",@"Scenario ",selectionKey];
    cell.TotalPtsLabel.text = [NSString stringWithFormat:@"%d%@", totalPts, @" Pts"];
    //NSLog(@"%@", numPlayers);
    //NSLog(@"%@", selectionKey);
    cell.NumPlayersLabel.text = [NSString stringWithFormat:@"%@%@", numPlayers, @" Players"];
    cell.RemoveButton.accessibilityIdentifier = selectionKey;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"ShowDetails"]){
        SelectionDetailController *selDetailController = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        NSString *selectionKey = [[[selections objectAtIndex: myIndexPath.row] objectAtIndex:0] stringValue];
        selDetailController.SelectionID = selectionKey;
        selDetailController.SelectionTitle = [NSString stringWithFormat:@"%@%@",@"Scenario  ",selectionKey];
    }
}
- (IBAction)removeSelection:(id)sender {
    UIButton *button = (UIButton *) sender;
    NSString *key = button.accessibilityIdentifier;
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    NSString *deleteSelection = [NSString stringWithFormat:@"delete from team where key = %@", key];
    [database performQuery: deleteSelection];
    selections = [database performQuery:@"select key, count(key), sum(score) from team t join player p on t.pid = p.pid where key != 0 group by key order by key desc"];
    [database closeConnection];
    [self.tableView reloadData];}

- (IBAction)editButtonClick:(id)sender {
    //NSLog(@"editButtonClick");
    
    UIButton *button = (UIButton *) sender;
    if([button.currentTitle isEqualToString:@"Edit"]){
        
        for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
        {
            for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
            {
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                SelectionsCell *selCell = (SelectionsCell *)cell;
                
                [selCell.RemoveButton setHidden:NO];
            }
        }
        
        [button setTitle:@"Done" forState:UIControlStateNormal];
    } else if([button.currentTitle isEqualToString:@"Done"]){
        for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
        {
            for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
            {
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                SelectionsCell *selCell = (SelectionsCell *)cell;
                
                [selCell.RemoveButton setHidden:YES];
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
