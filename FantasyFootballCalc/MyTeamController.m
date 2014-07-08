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
    NSString *myTeamQuery = [NSString stringWithFormat:@"select tid, p.* from team t join player p on t.pid =p.pid where key = 0"];
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
    
    cell.NameLabel.text = [[myTeamPlayers objectAtIndex:indexPath.row] objectAtIndex:2];
    cell.PositionLabel.text = [[myTeamPlayers objectAtIndex:indexPath.row] objectAtIndex:3];
    cell.TeamLabel.text = [[myTeamPlayers objectAtIndex:indexPath.row] objectAtIndex:4];
    cell.RemoveFromTeamBtn.accessibilityIdentifier = [[[myTeamPlayers objectAtIndex:indexPath.row] objectAtIndex:0] stringValue];
    return cell;
    
}

- (IBAction)removePlayerFromTeam:(id)sender {
    UIButton *button = (UIButton *) sender;
    NSString *tid = button.accessibilityIdentifier;
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    NSString *deleteSelectedPlayer = [NSString stringWithFormat:@"delete from team where tid = %@", tid];
    [database performQuery: deleteSelectedPlayer];
    NSString *selectionQuery = [NSString stringWithFormat:@"select tid, p.* from team t join player p on t.pid =p.pid where key = 0"];
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
