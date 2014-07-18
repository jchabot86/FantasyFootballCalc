//
//  MyTeamCell.m
//  FantasyFootballCalc
//
//  Created by Jon on 7/7/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import "MyTeamCell.h"

@implementation MyTeamCell
@synthesize RemoveFromSelectionBtn;
@synthesize pid;
@synthesize PlayerLabel;
@synthesize TeamLabel;
@synthesize PosLabel;
@synthesize stat1;
@synthesize stat2;
@synthesize stat3;
@synthesize stat1Label;
@synthesize stat2Label;
@synthesize stat3Label;
@synthesize projPts;
@synthesize byeLabel;
@synthesize RemoveFromTeamBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
