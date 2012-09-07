//
//  PickGymViewController.h
//  MultiSpa
//
//  Created by MacUser on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassesViewController.h"

@interface PickGymViewController : UIViewController <UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *gymPicker;
@property (strong, nonatomic) NSArray *gymsArray;
@property (strong, nonatomic) NSString *selectedKey;
- (IBAction)share:(id)sender;

@end
