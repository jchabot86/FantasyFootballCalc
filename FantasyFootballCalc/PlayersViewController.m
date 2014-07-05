//
//  PlayersViewController.m
//  FantasyFootballCalc
//
//  Created by Jon on 7/3/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import "PlayersViewController.h"
#import "PlayersCell.h"
#import "SQLiteHelper.h"

@interface PlayersViewController ()

@end

@implementation PlayersViewController

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
    
    //this shows the user that something is being downloaded from network
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //build connection - will need to replace URL String
    //NSURL *url = [NSURL URLWithString:@"http://www.somethingrighthere.com/something.php"];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"KrunchProjections" withExtension:@"json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    
    
   // NSString *dataStr = @"Cuteness beyond belief!";
    
   /* UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Test"
                                                   message: dataStr
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"OK",nil];
    
    
    [alert show];*/
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    [_data appendData:theData];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    _players = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    [self.tableView reloadData];
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //TODO do something here
    NSLog(@"Failed!!!");
    //stop the networkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

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
    return [_players count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayersCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.PlayerLabel.text = [[_players objectAtIndex: indexPath.row] objectForKey:@"Player"];
    cell.PosLabel.text = [[_players objectAtIndex: indexPath.row] objectForKey:@"Pos"];
    cell.TeamLabel.text = [[_players objectAtIndex: indexPath.row] objectForKey:@"Team"];
    
    return cell;
}

- (IBAction)getPlayerList:(id)sender {
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
