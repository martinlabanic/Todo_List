//
//  CustomCell.h
//  Todo
//
//  Created by Martin Labanic on 11-06-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell {
    NSString *cellTitle;
    NSString *cellDescription;
}

@property (nonatomic, retain) IBOutlet NSString *cellTitle;
@property (nonatomic, retain) IBOutlet NSString *cellDescription;


@end
