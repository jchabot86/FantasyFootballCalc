//
//  PlayersCell.m
//  FantasyFootballCalc
//
//  Created by Jon on 7/4/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import "PlayersCell.h"
#import "SQLite.h"
#import "Config.h"

@implementation PlayersCell

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
