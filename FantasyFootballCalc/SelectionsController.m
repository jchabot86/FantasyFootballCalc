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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    selections = [database performQuery:@"select key, count(key) from team where key != 0 group by key order by key desc"];
    [database closeConnection];
    
    [self.tableView reloadData];
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
    
    // Configure the cell...
    NSString *selectionKey = [[[selections objectAtIndex: indexPath.row] objectAtIndex:0] stringValue];
    NSString *numPlayers = [[[selections objectAtIndex: indexPath.row] objectAtIndex:1] stringValue];

    cell.IDLabel.text = selectionKey;
    cell.TitleLabel.text = [NSString stringWithFormat:@"%@%@",@"Selection ",selectionKey];
    NSLog(@"%@", numPlayers);
    NSLog(@"%@", selectionKey);
    cell.NumPlayersLabel.text = [NSString stringWithFormat:@"%@%@", numPlayers, @" Players"];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"ShowDetails"]){
        SelectionDetailController *selDetailController = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        NSString *selectionKey = [[[selections objectAtIndex: myIndexPath.row] objectAtIndex:0] stringValue];
        selDetailController.SelectionID = selectionKey;
        selDetailController.SelectionTitle = [NSString stringWithFormat:@"%@%@",@"Selection ",selectionKey];
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
