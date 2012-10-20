//
//  ClassesViewController.m
//  MultiSpa
//
//  Created by MacUser on 7/25/12.
//  Copyright (c) 2012 Pernix Solutions. All rights reserved.
//

#import "ClassesViewController.h"
#import "DatabaseManager.h"
#import "SHK.h"
#import "JSONparser.h"

static NSUInteger multiSpaTableViewHeight = 70;
static NSUInteger multiSpaTableViewWidth  = 100;

static BOOL is_ipad()
{
    return [[[UIDevice currentDevice] model] isEqualToString:@"iPad"] || [[[UIDevice currentDevice] model] isEqualToString:@"iPad Simulator"];
}

@interface ClassesViewController ()
@property (nonatomic, readonly, strong) NSArray* details;
- (EasyTableView*)setupEasyTableViewWithNumCells:(NSUInteger)count;
@end

@implementation ClassesViewController
{
    NSUInteger selectedColumn;
    NSArray*   selectedData;
    NSMutableArray *daysOfWeeek;
    NSInteger selectedDay;
    NSDictionary *images;
}

@synthesize tableView;
@synthesize selectedKey = _selectedKey;
@synthesize schedules = _schedules;
@synthesize DBManager;
@synthesize jParser;
@synthesize shareButton;

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
    NSDate *today = [NSDate date];
    [self setSelectedDay:[self getEuropeanWeekDay:today]];
    
    daysOfWeeek = [self getDaysOfWeek:today];
    
    self.DBManager = [[DatabaseManager alloc] init];
    self.jParser = [[JSONparser alloc] init];
  //  [self.DBManager CopyDbToDocumentsFolder];
    
    //   [dbManager CopyDbToDocumentsFolder];   // No vuelve a copiar la base de documentos, usa la local
    
//    if ([DBManager getShare]) {
//        shareButton.hidden = TRUE;
//    };
    
    images = [self.jParser getClassesImages];
    
    self.selectedKey = [self.tabBarController title];
    
    [self reloadTable];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setDBManager:nil];
    [self setShareButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"] || [[[UIDevice currentDevice] model] isEqualToString:@"iPad Simulator"]) 
    {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
    else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

#pragma mark - build Details
- (NSArray*)details
{
    NSError* error;
    if(details)
        return details;
    
    details = [self separateBySchedule:[self.jParser getWeekClassesFromGym:self.selectedKey]];
    
    [self getClassesByDay:[daysOfWeeek objectAtIndex:selectedDay] andLocal:self.selectedKey];
    [self getClassesTypes:details];
    
    if(error)
    {
        NSLog(@"Error: %@", error);
        return [NSArray array]; // This should do something more constructive
    }
    
    return details;
}

#pragma mark - ComboBox

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    if([textField isKindOfClass:[STComboText class]]) {
//        [(STComboText*)textField showOptions];
//        return NO;
//    }
//    return YES;
//}
//
//- (NSString*)stComboText:(STComboText*)stComboText textForRow:(NSUInteger)row  {
//    return [self.gymsArray objectAtIndex:row];
//}
//
//- (NSInteger)stComboText:(STComboText*)stComboTextNumberOfOptions {
//    return [self.gymsArray count];
//}
//
//- (void)stComboText:(STComboText*)stComboText didSelectRow:(NSUInteger)row {
//    self.gymComboText.text=self.selectedKey=[self.gymsArray objectAtIndex:row];
//    
//    [self reloadTable];
//}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    for(int i = 0; i < kSections; i++)
    {
        CGRect frame = easyTableView[i].frame;
        frame.size.width = self.view.bounds.size.width;
        easyTableView[i].frame = frame;
    }
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView*)tv numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return kSections;
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return is_ipad() ? 142.0f : 78.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* sections[3] = { NSLocalizedString(@"Mañana", @""), NSLocalizedString(@"Tarde", @""), NSLocalizedString(@"Noche", @"") };
    return sections[section];
}

- (UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tv titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, -5, 300, 40);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHue:(136.0/360.0)  // Slightly bluish green
                                 saturation:1.0
                                 brightness:0.60
                                      alpha:1.0];
    label.textColor = [UIColor blackColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    // Create images for sections
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tv.bounds.size.width, 15)];
    imageView.image = [UIImage imageNamed:@"top.png"];
    
    UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,20, tv.bounds.size.width, 15)];
    bottomImageView.image = [UIImage imageNamed:@"bottom.png"];
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
    [view addSubview:imageView];
    [view addSubview:bottomImageView];
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell*)tableView:(UITableView*)tv cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* kNewsCellIdentifier = @"itemCell";
    UITableViewCell* cell = [tv dequeueReusableCellWithIdentifier:kNewsCellIdentifier];
    
    UIView* v = [cell.contentView viewWithTag:kClassCellHorizontalTableViewTag];
    [v removeFromSuperview];
    

    NSMutableArray *forData = [NSMutableArray array];
    for (NSString *type in [_schedules objectAtIndex:indexPath.section]) {
        [forData addObject:[self getClassesByType:type schedule:indexPath.section]];
    }
    
    EasyTableView* et = [self setupEasyTableViewWithNumCells:[forData count]];
    easyTableView[indexPath.section] = et;
    
    easyTableView[indexPath.section].data = forData;
    
    if ([DBManager getShare] == 0 && indexPath.section == 2)
    {
     //   [cell.contentView addSubview:shareButton];
        shareButton.hidden = FALSE;
    }
    else {
        shareButton.hidden = TRUE;
        [cell.contentView addSubview:easyTableView[indexPath.section]];
    }
    return cell;
}

#pragma mark - easyTableView

- (EasyTableView*)setupEasyTableViewWithNumCells:(NSUInteger)count
{
    EasyTableView *view;
    CGRect frameRect;
    if(is_ipad())
    {
        frameRect                  = CGRectMake(10, 10, self.view.bounds.size.width, 300);
        view                       = [[EasyTableView alloc] initWithFrame:frameRect numberOfColumns:count ofWidth:170];
    }
    else
    {
        frameRect                  = CGRectMake(10, 10, self.view.bounds.size.width - 20, multiSpaTableViewHeight);
        view                       = [[EasyTableView alloc] initWithFrame:frameRect numberOfColumns:count ofWidth:multiSpaTableViewWidth];
    }

    view.tag                       = kClassCellHorizontalTableViewTag;
	view.delegate                  = self;
	view.tableView.backgroundColor = [UIColor clearColor];
	view.tableView.separatorColor  = [UIColor clearColor];
	//view.cellBackgroundColor       = [UIColor blackColor];
	view.autoresizingMask          = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    return view;
}

- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect
{
    UIView* container = [[UIView alloc] initWithFrame:rect];
    
    CGRect imageViewRect = CGRectMake(19, 4, 64, 64);
    if(is_ipad())
        imageViewRect = CGRectMake(19, 4, 140, 130);
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:imageViewRect];
    imageView.tag = kClassCellImageViewTag;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [container addSubview:imageView];
    
    UILabel* titleLabel = nil;
    if(is_ipad())
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 67, 140, 67)];
        titleLabel.numberOfLines = 3;
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    else
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 34, 66, 36)];
        titleLabel.numberOfLines = 2;
        titleLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    titleLabel.tag = kClassCellTitleTag;
    //titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.shadowColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.01];
    [container addSubview:titleLabel];
    
    return container;
}


- (void)easyTableView:(EasyTableView *)et setDataForView:(UIView *)view forIndex:(NSUInteger)index;
{
    UIImageView* imageView = (UIImageView*)[view viewWithTag:kClassCellImageViewTag];
   
    
    UILabel *titleLabel = (UILabel*)[view viewWithTag:kClassCellTitleTag];
    titleLabel.text = [[et.data objectAtIndex:index] objectAtIndex:0];
    UIImage *image = [images objectForKey:titleLabel.text];
    if(image == nil) {
        images = [self.jParser getClassesImages];
        image = [images objectForKey:titleLabel.text];
    }
    imageView.image = image;
}


- (void)easyTableView:(EasyTableView *)et selectedView:(UIView *)selectedView atIndex:(NSUInteger)index deselectedView:(UIView *)deselectedView
{
    selectedColumn = index;
    selectedData = et.data;
    NSString *title = [[selectedData objectAtIndex:index] objectAtIndex:0];
    NSArray *classes = [[selectedData objectAtIndex:index] objectAtIndex:1];
    NSString *message = [NSString stringWithString:@""];
    
    for (Classes *class in classes) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh':'mm a"];
        NSDate *start = [class date];
        NSDate *end = [start dateByAddingTimeInterval:[[class duration] intValue]*60];
        NSString *startWithFormat = [formatter stringFromDate:start];
        NSString *endWithFormat = [formatter stringFromDate:end];
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"Instructor: %@\nInicia: %@\nTermina: %@ \n\n",[class instructor],startWithFormat,endWithFormat]];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    NSArray *subviews = [alertView subviews];
    for(UIView *subview in subviews)
    {
        if([[subview class] isSubclassOfClass:[UILabel class]])
        {
            ((UILabel*)subview).textAlignment = UITextAlignmentLeft;
        }
    }
    [alertView show];
}

- (void)reloadTable {
    [self getClassesByDay:[daysOfWeeek objectAtIndex:selectedDay] andLocal:self.selectedKey];
    [self getClassesTypes:details];
    [tableView reloadData];
}

#pragma mark - List of Classes
 
- (NSArray *) getClassesByType: (NSString *) pName schedule: (NSInteger) pSchedule
{
    NSMutableArray *res = [NSMutableArray arrayWithObjects:pName, [NSMutableArray array], nil];
    for (Classes *class in [details objectAtIndex:pSchedule]) {
        if (![[class name] compare:pName]) {
            [[res objectAtIndex:1] addObject:class];
        }
    }
    return res;
}

- (NSArray *)getClassesTypes: (NSArray *)pClasses
{
    NSMutableArray *res = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], nil];
    for (int i =0; i< [pClasses count] ; i++) {
        for (Classes *class in [pClasses objectAtIndex:i]) {
            if(![[res objectAtIndex:i] containsObject:[class name]])
            {
                [[res objectAtIndex:i] addObject:[class name]];
            }
        }
    }
    _schedules = res;
    return res;
}

- (NSArray*) separateBySchedule:(NSArray *)pClasses
{
    NSMutableArray *ret = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], nil];
    
    for (Classes *class in pClasses) {
        if(![[class schedule] compare:@"mañana"])
        {
            [[ret objectAtIndex:0] addObject:class];
        }
        else if (![[class schedule] compare:@"tarde"]) {
            [[ret objectAtIndex:1] addObject:class];
        }
        else if (![[class schedule] compare:@"noche"])
        {
            [[ret objectAtIndex:2] addObject:class];
        }
    }
    return ret;
}

#pragma mark - utils

- (NSInteger)getEuropeanWeekDay:(NSDate *)pDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:pDate];
    NSInteger weekday = [comps weekday];
    NSInteger europeanWeekday = ((weekday + 5) % 7) + 1;
    return europeanWeekday;
}

- (NSMutableArray*) getDaysOfWeek:(NSDate *)date
{
    int secsPerDay = 86400;
    
    int europeanWeekday;
    europeanWeekday = [self getEuropeanWeekDay:date];
    
    NSMutableArray *daysOfWeek = [NSMutableArray arrayWithCapacity:7];
    
    for (int i = 0; i<7; i++) {
        if (i==europeanWeekday) {
            ;
        }
        NSDate *day = [NSDate dateWithTimeIntervalSinceNow:(i - europeanWeekday)*secsPerDay];
        [daysOfWeek addObject:day];
    }
    
    return daysOfWeek;
}

- (NSArray*) getClassesByDay:(NSDate *)pDay andLocal:(NSString *)pGym
{
    details = [self separateBySchedule:[self.jParser getWeekClassesFromGym:self.selectedKey]];
    
    NSMutableArray *res = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], nil];
    for( int i = 0; i < kSections; i++)
    {
        for(Classes *class in [details objectAtIndex:i])
        {
            if([self isSameDay:[class date] otherDay:[daysOfWeeek objectAtIndex:selectedDay]] && ![[class gym] compare:pGym])
            {
                [[res objectAtIndex:i] addObject:class];
            }
        }
    }
    details = res;
    return res;
}

- (void) paintDay: (NSInteger)pDay
{
    UIButton *button = [UIButton alloc];
    for(int i = 0; i<7; i++)
    {
        button = (UIButton*)[self.view viewWithTag:kClassDaysButtons+i];
        if (i==pDay) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else {
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
    }
}

- (void)setSelectedDay:(NSInteger)pNewDay {
    selectedDay = pNewDay;
    [self paintDay:selectedDay];
}

- (BOOL)isSameDay:(NSDate*)date1 otherDay:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

#pragma mark - IBActions



- (IBAction)selectDay:(id)sender {
    
    NSString *buttonPressed = [sender currentTitle];
    NSInteger newDay;
    
    if(![buttonPressed compare:@"D"])
        newDay = 0;
    else if (![buttonPressed compare:@"L"]) {
        newDay = 1;
    }
    else if (![buttonPressed compare:@"M"]) {
        newDay = 2;
    }
    else if (![buttonPressed compare:@"K"]) {
        newDay = 3;
    }
    else if (![buttonPressed compare:@"J"]) {
        newDay = 4;
    }
    else if (![buttonPressed compare:@"V"]) {
        newDay = 5;
    }
    else if (![buttonPressed compare:@"S"]) {
        newDay = 6;
    }
    
    [self setSelectedDay:newDay];
    
    [self reloadTable];
}


- (IBAction)swipeRight:(id)sender {
    NSInteger newDay = ++selectedDay % 7;
    
    [self setSelectedDay:newDay];
    
    [self reloadTable];
}

- (IBAction)swipeLeft:(id)sender {
    NSInteger newDay;
    if(selectedDay > 0)
        newDay = selectedDay-1 % 7;
    else {
        newDay = 6;
    }
    
    [self setSelectedDay: newDay];
   
    [self reloadTable];
}

- (IBAction)share:(id)sender {
    SHKItem *item = [SHKItem URL:[NSURL URLWithString:@"http://www.grupomultispa.com/"] title:@"Gimnasios Multispa" contentType:(SHKURLContentTypeWebpage)];
    item.facebookURLSharePictureURI = @"http://www.grupomultispa.com/sites/all/themes/multispa/logo.png";
    item.facebookURLShareDescription = @"Somos centros de entrenamiento específico MULTISPA con más de 25 años de experiencia. Nuestros centros promocionan la salud y el ejercicio y buscan motivar, educar e inspirar a las personas de todas las edades a vivir un estilo de vida saludable en un ambiente agradable.";
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [SHK setRootViewController:self];
	[actionSheet showFromToolbar:self.navigationController.toolbar];
    
    DatabaseManager *dbManager = [[DatabaseManager alloc] init];
    
    [dbManager setShare:1];
    [self reloadTable];
}

@end
