//
//  PersoonlijkRooster.h
//  MondialCApp
//
//  Created by Arthur Hemmer on 1/19/13.
//
//

#import <Foundation/Foundation.h>
#import "Timetable.h"

@interface PersoonlijkRooster : NSObject
@property (nonatomic) PersonType roostertype;
@property (nonatomic) NSString *roostervan;

@property (nonatomic) BOOL notificaties;
@property (nonatomic) NSString *DeviceToken;

-(BOOL)isConfigured;

+(void)registerForNotifications;
+(void)unregisterForNotifications;

+(instancetype)defaultInstance;

-(void)registerForRemoteNotificationTypes;

@end
