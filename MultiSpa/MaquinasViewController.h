//
//  MaquinasViewController.h
//  MultiSpa
//
//  Created by MacUser on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STControls.h"

@interface MaquinasViewController : UIViewController{
    
    IBOutlet UIWebView *videoView;
    NSString *videoURL;
    NSString *videoHTML;
    
}

@property (strong, nonatomic) IBOutlet STComboText *machineComboText;
@property (strong, nonatomic) NSString *selectedKey;
@property (strong, nonatomic) NSArray *machinesArray;
@property (strong, retain) IBOutlet UIWebView *videoView;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) IBOutlet UILabel *msgSelectNumberMachine;
@property (nonatomic, strong) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) IBOutlet UILabel *name;


- (void) embedYouTube;

@end
