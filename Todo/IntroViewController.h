//
//  IntroViewController.h
//  Todo
//
//  Created by Martin Labanic on 11-06-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IntroViewController : UIViewController {
    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


- (IBAction) btn1Clicked;
- (IBAction) btn2Clicked;

@end
