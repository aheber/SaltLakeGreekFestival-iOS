//
//  ScheduleController.m
//  FeaturesExample
//

#import "ScheduleController.h"
#import "TBXML.h"

@implementation ScheduleController


NSMutableDictionary *schedule;
NSMutableArray *currentDay;
NSMutableArray *days;
UIButton *lastButton;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    schedule = [[NSMutableDictionary alloc]initWithCapacity:4];
    [self loadSchedule];
    currentDay = [schedule objectForKey:@"friday"];
    _fridayBtn.enabled = NO;
    lastButton = _fridayBtn;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currentDay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%-8@ - %@",[[currentDay objectAtIndex: indexPath.row] objectAtIndex:1],[[currentDay objectAtIndex: indexPath.row] objectAtIndex:0]];
    return cell;
}

- (IBAction)clickButton:(id)sender {
    UIButton *pressed = (UIButton *)sender;
    pressed.enabled = NO;
    if(lastButton != nil)
        lastButton.enabled = YES;
    lastButton = pressed;
    currentDay = [schedule objectForKey:[pressed.currentTitle lowercaseString]];
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [self setFridayBtn:nil];
    [super viewDidUnload];
}

#pragma mark - XML Parser

- (void)loadSchedule {
    NSError *myError = nil;
    
    NSData *xmlData;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    
    NSString* cachedXML = [cachesDirectory stringByAppendingPathComponent:@"schedule.xml"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:cachedXML];
    if (fileExists){
        xmlData = [[NSFileManager defaultManager] contentsAtPath:cachedXML];
    }else{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"schedule" ofType:@"xml"];
        xmlData = [NSData dataWithContentsOfFile:filePath];
    }
    
    TBXML *tbxml = [TBXML newTBXMLWithXMLData:xmlData error:&myError];
    
    currentDay = [[NSMutableArray alloc] init];
    if (tbxml.rootXMLElement)
        [self traverseElement:tbxml.rootXMLElement];
}

- (void) traverseElement:(TBXMLElement *)element {
    do {
        if (element->firstChild)
            [self traverseElement:element->firstChild];
        if ([[TBXML elementName:element] isEqualToString:@"event"]) {
            [currentDay addObject:[NSArray arrayWithObjects:
                                [TBXML valueOfAttributeNamed:@"name" forElement:element],
                                [TBXML valueOfAttributeNamed:@"time" forElement:element],
                                [TBXML valueOfAttributeNamed:@"location" forElement:element],
                                [TBXML textForElement:element],nil]];
        }
        
        if ([[TBXML elementName:element] isEqualToString:@"day"]) {
            [days addObject:[[TBXML valueOfAttributeNamed:@"name" forElement:element] lowercaseString]];
            [schedule setObject:currentDay forKey:[[TBXML valueOfAttributeNamed:@"name" forElement:element] lowercaseString]];
            currentDay = [[NSMutableArray alloc] init];
        }
    } while ((element = element->nextSibling));
}

@end
