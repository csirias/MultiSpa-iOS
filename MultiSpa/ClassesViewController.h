//
//  ClassesViewController.h
//  MultiSpa
//
//  Created by MacUser on 7/25/12.
//  Copyright (c) 2012 Pernix Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STControls.h"
#import "EasyTableView.h"
#import "Classes.h"
#import "DatabaseManager.h"
#import "JSONparser.h"

#define kClassDaysButtons                5000 //First Day button
#define kClassCellHorizontalTableViewTag 4000
#define kClassCellImageViewTag           3000
#define kClassCellTitleTag               3001
#define kSections                        3

@interface ClassesViewController : UIViewController <EasyTableViewDelegate, STComboTextDelegate,UITextFieldDelegate>
{
    UITableView *tableView;
    EasyTableView* easyTableView[3];
    NSArray *details;
}

@property (strong, nonatomic) NSString *selectedKey;
@property (strong, nonatomic) NSArray *schedules;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DatabaseManager *DBManager;
@property (strong, nonatomic) JSONparser *jParser;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction)selectDay:(id)sender;
- (IBAction)swipeRight:(id)sender;
- (IBAction)swipeLeft:(id)sender;
- (IBAction)share:(id)sender;
@end
