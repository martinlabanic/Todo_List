//
//  RootViewController.m
//  Todo
//
//  Created by Martin Labanic on 11-06-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "ListDetailsViewController.h"

@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation RootViewController
@synthesize fetchedResultsController=__fetchedResultsController;
@synthesize managedObjectContext=__managedObjectContext;


- (void) viewDidLoad{
    [super viewDidLoad];
    // Set up the edit and add buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    self.title = @"Todo Lists";
}    


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}


- (void) viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
}


 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// Customize the number of sections in the table view.
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}



// Customize the appearance of table view cells.
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        cell.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
    }

    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    // The table view should not be re-orderable.
    return NO;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSManagedObject *selectedRow = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
	//Initialize the detail view controller and display it.
	ListDetailsViewController *ldvController = [[ListDetailsViewController alloc] initWithNibName:@"ListDetailsViewController" bundle:[NSBundle mainBundle]];
	ldvController.listName = [selectedRow valueForKey:@"listName"];
    ldvController.dateListCreated = [selectedRow valueForKey:@"dateListCreated"];
    selectedRow =nil;
    
	[self.navigationController pushViewController:ldvController animated:YES];
}


- (void) didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void) viewDidUnload{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void) dealloc{
    [__fetchedResultsController release];
    [__managedObjectContext release];
    [super dealloc];
}


- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[managedObject valueForKey:@"listName"] description];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Creation Date: %@",[[managedObject valueForKey:@"dateListCreated"] description]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    //cell.backgroundColor = [UIColor clearColor];
}


- (void) insertNewObject{
    userClickedCancel = true;
    [self callAlertBox];
}


- (void) actuallyInsertList{
    if(userClickedCancel == false){
        // Create a new instance of the entity managed by the fetched results controller.
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        if (![listName isEqualToString:nil]) {
            [newManagedObject setValue:[NSString stringWithString:listName] forKey:@"listName"];
            [newManagedObject setValue:[NSString stringWithString:dateListCreated] forKey:@"dateListCreated"];
        }
            
        // Save the context.
        NSError *error = nil;
        if (![context save:&error])
        {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        }
        
    }
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    userClickedCancel = (buttonIndex == 1) ? true : false;
    if(userClickedCancel == false){
        [self textFieldDidEndEditing:listNameField];
        [self getDateListCreated];
        [self actuallyInsertList];
        
    }
}


- (void) textFieldDidEndEditing:(UITextField *)textField{
    listName = textField.text;
}


- (void) callAlertBox{
    UIAlertView *dialog = [[[UIAlertView alloc] init] retain];
    [dialog setDelegate:self];
    [dialog setTitle:@"New List"];
    [dialog setMessage:@"\n"];
    listNameField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    [dialog addSubview:listNameField];
    [listNameField setBackgroundColor:[UIColor whiteColor]];
    [dialog addButtonWithTitle:@"Create"];
    [dialog addButtonWithTitle:@"Cancel"];
    [listNameField setDelegate:self];
    [listNameField becomeFirstResponder];

    [dialog show];
    [dialog release];
}


#pragma mark - Fetched results controller
- (NSFetchedResultsController *) fetchedResultsController{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
    */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TodoList" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"listName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
        {
	    /*
	     Replace this implementation with code to handle the error appropriately.

	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}

#pragma mark - Fetched results controller delegate

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}


- (void) controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath{
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}


/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}


- (void) getDateListCreated{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd -hh:mm:ss"];
    dateListCreated = [format stringFromDate:[NSDate date]];

    [format release];
}

@end






//  from viewdidload
/*UIToolbar *tBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 440.0f, 320.0f, 40.0f)];
 tBar.translucent = YES;
 tBar.tintColor = [UIColor blackColor];
 
 UIBarButtonItem *magicBtn = [[UIBarButtonItem alloc] 
 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
 target:self 
 action:@selector(magicBtnClicked)];
 NSArray *items = [NSArray arrayWithObject:magicBtn];
 [tBar setItems:items];
 [[[UIApplication sharedApplication] keyWindow] addSubview:tBar];
 }
 
 
 -(IBAction) magicBtnClicked{
 UIImageView *imageView = [[[UIImageView alloc] init] initWithImage:[UIImage imageNamed:@"facial_animation_laughing.jpg"]];
 [self.view addSubview:imageView];*/




