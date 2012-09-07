//
//  Machine.m
//  MultiSpa
//
//  Created by MacUser on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Machine.h"

@implementation Machine

@synthesize number = _number;
@synthesize name = _name;
@synthesize description = _description;
@synthesize videoURL = _videoURL;
@synthesize image = _image;

+ (Machine*)newWithDictionary:(NSDictionary*)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (id)initWithDictionary:(NSDictionary*)dict
{
    if(!(self = [super init]))
        return nil;
    
    _number = [dict objectForKey:@"number"];
    _name = [dict objectForKey:@"name"];
    _description = [dict objectForKey:@"description"];
    _videoURL = [dict objectForKey:@"videoURL"];
    _image = [dict objectForKey:@"image"];
    
    return self;
}

@end