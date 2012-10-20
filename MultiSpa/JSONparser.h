//
//  JSONparser.h
//  MultiSpa
//
//  Created by MacUser on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONparser : NSObject

@property (strong, nonatomic) NSString *path;

- (NSArray*) getGymsArray;
- (NSArray*) getMachinesForGym: (NSString*)pGym;
- (NSString *) getGymId: (NSString*)gym_name;
- (NSArray *)getWeekClassesFromGym: (NSString *)gym_name;
- (NSString *)getInstructorName: (NSString *)instructor_id;
- (NSString *)getLessonName: (NSString *)lesson_id;
- (NSDictionary *)getClassesImages;


@end
