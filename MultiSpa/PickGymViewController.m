//
//  PickGymViewController.m
//  MultiSpa
//
//  Created by MacUser on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PickGymViewController.h"
#import "DatabaseManager.h"
#import "JSONparser.h"
#import "SHK.h"

@interface PickGymViewController ()

@end

@implementation PickGymViewController
@synthesize gymPicker;
@synthesize gymsArray;
@synthesize selectedKey;
@synthesize textView;

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
    
    
    //DatabaseManager *dbManager = [[DatabaseManager alloc] init];
    //gymsArray = [dbManager getGyms];
    JSONparser *jParser = [[JSONparser alloc] init];
    gymsArray = [jParser getGymsArray];
    if(gymsArray)
        self.selectedKey = [gymsArray objectAtIndex:0];
}

- (void)viewDidUnload
{
    [self setGymPicker:nil];
    [self setGymsArray:nil];
    [self setTextView:nil];
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

+ (NSString*) copyResourceFileToDocuments:(NSString*)fileName withExt:(NSString*)fileExt
{
    //Look at documents for existing file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, fileExt]];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:path])
    {
        NSError *nError;
        [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:fileName ofType:fileExt] toPath:path error:&nError];
    }
    
    return path;
}


- (IBAction)share:(id)sender {
	SHKItem *item = [SHKItem URL:[NSURL URLWithString:@"http://www.grupomultispa.com/"] title:@"Gimnasios Multispa" contentType:(SHKURLContentTypeUndefined)];
    item.facebookURLSharePictureURI = @"http://www.grupomultispa.com/sites/all/themes/multispa/logo.png";
    item.facebookURLShareDescription = @"Somos centros de entrenamiento específico MULTISPA con más de 25 años de experiencia. Nuestros centros promocionan la salud y el ejercicio y buscan motivar, educar e inspirar a las personas de todas las edades a vivir un estilo de vida saludable en un ambiente agradable.";
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [SHK setRootViewController:self];
	[actionSheet showFromToolbar:self.navigationController.toolbar];
    
    DatabaseManager *dbManager = [[DatabaseManager alloc] init];
    
    [dbManager setShare:1];
    NSLog(@"edit: %d",[dbManager getShare]);
}
@end
