//
//  DatabaseManager.h
//  MultiSpa
//
//  Created by MacUser on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Machine.h"

@interface DatabaseManager : NSObject

{
    NSInteger dataId;
    sqlite3 *db;
    NSFileManager *fileMgr;
    NSString *homeDir;
}
@property (nonatomic,retain) NSString *homeDir;
@property (nonatomic, assign) NSInteger dataId;
@property (nonatomic,retain) NSFileManager *fileMgr;

-(void)CopyDbToDocumentsFolder;
-(NSString *) GetDocumentDirectory;

-(void)InsertRecords:(int) news_id :(int) category_id:(NSMutableString *) newTitle:(NSMutableString *) newDetails:(NSMutableString *) newImage;
-(void)UpdateRecords:(NSString *)txt :(NSMutableString *) utxt;
-(void)DeleteRecords:(NSString *)txt;
-(Boolean)existNews:(int) news_id;
-(NSMutableArray *)getLocalNews;
-(NSMutableArray*) getHTMLFromCategory:(int)quantity:(int)category_id;
-(NSArray*) getClasses;
- (NSArray*) getClassesFromDay: (NSDate *)pDate toDay:(NSDate *)pFinalDate;
- (NSArray*) getGyms;
-(NSArray*) getMachinesForGym: (NSString*)pGym;
- (NSDictionary* ) getClassesImages;
@end