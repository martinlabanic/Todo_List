//
//  ListDetailsViewController.h
//  Todo
//
//  Created by Martin Labanic on 11-06-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListDetailsViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate> {
    @private
        BOOL userClickedCancel;
        NSString *listName;    //The selected list
        NSString *task;
        NSString *dateListCreated;
        NSString *dateTime;
        UITextField *taskField;
}

@property (nonatomic, retain) NSString *listName;
@property (nonatomic, retain) NSString *dateListCreated;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void) callAlertBox;
- (void) actuallyInsertItem;
- (void) getDateTime;
- (UIColor*) findTextColourForCell:(BOOL)boolVal;
//- (UIImageView*) getAccessoryViewForCell:(BOOL)boolValS crossedOff:(BOOL)boolValC;
@end
