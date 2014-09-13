//
//  Weekday.m
//  MondialCollegeRooster
//
//  Created by Arthur Hemmer on 12/11/12.
//  Copyright (c) 2012 Arthur Hemmer. All rights reserved.
//

#import "Weekday.h"

@implementation Weekday

+(Weekday *)weekdayWithLessons:(NSArray *)lessons dayNumber:(NSInteger)day
{
    Weekday *weekday = [[Weekday alloc] init];
    weekday.lessons = lessons;
    weekday.dayNumber = day;
    return weekday;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.lessons forKey:@"lessons"];
    [aCoder encodeInteger:self.dayNumber forKey:@"daynumber"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.lessons = [aDecoder decodeObjectForKey:@"lessons"];
        self.dayNumber = [aDecoder decodeIntegerForKey:@"daynumber"];
    }
    
    return self;
}

@end
