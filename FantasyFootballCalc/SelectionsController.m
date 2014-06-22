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

@interface SelectionsController ()

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
    _SelectionID = @[@"1",@"2",];
    _SelectionTitle = @[@"Selction 1", @"Selection 2",];
    _NumPlayers = @[@"2", @"7",];
    
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
    return _SelectionID.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionsCell" forIndexPath:indexPath];
    
    // Configure the cell...
    int row = [indexPath row];
    
    cell.IDLabel.text = _SelectionID[row];
    cell.TitleLabel.text = _SelectionTitle[row];
    cell.NumPlayersLabel.text = [NSString stringWithFormat:@"%@%@", _NumPlayers[row], @" Players"];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"ShowDetails"]){
        SelectionDetailController *selDetailController = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        int row = [myIndexPath row];
        selDetailController.SelectionID = _SelectionID[row];
        selDetailController.SelectionTitle = _SelectionTitle[row];
        
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
