//
//  Timetable.m
//  MondialCollegeRooster
//
//  Created by Arthur Hemmer on 12/11/12.
//  Copyright (c) 2012 Arthur Hemmer. All rights reserved.
//

#import "Timetable.h"
#import "AHPlistManager.h"

static NSString *kPlistTimetable = @"Timetable";

@interface Timetable ()

@end

@implementation Timetable

#pragma mark - Public methods
+(instancetype)defaultInstance
{
    static Timetable *_sharedrooster = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedrooster = [[Timetable plistTimetable] contents];
        if (!_sharedrooster) {
            _sharedrooster = [Timetable new];
        }
    });
    
    return _sharedrooster;
}

//This method searches for a lesson in a given timetable for a given indexpath
+(Lesson*)getLessonFromTimetable:(Timetable*)timetable forIndexPath:(NSIndexPath*)indexPath
{
    Lesson *result;
    for (Weekday *weekday in timetable.weekdays) {
        if (weekday.dayNumber == indexPath.section) {
            for (Lesson *lesson in weekday.lessons) {
                if (lesson.hour == indexPath.row) {
                    result = lesson;
                }
            }
        }
    }
    if (!result) {
        result = [Lesson freeLessonWithHour:(int)indexPath.row dayNumber:(int)indexPath.section];
    }
    return result;
}
//This method will, whenever a lesson has been found, return a lesson. If no lessons that meet the criteria have been found
// then it will return nil.

-(NSString *)averageLevel
{
    if (!self.weekdays || self.weekdays.count == 0)
        return @"1";
    
    int sum = 0;
    int nLessons = 1;
    for (Weekday *w in self.weekdays) {
        for (Lesson *l in w.lessons) {
            NSString *lesgroep = [l group];
            NSString *klas = lesgroep.length > 0 ? [lesgroep substringToIndex:1] : nil;
            sum += klas.intValue;
            nLessons += 1;
        }
    }
    
    int average = sum/nLessons;
    return [NSString stringWithFormat:@"%i", average];
}

#pragma mark - Downloading & Parsing
-(void)reloadTimetableWithName:(NSString*)name forType:(PersonType)type
{
    _person = name;
    _timetableType = type;
    
    //Get the right URL for the given type
    NSString *urlString;
    if (type == Pupil)
        urlString = [NSString stringWithFormat:@"http://217.149.202.54:88/Service1.svc/GetRoosterPupil/%@", name];
    else if (type == Teacher)
        urlString = [NSString stringWithFormat:@"http://217.149.202.54:88/Service1.svc/GetRoosterTeacher/%@", name];
    else if (type == Classroom)
        urlString = [NSString stringWithFormat:@"http://217.149.202.54:88/Service1.svc/GetRoosterLocal/%@", name];
    
    //Perform the request
    NSURL *URL = [NSURL URLWithString:urlString];
    [self downloadTimetableJSONForURL:URL withCompletion:^(NSError *error) {
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(timetableDidUpdate:succes:)])
                [self.delegate timetableDidUpdate:self succes:YES];
        } else {
            if ([self.delegate respondsToSelector:@selector(timetableDidUpdate:succes:)])
                [self.delegate timetableDidUpdate:self succes:NO];
        }
    }];
}

//This method downloads the JSON from the given url and fills the whole timetable
-(void)downloadTimetableJSONForURL:(NSURL*)URL withCompletion:(void(^)(NSError *error))completion
{
    __weak typeof(self) weakself = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        //Check if there is no error
        if (!connectionError && data.length > 0) {
            
            //Instantiate the lessons and check if there are more than 0
            NSArray *lessons = [self parseJSONData:data];
            if (lessons.count == 0)
                completion([NSError errorWithDomain:@"No lessons found" code:0 userInfo:nil]);
            
            //If there are any lessons, create the weekdays
            NSArray *weekdays = [self instantiateWeekdaysWithLessons:lessons];
            [weakself setWeekdays:weekdays];
            
            [self save];

            //Complete without error
            if (completion)
                completion(nil);
        } else {
            //Complete with error
            if (completion)
                completion(connectionError);
        }
    }];
}

//This method parses all the lessons from the given JSONData
-(NSArray*)parseJSONData:(NSData*)data
{
    NSArray *lessons = [NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingAllowFragments
                                                         error:nil];
    
    NSMutableArray *returnLessons = [NSMutableArray arrayWithCapacity:lessons.count];
    for (NSDictionary *info in lessons) {
        [returnLessons addObject:[Lesson createLessonWithInfo:info]];
    }
    return returnLessons;
}
//The method returns an array of Lesson objects

+(AHPlistManager *)plistTimetable
{
    return [[AHPlistManager alloc] initWithName:kPlistTimetable delegate:nil];
}

#pragma mark - Timbetable Instantiation
//Timetable init method
-(id)initWithName:(NSString *)name forTimetable:(PersonType)type
{
    self = [super init];
    if (self) {
        [self reloadTimetableWithName:name forType:type];
    }
    
    return self;
}
//The timetable has been filled with weekdays containing the lessons of the given 'name' and 'type'
//Be aware: even if no lessons have been found, the 'weekdays' property will stil contain five weekdays which aren't filled

//This method fills the current timetable object with weekdays holding the appropriate lessons
-(NSArray*)instantiateWeekdaysWithLessons:(NSArray*)lessons
{
    NSMutableArray *weekdays = [NSMutableArray arrayWithCapacity:5];
    
    for (int daynumber = 1; daynumber < 6; daynumber++) {
        Weekday *weekday = [Weekday new];
        weekday.dayNumber = daynumber;
        
//        bool les[9];
//                
//        NSMutableArray *weeklessons = [NSMutableArray arrayWithCapacity:10];
//        for (int i = 0; i < lessons.count; i++) {
//            Lesson *lesson = [lessons objectAtIndex:i];
//            if (lesson.dayNumber == weekday.dayNumber) {
//                int lessonIndex = lesson.hour - 1;
//                les[lessonIndex] = true;
//                [weeklessons addObject:lesson];
//            }
//        }
        
//        weekday.lessons = weeklessons;
        [weekdays addObject:weekday];
    }
    
    return weekdays;
}
//The self.weekdays object now has all the weekdays filled with lessons

//Saves the timetable to disk
-(void)save
{
    [[Timetable plistTimetable] setContents:self];
}

#pragma mark - Timetable comparison
//Zeroes a boolarray with a capacity of nine elements
static void zeroBoolArray(bool array[9])
{
    for (int i = 0; i < 9; i++) {
        array[i] = false;
    }
}
//The bool array[9] has been set to false

//This is a recursive method that compares all the timetables to eachother
-(Timetable*)compareWithTimetables:(Stack*)timetables
{
    if(timetables.size == 0 || !timetables) {
        return self;
    } else {
        Timetable *bottom = [timetables pop];
        return [[self compareWithTimetable:bottom] compareWithTimetables:timetables];
    }
}
//The result will be a timetable with all the hours where no one has a lesson

#pragma mark - Timetable Comparison
//Compare each weekday in the timetables
-(Timetable *)compareWithTimetable:(Timetable *)timetable
{
    Timetable *returnTable = [Timetable new];
    NSMutableArray *weekdays = [NSMutableArray new];
    
    for (Weekday *weekday in self.weekdays) {
        for (Weekday *cWeekday in timetable.weekdays) {
            if (weekday.dayNumber == cWeekday.dayNumber) {
                [weekdays addObject:[Timetable compareWeekday:weekday withWeekDay:cWeekday]];
            }
        }
    }
    
    returnTable.weekdays = weekdays;
    
    return returnTable;
}
//This method returns a timetable with lessons on hours where either or both of the timetables has a free hour

//This methods compares the two given weekdays to make a resultDay
+(Weekday*)compareWeekday:(Weekday*)day withWeekDay:(Weekday*)cDay
{
    bool lessons[9];
    zeroBoolArray(lessons);
    
    NSMutableArray *resultDay = [NSMutableArray new];
//    
//    NSArray *days = [NSArray arrayWithObjects:day, cDay, nil];
//    for (int i = 0; i < [days count]; i++) {
//        for (Lesson *lesson in ((Weekday*)[days objectAtIndex:i]).lessons) {
//            int trueIndex = lesson.hour - 1;
//            lessons[trueIndex] = true;
//        }
//    }
    
    for (int i = 0; i < 9; i++) {
        if (lessons[i] == true) {
//            [resultDay addObject:[Lesson freeLessonWithHour:(i + 1) dayNumber:day.dayNumber]];
        }
    }
    
    Weekday *lessonsday = [Weekday new];
    lessonsday.dayNumber = day.dayNumber;
    lessonsday.lessons = [resultDay copy];
    
    return lessonsday;
}
//Returns a Weekday-object which contains Lesson-objects from hours where either or both weekdays have lessons


#pragma mark - NSCoding protocol
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.timetableType forKey:@"timetabletype"];
    [aCoder encodeObject:self.person forKey:@"person"];
    [aCoder encodeObject:self.weekdays forKey:@"weekdays"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _timetableType = [aDecoder decodeIntForKey:@"timetabletype"];
        _person = [aDecoder decodeObjectForKey:@"person"];
        _weekdays = [aDecoder decodeObjectForKey:@"weekdays"];
    }
    
    return self;
}
@end
