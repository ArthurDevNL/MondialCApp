#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "InstellingenViewController.h"

@interface RoosterTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) NSIndexPath *oldIndexPath;
@property (nonatomic) BOOL showTimeOfLesson;
@property (nonatomic) int dag;
@end
