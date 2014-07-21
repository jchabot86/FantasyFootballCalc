//
//  PlayerListController.m
//  FantasyFootballCalc
//
//  Created by Jon on 7/7/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import "PlayerListController.h"
#import "PlayersCell.h"
#import "SQLite.h"
#import "Settings.h"
#import "Config.h"
#import "DataHelper.h"

@interface PlayerListController ()
{
    NSArray *playerResults;
    float PassingTdWeight;
    float PassingYardsWeight;
    float PassingCompletionWeight;
    float PassingAttemptsWeight;
    float PassingIntWeight;
    float RushingYardsWeight;
    float RushingTdWeight;
    float RushingAttemptsWeight;
    float ReceivingYardsWeight;
    float ReceivingReceptionsWeight;
    float ReceivingTdWeight;
    float KickingXpWeight;
    float KickingFgWeight;
    float KickingFg50Weight;
    float DefenseTdWeight;
    float DefenseInterceptionWeight;
    float DefenseSackWeight;
    float DefenseSafetyWeight;


}

@end

@implementation PlayerListController

@synthesize pickerData = _pickerData;
@synthesize filterPicker;

- (void) loadSettingsInMemory{
    Settings* properties = [Settings new];
    PassingTdWeight = [[properties getProperty:PASSING_TD] floatValue];
    PassingYardsWeight = [[properties getProperty:PASSING_YARDS] floatValue];
    PassingCompletionWeight = [[properties getProperty:PASSING_COMPLETION] floatValue];
    PassingAttemptsWeight = [[properties getProperty:PASSING_ATTEMPTS] floatValue];
    PassingIntWeight = [[properties getProperty:PASSING_INT] floatValue];
    RushingYardsWeight = [[properties getProperty:RUSHING_YARDS] floatValue];
    RushingTdWeight = [[properties getProperty:RUSHING_TD] floatValue];
    RushingAttemptsWeight = [[properties getProperty:RUSHING_ATTEMPS] floatValue];
    ReceivingYardsWeight = [[properties getProperty:RECEIVING_YARDS] floatValue];
    ReceivingReceptionsWeight = [[properties getProperty:RECEIVING_RECEPTIONS] floatValue];
    ReceivingTdWeight = [[properties getProperty:RECEIVING_TD] floatValue];
    KickingXpWeight = [[properties getProperty:KICKING_XP] floatValue];
    KickingFgWeight = [[properties getProperty:KICKING_FG] floatValue];
    KickingFg50Weight = [[properties getProperty:KICKING_FG50] floatValue];
    DefenseTdWeight = [[properties getProperty:DEFENSE_TD] floatValue];
    DefenseInterceptionWeight = [[properties getProperty:DEFENSE_INTERCEPTION] floatValue];
    DefenseSackWeight = [[properties getProperty:DEFENSE_SACK] floatValue];
    DefenseSafetyWeight = [[properties getProperty:DEFENSE_SAFETY] floatValue];
    
    
}

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
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:52.0f/255.0f green:111.0f/255.0f blue:200.0f/255.0f alpha:255.0f/255.0f]];

    //self.navigationController.navigationBar.opaque = YES;
    //self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:52.0f/255.0f green:111.0f/255.0f blue:200.0f/255.0f alpha:255.0f/255.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    _calculateButton.enabled = NO;
    _selectedIndexes = [[NSMutableArray alloc] init];
    _tableView.allowsMultipleSelection = YES;
    
    _pickerData = [[NSArray alloc] initWithObjects:@"Any", @"QB",@"WR",@"RB",@"TE",@"DST",@"K", nil];
    
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    NSArray *lastSyncDate = [database performQuery:@"select date from last_sync_date"];
    BOOL *syncLongTime = NO;
    if(lastSyncDate.count > 0) {
        NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [[lastSyncDate objectAtIndex:0] objectAtIndex:0];
        NSLog(dateString);
        NSDate *syncDate =[DateFormatter dateFromString:dateString];
        NSInteger *hoursSinceSync = [self daysBetweenDate:syncDate andDate:[NSDate date]];
        if(hoursSinceSync > 48){
            syncLongTime = YES;
        }
        
        NSLog([NSString stringWithFormat:@"Hours since last sync: %d",hoursSinceSync]);
        
        
    }
    if(lastSyncDate.count == 0 || syncLongTime){
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"Old Data!" message: @"Your stats data is out of date.  Would you like to sync?" delegate: self cancelButtonTitle: @"YES"  otherButtonTitles:@"NO",nil];
        
        [updateAlert show];
    }
    
    if(playerResults.count == 0){ // this is because the viewDidAppear method is also going to attempt to do this query.  But if the viewDidAppear executes before the json is pulled and inserted to database then this will load it.
        playerResults = [database performQuery: @"SELECT * FROM player where pid not in (select pid from team where key = 0) and pid not in (select pid from removed_players) order by score desc"];
        [_tableView reloadData];
    }
    [database closeConnection];
    [self loadSettingsInMemory];
    NSLog(@"Loaded class w floats.");
    
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSTimeInterval distanceBetweenDates = [toDateTime timeIntervalSinceDate:fromDateTime];
    double secondsInAnHour = 3600;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    return hoursBetweenDates;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        //build connection - will need to replace URL String
       /* NSURL *url = [NSURL URLWithString:@"http://www.profootballfocus.com/toolkit/export/RyanWetter/?password=sdhjgkd5j45jhdgfyh4fhdf5h"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];*/
        DataHelper *dataHelper = [DataHelper new];
        [dataHelper importPlayerData];
    }
}

/**
 so that the view is reloaded with latest list of players
 **/
-(void)viewDidAppear:(BOOL)animated
{
    //make sure it queries for the selected filter again
    NSInteger *selectedFilter;
    selectedFilter = [filterPicker selectedRowInComponent:0];
    [filterPicker selectRow:selectedFilter inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [playerResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayersCell" forIndexPath:indexPath];
    NSLog(@"The row: %d",indexPath.row);
    if(indexPath.row % 2 == 0){
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    NSString *pid = [[playerResults objectAtIndex: indexPath.row]objectAtIndex:0];
    NSLog(@"Player: %@", pid);
    [cell.AddToTeamButton setTitleColor:[UIColor greenColor] forState:(UIControlStateNormal)];
    [cell.ScratchFromTeamButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];

    // Configure the cell...
    NSString *pos = [[playerResults objectAtIndex: indexPath.row] objectAtIndex:2];
    cell.PlayerLabel.text = [[playerResults objectAtIndex: indexPath.row] objectAtIndex:1];
    cell.PosLabel.text = pos;
    cell.TeamLabel.text = [[playerResults objectAtIndex: indexPath.row] objectAtIndex:3];
    cell.byeLabel.text = [NSString stringWithFormat:@"Bye: %d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:24] integerValue]];
    cell.projPts.text = [NSString stringWithFormat:@"%d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:27] integerValue]];
    cell.pid = pid;
    //Based on position, display appropriate stats
    if([pos caseInsensitiveCompare:@"QB"] == NSOrderedSame){
        cell.stat1Label.text = @"Pass Yds:";
        cell.stat2Label.text = @"Pass TDs:";
        cell.stat3Label.text = @"Int:";
        cell.stat1.text = [NSString stringWithFormat:@"%d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:7] integerValue]];
        cell.stat2.text = [NSString stringWithFormat:@"%d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:8] integerValue]];
        cell.stat3.text = [NSString stringWithFormat:@"%d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:9] integerValue]];
    } else
        if([pos caseInsensitiveCompare:@"RB"] == NSOrderedSame){
            cell.stat1Label.text = @"Rush Att:";
            cell.stat2Label.text = @"Rush Yds:";
            cell.stat3Label.text = @"Rush TDs:";
            cell.stat1.text = [NSString stringWithFormat:@"%d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:10] integerValue]];
            cell.stat2.text = [NSString stringWithFormat:@"%d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:11] integerValue]];
            cell.stat3.text = [NSString stringWithFormat:@"%d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:12] integerValue]];


    } else
        if([pos caseInsensitiveCompare:@"WR"] == NSOrderedSame || [pos caseInsensitiveCompare:@"TE"] == NSOrderedSame){
            cell.stat1Label.text = @"Receptions:";
            cell.stat2Label.text = @"Rec Yds:";
            cell.stat3Label.text = @"Rec TDs:";
            cell.stat1.text = [NSString stringWithFormat:@"%d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:13] integerValue]];
            cell.stat2.text = [NSString stringWithFormat:@"%d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:14] integerValue]];
            cell.stat3.text = [NSString stringWithFormat:@"%d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:15] integerValue]];
    }
    else
        if([pos caseInsensitiveCompare:@"K"] == NSOrderedSame){
            cell.stat1Label.text = @"Extra Pts:";
            cell.stat2Label.text = @"FG < 50";
            cell.stat3Label.text = @"FG > 50";
            cell.stat1.text = [NSString stringWithFormat:@"%d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:16] integerValue]];
            cell.stat2.text = [NSString stringWithFormat:@"%d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:17] integerValue]];
            cell.stat3.text = [NSString stringWithFormat:@"%d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:18] integerValue]];
    }
    else
        if([pos caseInsensitiveCompare:@"DST"] == NSOrderedSame){
            cell.stat1Label.text = @"Def TDs:";
            cell.stat2Label.text = @"Def Sacks:";
            cell.stat3Label.text = @"Def Int:";
            cell.stat1.text = [NSString stringWithFormat:@"%d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:19]integerValue]];
            cell.stat2.text = [NSString stringWithFormat:@"%d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:22] integerValue]];
            cell.stat3.text = [NSString stringWithFormat:@"%d", [[[playerResults objectAtIndex: indexPath.row] objectAtIndex:21] integerValue]];
    }
    
    cell.AddToTeamButton.tag = indexPath.row;
    cell.AddToTeamButton.accessibilityIdentifier = pid;
    cell.ScratchFromTeamButton.tag = indexPath.row;
    cell.ScratchFromTeamButton.accessibilityIdentifier = pid;
    
    if([_selectedIndexes containsObject:pid]){
        [cell setSelected:YES];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        [cell setSelected:NO];
    }
    if(_selectedIndexes.count > 1) {
        _calculateButton.enabled = YES;
    } else {
        _calculateButton.enabled = NO;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    PlayersCell *playersCell = (PlayersCell *) selectedCell;
    [_selectedIndexes removeObject: playersCell.pid];
    
    if(_selectedIndexes.count > 1) {
        _calculateButton.enabled = YES;
    } else {
        _calculateButton.enabled = NO;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    PlayersCell *playersCell = (PlayersCell *) selectedCell;
    [_selectedIndexes addObject: playersCell.pid];
    if(_selectedIndexes.count > 1) {
        _calculateButton.enabled = YES;
    } else {
        _calculateButton.enabled = NO;
    }
    
}

#pragma mark - UIPickerView Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickerData.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_pickerData objectAtIndex:row];
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.text = [NSString stringWithFormat:@"  %@", [_pickerData objectAtIndex:row]];
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH];
    NSString *pos;
    switch (row) {
        case 0:
            pos = @"Any";
            break;
        case 1:
            pos = @"QB";
            break;
        case 2:
            pos = @"WR";
            break;
        case 3:
            pos = @"RB";
            break;
        case 4:
            pos = @"TE";
            break;
        case 5:
            pos = @"DST";
            break;
        case 6:
            pos = @"K";
            break;
        default:
            break;
    }
    NSString *filterQuery;
    if([pos isEqualToString:@"Any"]){
        filterQuery = @"SELECT * FROM player where pid not in (select pid from team where key = 0) and pid not in (select pid from removed_players) order by score desc";
    } else {
        filterQuery = [NSString stringWithFormat:@"SELECT * FROM player where pos =\"%@\" and pid not in (select pid from team where key = 0) and pid not in (select pid from removed_players) order by score desc", pos];
    }
    playerResults = [database performQuery: filterQuery];
    [database closeConnection];
    [_tableView reloadData];
    [pickerView setHidden:YES];
    [_selectAFilterBtn setTitle:pos forState:UIControlStateNormal];
}

- (IBAction)calculateSelections:(id)sender {
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    NSArray *result = [database performQuery:@"select max(key) from team"];
    NSNumber *maxKey;
    if(result != nil && result.count>0){
        maxKey = (NSNumber *)[[result objectAtIndex:0] objectAtIndex:0];
    } else {
        maxKey = 0;
    }
    if([maxKey isKindOfClass:[NSNull class]]){//this can happen if there are no rows in team table
        maxKey = 0;
    }
    int value = [maxKey intValue];
    value = value +1;
    for(NSString *pid in _selectedIndexes){
        [database performQuery:[NSString stringWithFormat:@"insert into team (pid, key) values(\"%@\",%d)",pid, value]];
        ;
    }
    [_selectedIndexes removeAllObjects];
    [database closeConnection];
    [_tableView reloadData];
}

- (IBAction)addToTeam:(id)sender {
    UIButton *button = (UIButton *) sender;
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    NSString *addToTeamQuery = [NSString stringWithFormat: @"insert into team (pid, key) values (\"%@\",0)", button.accessibilityIdentifier];
    [database performQuery: addToTeamQuery];
    NSString *refreshQuery = [NSString stringWithFormat:@"SELECT * FROM player where pid not in (select pid from team where key = 0) and pid not in (select pid from removed_players) order by score desc"];
    playerResults = [database performQuery: refreshQuery];
    [database closeConnection];
    [_tableView reloadData];
}
- (IBAction)removeFromPlayerList:(id)sender {
    UIButton *button = (UIButton *) sender;
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    NSString *scratchFromTeamQuery = [NSString stringWithFormat: @"insert into removed_players (pid) values(\"%@\")", button.accessibilityIdentifier];
    [database performQuery: scratchFromTeamQuery];
    NSString *refreshQuery = [NSString stringWithFormat:@"SELECT * FROM player where pid not in (select pid from team where key = 0) and pid not in (select pid from removed_players) order by score desc"];
    playerResults = [database performQuery: refreshQuery];
    [database closeConnection];
    [_tableView reloadData];
}

- (IBAction)selectFilter:(id)sender {
    if([filterPicker isHidden]){
        [filterPicker setHidden:NO];
    } else {
        [filterPicker setHidden:YES];
    }
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
