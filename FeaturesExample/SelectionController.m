//
//  SelectionController.m
//  FeaturesExample
//

#import "SelectionController.h"
#import "IIViewDeckController.h"
#import "ScheduleController.h"
#import "MapController.h"
#import "FoodController.h"
#import "InformationController.h"

@implementation SelectionController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:
                                              [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menubtn.png"] style:UIBarButtonItemStyleDone target:self action:@selector(showSelector)],
                                              nil];
    
    self.navigationItem.title = @"Schedule";
}

- (void)back {
    [self.viewDeckController closeLeftView];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showSelector {
    [self.viewDeckController toggleLeftViewAnimated:YES];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIImage *myImage = [UIImage imageNamed:@"gflogo.png"];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
	imageView.frame = CGRectMake(10,10,300,100);
    
    UILabel* label = [[UILabel alloc] initWithFrame:(CGRect) { 10, 0, 80, 100 }];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:47/255.0f green:101/255.0f blue:176/255.0f alpha:1];
    label.opaque = NO;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    label.text = @"SLC Greek Festival";
    label.shadowColor = [UIColor colorWithRed:47/255.0f green:101/255.0f blue:176/255.0f alpha:1];
    label.shadowOffset = (CGSize) { 0, -1 };
    
    UIView* view = [[UIView alloc] initWithFrame:(CGRect) { 0, 0, 100, 100 }];
    [view addSubview:label];
    view.backgroundColor = [UIColor colorWithRed:47/255.0f green:101/255.0f blue:176/255.0f alpha:1];
    view.opaque = NO;
    
    return view;
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
    cell.textLabel.text = indexPath.row == 0 ? @"Schedule" : indexPath.row == 1 ? @"Food" : @"Coupon";
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            self.viewDeckController.centerController = [[ScheduleController alloc] initWithNibName:@"ScheduleController" bundle:nil];
                self.navigationItem.title = @"Schedule";
            break;
        case 1:
            self.viewDeckController.centerController = [[FoodController alloc] initWithNibName:@"FoodController" bundle:nil];
            self.navigationItem.title = @"Food";
            break;
        case 2:
            self.viewDeckController.centerController = [[InformationController alloc] initWithNibName:@"InformationController" bundle:nil];
            self.navigationItem.title = @"Coupon";
            break;
    }
    [self showSelector];
}

@end
