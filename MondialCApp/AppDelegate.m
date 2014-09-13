#import "AppDelegate.h"
#import "RoosterViewController.h"
#import "RoosterViewController.h"
#import "Appirater.h"
#import "AHPlistManager.h"
#import "News.h"
#import "PersoonlijkRooster.h"
#import "UIColor+MLPFlatColors.h"

@interface AppDelegate ()
@property (nonatomic) AHPlistManager *plistTimetable;
@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize newsNavigationController = _newsNavigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupAppirator];
    
    //Notifications
//    [PersoonlijkRooster registerForNotifications];
    [[News defaultInstance] refreshArticles];
    
    //Appearance
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor flatDarkPurpleColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITabBar appearance] setTintColor:[UIColor flatPurpleColor]];
    
    //Get the news links
    NSDictionary *links = [[NSDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://mondialapp.mondialweb.nl/links.plist"]];
    NSArray *nieuwsLink = [links objectForKey:@"nieuws"];
    NSArray *dagroosterLink = [links objectForKey:@"dagrooster"];
    NSArray *agendaLink = [links objectForKey:@"agenda"];
    
    //
    //------- If statement to check which school you are currently in -------
    //
    //Set all the links in NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[nieuwsLink objectAtIndex:0] forKey:@"nieuws"];
    [defaults setObject:[dagroosterLink objectAtIndex:0] forKey:@"dagrooster"];
    [defaults setObject:[agendaLink objectAtIndex:0] forKey:@"agenda"];
    [defaults synchronize];
            
    [Appirater appLaunched:YES];

    return true;
}

#pragma mark - Appirator
-(void)setupAppirator
{
    [Appirater setAppId:@"496864002"];
    [Appirater setUsesUntilPrompt:25];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
}

#pragma mark - Application lifecycle
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application 
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

#pragma mark - Application's Documents directory
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
