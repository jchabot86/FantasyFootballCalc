//
//  SelectionDetailCell.m
//  FantasyFootballCalc
//
//  Created by Jon on 6/22/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import "SelectionDetailCell.h"

@implementation SelectionDetailCell

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
