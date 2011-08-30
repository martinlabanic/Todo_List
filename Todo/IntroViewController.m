//
//  IntroViewController.m
//  Todo
//
//  Created by Martin Labanic on 11-06-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IntroViewController.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation IntroViewController

@synthesize managedObjectContext;
@synthesize fetchedResultsController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)dealloc{
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
    // Do any additional setup after loading the view from its nib.
    //self.navigationItem
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 280.0f, 440.0f)];//[[UIScreen mainScreen] applicationFrame]];
    contentView.backgroundColor = [UIColor clearColor];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(60, 130.0f, 200.0f, 100.0f)];
    btn1.layer.cornerRadius = 5;
    btn1.titleLabel.text = @"View Lists";
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(60, 250.0f, 200.0f, 100.0f)];
    btn2.layer.cornerRadius = 5;
    btn2.titleLabel.text = @"Magic!";
    
    [contentView addSubview:btn1];
    [contentView addSubview:btn2];
    [btn1 release];
    [btn2 release];
    
    self.view = contentView;
    [contentView release];
}


- (IBAction) btn1Clicked{
    RootViewController *rController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:rController animated:YES];
}


- (IBAction) btn2Clicked{
    
}


- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}


- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void) viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
	[super viewWillDisappear:animated];
}


- (void) viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
