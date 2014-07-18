//
//  TabViewController.m
//  FantasyFootballCalc
//
//  Created by Jon on 7/18/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController

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
    UITabBarItem *item = [[[UITabBarItem alloc] initWithTitle:@"Sync" style:UIBarButtonItemStyleBordered target: self action: @selector(doSomething:)]];
    [[self setTabBarItem:item]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if([item.title isEqualToString:(@"Sync")]){
        NSLog(@"TAB INDEX = %@", item.title);
        return;
    }
}
-(void)doSomething:(UITabBarItem *) item{
    NSLog(@"Heyyyyyyy");
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
