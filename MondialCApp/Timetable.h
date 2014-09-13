//
//  Timetable.h
//  MondialCollegeRooster
//
//  Created by Arthur Hemmer on 12/11/12.
//  Copyright (c) 2012 Arthur Hemmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weekday.h"
#import "Lesson.h"
#import "Stack.h"

typedef enum {
    Pupil = 0,
    Teacher,
    Classroom,
    None
} PersonType;

@class Timetable;

@protocol TimetableDelegate <NSObject>
@required
-(void)timetableDidUpdate:(Timetable*)timeTable succes:(BOOL)succes;
@end

@interface Timetable : NSObject <NSCoding>
@property (nonatomic, readonly) PersonType timetableType;
@property (nonatomic, readonly) NSString *person;
@property (nonatomic) NSArray *weekdays;
@property (nonatomic, weak) id<TimetableDelegate> delegate;

+(instancetype)defaultInstance;

-(NSString*)averageLevel;

+(Lesson*)getLessonFromTimetable:(Timetable*)timetable forIndexPath:(NSIndexPath*)indexPath;
-(id)initWithName:(NSString*)name forTimetable:(PersonType)type;
-(void)reloadTimetableWithName:(NSString*)name forType:(PersonType)type;

//Comparing timetable(s)
-(Timetable*)compareWithTimetable:(Timetable*)timetable;
-(Timetable*)compareWithTimetables:(Stack*)timetables;
@end
