//
//  RootViewController.h
//  FeaturesExample
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIScrollViewDelegate>
{
    int h;
}

@property (nonatomic, retain) IBOutlet UIView* choiceView;
@property (nonatomic, retain) IBOutlet UIView* panningView;
@property (nonatomic, retain) UINavigationController* navController;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@end
