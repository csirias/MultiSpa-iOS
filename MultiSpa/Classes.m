//
//  Classes.m
//  MultiSpa
//
//  Created by MacUser on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Classes.h"

@implementation Classes

@synthesize instructor = _instructor;
@synthesize date = _date;
@synthesize duration = _duration;
@synthesize name = _name;
@synthesize gym = _gym;
@synthesize schedule = _schedule;
@synthesize image = _image;

+ (Classes*)newWithDictionary:(NSDictionary*)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (id)initWithDictionary:(NSDictionary*)dict
{
    if(!(self = [super init]))
        return nil;
    
    _instructor = [dict objectForKey:@"instructor"];
    _date = [dict objectForKey:@"date"];
    _duration = [dict objectForKey:@"duration"];
    _name = [dict objectForKey:@"name"];
    _gym = [dict objectForKey:@"gym"];
    _schedule = [dict objectForKey:@"schedule"];
    _image = [dict objectForKey:@"image"];
    
    return self;
}

@end
