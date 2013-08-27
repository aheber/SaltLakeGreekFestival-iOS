//
//  RootViewController.m
//  FeaturesExample
//

#import "RootViewController.h"
#import "IIViewDeckController.h"
#import "ChoiceController.h"
#import "ScheduleController.h"
#import "SelectionController.h"
#import "TBXML.h"
#define PAGES_NUMBER 6
#define SCROLL_INT 10.0

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
@synthesize scrollView = _scrollView;
NSMutableArray *ads;

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
    [self loadAds];
    [self GeneratePages];
    h = 0;
    [NSTimer scheduledTimerWithTimeInterval:SCROLL_INT target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    

    // Override point for customization after application launch.
    RootViewController* rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    rootViewController.panningView = self.panningView;
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    self.navController.navigationBar.tintColor = [UIColor colorWithRed:47/255.0f green:101/255.0f blue:176/255.0f alpha:1];
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
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

# pragma mark - timer

- (void) onTimer {
    
    // Updates the variable h, adding 100 (put your own value here!)
    h = _scrollView.contentOffset.x;
    h += _scrollView.frame.size.width;
    if(h == _scrollView.contentSize.width)
        h = 0;
    //This makes the scrollView scroll to the desired position
    [_scrollView setContentOffset: CGPointMake(h, 0)];
}

# pragma mark - scrollview methods
-(void)GeneratePages
{
    for (int i=0; i<[ads count]; i++)
    {
        UIButton *Page = [[UIButton alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width*i, 0.0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        UIImage *btnImage = [UIImage imageNamed:[[ads objectAtIndex:i] objectAtIndex:0]];
        [Page setImage:btnImage forState:UIControlStateNormal];
        [_scrollView addSubview:Page];
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*PAGES_NUMBER, _scrollView.frame.size.height);
}

#pragma mark - XML Parser

- (void)loadAds{
    NSError *myError = nil;
    TBXML *tbxml = [TBXML newTBXMLWithXMLFile:@"sponsors" fileExtension:@"xml" error:&myError];
    ads = [[NSMutableArray alloc] init];
    
    if (tbxml.rootXMLElement)
        [self traverseElement:tbxml.rootXMLElement];
}

- (void) traverseElement:(TBXMLElement *)element {
    do {
        if (element->firstChild)
            [self traverseElement:element->firstChild];
        if ([[TBXML elementName:element] isEqualToString:@"sponsor"]) {
            [ads addObject:[NSArray arrayWithObjects:
                             [TBXML valueOfAttributeNamed:@"image" forElement:element],
                             [TBXML valueOfAttributeNamed:@"url" forElement:element],
                             [TBXML textForElement:element],nil]];
        }
    } while ((element = element->nextSibling));
}


@end
