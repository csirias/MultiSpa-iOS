//
//  MaquinasViewController.m
//  MultiSpa
//
//  Created by MacUser on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MaquinasViewController.h"
#import "DatabaseManager.h"
#import "Machine.h"

@interface MaquinasViewController ()

@end

@implementation MaquinasViewController
{
    DatabaseManager *DBManager;
    NSInteger selectedMachine;
}

@synthesize machineComboText;
@synthesize machinesArray;
@synthesize videoView;
@synthesize image;
@synthesize description;
@synthesize msgSelectNumberMachine;
@synthesize scroller;
@synthesize name;
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
	// Do any additional setup after loading the view.
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 900)];
    
    DBManager = [[DatabaseManager alloc] init];
    [DBManager CopyDbToDocumentsFolder];
    selectedKey = [self.tabBarController title];
    
    machinesArray = [DBManager getMachinesForGym:selectedKey];
    if([machinesArray count] == 0)
        selectedMachine = -1;
    else
        selectedMachine = 0;
    [self loadMachine:selectedMachine];
    
    //videoURL = @"http://www.youtube.com/watch?v=D3cgi36sY-k";
    //[self embedYouTube];
}

- (void)viewDidUnload
{
    [self setMachineComboText:nil];
    [self setVideoView:nil];
    [self setImage:nil];
    [self setDescription:nil];
    [self setMsgSelectNumberMachine:nil];
    [self setScroller:nil];
    [self setName:nil];
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

#pragma mark - ComboBox
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([textField isKindOfClass:[STComboText class]]) {
        [(STComboText*)textField showOptions];
        return NO;
    }
    return YES;
}

- (NSString*)stComboText:(STComboText*)stComboText textForRow:(NSUInteger)row  {
    NSInteger number = [[[self.machinesArray objectAtIndex:row] number] intValue];
    return [NSString stringWithFormat:@"%d", number];
}

- (NSInteger)stComboText:(STComboText*)stComboTextNumberOfOptions {
    return [self.machinesArray count];
}

- (void)stComboText:(STComboText*)stComboText didSelectRow:(NSUInteger)row {
    selectedMachine = row;
    [self loadMachine:selectedMachine];
    self.machineComboText.text=self.selectedKey=[NSString stringWithFormat:@"%d",[[[self.machinesArray objectAtIndex:row] number] intValue]];
}

#pragma mark - YouTube

- (void)embedYouTube {
    
    videoHTML = [NSString stringWithFormat:@"\
                 <html>\
                 <head>\
                 <style type=\"text/css\">\
                 iframe {position:absolute; top:50%%; margin-top:-130px;}\
                 body {background-color:#000; margin:0;}\
                 </style>\
                 </head>\
                 <body>\
                 <iframe width=\"100%%\" height=\"240px\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                 </body>\
                 </html>", videoURL];
    
    [videoView loadHTMLString:videoHTML baseURL:nil];
}

#pragma mark - utils

-(void) loadMachine: (NSInteger) pSelectedMachine
{
    if (pSelectedMachine != -1) {
        Machine *machine = [self.machinesArray objectAtIndex:pSelectedMachine];
        
        videoURL = [machine videoURL];
        self.machineComboText.text = [NSString stringWithFormat:@"%d",[[machine number] intValue]];
        [self.image setImage:[machine image]];
        self.description.text = [machine description];
        [self embedYouTube];
        self.name.text = [machine name];
    }
    else {
        self.description.text = @"No hay Maquinas disponibles para este Gimnasio.";
        [self.machineComboText setHidden:YES];
        [self.msgSelectNumberMachine setHidden:YES];
        [self.name setHidden:YES];
    }
    
}
@end
