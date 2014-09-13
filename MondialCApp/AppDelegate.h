#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Timetable.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
    
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *newsNavigationController;

- (NSURL *)applicationDocumentsDirectory;

@end
