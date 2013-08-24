//
//  FoodDisplay.m
//  SLCGreekFestival
//
//  Created by Anthony Heber on 8/23/13.
//  Copyright (c) 2013 Adriaenssen BVBA. All rights reserved.
//

#import "FoodDisplay.h"

@interface FoodDisplay ()

@end

@implementation FoodDisplay
@synthesize delegate;
@synthesize food;
@synthesize navigationItemThing;
@synthesize picture;
@synthesize price;
@synthesize location;
@synthesize description;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage *navBackgroundImage = [UIImage imageNamed:@"navbar_bg"];
        [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
        
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                                               [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,
                                                               [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                                               UITextAttributeTextShadowOffset,
                                                               [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], UITextAttributeFont, nil]];
    }
    return self;
}

- (IBAction)close:(id)sender{
    [delegate foodDisplayDidFinish:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.navigationItem.title = [food objectAtIndex:1];
    navigationItemThing.title = [food objectAtIndex:1];
    [picture setImage:[UIImage imageNamed:[[food objectAtIndex:0] lowercaseString]]];
    [price setText:[food objectAtIndex:2]];
    [location setText:[food objectAtIndex:3]];
    [description setText:[food objectAtIndex:4]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNavigationItemThing:nil];
    [self setPicture:nil];
    [self setPrice:nil];
    [self setLocation:nil];
    [self setDescription:nil];
    [super viewDidUnload];
}
@end
