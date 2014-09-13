//
//  PersoonlijkRooster.m
//  MondialCApp
//
//  Created by Arthur Hemmer on 1/19/13.
//
//

#import "PersoonlijkRooster.h"
#import "AHPlistManager.h"

static NSString *kDeviceToken = @"DeviceToken";
static NSString *kNotifications = @"Notifications";
static NSString *kIsConfigured = @"Configured";

static NSString *kRoosterVan = @"accountroostervan";
static NSString *kRoosterType = @"accountroostertype";

static NSString *kPlistNameAccount = @"MondialCAppAccount";

//Registering
static NSString *URLRegisterPupil =
@"http://37.251.18.124/MondialAppService/Dagrooster/Dagrooster.svc/RegisterPupil?deviceToken=%@&leerlingnummer=%@";

static NSString *URLRegisterTeacher =
@"http://37.251.18.124/MondialAppService/Dagrooster/Dagrooster.svc/RegisterTeacher?deviceToken=%@&afkorting=%@";

//Unregistering
static NSString *URLUnregisterPupil =
@"http://37.251.18.124/MondialAppService/Dagrooster/Dagrooster.svc/UnregisterPupil?deviceToken=%@&leerlingnummer=%@";

static NSString *URLUnregisterTeacher =
@"http://37.251.18.124/MondialAppService/Dagrooster/Dagrooster.svc/UnregisterTeacher?deviceToken=%@&afkorting=%@";

@implementation PersoonlijkRooster
@synthesize roostervan = _roostervan;
@synthesize roostertype = _roostertype;

- (id)init
{
    self = [super init];
    if (self) {
        self.DeviceToken = @"";
        self.notificaties = NO;
    }
    return self;
}

//The 'configured' property is determined when calling the getter
-(BOOL)isConfigured
{
    BOOL configured = false;
    if (self.roostertype == Teacher) {
        configured = ![self.roostervan isEqualToString:@""] && self.roostervan.length >= 4;
    } else if (self.roostertype == Pupil) {
        configured = ![self.roostervan isEqualToString:@""] && self.roostervan.length >= 6;
    }
    return configured;
}

-(void)registerForRemoteNotificationTypes
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
}

#pragma mark - Public (class) Methods
//Performs a few validation checks and sends a request to the server to register for remote notifications
+(void)registerForNotifications
{
    PersoonlijkRooster *pr = [PersoonlijkRooster defaultInstance];
    
    //Check if the user wants notifications
    if (!pr.notificaties)
        return;
    
    //Check if we kan receive push notifications
    if ([UIApplication sharedApplication].enabledRemoteNotificationTypes == UIRemoteNotificationTypeNone)
        return;
    
    //Check if it is configured
    if (![pr isConfigured])
        return;
    
    //Check if we have a devicetoken. Ifnot, get one.
    if (!pr.DeviceToken || [pr.DeviceToken isEqualToString:@""]) {
        [pr registerForRemoteNotificationTypes];
        return;
    }

    //Check if the roostertype is either teacher or pupil
    if (pr.roostertype != Teacher && pr.roostertype != Pupil)
        return;
    
    //Get the right URL for the given roostertype
    NSURL *URL;
    if (pr.roostertype == Pupil)
        URL = [NSURL URLWithString:[NSString stringWithFormat:URLRegisterPupil, pr.DeviceToken, pr.roostervan]];
    else if (pr.roostertype == Teacher)
        URL = [NSURL URLWithString:[NSString stringWithFormat:URLRegisterTeacher, pr.DeviceToken, pr.roostervan]];
    
    //Configure and send the request
    NSURLRequest *request = [NSURLRequest requestWithURL:URL
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:20.f];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:NULL];
}

//Unregisters the configured account for notifications
+(void)unregisterForNotifications
{
    PersoonlijkRooster *pr = [PersoonlijkRooster defaultInstance];

    if (pr.notificaties)
        return;
    
    //Check if it is configured
    if (![pr isConfigured])
        return;
    
    //Check if we have a devicetoken
    if (!pr.DeviceToken || [pr.DeviceToken isEqualToString:@""])
        return;
    
    //Check if the roostertype is either teacher or pupil
    if (pr.roostertype != Teacher || pr.roostertype != Pupil)
        return;
    
    //Get the right URL for the given roostertype
    NSURL *URL;
    if (pr.roostertype == Pupil)
        URL = [NSURL URLWithString:[NSString stringWithFormat:URLUnregisterPupil, pr.DeviceToken, pr.roostervan]];
    else if (pr.roostertype == Teacher)
        URL = [NSURL URLWithString:[NSString stringWithFormat:URLUnregisterTeacher, pr.DeviceToken, pr.roostervan]];
    
    //Configure and send the request
    NSURLRequest *request = [NSURLRequest requestWithURL:URL
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:20.f];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:NULL];
}

//Returns the defaultinstance, if it doesn't exist yet it'll create a new PersoonlijkRooster
static PersoonlijkRooster *_sharedrooster;
static dispatch_once_t onceToken;
+(instancetype)defaultInstance
{
    if (!_sharedrooster) {
        dispatch_once(&onceToken, ^{
            _sharedrooster = [PersoonlijkRooster new];
        });
    }
    return _sharedrooster;
}

-(NSString *)roostervan
{
    if (!_roostervan) {
        _roostervan = [[NSUserDefaults standardUserDefaults] objectForKey:kRoosterVan];
    }
    return _roostervan;
}

-(void)setRoostervan:(NSString *)roostervan
{
    if (_roostervan != roostervan) {
        _roostervan = roostervan;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:roostervan forKey:kRoosterVan];
        [defaults synchronize];
    }
}

-(PersonType)roostertype
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger person = [defaults integerForKey:kRoosterType];
    return (PersonType)person;
}

-(void)setRoostertype:(PersonType)roostertype
{
    if (_roostertype != roostertype) {
        _roostertype = roostertype;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:roostertype forKey:kRoosterType];
        [defaults synchronize];
    }
}

@end
