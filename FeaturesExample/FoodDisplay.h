//
//  FoodDisplay.h
//  SLCGreekFestival
//
//  Created by Anthony Heber on 8/23/13.
//  Copyright (c) 2013 Adriaenssen BVBA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FoodDisplay;

@protocol FoodDisplayDelegate
- (void)foodDisplayDidFinish:(FoodDisplay*)foodDisplay;
@end

@interface FoodDisplay : UIViewController {
    id<FoodDisplayDelegate> delegate;
    NSMutableArray<FoodDisplayDelegate> *food;
}

@property (retain) id<FoodDisplayDelegate> delegate;
@property (retain) NSMutableArray<FoodDisplayDelegate> *food;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItemThing;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *description;
- (IBAction)close:(id)sender;

@end

