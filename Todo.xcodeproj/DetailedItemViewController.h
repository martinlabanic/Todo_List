//
//  DetailedItemViewController.h
//  Todo
//
//  Created by Martin Labanic on 11-06-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedItemViewController : UIViewController <NSFetchedResultsControllerDelegate, UITextViewDelegate>{
    @private
        NSString *itemName;
        NSString *itemDateTime;
        NSString *itemDescrip;
        UITextView *itemDescriptionField;
}

@property (nonatomic, retain) NSString *itemName;
@property (nonatomic, retain) NSString *itemDateTime;
@property (nonatomic, retain) NSString *itemDescrip;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void) saveDescription;
- (IBAction) backBtnClicked;
//- (IBAction) starBtnClicked;
@end
