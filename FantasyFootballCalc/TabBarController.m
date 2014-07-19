//
//  TabBarController.m
//  FantasyFootballCalc
//
//  Created by Jon on 7/18/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

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
    UITabBarItem *playersItem = [self.tabBar.items objectAtIndex:0];
    NSLog(playersItem.title);
    UIImage *playersUnselectedImage = [UIImage imageNamed:@"Search_blue.png"];
    UIImage *playersSelectedImage = [UIImage imageNamed:@"Search_white.png"];
    
    [playersItem setImage: [playersUnselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [playersItem setSelectedImage: playersSelectedImage];
    
    UITabBarItem *selectionsItem = [self.tabBar.items objectAtIndex:1];
    NSLog(selectionsItem.title);
    UIImage *selectionsUnselectedImage = [UIImage imageNamed:@"Search_blue"];
    UIImage *selectionsSelectedImage = [UIImage imageNamed:@"Search_white"];
    
    [selectionsItem setImage: [selectionsUnselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [selectionsItem setSelectedImage: selectionsSelectedImage];
    
    UITabBarItem *teamItem = [self.tabBar.items objectAtIndex:2];
    NSLog(teamItem.title);
    UIImage *teamUnselectedImage = [UIImage imageNamed:@"Search_blue"];
    UIImage *teamSelectedImage = [UIImage imageNamed:@"Search_white"];
    
    [teamItem setImage: [teamUnselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [teamItem setSelectedImage: teamSelectedImage];
    
    UITabBarItem *settingsItem = [self.tabBar.items objectAtIndex:3];
    NSLog(settingsItem.title);
    UIImage *settingsUnselectedImage = [UIImage imageNamed:@"Search_blue"];
    UIImage *settingsSelectedImage = [UIImage imageNamed:@"Search_white"];
    
    [settingsItem setImage: [settingsUnselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [settingsItem setSelectedImage: settingsSelectedImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
