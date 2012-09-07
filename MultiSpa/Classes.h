//
//  Classes.h
//  MultiSpa
//
//  Created by MacUser on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Classes : NSObject

@property (readonly, nonatomic, strong) NSString *instructor;
@property (readonly, nonatomic, strong) NSDate *date;
@property (readonly, nonatomic, strong) NSNumber *duration;
@property (readonly, nonatomic, strong) NSString *name;
@property (readonly, nonatomic, strong) NSString *gym;
@property (readonly, nonatomic, strong) NSString *schedule;
@property (readonly, nonatomic, strong) UIImage *image;

+ (Classes*)newWithDictionary:(NSDictionary*)dict;
- (id)initWithDictionary:(NSDictionary*)dict;

@end
