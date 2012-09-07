//
//  Machine.h
//  MultiSpa
//
//  Created by MacUser on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Machine : NSObject

@property(readonly, strong, nonatomic) NSNumber *number;
@property(readonly,strong, nonatomic) NSString *name;
@property(readonly, strong, nonatomic) NSString *description;
@property(readonly, strong, nonatomic) NSString *videoURL;
@property(readonly, strong, nonatomic) UIImage *image;

+ (Machine *)newWithDictionary:(NSDictionary *)dict;
- (id)initWithDictionary:(NSDictionary*)dict;


@end
