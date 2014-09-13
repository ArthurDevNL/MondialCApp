//
//  Lesson.m
//  MondialCollegeRooster
//
//  Created by Arthur Hemmer on 12/11/12.
//  Copyright (c) 2012 Arthur Hemmer. All rights reserved.
//

#import "Lesson.h"
#import "Timetable.h"

@implementation Lesson

+(Lesson *)createLessonWithInfo:(NSDictionary *)info
{
    Lesson *lesson = [Lesson new];
    lesson.hour = [[info objectForKey:BR_LESUUR] integerValue];
    lesson.dayNumber = [[info objectForKey:BR_DAGNUMMER] integerValue];
    lesson.ID = [info objectForKey:BR_LESID];
    lesson.group = [info objectForKey:BR_LESGROEP];
    lesson.teacher = [info objectForKey:BR_DOCENT];
    lesson.classroom = [info objectForKey:BR_LOKAAL];
    lesson.subject = [info objectForKey:BR_VAK];
    
    return lesson;
}

+(Lesson *)freeLessonWithHour:(int)hour dayNumber:(int)day
{
    Lesson *lesson = [Lesson new];
    lesson.hour = hour;
    lesson.ID = @"";
    lesson.dayNumber = day;
    lesson.group = @"";
    lesson.teacher = @"";
    lesson.classroom = @"";
    lesson.subject = @"";
    
    return lesson;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.dayNumber forKey:@"daynumber"];
    [aCoder encodeInteger:self.hour forKey:@"hour"];
    [aCoder encodeObject:self.ID forKey:@"id"];
    [aCoder encodeObject:self.group forKey:@"group"];
    [aCoder encodeObject:self.teacher forKey:@"teacher"];
    [aCoder encodeObject:self.classroom forKey:@"classroom"];
    [aCoder encodeObject:self.subject forKey:@"subject"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.dayNumber = [aDecoder decodeIntegerForKey:@"daynumber"];
        self.hour = [aDecoder decodeIntegerForKey:@"hour"];
        self.ID = [aDecoder decodeObjectForKey:@"id"];
        self.group = [aDecoder decodeObjectForKey:@"group"];
        self.teacher = [aDecoder decodeObjectForKey:@"teacher"];
        self.classroom = [aDecoder decodeObjectForKey:@"classroom"];
        self.subject = [aDecoder decodeObjectForKey:@"subject"];
    }
    
    return self;
}

@end
