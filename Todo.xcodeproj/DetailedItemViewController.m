//
//  DetailedItemViewController.m
//  Todo
//
//  Created by Martin Labanic on 11-06-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailedItemViewController.h"
#import "TodoAppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@implementation DetailedItemViewController

@synthesize itemName;
@synthesize itemDateTime;
@synthesize itemDescrip;
@synthesize fetchedResultsController=__fetchedResultsController;
@synthesize managedObjectContext=__managedObjectContext;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)dealloc{
    itemName = nil;
    itemDateTime = nil;
    itemDescrip = nil;
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

-(void) loadView{
    if (self.managedObjectContext == nil){
        self.managedObjectContext= [(TodoAppDelegate*)[[UIApplication sharedApplication] delegate]managedObjectContext]; 
    }
}


- (void)viewDidLoad{
    [super viewDidLoad];    
    
    //UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[btn setTitle:@"Save Details" forState:UIControlStateNormal];
    //[btn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.title = itemName;
    
    NSManagedObject *obj = [self.fetchedResultsController.fetchedObjects objectAtIndex:0];
    /*UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveBtnClicked)];
     self.navigationItem.rightBarButtonItem = saveBtn;*/
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnClicked)];
    self.navigationItem.leftBarButtonItem = backBtn;
    [backBtn release];
    
    //UIBarButtonItem *starBtn = [[UIBarButtonItem alloc] initWithTitle:@"Star" style:UIBarButtonItemStyleBordered target:self action:@selector(starBtnClicked)];
    //UIButton *starBtn = [[UIButton alloc] initWithTitle:@"Star" style:UIBarButtonItemStyleBordered target:self action:@selector(starBtnClicked)];

//    self.navigationItem.rightBarButtonItem = starBtn;
  //  [starBtn release];
    
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    contentView.backgroundColor=[UIColor clearColor];
    itemDescriptionField = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 50.0f, 300.0f, 150.0f)];
    itemDescriptionField.backgroundColor = [UIColor whiteColor];
    itemDescriptionField.alpha = 0.75f;
    itemDescriptionField.layer.cornerRadius = 5;
    itemDescriptionField.clipsToBounds = YES;
    NSString *txt = [obj valueForKey:@"itemDescription"];
    if ([txt isEqualToString:@"No details"])
    {   itemDescriptionField.text = @"";}
    else
    {   itemDescriptionField.text = txt;}
    
    [txt release];
    [obj release];
    
    //UIButton *superAwesomeMagicButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 220.0f, 80.0f, 35.0f)];
    //superAwesomeMagicButton.layer.cornerRadius = 5;
    //superAwesomeMagicButton.titleLabel.text = @"Save Changes";

    [contentView addSubview:itemDescriptionField];
    self.view = contentView;
    [contentView release];
}


- (IBAction) backBtnClicked{
    [self saveDescription];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) saveDescription{
    NSManagedObject *obj = [self.fetchedResultsController.fetchedObjects objectAtIndex:0];
    if (![itemDescriptionField.text isEqualToString:@""]){
        [obj setValue:[NSString stringWithString:itemDescriptionField.text ] forKey:@"itemDescription"];
    
        NSError *error = nil;
        if (![[self managedObjectContext] save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [error release];
    }
}

/*- (void) starBtnClicked{
    NSManagedObject *obj = [self.fetchedResultsController.fetchedObjects objectAtIndex:0];
    if ([[obj valueForKey:@"star"] boolValue] == YES)
    {   [obj setValue:[NSNumber numberWithBool:NO] forKey:@"star"];}
    else
    {   [obj setValue:[NSNumber numberWithBool:YES] forKey:@"star"];}

    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [error release];
}*/



- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    [fetchRequest setFetchBatchSize:1];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"task" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"dateTime MATCHES %@", itemDateTime]];
    
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

@end
