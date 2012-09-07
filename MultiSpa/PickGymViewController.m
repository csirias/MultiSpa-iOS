//
//  PickGymViewController.m
//  MultiSpa
//
//  Created by MacUser on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PickGymViewController.h"
#import "DatabaseManager.h"
#import "SHK.h"

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
- (IBAction)share:(id)sender {
	SHKItem *item = [SHKItem URL:[NSURL URLWithString:@"http://www.grupomultispa.com/"] title:@"Gimnasios Multispa" contentType:(SHKURLContentTypeUndefined)];
    //SHKItem *item = [SHKItem URL:[NSURL URLWithString:@"http://www.youtube.com/watch?v=3t8MeE8Ik4Y"] title:@"Big bang" contentType:SHKURLContentTypeVideo];
    item.facebookURLSharePictureURI = @"http://www.grupomultispa.com/sites/all/themes/multispa/logo.png";
    item.facebookURLShareDescription = @"Somos centros de entrenamiento específico MULTISPA con más de 25 años de experiencia. Nuestros centros promocionan la salud y el ejercicio y buscan motivar, educar e inspirar a las personas de todas las edades a vivir un estilo de vida saludable en un ambiente agradable.";
    //item.mailToRecipients = [NSArray arrayWithObjects:@"frodo@middle-earth.me", @"gandalf@middle-earth.me", nil];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [SHK setRootViewController:self];
	[actionSheet showFromToolbar:self.navigationController.toolbar]; 
}
@end
