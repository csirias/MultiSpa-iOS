//
//  JSONparser.m
//  MultiSpa
//
//  Created by MacUser on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSONparser.h"
#import "Machine.h"
#import "Classes.h"

@implementation JSONparser

@synthesize path;

- (NSArray*) getGymsArray {
    path = @"http://localhost:3000/gyms.json";
    NSData *json_data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
    NSArray* JSON = [NSJSONSerialization JSONObjectWithData:json_data options:kNilOptions error:nil];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    
    for(NSDictionary *gym in JSON){
        [ret addObject:[gym objectForKey:@"name"]];
    }
    
    return ret;
}
- (NSDictionary*) getMachine: (NSString*)mID {
    path = [NSString stringWithFormat:@"http://localhost:3000/machines/%@.json", mID];
    NSData *json_data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
    NSDictionary* JSON = [NSJSONSerialization JSONObjectWithData:json_data options:kNilOptions error:nil];

    return JSON;
}

- (NSArray*) getMachinesForGym: (NSString*)pGym {
    path = [NSString stringWithFormat:@"http://localhost:3000/machines/byGym/%@.json", [self getGymId:pGym]];
    NSData *json_data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
    NSArray* JSON = [NSJSONSerialization JSONObjectWithData:json_data options:kNilOptions error:nil];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    
    NSArray *keys = [NSArray arrayWithObjects:@"number",@"name", @"description", @"video", @"image", nil];
    
    for(NSMutableDictionary *machine in JSON) {
        NSDictionary* m = [self getMachine:[machine objectForKey:@"machine_id"]];
        
        NSInteger number = [[machine objectForKey:@"number"] intValue];
        
        NSString *name = [m objectForKey:@"name"];
        
        NSString *description = [m objectForKey:@"description"];
        
        NSString *video = [m objectForKey:@"video"];
        
        NSData *image_data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:3000/system/images/%@/original/%@", [m objectForKey:@"id"], [m objectForKey:@"image_file_name"]]]];
        
        UIImage *image = [UIImage imageWithData:image_data];
        
        NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithInt:number], name, description, video, image, nil];
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        Machine *maquina = [[Machine alloc] initWithDictionary:dict];
        [ret addObject:maquina];
        
    }
    return ret;
}

- (NSString *) getGymId: (NSString*)gym_name {
    path = @"http://localhost:3000/gyms.json";
    NSData *json_data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
    NSArray* JSON = [NSJSONSerialization JSONObjectWithData:json_data options:kNilOptions error:nil];
    
    for(NSDictionary *gym in JSON){
        if( [[gym objectForKey:@"name"] isEqualToString:gym_name] ) 
            return [gym objectForKey:@"id"];
    }
    return FALSE;
}

- (NSArray *)getWeekClassesFromGym: (NSString *)gym_name {
    path = [NSString stringWithFormat:@"http://localhost:3000/calendario/%@.json", [self getGymId:gym_name]];
    NSData *json_data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
    NSArray* JSON = [NSJSONSerialization JSONObjectWithData:json_data options:kNilOptions error:nil];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    
    NSArray *keys = [NSArray arrayWithObjects:@"instructor", @"date", @"duration",@"name",@"gym", @"schedule", @"image",  nil];
    for(NSMutableDictionary *class in JSON) {
        NSString *instructor = [self getInstructorName:[class objectForKey:@"instructor_id"]];
        
        NSDate *date = [dateFormatter dateFromString:[class objectForKey:@"date"]]; 
        
        NSInteger duration = [[class objectForKey:@"duration"] intValue];
        
        NSString *name = [[self getLessonNameAndImage:[class objectForKey:@"lesson_id"]] objectForKey:@"name"];
        
        NSString *schedule = [class objectForKey:@"schedule"];
        
        NSData *image_data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:3000/system/images/%@/original/%@", [class objectForKey:@"lesson_id"], [[self getLessonNameAndImage:[class objectForKey:@"lesson_id"]] objectForKey:@"image_name"]]]];
        UIImage *image = [UIImage imageWithData:image_data];
        
        NSArray *objects = [NSArray arrayWithObjects:instructor,date, [NSNumber numberWithInt:duration], name, gym_name, schedule, image, nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        
        Classes *clase = [[Classes alloc] initWithDictionary:dictionary];
        [ret addObject:clase];
        
    }
    return ret;
}

- (NSString *)getInstructorName: (NSString *)instructor_id {
    path = [NSString stringWithFormat:@"http://localhost:3000/instructors/%@.json", instructor_id ];
    NSData *json_data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:json_data options:kNilOptions error:nil];
    return [JSON objectForKey:@"name"];
}

- (NSDictionary *)getLessonNameAndImage: (NSString *)lesson_id {
    path = [NSString stringWithFormat:@"http://localhost:3000/lessons/%@.json", lesson_id ];
    NSData *json_data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:json_data options:kNilOptions error:nil];
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[JSON objectForKey:@"name"], [JSON objectForKey:@"image_file_name"], nil] forKeys:[NSArray arrayWithObjects:@"name", @"image_name", nil]];
}

- (NSDictionary *)getClassesImages {
    path = @"http://localhost:3000/lessons.json";
    NSData *json_data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:json_data options:kNilOptions error:nil];
    
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    
    for( NSDictionary* lesson in JSON ) {
        NSData *image_data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:3000/system/images/%@/original/%@", [lesson objectForKey:@"id"], [lesson objectForKey:@"image_file_name"]]]];
        UIImage *image = [UIImage imageWithData:image_data];

        [ret setObject:image forKey:[lesson objectForKey:@"name"]];
    }
    return ret;
}

@end
