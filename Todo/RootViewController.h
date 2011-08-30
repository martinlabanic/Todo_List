//
//  RootViewController.h
//  Todo
//
//  Created by Martin Labanic on 11-06-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate> {
    @private
        BOOL userClickedCancel;
        NSString* listName;
        NSString* dateListCreated;
        UITextField* listNameField;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void) callAlertBox;
- (void) actuallyInsertList;
- (void) getDateListCreated;

@end
