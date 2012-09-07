//
//  PickGymViewController.m
//  MultiSpa
//
//  Created by MacUser on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PickGymViewController.h"
#import "DatabaseManager.h"

@interface PickGymViewController ()

@end

@implementation PickGymViewController
@synthesize gymPicker;
@synthesize gymsArray;
@synthesize selectedKey;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DatabaseManager *dbManager = [[DatabaseManager alloc] init];
    [dbManager CopyDbToDocumentsFolder];
    
    gymsArray = [dbManager getGyms];
    if(gymsArray)
        self.selectedKey = [gymsArray objectAtIndex:0];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setGymPicker:nil];
    [self setGymsArray:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"] || [[[UIDevice currentDevice] model] isEqualToString:@"iPad Simulator"]) 
    {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
    else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}


- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *) pickerView 
{
    return 1;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedKey = [self.gymsArray objectAtIndex:row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.gymsArray objectAtIndex:row];
}

- (NSInteger)pickerView: (UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.gymsArray count];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(![[segue identifier] compare:@"pushGym"])
    {
        UITabBarController *tb = [segue destinationViewController];
        tb.title = self.selectedKey;
    }
}
@end
