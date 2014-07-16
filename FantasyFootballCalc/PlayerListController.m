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

@interface PlayerListController ()
{
    NSArray *playerResults;
    NSMutableArray *myTeamArray;
    float PassingTd;
    float PassingYards;
    float PassingCompletion;
    float PassingAttempts;
    float PassingInt;
    float RushingYards;
    float RushingTd;
    float RushingAttempts;
    float ReceivingYards;
    float ReceivingReceptions;
    float ReceivingTd;
    float KickingXp;
    float KickingFg;
    float KickingFg50;
    float DefenseTd;
    float DefenseInterception;
    float DefenseSack;
    float DefenseSafety;


}

@end

@implementation PlayerListController


- (void) loadSettingsInMemory{
    Settings* properties = [Settings new];
    PassingTd = [[properties getProperty:PASSING_TD] floatValue];
    PassingYards = [[properties getProperty:PASSING_YARDS] floatValue];
    PassingCompletion = [[properties getProperty:PASSING_COMPLETION] floatValue];
    PassingAttempts = [[properties getProperty:PASSING_ATTEMPTS] floatValue];
    PassingInt = [[properties getProperty:PASSING_INT] floatValue];
    RushingYards = [[properties getProperty:RUSHING_YARDS] floatValue];
    RushingTd = [[properties getProperty:RUSHING_TD] floatValue];
    RushingAttempts = [[properties getProperty:RUSHING_ATTEMPS] floatValue];
    ReceivingYards = [[properties getProperty:RECEIVING_YARDS] floatValue];
    ReceivingReceptions = [[properties getProperty:RECEIVING_RECEPTIONS] floatValue];
    ReceivingTd = [[properties getProperty:RECEIVING_TD] floatValue];
    KickingXp = [[properties getProperty:KICKING_XP] floatValue];
    KickingFg = [[properties getProperty:KICKING_FG] floatValue];
    KickingFg50 = [[properties getProperty:KICKING_FG50] floatValue];
    DefenseTd = [[properties getProperty:DEFENSE_TD] floatValue];
    DefenseInterception = [[properties getProperty:DEFENSE_INTERCEPTION] floatValue];
    DefenseSack = [[properties getProperty:DEFENSE_SACK] floatValue];
    DefenseSafety = [[properties getProperty:DEFENSE_SAFETY] floatValue];
    
    
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
    _calculateButton.enabled = NO;
    _qbFilterBtn.hidden = YES;
    _rbFilterBtn.hidden = YES;
    _wrFilterBtn.hidden = YES;
    _teFilterBtn.hidden = YES;
    _kickerFilterBtn.hidden = YES;
    _defFilterBtn.hidden = YES;
    _selectedIndexes = [[NSMutableArray alloc] init];
    _tableView.allowsMultipleSelection = YES;
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //build connection - will need to replace URL String
    //NSURL *url = [NSURL URLWithString:@"http://www.somethingrighthere.com/something.php"];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"KrunchProjections" withExtension:@"json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(playerResults.count == 0){ // this is because the viewDidAppear method is also going to attempt to do this query.  But if the viewDidAppear executes before the json is pulled and inserted to database then this will load it.
        SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
        playerResults = [database performQuery: @"SELECT * FROM player"];
        myTeamArray = [[NSMutableArray alloc] init];
        NSArray *myTeamResults = [database performQuery: @"SELECT pid FROM team where key = 0"];
        for(int i=0; i<myTeamResults.count; i++){
            NSString *pid = (NSString *)[[myTeamResults objectAtIndex: i]objectAtIndex:0];
            [myTeamArray addObject:pid];
        }
        [database closeConnection];
        [_tableView reloadData];
    }
    
    [self loadSettingsInMemory];
    NSLog(@"Loaded class w floats.");
    
}
/**
 so that the view is reloaded with latest list of players
 **/
-(void)viewDidAppear:(BOOL)animated
{
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH

    playerResults = [database performQuery: @"SELECT * FROM player"];
    myTeamArray = [[NSMutableArray alloc] init];
    NSArray *myTeamResults = [database performQuery: @"SELECT pid FROM team where key = 0"];
    for(int i=0; i<myTeamResults.count; i++){
        NSString *pid = (NSString *)[[myTeamResults objectAtIndex: i]objectAtIndex:0];
        [myTeamArray addObject:pid];
    }
    [database closeConnection];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    [database performQuery:@"delete from player"];
    for(int i = 0; i< _players.count; i++)
    {
        /*float calcPassingTd = PassingTd * [[_players objectAtIndex: i] objectForKey:@"Pass TD"];
        float calcPassingYards = PassingYards * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];
        float calcPassingCompletion = PassingCompletion * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];
        float calcPassingAttempts = PassingAttempts * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];
        float calcPassingInt = PassingInt * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];
        float calcRushingYards = RushingYards * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];
        float calcRushingTd = RushingTd * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];
        float calcRushingAttempts = RushingAttempts * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];
        float calcReceivingYards = ReceivingYards * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];
        float calcReceivingReceptions = ReceivingReceptions * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];
        float calcReceivingTd = ReceivingTd * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];
        float calcKickingXp = KickingXp * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];
        float calcKickingFg = KickingFg * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];
        float calcKickingFg50 = KickingFg50 * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];
        float calcDefenseTd = DefenseTd * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];
        float calcDefenseInterception = DefenseInterception * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];
        float calcDefenseSack = DefenseSack * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];
        float calcDefenseSafety = DefenseSafety * [[[_players objectAtIndex: i] objectForKey:@"Pass TD"] floatValue];*/

        NSString *refreshPlayers = [NSString stringWithFormat:@"insert into player (pid, player, pos, team, adp, passcomp,passatt, passyds, passtd,int,rushatt,rushyds,rushtd,rec,recyds, rectd, xp, fg, fg50, deftd, deffum, defint,defsack, defsafety, bye, opponent, news) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[[_players objectAtIndex: i] objectForKey:@"PID"], [[_players objectAtIndex: i] objectForKey:@"Player"], [[_players objectAtIndex: i] objectForKey:@"Pos"], [[_players objectAtIndex: i] objectForKey:@"Team"], [[_players objectAtIndex: i] objectForKey:@"ADP"], [[_players objectAtIndex: i] objectForKey:@"Pass Comp"], [[_players objectAtIndex: i] objectForKey:@"Pass Att"], [[_players objectAtIndex: i] objectForKey:@"Pass Yds"], [[_players objectAtIndex: i] objectForKey:@"Pass TD"], [[_players objectAtIndex: i] objectForKey:@"INT"], [[_players objectAtIndex: i] objectForKey:@"Rush Att"], [[_players objectAtIndex: i] objectForKey:@"Rush Yds"], [[_players objectAtIndex: i] objectForKey:@"Rush TD"], [[_players objectAtIndex: i] objectForKey:@"Rec"], [[_players objectAtIndex: i] objectForKey:@"Rec Yds"], [[_players objectAtIndex: i] objectForKey:@"Rec TD"], [[_players objectAtIndex: i] objectForKey:@"XP"], [[_players objectAtIndex: i] objectForKey:@"FG"], [[_players objectAtIndex: i] objectForKey:@"FG50"], [[_players objectAtIndex: i] objectForKey:@"DefTD"], [[_players objectAtIndex: i] objectForKey:@"DefFum"], [[_players objectAtIndex: i] objectForKey:@"DefInt"], [[_players objectAtIndex: i] objectForKey:@"DefSack"], [[_players objectAtIndex: i] objectForKey:@"DefSafety"], [[_players objectAtIndex: i] objectForKey:@"Bye"], [[_players objectAtIndex: i] objectForKey:@"Opponent"], [[_players objectAtIndex: i] objectForKey:@"News"]];
        [database performQuery:refreshPlayers];
    }
    [database closeConnection];

}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //TODO do something here
    NSLog(@"Failed!!!");
    //stop the networkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
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
    [_activityIndicator stopAnimating];
    PlayersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayersCell" forIndexPath:indexPath];
    NSLog(@"The row: %d",indexPath.row);
    if(indexPath.row % 2 == 0){
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    NSString *pid = [[playerResults objectAtIndex: indexPath.row]objectAtIndex:0];
    NSLog(@"Player: %@", pid);
    [cell.AddToTeamButton setTitleColor:[UIColor grayColor] forState:(UIControlStateDisabled)];
    [cell.AddToTeamButton setTitleColor:[UIColor greenColor] forState:(UIControlStateNormal)];
    [cell.ScratchFromTeamButton setTitleColor:[UIColor grayColor] forState:(UIControlStateDisabled)];
    [cell.ScratchFromTeamButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    
    if([myTeamArray containsObject:pid]) {
        NSLog(@"Player already added: %@", pid);
        [cell.AddToTeamButton setEnabled:NO];
        [cell.ScratchFromTeamButton setEnabled:YES];
    } else {
        [cell.AddToTeamButton setEnabled:YES];
        [cell.ScratchFromTeamButton setEnabled:NO];
    }
    // Configure the cell...
    cell.PlayerLabel.text = [[playerResults objectAtIndex: indexPath.row] objectAtIndex:1];
    cell.PosLabel.text = [[playerResults objectAtIndex: indexPath.row] objectAtIndex:2];
    cell.TeamLabel.text = [[playerResults objectAtIndex: indexPath.row] objectAtIndex:3];
    cell.pid = pid;
    
    cell.AddToTeamButton.tag = indexPath.row;
    cell.AddToTeamButton.accessibilityIdentifier = pid;
    cell.ScratchFromTeamButton.tag = indexPath.row;
    cell.ScratchFromTeamButton.accessibilityIdentifier = pid;
    if([_selectedIndexes containsObject:pid]){
        UIView *selectedBck= [[UIView alloc] init];
        selectedBck.backgroundColor = [UIColor blueColor];
        cell.selectedBackgroundView = selectedBck;
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
    UIView *selectedBck= [[UIView alloc] init];
    selectedBck.backgroundColor = [UIColor blueColor];
    playersCell.selectedBackgroundView = selectedBck;

    [_selectedIndexes addObject: playersCell.pid];
    
    if(_selectedIndexes.count > 1) {
        _calculateButton.enabled = YES;
    } else {
        _calculateButton.enabled = NO;
    }
    
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
    [database closeConnection];
    
    PlayersCell *cell = (PlayersCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
    [cell.ScratchFromTeamButton setEnabled:YES];
    [cell.AddToTeamButton setEnabled:NO];
}
- (IBAction)scratchFromTeam:(id)sender {
    UIButton *button = (UIButton *) sender;
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH]; //SEE Config.m for DBPATH
    NSString *scratchFromTeamQuery = [NSString stringWithFormat: @"delete from team where pid = \"%@\"", button.accessibilityIdentifier];
    [database performQuery: scratchFromTeamQuery];
    [database closeConnection];
    
    PlayersCell *cell = (PlayersCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
    [cell.ScratchFromTeamButton setEnabled:NO];
    [cell.AddToTeamButton setEnabled:YES];
}

- (IBAction)selectFilter:(id)sender {
    if(_qbFilterBtn.hidden == YES){
        [self.view bringSubviewToFront:_qbFilterBtn];
        [self.view bringSubviewToFront:_rbFilterBtn];
        [self.view bringSubviewToFront:_wrFilterBtn];
        [self.view bringSubviewToFront:_teFilterBtn];
        [self.view bringSubviewToFront:_kickerFilterBtn];
        [self.view bringSubviewToFront:_defFilterBtn];
        _qbFilterBtn.hidden = NO;
        _rbFilterBtn.hidden = NO;
        _wrFilterBtn.hidden = NO;
        _teFilterBtn.hidden = NO;
        _kickerFilterBtn.hidden = NO;
        _defFilterBtn.hidden = NO;
    } else {
        _qbFilterBtn.hidden = YES;
        _rbFilterBtn.hidden = YES;
        _wrFilterBtn.hidden = YES;
        _teFilterBtn.hidden = YES;
        _kickerFilterBtn.hidden = YES;
        _defFilterBtn.hidden = YES;
    
    }
}

- (IBAction)filterResults:(id)sender {
    UIButton *filterBtn = (UIButton *) sender;
    SQLite *database = [[SQLite alloc] initWithPath: DBPATH];
    NSString *pos;
    switch ([filterBtn tag]) {
        case 0:
            pos = @"QB";
            break;
        case 1:
            pos = @"RB";
            break;
        case 2:
            pos = @"WR";
            break;
        case 3:
            pos = @"TE";
            break;
        case 4:
            pos = @"Def";
            break;
        case 5:
            pos = @"K";
            break;
        default:
            break;
    }
    NSString *filterQuery = [NSString stringWithFormat:@"SELECT * FROM player where pos =\"%@\"", pos];
    playerResults = [database performQuery: filterQuery];
    myTeamArray = [[NSMutableArray alloc] init];
    NSArray *myTeamResults = [database performQuery: @"SELECT pid FROM team where key = 0"];
    for(int i=0; i<myTeamResults.count; i++){
        NSString *pid = (NSString *)[[myTeamResults objectAtIndex: i]objectAtIndex:0];
        [myTeamArray addObject:pid];
    }
    [database closeConnection];
    [_tableView reloadData];
    _qbFilterBtn.hidden = YES;
    _rbFilterBtn.hidden = YES;
    _wrFilterBtn.hidden = YES;
    _teFilterBtn.hidden = YES;
    _kickerFilterBtn.hidden = YES;
    _defFilterBtn.hidden = YES;
    [_selectAFilterBtn setTitle:pos forState:UIControlStateNormal];
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
