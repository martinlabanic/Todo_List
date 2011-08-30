//
//  ListDetailsViewController.m
//  Todo
//
//  Created by Martin Labanic on 11-06-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ListDetailsViewController.h"
#import "DetailedItemViewController.h"
#import "TodoAppDelegate.h"

@interface ListDetailsViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation ListDetailsViewController

@synthesize listName;
@synthesize dateListCreated;
@synthesize fetchedResultsController=__fetchedResultsController;
@synthesize managedObjectContext=__managedObjectContext;




- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)dealloc{
    
    listName = nil;
    dateListCreated = nil;
    [__managedObjectContext release];
    [__fetchedResultsController release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];

    // Set up the edit and add buttons.
    //self.navigationItem.leftBarButtonItem = self.;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [addButton release];
    self.navigationItem.title = listName;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //seconds
    lpgr.delegate = self;
    [self.view addGestureRecognizer:lpgr];
    [lpgr release];    
    if (self.managedObjectContext == nil){
        self.managedObjectContext= [(TodoAppDelegate*)[[UIApplication sharedApplication] delegate]managedObjectContext];
    }
    
}


- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[managedObject valueForKey:@"task"] description];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"- %@",[[managedObject valueForKey:@"itemDescription"] description]];
    
    cell.textLabel.textColor = [self findTextColourForCell:[[managedObject valueForKey:@"crossedOff"] boolValue]];
    cell.detailTextLabel.textColor = [self findTextColourForCell:[[managedObject valueForKey:@"crossedOff"] boolValue]];
    
    
    UIButton *accBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 18.0f, 18.0f)];
    [accBtn setBackgroundImage:[UIImage imageNamed:@"star_big.png"] forState:UIControlStateSelected];
    [accBtn setBackgroundImage:[UIImage imageNamed:@"silvStar.png"] forState:UIControlStateNormal];
    cell.accessoryView = accBtn;//[self getAccessoryViewForCell:[[managedObject valueForKey:@"star"] boolValue] crossedOff:[[managedObject valueForKey:@"crossedOff"] boolValue]];
}


- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    //return 0;
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
        
      //  UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(270.0f, 10.0f, 38.0f, 38.0f)] initWithImage:[UIImage imageNamed:@"1.png"]];//initWithFrame:CGRectMake(0.0f, 0.0f, 38.0f, 38.0f)];
      //  imageView.tag = kImageValueTag;
      //  [cell.contentView addSubview:imageView];*/
        
        //UIImage *imageSmall = [UIImage imageNamed:(@"%d.png",[managedObject valueForKey:@"priority"])];   
        //[cell.imageView initWithImage:imageSmall];
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        cell.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
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


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSManagedObject *selectedRow = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([[selectedRow valueForKey:@"star"] boolValue] == YES)
    {   [selectedRow setValue:[NSNumber numberWithBool:NO] forKey:@"star"];}
    else
    {   [selectedRow setValue:[NSNumber numberWithBool:YES] forKey:@"star"];}
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [error release];

    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSManagedObject *selectedRow = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
	//Initialize the detail view controller and display it.
	DetailedItemViewController *diController = [[DetailedItemViewController alloc] initWithNibName:@"DetailedItemViewController" bundle:[NSBundle mainBundle]];
	diController.itemName = [selectedRow valueForKey:@"task"];
    diController.itemDateTime = [selectedRow valueForKey:@"dateTime"];
    diController.itemDescrip = [selectedRow valueForKey:@"itemDescription"];
    selectedRow =nil;
    
	[self.navigationController pushViewController:diController animated:YES];
}


#pragma mark - Fetched results controller delegate
- (NSFetchedResultsController *) fetchedResultsController{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TodoItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"task" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"dateListCreated MATCHES %@", dateListCreated]];
    
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


- (void) insertNewObject{
    userClickedCancel = true;
    [self callAlertBox];
}


- (void) actuallyInsertItem{
    if(userClickedCancel == false){
        // Create a new instance of the entity managed by the fetched results controller.
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        if (![task isEqualToString:nil]) {
            [newManagedObject setValue:[NSString stringWithString:task] forKey:@"task"];
            [newManagedObject setValue:[NSString stringWithString:dateListCreated] forKey:@"dateListCreated"];
            [newManagedObject setValue:[NSString stringWithString:dateTime] forKey:@"dateTime"];
            [newManagedObject setValue:[NSNumber numberWithBool:NO] forKey:@"crossedOff"];
            [newManagedObject setValue:[NSNumber numberWithBool:NO] forKey:@"star"];
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
        [self textFieldDidEndEditing:taskField];
        [self getDateTime];
        [self actuallyInsertItem];
    }
}


- (void) textFieldDidEndEditing:(UITextField *)textField{
    task = textField.text;
}


- (void) callAlertBox{
    UIAlertView *dialog = [[[UIAlertView alloc] init] retain];
    [dialog setDelegate:self];
    [dialog setTitle:@"New Entry"];
    [dialog setMessage:@"\n"];
    taskField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    [dialog addSubview:taskField];
    [taskField setBackgroundColor:[UIColor whiteColor]];
    [dialog addButtonWithTitle:@"Create"];
    [dialog addButtonWithTitle:@"Cancel"];
    [taskField setDelegate:self];
    [taskField becomeFirstResponder];
    
    [dialog show];
    [dialog release];
}


- (void) getDateTime{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd -hh:mm:ss"];
    dateTime = [format stringFromDate:[NSDate date]];
    
    [format release];
}


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


/*- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if(((UITouch *)[touches anyObject]).tapCount == 2)
    {
        NSLog(@"DOUBLE TOUCH");
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    // Detect touch anywhere
    UITouch *touch = [touches anyObject];
    
    switch ([touch tapCount]) 
    {
        case 1:
            [self performSelector:@selector(oneTap) withObject:nil afterDelay:.5];
            break;
            
        case 2:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(oneTap) object:nil];
            [self performSelector:@selector(twoTaps) withObject:nil afterDelay:.5];
            break;
            
        default:
            break;
    }
}*/


- (UIColor*) findTextColourForCell:(BOOL)boolVal{  //boolVal is crossedOff in this case.
    return (boolVal == NO) ? [UIColor whiteColor] : [UIColor colorWithWhite:1.0f alpha:0.4f];   //This should do the same as the 3 lines below.
    /*if (boolVal == NO){
        return [UIColor whiteColor];
    }
    return [UIColor colorWithWhite:1.0f alpha:0.4f];*/
}


- (void) tableView:(UITableView*)tableView changeCrossedOffAtIndex:(NSIndexPath*)indexPath{
    NSManagedObject *selectedRow = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([[selectedRow valueForKey:@"crossedOff"] boolValue] == YES)
    {   [selectedRow setValue:[NSNumber numberWithBool:NO] forKey:@"crossedOff"];}
    else
    {   [selectedRow setValue:[NSNumber numberWithBool:YES] forKey:@"crossedOff"];}
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.view];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        if (indexPath != nil){
            [self tableView:self.tableView changeCrossedOffAtIndex:indexPath];
        }
    }
}


/*- (UIButton*) getAccessoryViewForCell:(BOOL)boolValS crossedOff:(BOOL)boolValC{  //boolValS = star, boolValC = crossedOff
    //UIImageView *imageView;
    //This line does the same as the commented out lines beneith.
    UIButton *accBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 18.0f, 18.0f)];
    if (!boolValC) {
        [accBtn setBackgroundImage:[UIImage imageNamed:@"star_big.png"] forState:UIControlStateSelected];
    }
    
    //accBtn = (boolValS && !boolValC) ? [[accBtn setBackgroundImage:[UIImage imageNamed:@"star_big.png"]] forState:UIControlStateSelected]: [accBtn setBackgroundImage:@"silvStar.png" forState:UIControlStateSelected];
    imageView = (boolValS && !boolValC) ? [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_big.png"]] : [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"silvStar.png"]];
    
    if (boolValS && !boolValC)
    {   imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_big.png"]];}
    //else if (boolValS && boolValC)
    //{   imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_big.png"]];
    //    imageView.alpha = 0.4f;
    //}     did not work.
    else
    {   imageView = nil;}
    return accBtn;
    [accBtn release];
}*/

@end












/*
 
 
 - (void) insertNewObject{
 userClickedCancel = true;
 [self callAlertBox];
 }
 
 
 - (void) actuallyInsertItem{
 if(userClickedCancel == false){
 // Create a new instance of the entity managed by the fetched results controller.
 NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
 NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
 NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
 
 // If appropriate, configure the new managed object.
 // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
 if (![task isEqualToString:nil]) {
 [newManagedObject setValue:[NSString stringWithString:task] forKey:@"task"];
 [newManagedObject setValue:[NSString stringWithString:dateListCreated] forKey:@"dateListCreated"];
 [newManagedObject setValue:[NSString stringWithString:dateTime] forKey:@"dateTime"];
 [newManagedObject setValue:[NSNumber numberWithBool:NO] forKey:@"crossedOff"];
 [newManagedObject setValue:[NSString stringWithString:itemDescript] forKey:@"itemDescription"];
 }
 
 // Save the context.
 NSError *error = nil;
 if (![context save:&error])
 {
 
 Replace this implementation with code to handle the error appropriately.
 
 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.

NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
abort();
}
}

}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    userClickedCancel = (buttonIndex == 1) ? true : false;
    if(userClickedCancel == false){
        [self textFieldDidEndEditing:taskField forString:task];
        [self textFieldDidEndEditing:descriptField forString:itemDescript];
        [self getDateTime];
        [self actuallyInsertItem];
    }
}


- (void) textFieldDidEndEditing:(UITextField *)textField forString:(NSString*)someStr{
    someStr = textField.text;
}


- (void) callAlertBox{
    UIAlertView *dialog = [[[UIAlertView alloc] init] retain];
    [dialog setDelegate:self];
    [dialog setTitle:@"New Entry"];
    [dialog setMessage:@"Entry Name:\n"];
    taskField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Description:";
    descriptField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    [taskField setBackgroundColor:[UIColor whiteColor]];
    
    [dialog addSubview:taskField];
    [dialog addSubview:label];
    [dialog addSubview:descriptField];
    [dialog addButtonWithTitle:@"Create"];
    [dialog addButtonWithTitle:@"Cancel"];
    [taskField setDelegate:nil];
    [taskField becomeFirstResponder];
    
    [label release];
    
    [dialog show];
    [dialog release];
}


- (void) getDateTime{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd -hh:mm:ss"];
    dateTime = [format stringFromDate:[NSDate date]];
    
    [format release];
}
*/

