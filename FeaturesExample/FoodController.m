//
//  FoodController.m
//  FeaturesExample
//

#import "FoodController.h"
#import "FoodDisplay.h"
#import "IIViewDeckController.h"
#import "TBXML.h"

@implementation FoodController


NSMutableArray *food;
int FOODPERROW = 3;
int FOODIMGSIZE = 80;
int padding;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int lCurrentWidth = self.view.frame.size.width;
    padding = (lCurrentWidth- (FOODIMGSIZE*FOODPERROW))/(FOODPERROW+3);
    food = [[NSMutableArray alloc] init];
    [self loadFood];
    self.tableView.rowHeight = FOODIMGSIZE+padding;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UIResponder

-(void)imageTouched:(id)sender {
        UIButton *button = (UIButton *)sender;
        //Initialize the view controller
        FoodDisplay *fd = [[FoodDisplay alloc]initWithNibName:@"FoodDisplay" bundle:nil];
        fd.delegate = self;
        fd.food = [food objectAtIndex:[button tag]];
        fd.modalPresentationStyle =  UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:fd animated:YES];
    
    /*
    UIButton *button = (UIButton *)sender;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Today's Entry Complete"
                                                    message:[NSString stringWithFormat:@"Tag %d",[button tag]]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
     */
}

- (void)foodDisplayDidFinish:(FoodDisplay*)foodDisplay {
    // do whatever, then
    // hide the modal view
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"FOOD COUNT %i, ROW COUNT %f", [food count], (float)[food count]/FOODPERROW);
    return ceilf((float)[food count]/FOODPERROW);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    UIImage *btnImage = nil;
    for(int i=0; i<FOODPERROW;i++){
        if(([indexPath row]*FOODPERROW)+i<[food count]){
            NSLog(@"INT %i",([indexPath row]*FOODPERROW)+i);
            btnImage = [UIImage imageNamed:[[[food objectAtIndex:indexPath.row*FOODPERROW+i] objectAtIndex:0] lowercaseString]];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self
                       action:@selector(imageTouched:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"Show View" forState:UIControlStateNormal];
            button.frame = CGRectMake(padding*2 + ((FOODIMGSIZE+padding)*i), padding/2, FOODIMGSIZE, FOODIMGSIZE);
            
            [button setImage:btnImage forState:UIControlStateNormal];
            [button setTag:([indexPath row]*FOODPERROW)+i];
            [cell addSubview:button];
        }
    }
    
    
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - XML Parser

- (void)loadFood{
    NSError *myError = nil;
    TBXML *tbxml = [TBXML newTBXMLWithXMLFile:@"food" fileExtension:@"xml" error:&myError];
    
    if (tbxml.rootXMLElement)
        [self traverseElement:tbxml.rootXMLElement];
}

- (void) traverseElement:(TBXMLElement *)element {
    do {
        if (element->firstChild)
            [self traverseElement:element->firstChild];
        if ([[TBXML elementName:element] isEqualToString:@"food"]) {
            [food addObject:[NSArray arrayWithObjects:
                             [TBXML valueOfAttributeNamed:@"name" forElement:element],
                             [TBXML valueOfAttributeNamed:@"fullname" forElement:element],
                             [TBXML valueOfAttributeNamed:@"price" forElement:element],
                             [TBXML valueOfAttributeNamed:@"location" forElement:element],
                             [TBXML valueOfAttributeNamed:@"description" forElement:element],
                             [TBXML textForElement:element],nil]];
        }
    } while ((element = element->nextSibling));
}

@end
