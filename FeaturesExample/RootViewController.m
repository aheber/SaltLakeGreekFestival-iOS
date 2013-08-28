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
#define SCROLL_INT 10.0
#define AWS_URL @"http://slcgreekfestival.s3-website-us-west-2.amazonaws.com";

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
NSString *cachesDirectory;
NSOperationQueue *imageOperationQueue;


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
    imageOperationQueue = [[NSOperationQueue alloc]init];
    imageOperationQueue.maxConcurrentOperationCount = 2;
    
    [self downloadAds:@"sponsors.xml"];
    [self downloadAds:@"food.xml"];
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

# pragma mark - ads

- (BOOL) downloadAds:(NSString *)catptureURL {
    
    NSString *stringURL = [NSString stringWithFormat:@"http://%@/%@",@"slcgreekfestival.s3-website-us-west-2.amazonaws.com", catptureURL];
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        cachesDirectory = [paths objectAtIndex:0];
        NSString  *filePath = [cachesDirectory stringByAppendingPathComponent:catptureURL];
        [urlData writeToFile:filePath atomically:YES];
    }
    return true;
}

- (void) adTouched:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSURL *url = [NSURL URLWithString:[[ads objectAtIndex:[button tag]] objectAtIndex:1]];
    [[UIApplication sharedApplication] openURL:url];
    
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
        [Page setTag:i];
        [Page addTarget:self
                   action:@selector(adTouched:)
         forControlEvents:UIControlEventTouchUpInside];
        NSString *nameExt = [NSString stringWithFormat:@"%@.png",[[ads objectAtIndex:i] objectAtIndex:0]];
        NSData *imgData;
        UIImage *btnImage;
        NSString* cachedImg = [cachesDirectory stringByAppendingPathComponent:nameExt];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:cachedImg];
        if(fileExists){
            imgData = [[NSFileManager defaultManager] contentsAtPath:cachedImg];
            btnImage = [UIImage imageWithData:imgData];
            
            [Page setImage:btnImage forState:UIControlStateNormal];
            [_scrollView addSubview:Page];
        } else {
            //Image not yet cached
            NSString *filePath = [[NSBundle mainBundle] pathForResource:[[ads objectAtIndex:i] objectAtIndex:0] ofType:@"png"];
            imgData = [NSData dataWithContentsOfFile:filePath];
            btnImage = [UIImage imageWithData:imgData];
            
            [Page setImage:btnImage forState:UIControlStateNormal];
            [_scrollView addSubview:Page];
            
            // Add an operation as a block to a queue
            [imageOperationQueue addOperationWithBlock: ^ {
                // a block of operation
                [self downloadAds:nameExt];
                if([[NSFileManager defaultManager] fileExistsAtPath:cachedImg]){
                    // Get hold of main queue (main thread)
                    [[NSOperationQueue mainQueue] addOperationWithBlock: ^ {
                        [Page setImage:[UIImage imageWithData:[[NSFileManager defaultManager] contentsAtPath:cachedImg]] forState:UIControlStateNormal];
                    }];
                }
            }];
        }
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*[ads count], _scrollView.frame.size.height);
}

#pragma mark - XML Parser

- (void)loadAds{
    NSError *myError = nil;
    NSData *xmlData;
    NSString* cachedXML = [cachesDirectory stringByAppendingPathComponent:@"sponsors.xml"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:cachedXML];
    if (fileExists){
        xmlData = [[NSFileManager defaultManager] contentsAtPath:cachedXML];
    }else{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sponsors" ofType:@"xml"];
        xmlData = [NSData dataWithContentsOfFile:filePath];
    }
    
    TBXML *tbxml = [TBXML newTBXMLWithXMLData:xmlData error:&myError];
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
