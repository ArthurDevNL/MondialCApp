//
//  Weekday.h
//  MondialCollegeRooster
//
//  Created by Arthur Hemmer on 12/11/12.
//  Copyright (c) 2012 Arthur Hemmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lesson.h"

@interface Weekday : NSObject <NSCoding>
@property (nonatomic) NSArray *lessons;
@property (nonatomic) NSInteger dayNumber;

+(Weekday*)weekdayWithLessons:(NSArray*)lessons dayNumber:(NSInteger)day;
@end
