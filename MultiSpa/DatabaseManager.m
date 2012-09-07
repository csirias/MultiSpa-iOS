//
//  DatabaseManager.m
//  MultiSpa
//
//  Created by MacUser on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatabaseManager.h"
#import "Classes.h"

@implementation DatabaseManager
@synthesize dataId;
@synthesize fileMgr;
@synthesize homeDir;

-(NSString *)GetDocumentDirectory{
    fileMgr = [NSFileManager defaultManager];
    homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    return homeDir;
}

-(void)CopyDbToDocumentsFolder{
    NSError *err=nil;
    
    fileMgr = [NSFileManager defaultManager];
    
    NSString *dbpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MultiSpa.sqlite"]; 
    
    NSString *copydbpath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MultiSpa.sqlite"];
    
    [fileMgr removeItemAtPath:copydbpath error:&err];
    if(![fileMgr copyItemAtPath:dbpath toPath:copydbpath error:&err])
    {
        UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to copy database." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [tellErr show];
    }
    
}

-(void)InsertRecords:
(int) news_id :
(int) category_id:
(NSMutableString *) newTitle:
(NSMutableString *) newDetails:
(NSMutableString *) newImage
{
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    
    
    //insert
    const char *sql = "Insert into News(news_id, category_id, title, details, image) values(?,?,?,?,?)";
    
    NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MultiSpa.sqlite"];
    BOOL success = [fileMgr fileExistsAtPath:dbPath];
    if(!success)
    {
        NSLog(@"Cannot locate database file '%@'.", dbPath);
    }
    
    sqlite3 *database;
    if(!(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK))
    {
        NSLog(@"An error has occured.");
    }
    
    if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Problem with prepare statement");
    }
    
    sqlite3_bind_int(stmt, 1, news_id);
    sqlite3_bind_int(stmt, 2, category_id);
    sqlite3_bind_text(stmt, 3, [newTitle UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 4, [newDetails UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 5, [newImage UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else{
        NSLog(@"Inserted");
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
        sqlite3_close(database); 
    }   
}

-(void)UpdateRecords:(NSString *)txt :(NSMutableString *)utxt{
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    
    const char *sql = "Update News set coltext=? where coltext=?";
    
    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MultiSpa.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &cruddb);
    sqlite3_prepare_v2(cruddb, sql, 1, &stmt, NULL);
    sqlite3_bind_text(stmt, 1, [txt UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [utxt UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);  
    
}
-(void)DeleteRecords:(NSString *)txt{
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb;
    
    //insert
    const char *sql = "Delete from News where coltext=?";
    
    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MultiSpa.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &cruddb);
    sqlite3_prepare_v2(cruddb, sql, 1, &stmt, NULL);
    sqlite3_bind_text(stmt, 1, [txt UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);  
    
}

- (NSMutableArray *) getLocalNews{
    NSMutableArray *newsArray = [[NSMutableArray alloc] init];
    @try {
        fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MultiSpa.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        
        sqlite3 *database;
        if(!(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT news_id, category_id ,title, details, image FROM  News";
        sqlite3_stmt *sqlStatement = nil;
        
        if(sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            
            NSArray *keys = [NSArray arrayWithObjects:@"Title", @"TabID", @"CategoryTabID",@"DetailsURL",@"ImageURL", nil];
            
            int news_id = sqlite3_column_int(sqlStatement, 0);
            int category_id = sqlite3_column_int(sqlStatement, 1);
            
            NSString *news_idString = [[NSNumber numberWithInt:news_id] stringValue];
            
            NSString *category_idString = [[NSNumber numberWithInt:category_id] stringValue];
            
            NSString *newsTitle = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,2)];
            
            NSString *detailsURL = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,3)];
            
            NSString *imageUrl = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];
            
            
            NSArray *objects = [NSArray arrayWithObjects:
                                news_idString, category_idString, newsTitle,detailsURL,imageUrl, nil];
            
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
            
            Classes* item = [[Classes alloc] initWithDictionary:dictionary];
            
            [newsArray addObject:item];
        }
        
        sqlite3_finalize(sqlStatement);
        sqlite3_close(database);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        
        return newsArray;
    }   
    
}

- (NSArray *) getClasses
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    @try {
        fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MultiSpa.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        
        sqlite3 *database;
        if(!(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT * FROM Class";
        sqlite3_stmt *sqlStatement = nil;
        
        if(sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            
            NSArray *keys = [NSArray arrayWithObjects:@"instructor", @"start", @"end",@"type",@"local", nil];
            
            //int class_id = sqlite3_column_int(sqlStatement, 0);
            NSString *class_name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
            
            NSArray *objects = [NSArray arrayWithObjects: @"", [NSDate date], [NSDate date], class_name, @"", nil];
            
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
            
            Classes* item = [[Classes alloc] initWithDictionary:dictionary];
            
            [ret addObject:item];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return ret;
    }
}

- (NSArray*) getClassesFromDay: (NSDate *)pDate toDay:(NSDate *)pFinalDate
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    @try {
        fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MultiSpa.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        
        sqlite3 *database;
        if(!(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT cg.instructor, cg.date, cg.duration, c.name, g.name, cg.schedule_type, c.image FROM Class c, Gym g, ClassXGym cg where cg.IDClass = c.ID and cg.IDGym = g.ID and cg.date >= datetime(?) and cg.date <= datetime(?)";
        
        sqlite3_stmt *sqlStatement = nil;
        
        if(sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
        
        NSString *startDate = [dateFormatter stringFromDate:pDate];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd 24:59:59"];
        NSString *finaldate = [dateFormatter stringFromDate:pFinalDate];
        
        sqlite3_bind_text(sqlStatement, 1, [startDate UTF8String], [startDate length], SQLITE_STATIC);
        sqlite3_bind_text(sqlStatement, 2, [finaldate UTF8String], [finaldate length], SQLITE_STATIC);
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSArray *keys = [NSArray arrayWithObjects:@"instructor", @"date", @"duration",@"name",@"gym", @"schedule", @"image",  nil];
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            
            
            NSString *instructor = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
            
            NSString *dateString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
            NSDate *date = [dateFormatter dateFromString:dateString];
            
            NSInteger duration = sqlite3_column_int(sqlStatement, 2);
            
            NSString *name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
            
            NSString *gym = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
            
            NSString *schedule = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 5)];
            
            NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(sqlStatement, 6) length:sqlite3_column_bytes(sqlStatement, 6)];
            UIImage *image;
            if (data == nil) {
                NSLog(@"No image Found.");
                image = nil;
            }
            else {
                image = [UIImage imageWithData:data];
            }
            
            NSArray *objects = [NSArray arrayWithObjects:instructor,date, [NSNumber numberWithInt:duration], name, gym, schedule, image, nil];
            
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
            
            Classes* item = [[Classes alloc] initWithDictionary:dictionary];
            [ret addObject:item];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return ret;
    }
}

- (NSArray*) getGyms
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    @try {
        fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MultiSpa.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        
        sqlite3 *database;
        if(!(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT name FROM Gym";
        
        sqlite3_stmt *sqlStatement = nil;
        
        if(sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            
            NSString *name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
            [ret addObject:name];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return ret;
    }

}

- (NSDictionary* ) getClassesImages
{
    //NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    @try {
        fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MultiSpa.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if (!success) {
            NSLog(@"Cannot locate database file %@.", dbPath);
        }
        sqlite3 *database;
        if (!(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)) {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT c.name , c.image FROM Class c";
        
        sqlite3_stmt *sqlStatement = nil;
        if(sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            
            NSString *name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
            
            NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(sqlStatement, 1) length:sqlite3_column_bytes(sqlStatement, 1)];
            UIImage *image;
            if (data == nil) {
                NSLog(@"No image Found.");
                image = nil;
            }
            else {
                image = [UIImage imageWithData:data];
            }
            
            [ret setObject:image forKey:name];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return ret;
    }
}

-(NSArray*) getMachinesForGym: (NSString*)pGym
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    @try {
        fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"MultiSpa.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if (!success) {
            NSLog(@"Cannot locate database file %@.", dbPath);
        }
        sqlite3 *database;
        if (!(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)) {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT mg.number, m.name, m.description, m.image, m.video  FROM MachineXGym mg, Gym g, Machine m Where g.ID = mg.IDGym and m.ID = mg.IDMachine and g.name = ?";
        
        sqlite3_stmt *sqlStatement = nil;
        if(sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        sqlite3_bind_text(sqlStatement, 1, [pGym UTF8String], [pGym length], SQLITE_STATIC);
        
        NSArray *keys = [NSArray arrayWithObjects:@"number", @"name", @"description", @"image", @"videoURL", nil];
        
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            
            NSNumber *number = [NSNumber numberWithInt:sqlite3_column_int(sqlStatement, 0)];
            
            NSString *name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
            
            NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 2)];
            
            NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(sqlStatement, 3) length:sqlite3_column_bytes(sqlStatement, 3)];
            UIImage *image;
            if (data == nil) {
                NSLog(@"No image Found.");
                image = nil;
            }
            else {
                image = [UIImage imageWithData:data];
            }
            
            NSString *videoURL = [NSString stringWithUTF8String:(char *)sqlite3_column_blob(sqlStatement, 4)];
            
            NSArray *objects = [NSArray arrayWithObjects:number, name, description, image, videoURL, nil];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
            
            Machine *machine = [[Machine alloc] initWithDictionary:dict];
            
            [ret addObject:machine];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return ret;
    }
}

- (NSMutableArray*) getHTMLFromCategory:(int) quantity : (int) category_id
{
    NSMutableArray * HTMLArray = [[NSMutableArray alloc] init];
    @try {
        fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"ADNDatabase.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        
        sqlite3 *database;
        if(!(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT details FROM  News Where category_id = ? Order by id asc Limit ?";
        sqlite3_stmt *sqlStatement = nil;
        
        if(sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        sqlite3_bind_int(sqlStatement, 1, category_id);
        sqlite3_bind_int(sqlStatement, 2, quantity);
        
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            
            NSString *html = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,0)];
            
            [HTMLArray addObject:html];
        }
        
        sqlite3_finalize(sqlStatement);
        sqlite3_close(database);
        return HTMLArray;
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    
}
-(Boolean)existNews: (int)news_id{
    @try {
        fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"ADNDatabase.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        sqlite3 *database;
        if(!(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT * FROM  News WHERE news_id=?";
        sqlite3_stmt *sqlStatement = nil;
        
        if(sqlite3_prepare_v2(database, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        sqlite3_bind_int(sqlStatement, 1, news_id);
        
        if (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            
            sqlite3_finalize(sqlStatement);
            sqlite3_close(database);
            return TRUE;
        }
        
        sqlite3_finalize(sqlStatement);
        sqlite3_close(database);
        return FALSE;
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    } 
}

@end