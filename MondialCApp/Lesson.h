//
//  Lesson.h
//  MondialCollegeRooster
//
//  Created by Arthur Hemmer on 12/11/12.
//  Copyright (c) 2012 Arthur Hemmer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BR_DAGNUMMER @"DAGNUMMER"
#define BR_LESUUR @"LESUUR"
#define BR_LESID @"LESID"
#define BR_LESGROEP @"LESGROEP"
#define BR_DOCENT @"DOCENT"
#define BR_LOKAAL @"LOKAAL"
#define BR_VAK @"VAK"

@interface Lesson : NSObject <NSCoding>
@property (nonatomic) NSInteger dayNumber;
@property (nonatomic) NSInteger hour;
@property (nonatomic) NSString *ID;
@property (nonatomic) NSString *group;
@property (nonatomic) NSString *teacher;
@property (nonatomic) NSString *classroom;
@property (nonatomic) NSString *subject;

+(Lesson*)createLessonWithInfo:(NSDictionary*)info;
+(Lesson*)freeLessonWithHour:(int)hour dayNumber:(int)day;
@end
