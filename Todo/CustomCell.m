//
//  CustomCell.m
//  Todo
//
//  Created by Martin Labanic on 11-06-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomCell.h"


@implementation CustomCell

@synthesize cellTitle;
@synthesize cellDescription;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [cellTitle release];
    [cellDescription release];
    [super dealloc];
}

@end
