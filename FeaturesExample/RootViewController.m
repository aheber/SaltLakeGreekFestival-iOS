//
//  RootViewController.m
//  FeaturesExample
//

#import "RootViewController.h"
#import "IIViewDeckController.h"
#import "ChoiceController.h"
#import "ScheduleController.h"
#import "SelectionController.h"

@interface RootViewController () <IIViewDeckControllerDelegate> {
    IIViewDeckPanningMode _panning;
    IIViewDeckCenterHiddenInteractivity _centerHidden;
    IIViewDeckNavigationControllerBehavior _navBehavior;
    IIViewDeckSizeMode _sizeMode;
    BOOL _elastic;
    CGFloat _maxLedge;
}

@end

@implementation RootViewController

@synthesize choiceView = _choiceView;
@synthesize panningView = _panningView;
@synthesize navController = _navController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Override point for customization after application launch.
    RootViewController* rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    rootViewController.panningView = self.panningView;
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    self.navController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self addChildViewController:self.navController];
    
    self.navController.view.frame = self.choiceView.bounds;
    [self.choiceView addSubview:self.navController.view];
    
    ScheduleController* scheduleController = [[ScheduleController alloc] initWithNibName:@"ScheduleController" bundle:nil];
    SelectionController* selectionController = [[SelectionController alloc] initWithNibName:@"SelectionController" bundle:nil];
    
    IIViewDeckController* controller = [[IIViewDeckController alloc] initWithCenterViewController:scheduleController leftViewController:selectionController];
    controller.panningMode = _panning;
    controller.centerhiddenInteractivity = _centerHidden;
    controller.navigationControllerBehavior = _navBehavior;
    controller.panningView = self.panningView;
    controller.maxSize = _maxLedge > 0 ? self.view.bounds.size.width-_maxLedge : 0;
    controller.sizeMode = _sizeMode;
    controller.elastic = _elastic;
    controller.leftSize = 100;
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


@end
