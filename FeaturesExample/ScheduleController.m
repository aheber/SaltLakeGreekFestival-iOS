//
//  ScheduleController.m
//  FeaturesExample
//

#import "ScheduleController.h"

@implementation ScheduleController


NSDictionary *schedule;
NSArray *currentDay;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *keys = [NSArray arrayWithObjects:@"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
    NSArray *thursday = [NSArray arrayWithObjects:@"5:00 PM - Ribbon Cutting", @"5:00 PM - Dionysios Dancers", @"6:00 PM - Olympian Dancers", @"6:30 PM - Athenian Dancers", @"7:00 PM - Parthenon Dancers", @"7:30 PM - Olympian Dancers", @"5:00 PM Dionysios Dancers", @"5:00 PM Dionysios Dancers", nil];
    NSArray *friday = [NSArray arrayWithObjects:@"value3", @"value4", nil];
    NSArray *saturday = [NSArray arrayWithObjects:@"value5", @"value6", nil];
    NSArray *sunday = [NSArray arrayWithObjects:@"value7", @"value8", nil];
    
    NSArray *days = [NSArray arrayWithObjects:thursday, friday, saturday, sunday, nil];
    schedule = [NSDictionary dictionaryWithObjects:days forKeys:keys];
    currentDay = thursday;
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
    
    // Configure the cell0.0.0.0
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [currentDay objectAtIndex: indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (IBAction)clickButton:(id)sender {
    UIButton *pressed = (UIButton *)sender;
    currentDay = [schedule objectForKey:pressed.currentTitle];
    [self.tableView reloadData];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
