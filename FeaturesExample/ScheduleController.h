//
//  ScheduleController.h
//  FeaturesExample
//

#import <UIKit/UIKit.h>

@interface ScheduleController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)clickButton:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *fridayBtn;

@end
